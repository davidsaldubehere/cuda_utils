#ifndef MATRIX_MUL_H
#define MATRIX_MUL_H

#include <vector>
#include "cuda_utils.h"

void matrix_mul(const std::vector<int>& a, const std::vector<int>& b, std::vector<int>& c, int N);

#endif // MATRIX_MUL_H
