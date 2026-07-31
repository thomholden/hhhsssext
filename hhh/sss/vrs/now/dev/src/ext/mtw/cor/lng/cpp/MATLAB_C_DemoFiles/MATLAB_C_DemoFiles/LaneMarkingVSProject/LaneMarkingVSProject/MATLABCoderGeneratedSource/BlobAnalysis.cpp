//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * BlobAnalysis.cpp
 *
 * Code generation for function 'BlobAnalysis'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "BlobAnalysis.h"

/* Function Definitions */

/*
 *
 */
visioncodegen_BlobAnalysis *BlobAnalysis_BlobAnalysis(visioncodegen_BlobAnalysis
  *obj)
{
  visioncodegen_BlobAnalysis *b_obj;
  visioncodegen_BlobAnalysis *c_obj;
  int32_T i;
  vision_BlobAnalysis_3 *d_obj;
  static const int16_T iv0[8] = { -1, 241, 242, 243, 1, -241, -242, -243 };

  boolean_T flag;
  b_obj = obj;
  c_obj = b_obj;
  c_obj->isInitialized = FALSE;
  c_obj->isReleased = FALSE;
  c_obj->inputDirectFeedthrough1 = FALSE;
  for (i = 0; i < 2; i++) {
    c_obj->tunablePropertyChanged[i] = FALSE;
  }

  c_obj = b_obj;
  c_obj->c_NoTuningBeforeLockingCodeGenE = TRUE;
  d_obj = &b_obj->cSFunObject;

  /* System object Constructor function: vision.BlobAnalysis */
  d_obj->S0_isInitialized = FALSE;
  d_obj->S1_isReleased = FALSE;
  for (i = 0; i < 8; i++) {
    d_obj->P0_WALKER_RTP[i] = iv0[i];
  }

  d_obj->P1_MINAREA_RTP = 10U;
  d_obj->P2_MAXAREA_RTP = MAX_uint32_T;
  c_obj = b_obj;
  c_obj->cSFunObject.P1_MINAREA_RTP = 10U;
  if (c_obj->isInitialized && (!c_obj->isReleased)) {
    flag = TRUE;
  } else {
    flag = FALSE;
  }

  if (flag) {
    c_obj->TunablePropsChanged = TRUE;
    c_obj->tunablePropertyChanged[0] = TRUE;
  }

  c_obj = b_obj;
  c_obj->cSFunObject.P2_MAXAREA_RTP = MAX_uint32_T;
  if (c_obj->isInitialized && (!c_obj->isReleased)) {
    flag = TRUE;
  } else {
    flag = FALSE;
  }

  if (flag) {
    c_obj->TunablePropsChanged = TRUE;
    c_obj->tunablePropertyChanged[1] = TRUE;
  }

  c_obj = b_obj;
  c_obj->c_NoTuningBeforeLockingCodeGenE = FALSE;
  return b_obj;
}

/* End of code generation (BlobAnalysis.cpp) */
