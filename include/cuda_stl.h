#ifndef CUDA_STL_H
#define CUDA_STL_H

#define SIZE 1024*1024

// 固定数据 便于观察index和sum结果
void initData(float *data, int count) {
    for (int i=0; i < count; i++) {
        data[i] = i * 1.0;
    }
}

#endif