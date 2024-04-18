#include "memoryAllocator.h"
#include <iostream>
#include <cstring>

// Helper function to check CUDA errors
inline void checkCudaError(cudaError_t result, char const *const func, const char *const file, int const line) {
    if (result) {
        std::cerr << "CUDA error = " << static_cast<unsigned int>(result) << " at " << file << ":" << line << " '" << func << "' \n" << "CUDA error message = " << cudaGetErrorString(result) << std::endl;
        cudaDeviceReset();
        exit(99);
    }
}

#define CUDA_CHECK(val) checkCudaError((val), #val, __FILE__, __LINE__)

void* allocate_memory(size_t size) {
    void* devicePtr;
    cudaError_t status = cudaMalloc(&devicePtr, size);
    if (status != cudaSuccess) {
        CUDA_CHECK(status); // This will handle the error and exit if there is an issue
    } else {
        std::cout << "Allocated " << size << " bytes on GPU at address " << devicePtr << std::endl;
    }
    return device_ptr;
}

void deallocate_memory(void* ptr) {
    cudaError_t status = cudaFree(ptr);
    if (status != cudaSuccess) {
        CUDA_CHECK(status); // This will handle the error and exit if there is an issue
    } else {
        std::cout << "Deallocated memory at address " << ptr << std::endl;
    }
}
