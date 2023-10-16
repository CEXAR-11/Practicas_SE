#include <stdio.h>
#include <stdint.h>

const int A = 7;

void swap(int *stack_a, int *stack_b) {
    int stack_temp = *stack_a;
    *stack_a = *stack_b;
    *stack_b = stack_temp;
}

void sortMatrix(int stack_mat[3][3]) {
    int stack_tempArr[9];
    int stack_k = 0;

    for (int heap_i = 0; heap_i < 3; heap_i++) {
        for (int heap_j = 0; heap_j < 3; heap_j++) {
            stack_tempArr[stack_k++] = stack_mat[heap_i][heap_j];
        }
    }

    for (int heap_i = 0; heap_i < 9; heap_i++) {
        for (int heap_j = 0; heap_j < 8; heap_j++) {
            if (stack_tempArr[heap_j] > stack_tempArr[heap_j + 1]) {
                swap(&stack_tempArr[heap_j], &stack_tempArr[heap_j + 1]);
            }
        }
    }

    stack_k = 0;

    for (int heap_i = 0; heap_i < 3; heap_i++) {
        for (int heap_j = 0; heap_j < 3; heap_j++) {
            stack_mat[heap_i][heap_j] = stack_tempArr[stack_k++];
        }
    }
}

int8_t suma(int stack_mat[3][3]){
    int8_t stack_sum = 0;
    for (int heap_i = 0; heap_i < 3; heap_i++) {
        for (int heap_j = 0; heap_j < 3; heap_j++) {
            stack_sum+=stack_mat[heap_i][heap_j];
        }
    }
    return stack_sum;
}

int main() {
    int ELF_st_matrix[3][3] = {
        {4, 5, 7},
        {8, 1, 6},
        {3, 2, 9}
    };
    auto ELF_auto_sumaContenido = 0;
    long st_rperez_a;
    
    sortMatrix(ELF_st_matrix);
    ELF_auto_sumaContenido = suma(ELF_st_matrix);
    printf("%d \n",ELF_auto_sumaContenido);
	
    

    return 0;
}
