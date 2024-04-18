#ifndef ALLOCATOR_H
#define ALLOCATOR_H

#include "cuda_runtime.h"
#include "cuda_utils.h"

#define CUDA_CHECK(val) checkCudaError((val), #val, __FILE__, __LINE__)
void checkCudaError(cudaError_t result, char const *const func, const char *const file, int const line);
void* allocate_memory(size_t size);
void deallocate_memory(void* ptr);

#endif // ALLOCATOR_H