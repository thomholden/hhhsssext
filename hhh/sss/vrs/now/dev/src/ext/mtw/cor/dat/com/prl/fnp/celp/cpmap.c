#include "mex.h"
#include "matrix.h"

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	mxArray **ppIn = 0,**ppOut = 0,**ppCells = 0;
	int i,j,fAnyCell = 0,nNumDims = 0,nIters = 0,*anDims = 0;

	if( nrhs > 1 )
	{
		nIters = mxGetNumberOfElements(prhs[1]);
		anDims = mxGetDimensions(prhs[1]);
		nNumDims = mxGetNumberOfDimensions(prhs[1]);
	}

	for(i = 0;i<nlhs;++i)
		plhs[i] = mxCreateCellArray(nNumDims,anDims);

	ppOut = (mxArray **)mxCalloc(nlhs,sizeof(mxArray *));
	ppIn = (mxArray **)mxCalloc(nrhs,sizeof(mxArray *));
	ppIn[0] = prhs[0];

	ppCells = (mxArray **)mxCalloc(nrhs-1,sizeof(mxArray *));
	for(i = 1;i<nrhs;++i)
	{
		if( nIters != mxGetNumberOfElements(prhs[i]) )
			mexErrMsgTxt("All arguments must have the same numel");

		if( mxIsCell(prhs[i]) )
		{
			ppCells[i-1] = prhs[i];
			fAnyCell = 1;
		}
		else
			mexCallMATLAB(1,&ppCells[i-1],1,&prhs[i],"num2cell");
	}

	for(i = 0;i<nIters;++i)
	{
		for(j = 1;j<nrhs;++j)
			ppIn[j] = mxGetCell(ppCells[j-1],i);

		mexCallMATLAB(nlhs,ppOut,nrhs,ppIn,"feval");

		for(j = 0;j<nlhs;++j)
			mxSetCell(plhs[j],i,ppOut[j]);
	}

/*	Shall I return vector if all inputs are vectors?
	if( !fAnyCell )
		for(i = 0;i<nlhs;++i)
		{
			mxArray *pBuf;
			mexCallMATLAB(1,&pBuf,1,&plhs[i],"cell2mat");
			plhs[i] = pBuf;
		}
*/
	mxFree(ppCells);
	mxFree(ppIn);
	mxFree(ppOut);
}