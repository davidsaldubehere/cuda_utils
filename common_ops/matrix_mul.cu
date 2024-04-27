#include "matrix_mul.h"
#include <iostream>

__global__ void matrixMulKernel(const int *a, const int *b, int *c, int N) {
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;

  if (row < N && col < N) {
    int tmp = 0;
    for (int k = 0; k < N; ++k) {
      tmp += a[row * N + k] * b[k * N + col];
    }
    c[row * N + col] = tmp;
  }
}

void matrix_mul(const std::vector<int>& a, const std::vector<int>& b, std::vector<int>& c, int N) {
  size_t bytes = N * N * sizeof(int);
  int *d_a, *d_b, *d_c;

  cudaMalloc(&d_a, bytes);
  cudaMalloc(&d_b, bytes);
  cudaMalloc(&d_c, bytes);

  cudaMemcpy(d_a, a.data(), bytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, b.data(), bytes, cudaMemcpyHostToDevice);

  dim3 threadsPerBlock(16, 16);
  dim3 numBlocks((N + threadsPerBlock.x - 1) / threadsPerBlock.x,
                 (N + threadsPerBlock.y - 1) / threadsPerBlock.y);

  matrixMulKernel<<<numBlocks, threadsPerBlock>>>(d_a, d_b, d_c, N);

  cudaMemcpy(c.data(), d_c, bytes, cudaMemcpyDeviceToHost);

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
}
