// vector_add.h
#ifndef VECTOR_ADD_H
#define VECTOR_ADD_H

#include "cuda_utils.h"

// Declaration of the vector addition function
void vector_add(const int* a, const int* b, int* result, int size);

#endif // VECTOR_ADD_H