#include <stdio.h>
#include <cuda.h>

#include "mex.h"

__global__ void square_array(float *a, int N)
{
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  if (idx<N) a[idx] = a[idx] * a[idx];
}

void mexFunction(int nargout, mxArray *argout[], int nargin, const mxArray *argin[]) 
{
  float *input, *cuda_mem;  
  int N;
  size_t size;

  argout[0] = mxDuplicateArray(argin[0]);
  input = (float *)mxGetPr(argout[0]); 
  N = mxGetN(argout[0]) * mxGetM(argout[0]);
  size = N * sizeof(float);
  cudaMalloc((void **) &cuda_mem, size);   
  cudaMemcpy(cuda_mem, input, size, cudaMemcpyHostToDevice);
  int block_size = 4;
  int n_blocks = N/block_size + (N%block_size == 0 ? 0:1);
  square_array <<< n_blocks, block_size >>> (cuda_mem, N);
  cudaMemcpy(input, cuda_mem, size, cudaMemcpyDeviceToHost);
  cudaFree(cuda_mem);
}
