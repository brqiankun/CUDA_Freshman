#include<stdio.h>
#include<cuda_runtime.h>

__global__ void warpReduce() {
    int laneId = threadIdx.x & 0x1f;
    int value = 8 - laneId;

    for(int i = 4; i >= 1; i/=2) {
        value += __shfl_xor_sync(0xffffffff, value, i, 32);
        printf("thread %d  i=%d value = %d\n", threadIdx.x, i, value);
        __syncthreads();
    }

    printf("thread %d final value = %d\n", threadIdx.x, value);
}

int main() {
    warpReduce<<<1, 8>>>();
    cudaDeviceSynchronize();
}
