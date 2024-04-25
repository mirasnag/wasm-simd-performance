#include <stdio.h>
#include <stdlib.h>
#include "../include/matmul.h"

void matmul(int* out, int* in_a, int* in_b, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            out[i * n + j] = 0;
            for (int k = 0; k < n; k++) {
                out[i * n + j] += in_a[i * n + k] * in_b[j * n + k];
            }
        }
    }
}