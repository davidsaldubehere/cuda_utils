// cuda_utils.h
#ifndef CUDA_UTILS_H
#define CUDA_UTILS_H

#define GET_GLOBAL_THREAD_IDX() (blockIdx.x * blockDim.x + threadIdx.x)
#define GET_GLOBAL_THREAD_IDY() (blockIdx.y * blockDim.y + threadIdx.y)

#endif // CUDA_UTILS_H