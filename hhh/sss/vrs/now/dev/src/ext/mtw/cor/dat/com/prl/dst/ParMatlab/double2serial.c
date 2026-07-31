
#include <math.h>
#include "mex.h"
#include "matrix.h"

void mexFunction( int nlhs, mxArray *plhs[], 
                  int nrhs, const mxArray*prhs[] )
     
{ 
    unsigned char *outptr; 
    unsigned char *inptr;
    unsigned char t;
    unsigned int i,j,k; 
    unsigned int elements, characteres, bytestosend;
    int test_endian=1;

    
    /* Check for proper number of arguments */
    
    if (nrhs != 1) { 
        mexErrMsgTxt("One argument required."); 
    } else if (nlhs > 1) {
        mexErrMsgTxt("Too many output arguments."); 
    } 
    
    /* Check to make sure the first input argument double and real */
       
    if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ) {
         mexErrMsgTxt("Input must be double and real");
       }
             
    elements = mxGetNumberOfElements(prhs[0]);
    /*mexPrintf("%d\n",elements);*/
    characteres=sizeof(double)*elements;
    /*mexPrintf("%d\n",characteres);*/
   
    /*initialize pointer to the input data*/
    inptr =(unsigned char *)  mxGetPr(prhs[0]);
        
    /*find number of zeros in the string of bytes, zeros can not be
      sent to the output because they'll truncate the string (eol=0)*/    
    i=0;
    for (j=0; j<characteres; j++) {
       t=inptr[j] ^ 205; /* first a xor because there is a lot of real 0's*/
       i=i+(t==0)+(t==92);
       }
    /*mexPrintf("Number of zeros %d\n",i);*/
    bytestosend=characteres+i; 
    /* Allocate memory for output string */   
    outptr=mxCalloc(bytestosend+1,sizeof(unsigned char));
      
    /*move data to output string, (0 ==> [92 92] , 92 ==> [92 93])*/       
    if (*(unsigned char*)&test_endian)
    {
     i=0;
     for (j=1; j<=elements; j++) for (k=0; k<sizeof(double); k++) { 
        t=inptr[j*sizeof(double)-k-1] ^ 205; /*the encoding includes this xor*/
        if ( (t==0)||(t==92) ) { /*and the take care of 0's and 92's*/
          
          outptr[i++]=92; 
          outptr[i++]=t+1; 
          }
        else  outptr[i++]=t; 
        }
    }
    else
    {
     i=0;
     for (j=0; j<characteres; j++) { 
        t=inptr[j] ^ 205; /*the encoding includes this xor*/
        if ( (t==0)||(t==92) ) { /*and the take care of 0's and 92's*/
          outptr[i++]=92; 
          outptr[i++]=t+1; 
          }
        else  outptr[i++]=t; 
        }
    }
       
    outptr[bytestosend]=NULL;  /*mark end of string*/
       
    plhs[0] = mxCreateString(( char *)outptr); /*matlab output var */
       
}

