//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * SystemCore.cpp
 *
 * Code generation for function 'SystemCore'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "SystemCore.h"
#include "Nondirect1.h"

/* Function Declarations */
static int32_T div_repeat_s32_floor(int32_T numerator, int32_T denominator,
  uint32_T nRepeatSub);
static uint32_T div_repeat_u32(uint32_T numerator, uint32_T denominator,
  uint32_T nRepeatSub);
static uint32_T div_repeat_u32_ceiling(uint32_T numerator, uint32_T denominator,
  uint32_T nRepeatSub);
static int32_T mul_s32_s32_s32_sr17(int32_T a, int32_T b);
static int32_T mul_s32_s32_s32_sr30(int32_T a, int32_T b);
static uint32_T mul_u32_u32_u32_sr30(uint32_T a, uint32_T b);
static void mul_wide_s32(int32_T in0, int32_T in1, uint32_T *ptrOutBitsHi,
  uint32_T *ptrOutBitsLo);
static void mul_wide_u32(uint32_T in0, uint32_T in1, uint32_T *ptrOutBitsHi,
  uint32_T *ptrOutBitsLo);

/* Function Definitions */
static int32_T div_repeat_s32_floor(int32_T numerator, int32_T denominator,
  uint32_T nRepeatSub)
{
  int32_T quotient;
  uint32_T absNumerator;
  uint32_T absDenominator;
  int32_T quotientNeedsNegation;
  if (denominator == 0) {
    if (numerator >= 0) {
      quotient = MAX_int32_T;
    } else {
      quotient = MIN_int32_T;
    }
  } else {
    if (numerator >= 0) {
      absNumerator = (uint32_T)numerator;
    } else {
      absNumerator = (uint32_T)-numerator;
    }

    if (denominator >= 0) {
      absDenominator = (uint32_T)denominator;
    } else {
      absDenominator = (uint32_T)-denominator;
    }

    quotientNeedsNegation = ((numerator < 0) != (denominator < 0));
    if ((uint32_T)quotientNeedsNegation) {
      absNumerator = div_repeat_u32_ceiling(absNumerator, absDenominator,
        nRepeatSub);
      quotient = -(int32_T)absNumerator;
    } else {
      absNumerator = div_repeat_u32(absNumerator, absDenominator, nRepeatSub);
      quotient = (int32_T)absNumerator;
    }
  }

  return quotient;
}

static uint32_T div_repeat_u32(uint32_T numerator, uint32_T denominator,
  uint32_T nRepeatSub)
{
  uint32_T quotient;
  uint32_T iRepeatSub;
  uint8_T numeratorExtraBit;
  if (denominator == (uint32_T)0) {
    quotient = MAX_uint32_T;
  } else {
    quotient = numerator / denominator;
    numerator %= denominator;
    for (iRepeatSub = (uint32_T)0; iRepeatSub < nRepeatSub; iRepeatSub++) {
      numeratorExtraBit = (uint8_T)(numerator >= 2147483648U);
      numerator <<= 1;
      quotient <<= 1;
      if (numeratorExtraBit || (numerator >= denominator)) {
        quotient++;
        numerator -= denominator;
      }
    }
  }

  return quotient;
}

static uint32_T div_repeat_u32_ceiling(uint32_T numerator, uint32_T denominator,
  uint32_T nRepeatSub)
{
  uint32_T quotient;
  uint32_T iRepeatSub;
  uint8_T numeratorExtraBit;
  if (denominator == (uint32_T)0) {
    quotient = MAX_uint32_T;
  } else {
    quotient = numerator / denominator;
    numerator %= denominator;
    for (iRepeatSub = (uint32_T)0; iRepeatSub < nRepeatSub; iRepeatSub++) {
      numeratorExtraBit = (uint8_T)(numerator >= 2147483648U);
      numerator <<= 1;
      quotient <<= 1;
      if (numeratorExtraBit || (numerator >= denominator)) {
        quotient++;
        numerator -= denominator;
      }
    }

    if (numerator > 0U) {
      quotient++;
    }
  }

  return quotient;
}

static int32_T mul_s32_s32_s32_sr17(int32_T a, int32_T b)
{
  uint32_T u32_clo;
  uint32_T u32_chi;
  mul_wide_s32(a, b, &u32_chi, &u32_clo);
  u32_clo = u32_chi << 15U | u32_clo >> 17U;
  return (int32_T)u32_clo;
}

