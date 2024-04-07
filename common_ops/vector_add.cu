// vector_add.cu
#include "vector_add.h"
#include <iostream>

__global__ void vectorAdd(int *a, int *b, int *c, int N) {
  // Calculate global thread thread ID
  int tid = GET_GLOBAL_THREAD_IDX();

  // Boundary check
  if (tid < N) {
    c[tid] = a[tid] + b[tid];
  }
}

void vector_add(const int* a, const int* b, int* result, int size) {
    size_t bytes = size * sizeof(int);
    int *d_a, *d_b, *d_result;

    // Allocate memory on the GPU
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_result, bytes);

    // Copy input vectors from host memory to GPU buffers
    cudaMemcpy(d_a, a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, bytes, cudaMemcpyHostToDevice);

    // Determine grid and block dimensions
    int threadsPerBlock = 256;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;

    // Launch vector addition kernel
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_result, size);

    // Copy result from GPU buffer to host memory
    cudaMemcpy(result, d_result, bytes, cudaMemcpyDeviceToHost);

    // Free GPU memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_result);
}
