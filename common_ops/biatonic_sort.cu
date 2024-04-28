#include "biatonic_sort.h"
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <algorithm>

#define MAX_THREADS_PER_BLOCK 1024

//GPU Kernel Implementation of Bitonic Sort
__global__ void bitonicSortGPU(int* arr, int j, int k)
{
    unsigned int i, ij;
    i = GET_GLOBAL_THREAD_IDX();
    ij = i ^ j;
    if (ij > i)
    {    if ((i & k) == 0)
        {    if (arr[i] > arr[ij])
            {   int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }    }
        else
        {    if (arr[i] < arr[ij])
            {   int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }    }    }    }



//MAIN PROGRAM
void sort(int* arr, int size) {       
    int* gpuArrmerge;
    int* gpuArrbiton;
    int* gpuTemp;
    // Allocate memory on GPU
    cudaMalloc((void**)&gpuArrmerge, size * sizeof(int));
    cudaMalloc((void**)&gpuTemp, size * sizeof(int));
    cudaMalloc((void**)&gpuArrbiton, size * sizeof(int));
    // Copy the input array to GPU memory
    cudaMemcpy(gpuArrmerge, arr, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(gpuArrbiton, arr, size * sizeof(int), cudaMemcpyHostToDevice);
    //Set number of threads and blocks for kernel calls
    int threadsPerBlock = MAX_THREADS_PER_BLOCK;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;
    int j, k;
    //Time the run and call GPU Bitonic Kernel
    for (k = 2; k <= size; k <<= 1){
        for (j = k >> 1; j > 0; j = j >> 1){
            bitonicSortGPU << <blocksPerGrid, threadsPerBlock >> > (gpuArrbiton, j, k);
        }    }
    cudaMemcpy(arr, gpuArrbiton, size * sizeof(int), cudaMemcpyDeviceToHost);
    //Destroy all variables
    delete[] arr;
    //End
    cudaFree(gpuArrmerge);
    cudaFree(gpuArrbiton);
    cudaFree(gpuTemp);
}