static int32_T mul_s32_s32_s32_sr30(int32_T a, int32_T b)
{
  uint32_T u32_clo;
  uint32_T u32_chi;
  mul_wide_s32(a, b, &u32_chi, &u32_clo);
  u32_clo = u32_chi << 2U | u32_clo >> 30U;
  return (int32_T)u32_clo;
}

static uint32_T mul_u32_u32_u32_sr30(uint32_T a, uint32_T b)
{
  uint32_T result;
  uint32_T u32_chi;
  mul_wide_u32(a, b, &u32_chi, &result);
  return u32_chi << 2U | result >> 30U;
}

static void mul_wide_s32(int32_T in0, int32_T in1, uint32_T *ptrOutBitsHi,
  uint32_T *ptrOutBitsLo)
{
  uint32_T absIn0;
  uint32_T absIn1;
  int32_T negativeProduct;
  int32_T in0Hi;
  int32_T in0Lo;
  int32_T in1Hi;
  int32_T in1Lo;
  uint32_T productLoHi;
  uint32_T productLoLo;
  uint32_T outBitsLo;
  if (in0 < 0) {
    absIn0 = (uint32_T)-in0;
  } else {
    absIn0 = (uint32_T)in0;
  }

  if (in1 < 0) {
    absIn1 = (uint32_T)-in1;
  } else {
    absIn1 = (uint32_T)in1;
  }

  negativeProduct = !((in0 == 0) || ((in1 == 0) || ((in0 > 0) == (in1 > 0))));
  in0Hi = (int32_T)(absIn0 >> 16U);
  in0Lo = (int32_T)(absIn0 & 65535U);
  in1Hi = (int32_T)(absIn1 >> 16U);
  in1Lo = (int32_T)(absIn1 & 65535U);
  absIn0 = (uint32_T)in0Hi * in1Hi;
  absIn1 = (uint32_T)in0Hi * in1Lo;
  productLoHi = (uint32_T)in0Lo * in1Hi;
  productLoLo = (uint32_T)in0Lo * in1Lo;
  in0Hi = 0;
  outBitsLo = productLoLo + (productLoHi << 16U);
  if (outBitsLo < productLoLo) {
    in0Hi = 1;
  }

  productLoLo = outBitsLo;
  outBitsLo += absIn1 << 16U;
  if (outBitsLo < productLoLo) {
    in0Hi++;
  }

  absIn0 = ((in0Hi + absIn0) + (productLoHi >> 16U)) + (absIn1 >> 16U);
  if (negativeProduct) {
    absIn0 = ~absIn0;
    outBitsLo = ~outBitsLo;
    outBitsLo++;
    if (outBitsLo == 0U) {
      absIn0++;
    }
  }

  *ptrOutBitsHi = absIn0;
  *ptrOutBitsLo = outBitsLo;
}

static void mul_wide_u32(uint32_T in0, uint32_T in1, uint32_T *ptrOutBitsHi,
  uint32_T *ptrOutBitsLo)
{
  int32_T in0Hi;
  int32_T in0Lo;
  int32_T in1Hi;
  int32_T in1Lo;
  uint32_T productHiHi;
  uint32_T productHiLo;
  uint32_T productLoHi;
  uint32_T productLoLo;
  uint32_T outBitsLo;
  in0Hi = (int32_T)(in0 >> 16U);
  in0Lo = (int32_T)(in0 & 65535U);
  in1Hi = (int32_T)(in1 >> 16U);
  in1Lo = (int32_T)(in1 & 65535U);
  productHiHi = (uint32_T)in0Hi * in1Hi;
  productHiLo = (uint32_T)in0Hi * in1Lo;
  productLoHi = (uint32_T)in0Lo * in1Hi;
  productLoLo = (uint32_T)in0Lo * in1Lo;
  in0Hi = 0;
  outBitsLo = productLoLo + (productLoHi << 16U);
  if (outBitsLo < productLoLo) {
    in0Hi = 1;
  }

  productLoLo = outBitsLo;
  outBitsLo += productHiLo << 16U;
  if (outBitsLo < productLoLo) {
    in0Hi++;
  }

  productHiHi = ((in0Hi + productHiHi) + (productLoHi >> 16U)) + (productHiLo >>
    16U);
  *ptrOutBitsHi = productHiHi;
  *ptrOutBitsLo = outBitsLo;
}

/*
 *
 */
