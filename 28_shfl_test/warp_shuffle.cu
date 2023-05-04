#include<stdio.h>
#include<cuda_runtime.h>

__global__ void bcast(int arg) {
    int laneId = threadIdx.x & 0x1f; //转换线程ID为[0, 31]
    int value;
    if(laneId == 0) {
        value = arg;
    }
    value = __shfl_sync(0xfffffff, value, 0, 32);
    if(value != arg) {
        printf("Thread %d failed.\n", threadIdx.x);
    }
}

int main() {
        bcast<<<1, 32>>>(1234);
        cudaDeviceSynchronize();

        return 0;
}