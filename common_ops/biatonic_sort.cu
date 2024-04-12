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
    {
        if ((i & k) == 0)
        {
            if (arr[i] > arr[ij])
            {
                int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }
        }
        else
        {
            if (arr[i] < arr[ij])
            {
                int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }
        }
    }
}


//Function to print array
void printArray(int* arr, int size) 
{
    for (int i = 0; i < size; ++i)
        std::cout << arr[i] << " ";
    std::cout << std::endl;
}

//Automated function to check if array is sorted
bool isSorted(int* arr, int size) 
{
    for (int i = 1; i < size; ++i) 
    {
        if (arr[i] < arr[i - 1])
            return false;
    }
    return true;
}

//MAIN PROGRAM
int main()
{   
    int size = 128;
    
    //Create CPU based Arrays
    int* arr = new int[size];
    int* carr = new int[size];
    int* temp = new int[size];

    //Create GPU based arrays
    int* gpuArrmerge;
    int* gpuArrbiton;
    int* gpuTemp;

    // Initialize the array with random values
    srand(static_cast<unsigned int>(time(nullptr)));
    for (int i = 0; i < size; ++i) 
    {
        arr[i] = rand() % 100;
        carr[i] = arr[i];
    }

    //Print unsorted array 
    std::cout << "\n\nUnsorted array: ";
    if (size <= 100) 
    {
        printArray(arr, size);
    }
    else 
    {
        printf("\nToo Big to print. Check Variable. Automated isSorted Checker will be implemented\n");
    }

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
    cudaEventRecord(startGPU);
    for (k = 2; k <= size; k <<= 1)
    {
        for (j = k >> 1; j > 0; j = j >> 1)
        {
            bitonicSortGPU << <blocksPerGrid, threadsPerBlock >> > (gpuArrbiton, j, k);
        }
    }
    //Transfer Sorted array back to CPU
    cudaMemcpy(arr, gpuArrbiton, size * sizeof(int), cudaMemcpyDeviceToHost);

    // Display sorted GPU array
    std::cout << "\n\nSorted GPU array: ";
    if (size <= 100) 
    {
        printArray(arr, size);
    }
    else {
        printf("\nToo Big to print. Check Variable. Automated isSorted Checker will be implemented\n");
    }

    
    //Run the array with the automated isSorted checker
    if (isSorted(arr, size))
        std::cout << "\n\nSORT CHECKER RUNNING - SUCCESFULLY SORTED GPU ARRAY" << std::endl;
    else
        std::cout << "SORT CHECKER RUNNING - !!! FAIL !!!" << std::endl;

    //Destroy all variables
    delete[] arr;
    delete[] carr;
    delete[] temp;

    //End
    cudaFree(gpuArrmerge);
    cudaFree(gpuArrbiton);
    cudaFree(gpuTemp);

    std::cout << "\n------------------------------------------------------------------------------------\n||||| END. YOU MAY RUN THIS AGAIN |||||\n------------------------------------------------------------------------------------";
    return 0;
}