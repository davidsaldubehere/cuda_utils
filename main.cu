#include "./common_ops/vector_add.h"
#include "./common_ops/matrix_mul.h"
#include "./common_ops/biatonic_sort.h"
#include <cassert>
#include <iostream>
#include <vector>
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
int main() {

    /*Vector addition*/
    int N = 1 << 16;  // Array size of 2^16 (65536 elements)
    std::vector<int> a(N);
    std::vector<int> b(N);
    std::vector<int> result(N);

    // Initialize vectors
    for (int i = 0; i < N; ++i) {
        a[i] = rand() % 100;
        b[i] = rand() % 100;
    }

    // Call the custom vector addition function
    vector_add(a.data(), b.data(), result.data(), N);

    // Verify the result
    for (int i = 0; i < N; ++i) {
        if (result[i] != a[i] + b[i]) {
            std::cerr << "Error: Incorrect result at index " << i << std::endl;
            return 1;
        }
    }

    std::cout << "COMPLETED SUCCESSFULLY!" << std::endl;
    
    N = 1 << 10; // 1024x1024 matrix
    std::vector<int> d(N * N);
    std::vector<int> e(N * N);
    std::vector<int> f(N * N);

    // Initialize matrices...

    matrix_mul(d, e, f, N);

    // Verify result...
    
    for (int i = 0; i < N; i++) {
    // For every column...
        for (int j = 0; j < N; j++) {
        // For every element in the row-column pair
        int tmp = 0;
        for (int k = 0; k < N; k++) {
            // Accumulate the partial results
            tmp += d[i * N + k] * e[k * N + j];
        }

        // Check against the CPU result
        assert(tmp == f[i * N + j]); //takes a while
        }
    }
    /*sort*/
    const int size = 64;
        // Initialize the array with random values
    int arr[size];

    srand(static_cast<unsigned int>(time(nullptr)));
    for (int i = 0; i < size; ++i) 
    {
        arr[i] = rand() % 100;
    }
    std::cout << "\n\nUnsorted array: ";
    if (size <= 100) 
    {
        printArray(arr, size);
    }
    else 
    {
        printf("\nToo Big to print. Check Variable. Automated isSorted Checker will be implemented\n");
    }


    sort(arr, size);

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

    return 0;
}