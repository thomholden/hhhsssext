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
 * CONTRIBUTORS "AS IS" AND ANY EXVPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXVEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * Stefano Marchesini, Lawrence Berkeley National Laboratory, 2013
 */

#include <cuda.h>
#include <cusp/complex.h>
#include <cusp/blas.h>
#include<cusp/csr_matrix.h>
#include<cusp/multiply.h>
#include <cusp/array1d.h>
#include <cusp/copy.h>
#include <thrust/device_ptr.h>
#include "mex.h"
#include "gpu/mxGPUArray.h"

/* Input Arguments */
#define	VAL	prhs[0]
#define	COL	prhs[1]
#define	ROWPTR	prhs[2]
// #define	NCOL    prhs[3]
// #define	NROW    prhs[4]
// #define	NNZ    prhs[5]
#define	XV    prhs[3]


/* Output Arguments */
#define	Y	plhs[0]

void mexFunction(int nlhs, mxArray * plhs[], int nrhs,const mxArray * prhs[]){
    
    mxGPUArray const *Aval;
    mxGPUArray const *Acol;
    mxGPUArray const *Aptr;
    mxGPUArray const *x;
    mxGPUArray  *y;
    
//     int nnzs = lrint(mxGetScalar(NCOL));
//     int nrows = lrint(mxGetScalar(NROW));
//     int nptr=nrows+1;
//     int nnz  = lrint(mxGetScalar(NNZ));
//     
    
    /* Initialize the MathWorks GPU API. */
    mxInitGPU();
    
    /*get matlab variables*/
    Aval = mxGPUCreateFromMxArray(VAL);
    Acol = mxGPUCreateFromMxArray(COL);
    Aptr = mxGPUCreateFromMxArray(ROWPTR);
    x    = mxGPUCreateFromMxArray(XV);
    
    int nnz=mxGPUGetNumberOfElements(Acol);
    int nrowp1=mxGPUGetNumberOfElements(Aptr);
    int ncol =mxGPUGetNumberOfElements(x);

    
    mxComplexity isXVreal = mxGPUGetComplexity(x);
    mxComplexity isAreal = mxGPUGetComplexity(Aval);
    const mwSize ndim= 1;
    const mwSize dims[]={(mwSize) (nrowp1-1)};

    if (isAreal!=isXVreal)
    {
        mexErrMsgTxt("Aval and X must have the same complexity");
        return;
    }

    if(mxGPUGetClassID(Aval) != mxSINGLE_CLASS||
   mxGPUGetClassID(x)!= mxSINGLE_CLASS||
   mxGPUGetClassID(Aptr)!= mxINT32_CLASS||
   mxGPUGetClassID(Acol)!= mxINT32_CLASS){
     mexErrMsgTxt("usage: gspmv(single, int32, int32, single )");
     return;
    }
    
    //create output vector
    y = mxGPUCreateGPUArray(ndim,dims,mxGPUGetClassID(x),isAreal, MX_GPU_DO_NOT_INITIALIZE);
     
    
    /* wrap indices from matlab */
    typedef const int  TI;  /* the type for index */
    TI *d_col =(TI  *)(mxGPUGetDataReadOnly(Acol));
    TI *d_ptr =(TI  *)(mxGPUGetDataReadOnly(Aptr));
    // wrap with thrust::device_ptr
    thrust::device_ptr<TI>    wrap_d_col  (d_col);
    thrust::device_ptr<TI>    wrap_d_ptr  (d_ptr);
    // wrap with array1d_view 
    typedef typename cusp::array1d_view< thrust::device_ptr<TI> >   idx2Av;
    // wrap index arrays
    idx2Av colIndex (wrap_d_col , wrap_d_col + nnz);
    idx2Av ptrIndex (wrap_d_ptr , wrap_d_ptr + nrowp1);
           
    if (isAreal!=mxREAL){

        typedef const cusp::complex<float> TA;  /* the type for A */
        typedef const cusp::complex<float> TXV; /* the type for X */
        typedef cusp::complex<float> TYV; /* the type for Y */

        // wrap with array1d_view 
        typedef typename cusp::array1d_view< thrust::device_ptr<TA > >   val2Av;
        typedef typename cusp::array1d_view< thrust::device_ptr<TXV > >   x2Av;
        typedef typename cusp::array1d_view< thrust::device_ptr<TYV > >   y2Av;
        
        /* pointers from matlab */
        TA *d_val =(TA  *)(mxGPUGetDataReadOnly(Aval));
        TXV *d_x   =(TXV  *)(mxGPUGetDataReadOnly(x));
        TYV *d_y   =(TYV  *)(mxGPUGetData(y));
        
        // wrap with thrust::device_ptr
        thrust::device_ptr<TA >    wrap_d_val  (d_val);
        thrust::device_ptr<TXV >    wrap_d_x    (d_x);
        thrust::device_ptr<TYV >    wrap_d_y  (d_y);
        
        // wrap  arrays
        val2Av valIndex (wrap_d_val , wrap_d_val + nnz);
        x2Av xIndex   (wrap_d_x   , wrap_d_x   + ncol);
        y2Av yIndex(wrap_d_y, wrap_d_y+ nrowp1-1);
//        y2Av yIndex(wrap_d_y, wrap_d_y+ ncol);
        
        // combine info in CSR matrix
        typedef  cusp::csr_matrix_view<idx2Av,idx2Av,val2Av> DeviceView;
        
        DeviceView As(nrowp1-1, ncol, nnz, ptrIndex, colIndex, valIndex);
                
        // multiply matrix
        cusp::multiply(As, xIndex, yIndex);
        
    }
     else{
         
        typedef const float TA;  /* the type for A */
        typedef const float TXV; /* the type for X */
        typedef float TYV; /* the type for Y */
   
        /* pointers from matlab */
        TA *d_val =(TA  *)(mxGPUGetDataReadOnly(Aval));
        TXV *d_x   =(TXV  *)(mxGPUGetDataReadOnly(x));
        TYV *d_y   =(TYV  *)(mxGPUGetData(y));
        
        // wrap with thrust::device_ptr!
        thrust::device_ptr<TA >    wrap_d_val  (d_val);
        thrust::device_ptr<TXV >    wrap_d_x    (d_x);
        thrust::device_ptr<TYV >    wrap_d_y  (d_y);
        // wrap with array1d_view 
        typedef typename cusp::array1d_view< thrust::device_ptr<TA > >   val2Av;
        typedef typename cusp::array1d_view< thrust::device_ptr<TXV > >   x2Av;
        typedef typename cusp::array1d_view< thrust::device_ptr<TYV > >   y2Av;
        
        // wrap  arrays
        val2Av valIndex (wrap_d_val , wrap_d_val + nnz);
        x2Av xIndex   (wrap_d_x   , wrap_d_x   + ncol);
        //y2Av yIndex(wrap_d_y, wrap_d_y+ ncol);        
        y2Av yIndex(wrap_d_y, wrap_d_y+ nrowp1-1);
        
        // combine info in CSR matrix
        typedef  cusp::csr_matrix_view<idx2Av,idx2Av,val2Av> DeviceView;
        
        DeviceView As(nrowp1-1, ncol, nnz, ptrIndex, colIndex, valIndex);
                
        // multiply matrix
        cusp::multiply(As, xIndex, yIndex);
        
    }

    Y = mxGPUCreateMxArrayOnGPU(y);
    
    mxGPUDestroyGPUArray(Aval);
    mxGPUDestroyGPUArray(Aptr);
    mxGPUDestroyGPUArray(Acol);
    mxGPUDestroyGPUArray(x);
    mxGPUDestroyGPUArray(y);

    return;
}

