#include "mex.h"
#include "matrix.h"

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	mxArray *apIn[3],*apBuf[1],*pCell;
	int i,j,n = mxGetNumberOfElements(prhs[1]),n0 = 0;

	if( mxIsCell(prhs[1]) )
		pCell = prhs[1];
	else
		mexCallMATLAB(1,&pCell,1,&prhs[1],"num2cell");

	if( nrhs >= 3 )
		apBuf[0] = prhs[2];
	else
	{
		apBuf[0] = mxGetCell(pCell,0);
		n0 = 1;
	}

	apIn[0] = prhs[0];
	for(i = n0;i<n;++i)
	{
		apIn[1] = apBuf[0];
		apIn[2] = mxGetCell(pCell,i);

		mexCallMATLAB(1,apBuf,3,apIn,"feval");
	}

	plhs[0] = apBuf[0];
}