void SystemCore_step(c_visioncodegen_ColorSpaceConve *obj, const uint8_T
                     varargin_1[259200], uint8_T varargout_1[86400])
{
  c_visioncodegen_ColorSpaceConve *b_obj;
  int32_T k;
  static const int16_T value[8] = { 240, 360, 3, 1, 1, 1, 1, 1 };

  boolean_T exitg1;
  static const int16_T iv1[8] = { 240, 360, 3, 1, 1, 1, 1, 1 };

  vision_ColorSpaceConverter_0 *c_obj;
  uint32_T acc;
  if (!obj->isInitialized) {
    b_obj = obj;
    b_obj->isInitialized = TRUE;
    for (k = 0; k < 8; k++) {
      b_obj->inputVarSize1[k] = (uint32_T)value[k];
    }

    b_obj->TunablePropsChanged = FALSE;
  }

  b_obj = obj;
  if (b_obj->TunablePropsChanged) {
    b_obj->TunablePropsChanged = FALSE;
  }

  b_obj = obj;
  k = 0;
  exitg1 = FALSE;
  while ((exitg1 == FALSE) && (k < 8)) {
    if (b_obj->inputVarSize1[k] != (uint32_T)iv1[k]) {
      for (k = 0; k < 8; k++) {
        b_obj->inputVarSize1[k] = (uint32_T)value[k];
      }

      exitg1 = TRUE;
    } else {
      k++;
    }
  }

  b_obj = obj;
  c_obj = &b_obj->cSFunObject;

  /* System object Outputs function: vision.ColorSpaceConverter */
  for (k = 0; k < 86400; k++) {
    acc = ((uint32_T)varargin_1[k] * c_obj->P0_COEFF_RTP[0U] + (uint32_T)
           varargin_1[86400 + k] * c_obj->P0_COEFF_RTP[1U]) + (uint32_T)
      varargin_1[172800 + k] * c_obj->P0_COEFF_RTP[2U];
    acc = (acc + 32768U) >> 16;
    varargout_1[k] = (uint8_T)acc;
  }
}

/*
 *
 */
void b_SystemCore_step(visioncodegen_Autothresholder *obj, const uint8_T
  varargin_1[86400], boolean_T varargout_1[86400])
{
  visioncodegen_Autothresholder *b_obj;
  int32_T normTh;
  static const int16_T value[8] = { 240, 360, 1, 1, 1, 1, 1, 1 };

  boolean_T exitg1;
  static const int16_T iv2[8] = { 240, 360, 1, 1, 1, 1, 1, 1 };

  vision_Autothresholder_2 *c_obj;
  int32_T i;
  int32_T muT;
  int32_T idxMaxVal;
  int32_T maxVal;
  int32_T muA2P3;
  uint32_T posTh;
  uint8_T threshold;
  if (!obj->isInitialized) {
    b_obj = obj;
    b_obj->isInitialized = TRUE;
    for (normTh = 0; normTh < 8; normTh++) {
      b_obj->inputVarSize1[normTh] = (uint32_T)value[normTh];
    }

    b_obj->c_NoTuningBeforeLockingCodeGenE = TRUE;
    b_obj->TunablePropsChanged = FALSE;
  }

  b_obj = obj;
  if (b_obj->TunablePropsChanged) {
    b_obj->TunablePropsChanged = FALSE;
    b_obj->tunablePropertyChanged = FALSE;
  }

  b_obj = obj;
  normTh = 0;
  exitg1 = FALSE;
  while ((exitg1 == FALSE) && (normTh < 8)) {
    if (b_obj->inputVarSize1[normTh] != (uint32_T)iv2[normTh]) {
      for (normTh = 0; normTh < 8; normTh++) {
        b_obj->inputVarSize1[normTh] = (uint32_T)value[normTh];
      }

      exitg1 = TRUE;
    } else {
      normTh++;
    }
  }

  b_obj = obj;
  c_obj = &b_obj->cSFunObject;

  /* System object Outputs function: vision.Autothresholder */
  c_obj->W3_NORMF_FIXPT_DW = 1628906115;
  for (i = 0; i < 256; i++) {
    c_obj->W0_HIST_FIXPT_DW[i] = 0;
  }

  for (i = 0; i < 86400; i++) {
    c_obj->W0_HIST_FIXPT_DW[varargin_1[i]]++;
  }

  for (i = 0; i < 256; i++) {
    normTh = c_obj->W0_HIST_FIXPT_DW[i];
    c_obj->W1_P_FIXPT_DW[i] = mul_s32_s32_s32_sr17(c_obj->W3_NORMF_FIXPT_DW,
      normTh);
  }

  c_obj->W2_MU_FIXPT_DW[0] = c_obj->W1_P_FIXPT_DW[0] >> 8;
  for (i = 0; i < 255; i++) {
    c_obj->W2_MU_FIXPT_DW[i + 1] = (i + 2) << 22;
    c_obj->W2_MU_FIXPT_DW[i + 1] = mul_s32_s32_s32_sr30(c_obj->W2_MU_FIXPT_DW[i
      + 1], c_obj->W1_P_FIXPT_DW[i + 1]);
    muT = c_obj->W2_MU_FIXPT_DW[i];
    c_obj->W2_MU_FIXPT_DW[i + 1] += muT;
  }

  muT = c_obj->W2_MU_FIXPT_DW[255];
  for (i = 0; i < 254; i++) {
    normTh = c_obj->W1_P_FIXPT_DW[i];
    c_obj->W1_P_FIXPT_DW[i + 1] += normTh;
  }

  idxMaxVal = 0;
  maxVal = 0;
  for (i = 0; i < 255; i++) {
    muA2P3 = mul_s32_s32_s32_sr30(c_obj->W1_P_FIXPT_DW[i], muT);
    muA2P3 -= c_obj->W2_MU_FIXPT_DW[i];
    normTh = 1073741824 - c_obj->W1_P_FIXPT_DW[i];
    normTh = mul_s32_s32_s32_sr30(c_obj->W1_P_FIXPT_DW[i], normTh);
    if (normTh == 0) {
      normTh = 0;
    } else {
      normTh = div_repeat_s32_floor(mul_s32_s32_s32_sr30(muA2P3, muA2P3) << 2,
        normTh, 30U);
    }

    if (normTh > maxVal) {
      maxVal = normTh;
      idxMaxVal = i;
    }
  }

  normTh = c_obj->P1_SCALE_FIXPT_RTP * idxMaxVal;
  posTh = (uint32_T)c_obj->P3_UMAX_FIXPT_RTP << 15;
  posTh = mul_u32_u32_u32_sr30(posTh, (uint32_T)normTh);
  normTh = (int32_T)posTh;
  threshold = (uint8_T)((normTh >> 15) + ((normTh & 16384) != 0));
  for (i = 0; i < 86400; i++) {
    varargout_1[i] = (varargin_1[i] > threshold);
  }
}

