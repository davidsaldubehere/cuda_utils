// vector_add.h
#ifndef BIATONIC_SORT_H
#define BIATONIC_SORT_H

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda_utils.h"

// Declaration of the vector addition function
void biatonic_sort(int *a, int n);

#endif // BIATONIC_SORT_H