/*
*1_check_dimension
*/
#include <cuda_runtime.h>
#include <stdio.h>
__global__ void checkIndex(void)
{
    printf("x index: %d, threadIdx:(%d,%d,%d) blockIdx:(%d,%d,%d) blockDim:(%d,%d,%d) gridDim(%d,%d,%d)\n",
    threadIdx.x + threadIdx.y*blockDim.x + blockIdx.x*blockDim.x*blockDim.y + blockIdx.y*blockDim.x*blockDim.y*gridDim.x,
    threadIdx.x,threadIdx.y,threadIdx.z,
    blockIdx.x,blockIdx.y,blockIdx.z,
    blockDim.x,blockDim.y,blockDim.z,
    gridDim.x,gridDim.y,gridDim.z);

    printf("------------.\n");
}
int main(int argc,char **argv)
{
    dim3 block(3,3);
    dim3 grid(3,3);
    printf("grid.x %d grid.y %d grid.z %d\n",grid.x,grid.y,grid.z);
    printf("block.x %d block.y %d block.z %d\n",block.x,block.y,block.z);
    checkIndex<<<grid,block>>>();
    cudaDeviceReset();
    return 0;
}