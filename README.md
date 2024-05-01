# Usage

We have created an example main file that shows how to utilize the various libraries. You'll need NVIDIA [https://developer.nvidia.com/cuda-toolkit](Cuda) and have the nvcc compiler on path.

We don't have a make file yet, but you can just compile each library like ```nvcc -c vector_add.cu -o vector_add.o``` and then create the final executable with the needed libraries ```
nvcc ./common_ops/vector_add.o main.o -o final```

Feel free to clone the repo or copy the code
