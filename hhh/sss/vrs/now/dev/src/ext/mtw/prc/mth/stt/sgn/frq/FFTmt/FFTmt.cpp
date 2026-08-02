/******************************************************************************\

  Copyright August 2006 Universite Laval, Quebec, Canada.
  All Rights Reserved.

  Permission to use, copy, modify and distribute this software and its
  documentation for educational, research and non-profit purposes, without
  fee, and without a written agreement is hereby granted, provided that the
  above copyright notice and the following three paragraphs appear in all
  copies. Any use in a commercial organization requires a separate license.

  IN NO EVENT SHALL UNIVERSITE LAVAL BE LIABLE
  TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
  DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND
  ITS DOCUMENTATION.


  UNIVERSITE LAVAL SPECIFICALLY DISCLAIM ANY WARRANTIES,
  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
  FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS ON AN
  "AS IS" BASIS, AND UNIVERSITE LAVAL HAS NO OBLIGATION TO
  PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.


   ---------------------------------
  |Please send all BUG REPORTS to:  |
  |                                 |
  |   jgenest@gel.ulaval.ca         |
  |                                 |
   ---------------------------------

\*****************************************************************************/


/** Matlab C wrapper for FFTmt                   **/
/** See file testFFTmt.m for compilation details **/
/** and example                                  **/
/** Jerome Genest and Simon Potvin, August 2006  **/

/** This mex file implement vectoried FFTs on multiple threads      **/
/** When a matrix is passed to FFTmt, it is divided in "numCPU" and **/
/** each fraction of the problem is executed in a separate thread   **/
/** Example: if numCPU = 2 and the matrix has 256x2^14 elements     **/
/** 128 FFTs are performed in each thread, allowing the OS to	    **/
/** distribute the load on 2 processors. 			    **/

/** A single FFT will not be accelerated by this code.  	    **/
/** The FFTw library already provides provision for that	    **/
/** but the is not currently used by Matlab			    **/
/** see www.fftw.org for details				    **/ 

/** The same FFT library than Matlab uses is employed so that we    **/
/** don't even have to link against the FFTw lib.		    **/

/** Developed with pthreads, so UNIX only, not for Windows, sorry   **/


/*****************************************************************************\
*
* Known bug:
*
* We are supposed to use the fftw planner r2c for real ffts, but we use it only
* when the real fft has a even number of points. This is SLOWER but done to circumvent
* an apparent bug in FFTW. In fact, in multi-threads the r2c planner make "fftw_execute" to
* do a segmentation fault when vectors have odd number of points. 
* Example of bug: 256 real ffts of 2^14+1 points, r2c planner in 2 threads.
*
* To fix the problem, only the EvenRealCase uses the r2c fftw planner. 
* For odd cases, we use the complex planner with the imaginary part = 0.(Slower)
*
* A bug report was sent to www.fftw.org.
\*****************************************************************************/

#include "mex.h"
#include "matrix.h"
#include <pthread.h>
#include <math.h>
#include <fftw3.h>

// Number of threads
#define numCPU 2 

 typedef   struct 
        {
        double* in_r;
        double* in_i;
        double* out_r;
        double* out_i;
        int sizeCol;
        int sign;
        bool EvenRealCase;
        fftw_iodim dims;
        fftw_iodim howmany_dims;
        fftw_plan p;
        } FFTparams;
 

 void GuruFFT(FFTparams* params) 
 {
       if(params->EvenRealCase){
           fftw_execute_split_dft_r2c(params->p,params->in_r,params->out_r,params->out_i);
            // Real TF, copy Data in second part
            //printf("Copying data real ft \n");
                int j,i,l;
                int realVecLen = (int)floor((float)params->sizeCol/2);
                for(i=0;i<params->howmany_dims.n;i++)
                 for(j=1;j<realVecLen;j++)
                    {
                    l=i*params->sizeCol+realVecLen;
                    params->out_r[l+j]=  params->out_r[l-j];
                    params->out_i[l+j]=  -params->out_i[l-j];
                    }
           if(params->sign==FFTW_BACKWARD)
           {
               int j;
               //printf("Backward FFT: DIVIDE results by N %f\n",(double)params->sizeCol);
               for(j=0;j<params->sizeCol*params->howmany_dims.n;j++)
                   {
                    params->out_r[j]=  (params->out_r[j])/params->sizeCol;
                    params->out_i[j]=  -(params->out_i[j])/params->sizeCol;
                   }
           }
       }
       else{
           fftw_execute_split_dft(params->p,params->in_r,params->in_i,params->out_r,params->out_i);
           if(params->sign==FFTW_BACKWARD)
           {
               int j;
               //printf("Backward FFT: DIVIDE results by N %f\n",(double)params->sizeCol);
               for(j=0;j<params->sizeCol*params->howmany_dims.n;j++)
                   {
                    params->out_r[j]=  (params->out_r[j])/params->sizeCol;
                    params->out_i[j]=  (params->out_i[j])/params->sizeCol;
                   }
           }
       }
       

 }
 

 
 void *thread_function(void *arg) 
{   
    FFTparams* tt=(FFTparams*)arg;
  
     GuruFFT(tt); 
	
     return NULL;
}


