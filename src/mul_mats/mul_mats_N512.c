#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "../../include/benchmark.h"
#include "../../include/matmul.h"

extern const int IT;

double benchmark() {
	const int N = 512;
    const int SIZE = N * N;
    int out[SIZE];
    int in_a[SIZE];
    int in_b[SIZE];

    for (int i = 0; i < SIZE; i++) {
        in_a[i] = 1;
        in_b[i] = 1;
    }

    // transpose
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < i; j++) {
            int aux = in_b[i * N + j];
            in_b[i * N + j] = in_b[j * N + i];
            in_b[j * N + i] = aux;
        }
    }

    clock_t start = clock();
    for (int i = 0; i < IT; i++) {
        matmul(out, in_a, in_b, N);
    }
    clock_t end = clock();


	long long sum = 0;
	for (int i = 0; i < SIZE; i++) {
		sum += out[i];
	}
	if (sum != N*N*N) {
		printf("incorrect sum: %lld\n", sum);
	}

    return ((double)(end - start)) / CLOCKS_PER_SEC;
}