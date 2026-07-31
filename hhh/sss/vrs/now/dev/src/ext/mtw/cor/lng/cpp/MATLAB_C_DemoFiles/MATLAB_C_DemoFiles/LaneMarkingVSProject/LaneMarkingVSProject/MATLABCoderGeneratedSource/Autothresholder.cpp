//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * Autothresholder.cpp
 *
 * Code generation for function 'Autothresholder'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "Autothresholder.h"

/* Function Definitions */

/*
 *
 */
visioncodegen_Autothresholder *Autothresholder_Autothresholder
  (visioncodegen_Autothresholder *obj)
{
  visioncodegen_Autothresholder *b_obj;
  visioncodegen_Autothresholder *c_obj;
  vision_Autothresholder_2 *d_obj;
  int32_T i2;
  boolean_T flag;
  b_obj = obj;
  c_obj = b_obj;
  c_obj->isInitialized = FALSE;
  c_obj->isReleased = FALSE;
  c_obj->inputDirectFeedthrough1 = FALSE;
  c_obj->tunablePropertyChanged = FALSE;
  c_obj = b_obj;
  c_obj->c_NoTuningBeforeLockingCodeGenE = TRUE;
  d_obj = &b_obj->cSFunObject;

  /* System object Constructor function: vision.Autothresholder */
  d_obj->S0_isInitialized = FALSE;
  d_obj->S1_isReleased = FALSE;
  for (i2 = 0; i2 < 256; i2++) {
    d_obj->P0_BIN_BOUNDARY_FIXPT_RTP[i2] = (uint8_T)i2;
  }

  d_obj->P1_SCALE_FIXPT_RTP = 4210752;
  d_obj->P2_UMIN_FIXPT_RTP = 0;
  d_obj->P3_UMAX_FIXPT_RTP = MAX_uint8_T;
  c_obj = b_obj;
  if (c_obj->isInitialized && (!c_obj->isReleased)) {
    flag = TRUE;
  } else {
    flag = FALSE;
  }

  if (flag) {
    c_obj->TunablePropsChanged = TRUE;
    c_obj->tunablePropertyChanged = TRUE;
  }

  c_obj = b_obj;
  c_obj->c_NoTuningBeforeLockingCodeGenE = FALSE;
  return b_obj;
}

/* End of code generation (Autothresholder.cpp) */
