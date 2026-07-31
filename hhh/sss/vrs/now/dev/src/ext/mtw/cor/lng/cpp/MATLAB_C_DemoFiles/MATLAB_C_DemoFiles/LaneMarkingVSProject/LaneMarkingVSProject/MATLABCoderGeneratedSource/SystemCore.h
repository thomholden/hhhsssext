//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * SystemCore.h
 *
 * Code generation for function 'SystemCore'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

#ifndef __SYSTEMCORE_H__
#define __SYSTEMCORE_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>

#include "rtwtypes.h"
#include "lanemarking_Algorithm_types.h"

/* Function Declarations */
extern void SystemCore_step(c_visioncodegen_ColorSpaceConve *obj, const uint8_T varargin_1[259200], uint8_T varargout_1[86400]);
extern void b_SystemCore_step(visioncodegen_Autothresholder *obj, const uint8_T varargin_1[86400], boolean_T varargout_1[86400]);
extern void c_SystemCore_step(visioncodegen_BlobAnalysis *obj, const boolean_T varargin_1[86400], int32_T varargout_1_data[200], int32_T varargout_1_size[2], real_T varargout_2_data[50], int32_T varargout_2_size[2], real_T varargout_3_data[50], int32_T varargout_3_size[2], real_T varargout_4_data[50], int32_T varargout_4_size[2]);
#endif
/* End of code generation (SystemCore.h) */
