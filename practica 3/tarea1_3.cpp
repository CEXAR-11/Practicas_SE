#include <iostream>
#include <random>
#include <omp.h>
#include <iomanip>

using namespace std;

void operacion(int N){
    // NÚMEROS ALEATORIOS
    mt19937 mt(random_device{}()); // motor de números aleatorios
    uniform_real_distribution<double> crearDouble0_1(0.0, 1.0);
    uniform_int_distribution<int> crearInt0_255(0, 255);

    // CREACIÓN DE LAS MATRICES
    // usamos memoria dinámica para poder ampliar las dimensiones sin que haya un core dumped
    double** A, **B, **C, **K, **R;
    A = new double*[N];
    B = new double*[N];
    C = new double*[N];
    K = new double*[N];
    R = new double*[N];

    for (int i = 0; i < N; i++) {
        A[i] = new double[N];
        B[i] = new double[N];
        C[i] = new double[N];
        K[i] = new double[N];
        R[i] = new double[N];
    }

    // INICIALIZACIÓN DE MATRICES
    for (int i=0; i<N; i++){
        for (int j=0; j<N; j++){
            A[i][j] = crearDouble0_1(mt);
            B[i][j] = crearDouble0_1(mt);
            K[i][j] = crearInt0_255(mt);
    	}
    }

    // C = AxB
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            for (int k = 0; k < N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    
    // R = C·K
    for (int i=0; i<N; i++){
        for (int j=0; j<N; j++){
            R[i][j] = C[i][j]*K[i][j];
        }
    }
    
    // LIBERAR MEMORIA
    for (int i = 0; i < N; i++) {
        delete[] A[i];
        delete[] B[i];
        delete[] C[i];
        delete[] K[i];
        delete[] R[i];
    }

    delete[] A;
    delete[] B;
    delete[] C;
    delete[] K;
    delete[] R;
}

void operacionHebras(int N, int HEBRAS){
    // NÚMEROS ALEATORIOS
    mt19937 mt(random_device{}()); // motor de números aleatorios
    uniform_real_distribution<double> crearDouble0_1(0.0, 1.0);
    uniform_int_distribution<int> crearInt0_255(0, 255);

    // CREACIÓN DE LAS MATRICES
    // usamos memoria dinámica para poder ampliar las dimensiones sin que haya un core dumped
    double** A, **B, **C, **K, **R;
    A = new double*[N];
    B = new double*[N];
    C = new double*[N];
    K = new double*[N];
    R = new double*[N];

    for (int i = 0; i < N; i++) {
        A[i] = new double[N];
        B[i] = new double[N];
        C[i] = new double[N];
        K[i] = new double[N];
        R[i] = new double[N];
    }

    // INICIALIZACIÓN DE MATRICES
    #pragma omp parallel for num_threads(HEBRAS)
    for (int i=0; i<N; i++){
        for (int j=0; j<N; j++){
            A[i][j] = crearDouble0_1(mt);
            B[i][j] = crearDouble0_1(mt);
            K[i][j] = crearInt0_255(mt);
        }
    }

    // C = AxB
    #pragma omp parallel for num_threads(HEBRAS)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            for (int k = 0; k < N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    
    // R = C·K
    //#pragma omp parallel for num_threads(HEBRAS)
    for (int i=0; i<N; i++){
        for (int j=0; j<N; j++){
            R[i][j] = C[i][j]*K[i][j];
        }
    }

    // LIBERAR MEMORIA
    for (int i = 0; i < N; i++) {
        delete[] A[i];
        delete[] B[i];
        delete[] C[i];
        delete[] K[i];
        delete[] R[i];
    }

    delete[] A;
    delete[] B;
    delete[] C;
    delete[] K;
    delete[] R;
}


int main()
{
    cout << left <<  setw(20) << "# N (matrices NxN)" << setw(16) << "T_Secuencial" << setw(16) << "T_Monohebra"
    << setw(16) << "T_Bihebra" << setw(16) << "T_Multihebra" << setw(16) << "Ganancia(1H)" << setw(16) << "Ganancia(2H)" << setw(16) << "Ganancia(4H)"
    << setw(16) << "Eficiencia(1H)" << setw(16) << "Eficiencia(2H)" << setw(16) << "Eficiencia(4H)" << endl;
    // la operacion depende del parámetro N, que son las dimensiones de las matrices
    for(int N=2; N<600; N+=10){ //80
        // SECUENCIAL
        double start_time = omp_get_wtime(); // Iniciar el temporizador
        operacion(N);
        double end_time = omp_get_wtime(); // Detener el temporizador
        double SecTime = end_time-start_time;
        cout << setw(20) << N << setw(16) <<  SecTime;
        
        // TIEMPO MONOHEBRA
        start_time = omp_get_wtime();
        operacionHebras(N,1);
        end_time = omp_get_wtime();
        double MonoHebraTime = end_time-start_time;
        cout << setw(16) << MonoHebraTime;

        // TIEMPO BIHEBRA
        start_time = omp_get_wtime();
        operacionHebras(N,2);
        end_time = omp_get_wtime();
        double BiHebraTime = end_time-start_time;
        cout << setw(16) << BiHebraTime;

        // TIEMPO MULTIHEBRA
        start_time = omp_get_wtime();
        operacionHebras(N,4);
        end_time = omp_get_wtime();
        double MultiHebraTime = end_time-start_time;
        cout << setw(16) << MultiHebraTime;

        // GANANCIA MONOHEBRA
        double gananciaMonoHebra = SecTime/MonoHebraTime;
        cout << setw(16) << gananciaMonoHebra;

        // GANANCIA BIHEBRA
        double gananciaBiHebra = SecTime/BiHebraTime;
        cout << setw(16) << gananciaBiHebra;

        // GANANCIA MULTIHEBRA
        double gananciaMultiHebra = SecTime/MultiHebraTime;
        cout << setw(16) << gananciaMultiHebra;

        // EFICIENCIA MONOHEBRA
        double efcicienciaMonoHebra = gananciaMonoHebra/1;
        cout << setw(16) << efcicienciaMonoHebra;

        // EFICIENCIA BIHEBRA
        double efcicienciaBiHebra = gananciaBiHebra/2;
        cout << setw(16) << efcicienciaBiHebra;

        // EFICIENCIA MULTIHEBRA
        double efcicienciaMultiHebra = gananciaMultiHebra/4;
        cout << setw(16) << efcicienciaMultiHebra << endl;
    }
    return 0;
}
