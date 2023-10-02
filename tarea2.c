#include <stdio.h>

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void sortMatrix(int mat[3][3]) {
    int tempArr[9];
    int k = 0;

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            tempArr[k++] = mat[i][j];
        }
    }

    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 8; j++) {
            if (tempArr[j] > tempArr[j + 1]) {
                swap(&tempArr[j], &tempArr[j + 1]);
            }
        }
    }

    k = 0;

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            mat[i][j] = tempArr[k++];
        }
    }
}

int main() {
    int matrix[3][3] = {
        {4, 5, 7},
        {8, 1, 6},
        {3, 2, 9}
    };

    printf("Matriz original:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }

    sortMatrix(matrix);

    printf("\nMatriz ordenada:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }

    return 0;
}
