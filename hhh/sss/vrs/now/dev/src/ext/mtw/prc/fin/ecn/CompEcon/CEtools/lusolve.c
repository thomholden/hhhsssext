#include "mex.h"
#include <math.h>
/*
% LUSOLVE Sparse LU solver: x(colindex)=U\(L\(b(rowindex)));
% USAGE
%   x=lusolve(L,U,b,rowindex,colindex);
% INPUTS
%   L        : lower triangular matrix (n x n) (dense or sparse)
%   U        : upper triangular matrix (n x n) (dense or sparse)
%   b        : dense vector (n x 1)
%   rowindex : optional row permutation index vector (n x 1)
%   colindex : optional column permutation index vector (n x 1)
% OUTPUT
%   x :  dense vector (n x 1)
% 
% Note: no checks are made on the triangularity of L or U. Only the
% lower part of L and the upper part of U are used. 
% Also, no checks are made to ensure that rowindex and colindex are
% valid permuation vectors (i.e., are composed of a permutation 
% of the integers 1,..,n).
% 
% The inputs can be obtained using
%    colindex=colmmd(A);
%    [L,U,P]=lu(A(:,colindex));
%    rowindex=find(P');

*/

double *spforesub(double *x, double *Pr, double *b, int *Ri, int *Cj, int n)
{
int k, j, rik, cjj;
double xj;
  if (x!=b) memcpy(x,b,n*sizeof(double));
  for (j=0, k=0; j<n; j++){
    cjj=*(++Cj);
    for (; k<cjj; k++){
      rik=Ri[k];
      if (rik>j) x[rik] -= Pr[k]*xj;
      else if (rik==j){x[j] /= Pr[k]; xj=x[j];}
    }
  }
  return(x);
}


double *foresub(double *x, double *Pr, double *b, int n)
{
int k, j, rik, cjk;
double xj;
  if (x!=b) memcpy(x,b,n*sizeof(double));
  for (j=0; j<n; j++){
    Pr+=j;
    x[j] /= *Pr++; 
    xj=x[j];
    for (k=j+1; k<n; k++) x[k] -= *Pr++*xj;
  }
  return(x);
}

double *spbacksub(double *x, double *Pr, double *b, int *Ri, int *Cj, int n)
{
int k, j, rik, cjj;
double xj;
  if (x!=b) memcpy(x,b,n*sizeof(double));
  Cj+=n;
  for (j=n-1, k=*Cj-1; j>=0; j--){
    cjj=*(--Cj);
    for (; k>=cjj; k--){
      rik=Ri[k];
      if (rik<j) x[rik] -= Pr[k]*xj;
      else if (rik==j){x[j] /= Pr[k]; xj=x[j];}
    }
  }
  return(x);
}

double *backsub(double *x, double *Pr, double *b, int n)
{
int k, j, rik, cjk;
double xj;
  if (x!=b) memcpy(x,b,n*sizeof(double));
  Pr+=n*n-1;
  for (j=n-1; j>=0; j--){
    x[j] /= *Pr--; 
    xj=x[j];
    for (k=j-1; k>=0; k--) x[k] -= *Pr--*xj;
    Pr-=n-j;
  }
  return(x);
}


void mexFunction(
  int nlhs, mxArray *plhs[],
  int nrhs, const mxArray *prhs[])
{
  /* ***************** */
  /* Declare variables */
  /* ***************** */
  double *x, *b, *Pr, *pindex;
  int n, i, *Ri, *Cj;
  /* ********************************************** */
  /* Determine input sizes and perform error checks */
  /* ********************************************** */
  if (nrhs>5)
    mexErrMsgTxt("Only four arguments may be passed");
  if (nrhs<3)
    mexErrMsgTxt("At least two arguments must be passed");
  if (nlhs>1)
    mexErrMsgTxt("ArrayMult produces only one output");
  for (n=0; n<nrhs; n++)
  if (!(mxIsDouble(prhs[n]) || (mxIsSparse(prhs[n]) && n<2)))       
    mexErrMsgTxt("Input arguments of inproper type");

  n=mxGetM(prhs[0]);
  if (mxGetN(prhs[0])!=n)
    mexErrMsgTxt("First input must be square");

  if (mxGetM(prhs[1])!=n || mxGetN(prhs[1])!=n)
    mexErrMsgTxt("Second input must be square");

  if (mxGetM(prhs[2])!=n)
    mexErrMsgTxt("Inputs are not comformable");
  if (mxGetN(prhs[2])!=1)
    mexErrMsgTxt("Third input must be a vector");

  plhs[0]=mxDuplicateArray(prhs[2]);
  x=mxGetPr(plhs[0]);


  /* If a row permutation vector is passed, permute the RHS (b): x=b(rowindex) */

  if (nrhs>=4){
    i=mxGetNumberOfElements(prhs[3]);
    if (i>0){
      if (mxGetNumberOfElements(prhs[3])!=n)
        mexErrMsgTxt("Row permutation index is the wrong size");
      b=mxGetPr(prhs[2]);
      pindex=mxGetPr(prhs[3]);
      for (i=0; i<n; i++) x[i]=b[(int)(pindex[i])-1];
    }
  }

  /* Forward substitution using the L factor: x=L\x */
  Pr=mxGetPr(prhs[0]);
  if (mxIsSparse(prhs[0])){
    Ri=mxGetIr(prhs[0]);
    Cj=mxGetJc(prhs[0]);
    spforesub(x,Pr,x,Ri,Cj,n);
  }
  else
    foresub(x,Pr,x,n);

  /* Backward substitution using the U factor: x=U\x */
  Pr=mxGetPr(prhs[1]);
  if (mxIsSparse(prhs[1])){
    Ri=mxGetIr(prhs[1]);
    Cj=mxGetJc(prhs[1]);
    spbacksub(x,Pr,x,Ri,Cj,n);
  }
  else
    backsub(x,Pr,x,n);

  /* If a column permutation vector is passed, permute the LHS: x(colindex)=x */
  if (nrhs==5){
    i=mxGetNumberOfElements(prhs[4]);
    if (i>0){
      if (mxGetNumberOfElements(prhs[4])!=n)
        mexErrMsgTxt("Column permutation index is the wrong size");
      b=mxCalloc(n,sizeof(double));
      pindex=mxGetPr(prhs[4]);
      for (i=0; i<n; i++) b[(int)(pindex[i])-1]=x[i];
      memcpy(x,b,n*sizeof(double));
      mxFree(b);
    }
  }
}