void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
int elements,number_of_dims;
double *out_r, *in_r, *out_i, *in_i;
const int  *dim_array;
pthread_t mythread[numCPU];
FFTparams threadArg[numCPU];
int FFT_sign;
mxArray *tempMAT=NULL;
bool EvenRealCase=0;

	 if(nrhs!=2) 
        {
        mexErrMsgTxt("Two  inputs required.");
        } 
     else if(nlhs>1) 
        {
        mexErrMsgTxt("Too many  output arguments");
        }
     // Check data type of input argument. 
    if (!(mxIsDouble(prhs[0]))) 
        {
        mexErrMsgTxt("Input array must be of type double.");
        }
    
      

    number_of_dims = mxGetNumberOfDimensions(prhs[0]);
    if (number_of_dims !=2)
        {
        mexErrMsgTxt("Looking for a 2D matrix, FFT alonf 1st D");
        }

    dim_array = mxGetDimensions(prhs[0]);
    
    /* Get the data. */
    in_r = (double *)mxGetPr(prhs[0]);
    in_i = (double *)mxGetPi(prhs[0]);
     
    plhs[0] = mxCreateDoubleMatrix(dim_array[0], dim_array[1], mxCOMPLEX);
    out_r = (double *)mxGetPr(plhs[0]);
    out_i = (double *)mxGetPi(plhs[0]);
    
    FFT_sign = (int)*mxGetPr(prhs[1]);
    FFT_sign = -FFT_sign/abs(FFT_sign);
    
    if(in_r==NULL)
        mexErrMsgTxt("Vector Real Part must be non-NULL");
    
    if(in_i == NULL )
        {  // making in_i to point to an array of zeros
            if(dim_array[0]%2==0)
                  EvenRealCase=1;
            else {
                  tempMAT= mxCreateDoubleMatrix(dim_array[0], dim_array[1],mxREAL);
                  in_i = (double *)mxGetPr(tempMAT);
            }
        }
    
    if(FFT_sign == FFTW_BACKWARD && EvenRealCase==0)
        {
        double *temp;
        //printf("BackwardFFT SWAP real and complex\n");

        temp=in_r;
        in_r=in_i;
        in_i=temp;
        
        temp=out_r;
        out_r=out_i;
        out_i=temp;
        }
    
    int i=0;
    int firstCol, lastCol,sizeCol;
    while(i<numCPU)
        {
        //printf("setting thread params for guru fftw\n");
        
        firstCol = i*(int)floor((float)dim_array[1]/numCPU);
        lastCol = (i+1)*(int)floor((float)dim_array[1]/numCPU);
        sizeCol = dim_array[0];
        
        if(numCPU-1==i) 
                lastCol=dim_array[1]; //case: number of fft divide by numCPU is odd
            
        threadArg[i].in_r=&(in_r[firstCol*sizeCol]);
        threadArg[i].in_i=&(in_i[firstCol*sizeCol]);
        threadArg[i].out_r=&(out_r[firstCol*sizeCol]);
        threadArg[i].out_i=&(out_i[firstCol*sizeCol]);


        threadArg[i].sizeCol=sizeCol;
        threadArg[i].sign = FFT_sign;
        threadArg[i].dims.n = sizeCol;
        threadArg[i].dims.is= 1;
        threadArg[i].dims.os=1;
      
        threadArg[i].howmany_dims.n = lastCol-firstCol;
        threadArg[i].howmany_dims.is = sizeCol;
        threadArg[i].howmany_dims.os = sizeCol;
        
        threadArg[i].EvenRealCase=EvenRealCase;
        
        if(EvenRealCase){
            //printf("EvenRealCase plan FFT \n");
            threadArg[i].p = fftw_plan_guru_split_dft_r2c(1, &(threadArg[i].dims),1, &(threadArg[i].howmany_dims),
               &(in_r[firstCol*sizeCol]), &(out_r[firstCol*sizeCol]), &(out_i[firstCol*sizeCol]),FFTW_ESTIMATE);
        }
        else{
            //printf("Complex plan FFT \n");
            threadArg[i].p = fftw_plan_guru_split_dft(1, &(threadArg[i].dims),1, &(threadArg[i].howmany_dims),
                &(in_r[firstCol*sizeCol]), &(in_i[firstCol*sizeCol]), &(out_r[firstCol*sizeCol]), &(out_i[firstCol*sizeCol]),FFTW_ESTIMATE);
        }

 
        
     if(i<numCPU-1)
         {
         //printf("creating thread.\n");
         if ( pthread_create( &(mythread[i]), NULL, thread_function, (void*)&(threadArg[i])))
            {
            mexErrMsgTxt("error creating thread.");
            //abort();
            }
          }
        i++;
        }
           
    GuruFFT(&threadArg[numCPU-1]); // Doing also in the main thread
    
    i=0;
    while(i<numCPU-1)
        {
        if ( pthread_join ( mythread[i], NULL ) )
            {
            printf("error joining thread.");
            //abort();
            }
        fftw_destroy_plan(threadArg[i].p);
        i++;
        }
    fftw_destroy_plan(threadArg[i].p); // for main thread
    if(tempMAT)
           mxDestroyArray(tempMAT);
}
