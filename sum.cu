#include <cuda_runtime.h>
#include <stdio.h>

#include "include/cuda_stl.h"

// cpu
void sumArrays(float * a,float * b,float * res,const int size) {
    for(int i=0;i<size;i++) {
        res[i]=a[i]+b[i];
        // printf("sumArrays arrary index is: %d , sum is: %f\n", i, res[i]);//查看耗时，注释掉
    }
}

//通常grid和block为一维，apollo中pointpillar也是这样
// 1 2 3 4 5    1 2 3 4 5    1 2 3 4 5    ...
__global__ void sumArrayGpu(float *a, float *b, float *res, int size) {
    int i = threadIdx.x + blockIdx.x*blockDim.x;
    res[i] = a[i] + b[i];
    // printf("arrary index is: %d , sum is: %f\n", i, res[i]);//查看耗时，注释掉
}


int main(int arg, char **argv) {
    int dev = 0;
    cudaSetDevice(dev);

    int nBytes = sizeof(float) * SIZE;

// cpu mem
    float *a_h = (float *)malloc(nBytes);
    float *b_h = (float *)malloc(nBytes);
    float *res_h = (float *)malloc(nBytes);
    memset(res_h,0,nBytes);

// GPU mem
    float *a_d, *b_d, *res_d;
    cudaMalloc((float **)&a_d, nBytes);
    cudaMalloc((float **)&b_d, nBytes);
    cudaMalloc((float **)&res_d, nBytes);

// init data
    initData(a_h, SIZE);
    initData(b_h, SIZE);
    
    cudaMemcpy(a_d, a_h, nBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, b_h, nBytes, cudaMemcpyHostToDevice);

    // sumArrays(a_h, b_h, res_h, SIZE);

    dim3 block(1024);
    dim3 grid(SIZE/block.x);
    sumArrayGpu<<<grid, block>>>(a_d, b_d, res_d, SIZE);

    cudaMemcpy(res_h, res_d, nBytes, cudaMemcpyDeviceToHost);

    cudaDeviceReset();

    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(res_d);
    free(a_h);
    free(b_h);
    free(res_h);

    return 0;
}