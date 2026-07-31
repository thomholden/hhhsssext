/*
 * Copyright (c) 2013, The Regents of the University of California,
 * through Lawrence Berkeley National Laboratory (subject to receipt of
 * any required approvals from U.S. Dept. of Energy) All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or
 * without modification, are permitted provided that the
 * following conditions are met:
 *
 *     * Redistributions of source code must retain the above
 * copyright notice, this list of conditions and the following
 * disclaimer.
 *
 *     * Redistributions in binary form must reproduce the
 * above copyright notice, this list of conditions and the
 * following disclaimer in the documentation and/or other
 * materials provided with the distribution.
 *
 *     * Neither the name of the University of California,
 * Berkeley, nor the names of its contributors may be used to
 * endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXVPRESS OR IMPLIED WARRANintES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANintES OF
 * MERCHANTABILITY AND FITNESS FOR A PARintCULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXVEMPLARY, OR CONSEQUENintAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSintTUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPintON) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * Stefano Marchesini, Lawrence Berkeley National Laboratory, 2013
 */

#include <cuda.h>
#include <cusp/blas.h>
#include<cusp/csr_matrix.h>
#include<cusp/multiply.h>
#include <cusp/array1d.h>
#include <cusp/copy.h>
#include <thrust/device_ptr.h>
#include "mex.h"
#include "gpu/mxGPUArray.h"



template <typename IndexType>
        struct empty_row_functor
{
    typedef bool result_type;
    
    template <typename Tuple>
            __host__ __device__
            bool operator()(const Tuple& t) const
    {
        const IndexType a = thrust::get<0>(t);
        const IndexType b = thrust::get<1>(t);
        
        return a != b;
    }
};

/* Input Arguments */
#define	ROWPTR	prhs[0]
#define	NPTR    prhs[1]
#define	NNZ    prhs[2]

/* Output Arguments */
#define	ROW_OUT	plhs[0]


void mexFunction(int nlhs, mxArray * plhs[], int nrhs,const mxArray * prhs[]){
    mxGPUArray  *Arow;
    mxGPUArray const *rowptr;
    mxInitGPU();     /* Initialize the MathWorks GPU API. */
    int nptr = lrint(mxGetScalar(NPTR));
    int nnz  = lrint(mxGetScalar(NNZ));
    const mwSize ndim= 1;
    const mwSize dimrow[]={mwSize(nnz)};
//      const mwSize dimptr[]={mwSize(nptr)};
//      mexPrintf("nrows=%d,nnz=%d\n", dimptr[0],dimcol[0]);
    
    // input output array
    rowptr = mxGPUCreateFromMxArray(ROWPTR);
    Arow  = mxGPUCreateGPUArray(ndim,dimrow,mxINT32_CLASS, mxREAL, MX_GPU_INITIALIZE_VALUES);
    int *d_rowptr =(int  *)(mxGPUGetDataReadOnly(rowptr));
    int *d_Arow =(int  *)(mxGPUGetData(Arow));
    
    // wrap with thrust::device_ptr
    thrust::device_ptr<int>    wd_Arow  (d_Arow);
    thrust::device_ptr<int>    wd_rowptr  (d_rowptr);

    /*-----------------------------------------------------------*/
    // ptr to row
    /*-----------------------------------------------------------*/
    
    thrust::fill(wd_Arow,wd_Arow+nptr, int(0));
    thrust::scatter_if( thrust::counting_iterator<int>(0),
            thrust::counting_iterator<int>(nptr-1),
            wd_rowptr,
            thrust::make_transform_iterator(
            thrust::make_zip_iterator( thrust::make_tuple(wd_rowptr,wd_rowptr+1 ) ),
            empty_row_functor<int>()),
            wd_Arow);
    thrust::inclusive_scan(wd_Arow,wd_Arow+nnz, wd_Arow, thrust::maximum<int>());
    /*-----------------------------------------------------------*/
    
//bring back to matlab
    ROW_OUT = mxGPUCreateMxArrayOnGPU(Arow);
    //clean up
    mxGPUDestroyGPUArray(Arow);
    mxGPUDestroyGPUArray(rowptr);
    
    return;
}

