//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * ColorSpaceConverter.cpp
 *
 * Code generation for function 'ColorSpaceConverter'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "ColorSpaceConverter.h"

/* Function Definitions */

/*
 *
 */
c_visioncodegen_ColorSpaceConve *c_ColorSpaceConverter_ColorSpac
  (c_visioncodegen_ColorSpaceConve *obj)
{
  c_visioncodegen_ColorSpaceConve *b_obj;
  c_visioncodegen_ColorSpaceConve *c_obj;
  vision_ColorSpaceConverter_0 *d_obj;
  int32_T i;
  static const uint16_T uv0[3] = { 19595U, 38470U, 7471U };

  b_obj = obj;
  c_obj = b_obj;
  c_obj->isInitialized = FALSE;
  c_obj->isReleased = FALSE;
  c_obj->inputDirectFeedthrough1 = FALSE;
  d_obj = &b_obj->cSFunObject;

  /* System object Constructor function: vision.ColorSpaceConverter */
  d_obj->S0_isInitialized = FALSE;
  d_obj->S1_isReleased = FALSE;
  for (i = 0; i < 3; i++) {
    d_obj->P0_COEFF_RTP[i] = uv0[i];
  }

  return b_obj;
}

/* End of code generation (ColorSpaceConverter.cpp) */
