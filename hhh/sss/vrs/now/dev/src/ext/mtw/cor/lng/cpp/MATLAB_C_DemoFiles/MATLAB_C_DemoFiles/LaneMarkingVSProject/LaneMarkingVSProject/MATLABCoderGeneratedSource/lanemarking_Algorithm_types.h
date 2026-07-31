//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * lanemarking_Algorithm_types.h
 *
 * Code generation for function 'lanemarking_Algorithm'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

#ifndef __LANEMARKING_ALGORITHM_TYPES_H__
#define __LANEMARKING_ALGORITHM_TYPES_H__

/* Include files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_vision_ColorSpaceConverter_0
#define struct_vision_ColorSpaceConverter_0
struct vision_ColorSpaceConverter_0
{
    boolean_T S0_isInitialized;
    boolean_T S1_isReleased;
    uint16_T P0_COEFF_RTP[3];
};
#endif /*struct_vision_ColorSpaceConverter_0*/
typedef struct
{
    boolean_T isInitialized;
    boolean_T isReleased;
    boolean_T TunablePropsChanged;
    uint32_T inputVarSize1[8];
    boolean_T inputDirectFeedthrough1;
    vision_ColorSpaceConverter_0 cSFunObject;
} c_visioncodegen_ColorSpaceConve;
#ifndef struct_emxArray_b_int32_T_50x4
#define struct_emxArray_b_int32_T_50x4
struct emxArray_b_int32_T_50x4
{
    int32_T data[200];
    int32_T size[2];
};
#endif /*struct_emxArray_b_int32_T_50x4*/
#ifndef struct_emxArray_int32_T_50
#define struct_emxArray_int32_T_50
struct emxArray_int32_T_50
{
    int32_T data[50];
    int32_T size[1];
};
#endif /*struct_emxArray_int32_T_50*/
#ifndef struct_emxArray_real_T_50
#define struct_emxArray_real_T_50
struct emxArray_real_T_50
{
    real_T data[50];
    int32_T size[1];
};
#endif /*struct_emxArray_real_T_50*/
#ifndef struct_vision_Autothresholder_2
#define struct_vision_Autothresholder_2
struct vision_Autothresholder_2
{
    boolean_T S0_isInitialized;
    boolean_T S1_isReleased;
    int32_T W0_HIST_FIXPT_DW[256];
    int32_T W1_P_FIXPT_DW[256];
    int32_T W2_MU_FIXPT_DW[256];
    int32_T W3_NORMF_FIXPT_DW;
    uint8_T P0_BIN_BOUNDARY_FIXPT_RTP[256];
    int32_T P1_SCALE_FIXPT_RTP;
    uint8_T P2_UMIN_FIXPT_RTP;
    uint8_T P3_UMAX_FIXPT_RTP;
};
#endif /*struct_vision_Autothresholder_2*/
typedef struct
{
    boolean_T tunablePropertyChanged;
    boolean_T isInitialized;
    boolean_T isReleased;
    boolean_T TunablePropsChanged;
    uint32_T inputVarSize1[8];
    boolean_T inputDirectFeedthrough1;
    vision_Autothresholder_2 cSFunObject;
    boolean_T c_NoTuningBeforeLockingCodeGenE;
} visioncodegen_Autothresholder;
#ifndef struct_vision_BlobAnalysis_3
#define struct_vision_BlobAnalysis_3
struct vision_BlobAnalysis_3
{
    boolean_T S0_isInitialized;
    boolean_T S1_isReleased;
    int16_T W0_N_PIXLIST_DW[86400];
    int16_T W1_M_PIXLIST_DW[86400];
    uint32_T W2_NUM_PIX_DW[50];
    uint8_T W3_PAD_DW[87604];
    uint32_T W4_STACK_DW[86400];
    int32_T P0_WALKER_RTP[8];
    uint32_T P1_MINAREA_RTP;
    uint32_T P2_MAXAREA_RTP;
};
#endif /*struct_vision_BlobAnalysis_3*/
typedef struct
{
    boolean_T tunablePropertyChanged[2];
    boolean_T isInitialized;
    boolean_T isReleased;
    boolean_T TunablePropsChanged;
    uint32_T inputVarSize1[8];
    boolean_T inputDirectFeedthrough1;
    vision_BlobAnalysis_3 cSFunObject;
    boolean_T c_NoTuningBeforeLockingCodeGenE;
} visioncodegen_BlobAnalysis;

#endif
/* End of code generation (lanemarking_Algorithm_types.h) */
