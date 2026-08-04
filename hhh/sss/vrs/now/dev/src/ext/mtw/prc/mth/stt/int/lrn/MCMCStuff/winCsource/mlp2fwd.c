/* MLP2FWD - 20% faster than m-version
 *
 * MLP2FWD	Forward propagation through 2-layer network.
 *
 *	Description
 *	Y = MLP2FWD(NET, X) takes a network data structure NET together with a
 *	matrix X of input vectors, and forward propagates the inputs through
 *	the network to generate a matrix Y of output vectors. Each column of X
 *	corresponds to one input vector and each column of Y corresponds to one
 *	output vector.
 *
 *	[Y, Z] = MLPFWD(NET, X) also generates a matrix Z of the hidden unit
 *	activations where each row corresponds to one pattern.
 *
 * Last modified: 2001-02-12 22:44:57 EET
 *
 */

/* Copyright (C) 1998-2001 Aki Vehtari
 * 
 *This software is distributed under the GNU General Public 
 *License (version 2 or later); please refer to the file 
 *License.txt, included with the software, for details.
 *
 */

#include <math.h>
#include "mex.h"

void mexFunction(const int nlhs, mxArray *plhs[],
		 const int nrhs, const mxArray *prhs[])
{

  if (nlhs>2)
    mexErrMsgTxt( "Wrong number of output arguments.");
  
  if (nrhs!=2)
    mexErrMsgTxt( "Wrong number of input arguments." );
  
  if(!mxIsStruct(prhs[0]))
    mexErrMsgTxt("First input must be a structure.");
  
  {
    const double *x, *w1, *b1, *w2, *b2, dzero=0.0, done=1.0;
    double *z, *y, *p, pa;
    const int *dims;
    int i, j, n, nin, nhid, nout;
    char *trans="N";
    mxArray *field;

    dims = mxGetDimensions(prhs[1]);
    x = mxGetPr(prhs[1]);
    n = dims[0];
    nin = dims[1];
    
    if((field=mxGetField(*prhs, 0, "w1"))==NULL)
      mexErrMsgTxt("Could not get net.w1");
    dims = mxGetDimensions(field);
    if (dims[0]!=nin)
      mexErrMsgTxt("w1 should be nin x nhid");
    w1=mxGetPr(field);
    nhid=dims[1];
    
    if((field=mxGetField(*prhs, 0, "b1"))==NULL)
      mexErrMsgTxt("Could not get net.b1");
    dims = mxGetDimensions(field);
    if (dims[0]!=1 || dims[1]!=nhid)
      mexErrMsgTxt("b1 should be 1 x nhid");
    b1=mxGetPr(field);

    if((field=mxGetField(*prhs, 0, "w2"))==NULL)
      mexErrMsgTxt("Could not get net.w2");
    dims = mxGetDimensions(field);
    if (dims[0]!=nhid)
      mexErrMsgTxt("w2 should be nhid x nout");
    w2=mxGetPr(field);
    nout=dims[1];

    if((field=mxGetField(*prhs, 0, "b2"))==NULL)
      mexErrMsgTxt("Could not get net.b2");
    dims = mxGetDimensions(field);
    if (dims[0]!=1 || dims[1]!=nout)
      mexErrMsgTxt("b2 should be 1 x nout");
    b2=mxGetPr(field);

    plhs[0]=mxCreateDoubleMatrix(n, nout, mxREAL);
    y = mxGetPr(plhs[0]);
    if (nlhs>1) {
      plhs[1]=mxCreateDoubleMatrix(n, nhid, mxREAL);
      z=mxGetPr(plhs[1]);
    } else {
      z=mxCalloc(n*nhid,sizeof(double));
    }

    dgemm(trans,trans,&n,&nhid,&nin,&done,x,&n,w1,&nin,&dzero,z,&n);
    p=z;
    for (i=nhid;i>0;i--,b1++) {
      for (j=n;j>0;j--,p++) {
	*p+=*b1;
	pa=fabs(*p);
	*p = (pa > 18) ? (*p>0 ? 1.0 : -1.0)
	  : ((pa > 1.5e-8) ? 1.0-2.0/(exp(2.0**p)+1.0) : *p);
      }
    }
    dgemm(trans,trans,&n,&nout,&nhid,&done,z,&n,w2,&nhid,&dzero,y,&n);
    for (i=nout;i>0;i--,b2++) {
      for (j=n;j>0;j--,y++) {
	*y+=*b2;
      }
    }

    if (nlhs<2)
      mxFree(z);
    
  }
  
  return;
}     
