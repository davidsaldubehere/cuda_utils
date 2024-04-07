#include "./common_ops/vector_add.h"
#include "./common_ops/matrix_mul.h"
#include <iostream>
#include <vector>

int main() {

    /*Vector addition*/
    const int N = 1 << 16;  // Array size of 2^16 (65536 elements)
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
    
    int N = 1 << 10; // 1024x1024 matrix
    std::vector<int> a(N * N);
    std::vector<int> b(N * N);
    std::vector<int> c(N * N);

    // Initialize matrices...

    matrix_mul(a, b, c, N);

    // Verify result...

    return 0;
}