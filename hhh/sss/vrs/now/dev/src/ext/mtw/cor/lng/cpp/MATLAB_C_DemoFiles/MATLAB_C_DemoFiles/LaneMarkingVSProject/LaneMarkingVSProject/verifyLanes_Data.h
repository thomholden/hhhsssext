//
// This code is provided for example purposes only.
// 
// Copyright 2011-2013 MathWorks, Inc.
//


#ifndef verifyLanesData_H
#define verifyLanesData_H


////////////////////
// Local Variables
////////////////////

// Declare Engine pointer
Engine *P_ENG_VERIFY;

// Declare MX Arrays
mxArray *P_MX_FRAME_VERIFY     ;
mxArray *P_MX_LANEVERTS_VERIFY ;

// MXArray Helper variables
int    I_NUMPIXELS_VERIFY   ;
mwSize MW_NDIMS_VERIFY   = 3;
mwSize MW_DIMS_VERIFY[3]    ;

#endif