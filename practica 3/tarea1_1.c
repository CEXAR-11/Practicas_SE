#include <stdio.h>
#include <omp.h>

int main() {
  int i, n = 1000;
  float sum = 0.0f;

  // Sección en paralelo
  #pragma omp parallel
  {
    //`sum` será visible para todos los hilos
    #pragma omp for reduction(+:sum)
    for (i = 0; i < n; i++) {
      sum += i;
    }
  }

  printf("sum = %f\n", sum);

  return 0;
}
