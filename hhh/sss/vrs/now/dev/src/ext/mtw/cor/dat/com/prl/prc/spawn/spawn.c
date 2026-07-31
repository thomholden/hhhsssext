/* MEX-file, spawn.c
 * 1.01 A working version, bglenn, 27 January 2000 
*/
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <errno.h>
#include "matrix.h"
#include "mex.h"

void getarg(const mxArray *ptr1, char **ptr2);

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
   char *args[20];
   int i,rval;
   double *y;

   if (((nrhs < 1)||(nrhs > 10)) || (nlhs != 1))
   {
       mexPrintf("Usage:\n");
       mexErrMsgTxt("y = spawn('executable','arg1','arg2',. .'arg9')\n");
   }

   for(i=0;i<nrhs;i++)
   {
      getarg(prhs[i],&args[i]);
   }
   args[i] = NULL;

   _fileinfo = 1;

   /* _fileinfo is 0 by default. Set _fileinfo to non-zero so that
   * the terminating the spawned process doesn't kill Matlab
   * See _fileinfo in VC5 help.
   */

   plhs[0]=mxCreateDoubleMatrix(1,1,mxREAL); // return a 1x1 real Matrix
   y = mxGetPr(plhs[0]); // pointer to real part of return argument 

   rval = _spawnvp( _P_WAIT, args[0], args );
   y[0] = (double)rval;

   for(i=0;i<nrhs;i++)
   {
      mxFree(args[i]);
   }

   switch (rval)
   {
        case E2BIG:
             mexErrMsgTxt("Argument list exceeds 1024 bytes\n");
             break;

        case EINVAL:
             mexErrMsgTxt("mode argument is invalid\n");
             break;

        case ENOENT:
             mexErrMsgTxt("File or path is not found\n");
             break;

        case ENOEXEC:
             mexErrMsgTxt("Specified file is not executable\n");
             break;

        case ENOMEM:
             mexErrMsgTxt("Not enough memory\n");
             break;

        default:
             break;
   }
}

void getarg(const mxArray *ptr1,char **ptr2)
{
   int buflen;
   int status;

   buflen = (mxGetM(ptr1) * mxGetN(ptr1)) + 1;
   *ptr2 = mxCalloc(buflen, sizeof(char));

   if (*ptr2 == NULL)
   {
     mexErrMsgTxt("Not enough heap space to hold converted string.");
   }

   status = mxGetString(ptr1, *ptr2, buflen);
   if (status != 0)
   {
     mexErrMsgTxt("Could not convert string data.");
   }
}
