#include <stdio.h>
#include <stdlib.h>
#include <wasm_simd128.h>
#include "../include/matmul.h"

void matmul(int* out, int* in_a, int* in_b, int n) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			out[i*n+j] = 0;
      int sum_arr[] = {0, 0, 0, 0};
      v128_t sum = wasm_v128_load(sum_arr);
			for (int k = 0; k < n; k+=4) {
				v128_t a = wasm_v128_load(&in_a[i*n+k]);
				v128_t b = wasm_v128_load(&in_b[j*n+k]);
				v128_t prod = wasm_i32x4_mul(a, b);
        sum = wasm_i32x4_add(sum, prod);
			}
      v128_t sum_duo = wasm_i32x4_add(sum, wasm_i32x4_shuffle(sum, sum, 2, 3, 0, 0));
      v128_t sum_one = wasm_i32x4_add(sum_duo, wasm_i32x4_shuffle(sum_duo, sum_duo, 1, 0, 0, 0));
      out[i*n+j] += wasm_i32x4_extract_lane(sum_one, 0);
		}
	}
}