FLAGS = -sSTACK_SIZE=16777216
MATRIX_SIZES = 4 8 16 32 64 128 256 512 1024
MATMULS = matmul matmul_intrin
EMCC_PATH = /Users/miras/Documents/UNIST/Thesis/emsdk/upstream/emscripten/emcc

.PHONY: all clean

all: $(foreach matmul,$(MATMULS),$(foreach size,$(MATRIX_SIZES),run_wasm_N$(size) run_wasm_simd_N$(size) run_wasm_O3_N$(size) run_wasm_O3_simd_N$(size)))

run_wasm_N%: MATRIX_SIZE = $(subst run_wasm_N,,$(basename $@))
run_wasm_simd_N%: MATRIX_SIZE = $(subst run_wasm_simd_N,,$(basename $@))
run_wasm_O3_N%: MATRIX_SIZE = $(subst run_wasm_O3_N,,$(basename $@))
run_wasm_O3_simd_N%: MATRIX_SIZE = $(subst run_wasm_O3_simd_N,,$(basename $@))
run_js_N%: MATRIX_SIZE = $(subst run_js_N,,$(basename $@))

run_wasm_N%:
	$(EMCC_PATH) -o dist/matmul.o -c src/matmul.c
	$(EMCC_PATH) -o dist/mul_mats_N$(MATRIX_SIZE).o -c src/mul_mats/mul_mats_N$(MATRIX_SIZE).c
	$(EMCC_PATH) $(FLAGS) -o dist/base_N$(MATRIX_SIZE).js main.c dist/mul_mats_N$(MATRIX_SIZE).o dist/matmul.o
	node dist/base_N$(MATRIX_SIZE).js

run_wasm_simd_N%:
	$(EMCC_PATH) -o dist/matmul_intrin.o -c -msimd128 src/matmul_intrin.c
	$(EMCC_PATH) -o dist/mul_mats_N$(MATRIX_SIZE).o -c -msimd128 src/mul_mats/mul_mats_N$(MATRIX_SIZE).c
	$(EMCC_PATH) $(FLAGS) -o dist/simd_N$(MATRIX_SIZE).js -msimd128 main.c dist/mul_mats_N$(MATRIX_SIZE).o dist/matmul_intrin.o
	node dist/simd_N$(MATRIX_SIZE).js

run_wasm_O3_N%:
	$(EMCC_PATH) -o dist/matmul.o -O3 -c src/matmul.c
	$(EMCC_PATH) -o dist/mul_mats_N$(MATRIX_SIZE).o -c -O3 src/mul_mats/mul_mats_N$(MATRIX_SIZE).c
	$(EMCC_PATH) $(FLAGS) -o dist/base_N$(MATRIX_SIZE).js -O3 main.c dist/mul_mats_N$(MATRIX_SIZE).o dist/matmul.o
	node dist/base_N$(MATRIX_SIZE).js

run_wasm_O3_simd_N%:
	$(EMCC_PATH) -o dist/matmul_intrin.o -c -O3 -msimd128 src/matmul_intrin.c
	$(EMCC_PATH) -o dist/mul_mats_N$(MATRIX_SIZE).o -c -O3 -msimd128 src/mul_mats/mul_mats_N$(MATRIX_SIZE).c
	$(EMCC_PATH) $(FLAGS) -o dist/simd_N$(MATRIX_SIZE).js -O3 -msimd128 main.c dist/mul_mats_N$(MATRIX_SIZE).o dist/matmul_intrin.o
	node dist/simd_N$(MATRIX_SIZE).js

run_js_N%:
	node main.js $(MATRIX_SIZE)

clean:
	rm -f dist/*.o dist/*.js dist/*.wasm
