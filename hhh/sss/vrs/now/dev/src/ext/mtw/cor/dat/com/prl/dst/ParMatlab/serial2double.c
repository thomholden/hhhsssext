

#include <math.h>
#include "mex.h"
#include "matrix.h"

void mexFunction( int nlhs, mxArray *plhs[], 
                  int nrhs, const mxArray*prhs[] )
     
{ 
    unsigned char *outptr, t; 
    mxChar *inptr;
    int i,j,k; 
    int elements, characteres;
    int test_endian=1;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 1) { 
        mexErrMsgTxt("One argument required."); 
    } else if (nlhs > 1) {
        mexErrMsgTxt("Too many output arguments."); 
    } 
    
    if( mxIsChar(prhs[0]) != 1  ) {
         mexErrMsgTxt("Input must a valid string");
       }
     
   
    characteres = mxGetNumberOfElements(prhs[0]);
    /*mexPrintf("%d\n",characteres);*/
       
    /*initialize pointer to the input data*/
    inptr = (mxChar *) mxGetPr(prhs[0]);
          
    /*find number of bytes that were encoded (0 or 92) */   
    i=0;
    for (j=0; j<characteres; j++) {
       i=i+(inptr[j]== 92);
       }
    /*mexPrintf("Number encoded bytes %d\n",encoded_bytes);*/
    elements=(characteres-i)/sizeof(double);
    /*mexPrintf("Number of elements %d\n",elements); */
       
    /* Allocate memory for output array */
    plhs[0] = mxCreateDoubleMatrix(elements,1, mxREAL);
      
    /* Initiliza byte pointer for the output array */
    outptr = (unsigned char *) mxGetPr(plhs[0]);
      
    /*mexPrintf("Is this machine little-endian ? %d\n",(*(unsigned char*)&test_endian)); */    

    /*move data to the output array (decoding 0's and 92's)*/
   if (*(unsigned char*)&test_endian) 
    {
    i=sizeof(double);
    k=0;
    for (j=0; j<characteres; j++ ) {
         t= (unsigned char) inptr[j];
         if ( t==92)  {j++;
           t=(unsigned char) inptr[j];
           t=t-1; }
         outptr[(--i)+(k*sizeof(double))]=t ^ 205; /*un-xoring the encoded data*/
         if (i==0) { k++; i=sizeof(double);}
     }
    }
    else
    {
    i=0;
    for (j=0; j<characteres; j++ ) {
         t= (unsigned char) inptr[j];
         if ( t==92)  {j++;
           t=(unsigned char) inptr[j];
           t=t-1; }
        outptr[i++]=t ^ 205; /*un-xoring the encoded data*/
     }
    }

}
