// cuda_utils.h
#ifndef CUDA_UTILS_H
#define CUDA_UTILS_H

#define GET_GLOBAL_THREAD_ID() (blockIdx.x * blockDim.x + threadIdx.x)

#endif // CUDA_UTILS_H