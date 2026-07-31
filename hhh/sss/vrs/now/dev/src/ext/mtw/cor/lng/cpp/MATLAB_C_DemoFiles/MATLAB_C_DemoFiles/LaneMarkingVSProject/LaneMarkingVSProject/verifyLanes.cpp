//
// This code is provided for example purposes only.
// 
// Copyright 2011-2013 MathWorks, Inc.
//


#include "engine.h"
#include "string.h"

#include "configure.h"
#include "verifyLanes.h"
#include "VerifyLanes_Data.h"

void initializeVerifyLanes(int row, int col, int planes)
{
	// Initialize Engine pointer
	P_ENG_VERIFY = engOpen(NULL); // Connect to MATLAB engine

	I_NUMPIXELS_VERIFY = row * col * planes;

	MW_NDIMS_VERIFY  = 3;
	MW_DIMS_VERIFY[0] =    row ;
	MW_DIMS_VERIFY[1] =    col ;
	MW_DIMS_VERIFY[2] = planes ;

	P_MX_FRAME_VERIFY = mxCreateNumericArray(MW_NDIMS_VERIFY, MW_DIMS_VERIFY, mxUINT8_CLASS, mxREAL);
}


void verifyLanes(const unsigned char* frame, int laneVertices_data[200], int laneVertices_size[2])
{
	// Declare Local variables
	int numVertices = laneVertices_size[0] * laneVertices_size[1];

	// Create vertex data
	P_MX_LANEVERTS_VERIFY = mxCreateNumericMatrix(laneVertices_size[0], laneVertices_size[1], mxINT32_CLASS, mxREAL);

	// Get pointers to real data portion
	double *pmxFrameReal = mxGetPr(P_MX_FRAME_VERIFY    );
	double *pmxLanesReal = mxGetPr(P_MX_LANEVERTS_VERIFY);

	// copy data to MATLAB format
	memcpy(pmxFrameReal, frame            , I_NUMPIXELS_VERIFY * sizeof(unsigned char));
	memcpy(pmxLanesReal, laneVertices_data,        numVertices * sizeof(          int));

	/* Send Data to MATLAB */
	engPutVariable(P_ENG_VERIFY, "frame"       , P_MX_FRAME_VERIFY    );
	engPutVariable(P_ENG_VERIFY, "laneVertices", P_MX_LANEVERTS_VERIFY);

	/* Verify lanes on image */
	engEvalString(P_ENG_VERIFY, getCDCommand()                           );
	engEvalString(P_ENG_VERIFY, "displayLanes(frame, laneVertices)" );
}

extern void terminateVerifyLanes()
{
	/* Free MX arrays */
	mxDestroyArray(P_MX_FRAME_VERIFY    );
	mxDestroyArray(P_MX_LANEVERTS_VERIFY);

	/* Close Engine */
	engClose(P_ENG_VERIFY);
}