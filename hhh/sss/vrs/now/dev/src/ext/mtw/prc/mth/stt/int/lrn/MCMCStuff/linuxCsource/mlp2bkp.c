/* MLP2BKP - 50-70% faster than Matlab m-version
 *
 * MLP2BKP	Backpropagate gradient of error function for 2-layer network.
 *
 *	Description
 *	G = MLP2BKP(NET, X, Z, DELTAS) takes a network data structure NET
 *	together with a matrix X of input vectors, a matrix  Z of hidden unit
 *	activations, and a matrix DELTAS of the  gradient of the error
 *	function with respect to the values of the output units (i.e. the
 *	summed inputs to the output units, before the activation function is
 *	applied). The return value is the gradient G of the error function
 *	with respect to the network weights. Each row of X corresponds to one
 *	input vector.
 *
 *	This function is provided so that the common backpropagation
 *	algorithm can be used by multi-layer perceptron network models to
 *	compute gradients for mixture density networks as well as standard
 *	error functions.
 *
 * Last modified: 2001-02-14 13:35:15 EET
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

  if (nlhs>1)
    mexErrMsgTxt( "Wrong number of output arguments.");
  
  if (nrhs!=4)
    mexErrMsgTxt( "Wrong number of input arguments." );
  
  if(!mxIsStruct(prhs[0]))
    mexErrMsgTxt("First input must be a structure.");
  
  {
    const double *x, *z, *pz, *deltas, *w1, *b1, *w2, *b2, dzero=0.0, done=1.0;
    double *g, *delhid, *pd;
    const int *dims;
    int i, j, n, nin, nhid, nout, nwts;
    const char *N="N", *T="T";
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
    
    dims = mxGetDimensions(prhs[2]);
    if (dims[0]!=n || dims[1]!=nhid)
      mexErrMsgTxt("z should be n x nhid");
    z = mxGetPr(prhs[2]);
    
    dims = mxGetDimensions(prhs[3]);
    if (dims[0]!=n || dims[1]!=nout)
      mexErrMsgTxt("deltas should be n x nout");
    deltas = mxGetPr(prhs[3]);
    
    nwts=(nin+1)*nhid+(nhid+1)*nout;

    plhs[0]=mxCreateDoubleMatrix(1, nwts, mxREAL);
    g = mxGetPr(plhs[0]);

    delhid=mxCalloc(n*nhid,sizeof(double));

    /* gw1 */
    dgemm_(N,T,&n,&nhid,&nout,&done,deltas,&n,w2,&nhid,&dzero,delhid,&n);
    pd=delhid;
    pz=z;
    for (i=n*nhid;i>0;i--,pd++,pz++)
      *pd*=(1.0-*pz**pz);
    dgemm_(T,N,&nin,&nhid,&n,&done,x,&n,delhid,&n,&dzero,g,&nin);
    /* gb1 */
    g+=nin*nhid;
    pd=delhid;
    for (i=nhid;i>0;i--,g++)
      for (j=n;j>0;j--,pd++)
	*g+=*pd;
    mxFree(delhid);
    /* gw2 */
    dgemm_(T,N,&nhid,&nout,&n,&done,z,&n,deltas,&n,&dzero,g,&nhid);
    /* gb2 */
    g+=nhid*nout;
    pd=deltas;
    for (i=nout;i>0;i--,g++)
      for (j=n;j>0;j--,pd++)
	*g+=*pd;
  }
  
  return;
}     
