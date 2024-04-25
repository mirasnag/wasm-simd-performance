#include <stdio.h>
#include "include/benchmark.h"

const int IT = 10; // number of iterations

int main(){
    printf("%.3f\n", benchmark());
    return 0;
}