/*
 *
 */
void c_SystemCore_step(visioncodegen_BlobAnalysis *obj, const boolean_T
  varargin_1[86400], int32_T varargout_1_data[200], int32_T varargout_1_size[2],
  real_T varargout_2_data[50], int32_T varargout_2_size[2], real_T
  varargout_3_data[50], int32_T varargout_3_size[2], real_T varargout_4_data[50],
  int32_T varargout_4_size[2])
{
  visioncodegen_BlobAnalysis *b_obj;
  int32_T k;
  static const int16_T value[8] = { 240, 360, 1, 1, 1, 1, 1, 1 };

  int32_T i;
  boolean_T b_value[2];
  boolean_T exitg1;
  static const int16_T iv3[8] = { 240, 360, 1, 1, 1, 1, 1, 1 };

  if (!obj->isInitialized) {
    b_obj = obj;
    b_obj->isInitialized = TRUE;
    for (k = 0; k < 8; k++) {
      b_obj->inputVarSize1[k] = (uint32_T)value[k];
    }

    b_obj->c_NoTuningBeforeLockingCodeGenE = TRUE;
    b_obj->TunablePropsChanged = FALSE;
  }

  b_obj = obj;
  if (b_obj->TunablePropsChanged) {
    b_obj->TunablePropsChanged = FALSE;
    for (i = 0; i < 2; i++) {
      for (k = 0; k < 2; k++) {
        b_value[k] = b_obj->tunablePropertyChanged[k];
      }

      b_value[i] = FALSE;
      for (k = 0; k < 2; k++) {
        b_obj->tunablePropertyChanged[k] = b_value[k];
      }
    }
  }

  b_obj = obj;
  k = 0;
  exitg1 = FALSE;
  while ((exitg1 == FALSE) && (k < 8)) {
    if (b_obj->inputVarSize1[k] != (uint32_T)iv3[k]) {
      for (k = 0; k < 8; k++) {
        b_obj->inputVarSize1[k] = (uint32_T)value[k];
      }

      exitg1 = TRUE;
    } else {
      k++;
    }
  }

  Nondirect_stepImpl(obj, varargin_1, varargout_1_data, varargout_1_size,
                     varargout_2_data, varargout_2_size, varargout_3_data,
                     varargout_3_size, varargout_4_data, varargout_4_size);
}

/* End of code generation (SystemCore.cpp) */
