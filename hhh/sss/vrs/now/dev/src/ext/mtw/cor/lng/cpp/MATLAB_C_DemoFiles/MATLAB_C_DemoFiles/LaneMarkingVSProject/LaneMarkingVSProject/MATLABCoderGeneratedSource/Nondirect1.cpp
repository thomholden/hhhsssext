//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * Nondirect1.cpp
 *
 * Code generation for function 'Nondirect1'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "Nondirect1.h"

/* Function Definitions */

/*
 *
 */
void Nondirect_stepImpl(visioncodegen_BlobAnalysis *obj, const boolean_T
  varargin_1[86400], int32_T varargout_1_data[200], int32_T varargout_1_size[2],
  real_T varargout_2_data[50], int32_T varargout_2_size[2], real_T
  varargout_3_data[50], int32_T varargout_3_size[2], real_T varargout_4_data[50],
  int32_T varargout_4_size[2])
{
  visioncodegen_BlobAnalysis *b_obj;
  vision_BlobAnalysis_3 *c_obj;
  boolean_T maxNumBlobsReached;
  int32_T loop;
  uint8_T currentLabel;
  int32_T i;
  int32_T idx;
  int32_T n;
  int32_T maxr;
  uint32_T pixIdx;
  int32_T minr;
  uint32_T k;
  uint32_T start_pixIdx;
  uint32_T centerIdx;
  uint32_T walkerIdx;
  int32_T numBlobs;
  int32_T pixListMinc;
  int32_T pixListNinc;
  int32_T j;
  real_T centroid_idx_0;
  real_T centroid_idx_1;
  real_T xs;
  real_T ys;
  real_T xys;
  real_T uyy;
  real_T uxx;
  b_obj = obj;
  c_obj = &b_obj->cSFunObject;

  /* System object Outputs function: vision.BlobAnalysis */
  maxNumBlobsReached = FALSE;
  for (loop = 0; loop < 243; loop++) {
    c_obj->W3_PAD_DW[loop] = 0;
  }

  currentLabel = 1;
  i = 0;
  idx = 243;
  for (n = 0; n < 360; n++) {
    for (maxr = 0; maxr < 240; maxr++) {
      if (varargin_1[i]) {
        c_obj->W3_PAD_DW[idx] = MAX_uint8_T;
      } else {
        c_obj->W3_PAD_DW[idx] = 0;
      }

      i++;
      idx++;
    }

    c_obj->W3_PAD_DW[idx] = 0;
    c_obj->W3_PAD_DW[idx + 1] = 0;
    idx += 2;
  }

  for (loop = 0; loop < 241; loop++) {
    c_obj->W3_PAD_DW[loop + idx] = 0;
  }

  loop = 1;
  pixIdx = 0U;
  n = 0;
  while (n < 360) {
    idx = 1;
    minr = loop * 242;
    maxr = 0;
    while (maxr < 240) {
      k = (uint32_T)(minr + idx);
      start_pixIdx = pixIdx;
      if (c_obj->W3_PAD_DW[k] == 255) {
        c_obj->W3_PAD_DW[k] = currentLabel;
        c_obj->W0_N_PIXLIST_DW[pixIdx] = (int16_T)(loop - 1);
        c_obj->W1_M_PIXLIST_DW[pixIdx] = (int16_T)(idx - 1);
        pixIdx++;
        c_obj->W2_NUM_PIX_DW[currentLabel - 1] = 1U;
        c_obj->W4_STACK_DW[0U] = k;
        k = 1U;
        while (k != 0U) {
          k--;
          centerIdx = c_obj->W4_STACK_DW[k];
          for (i = 0; i < 8; i++) {
            walkerIdx = centerIdx + c_obj->P0_WALKER_RTP[i];
            if (c_obj->W3_PAD_DW[walkerIdx] == 255) {
              c_obj->W3_PAD_DW[walkerIdx] = currentLabel;
              c_obj->W0_N_PIXLIST_DW[pixIdx] = (int16_T)((int16_T)(walkerIdx /
                242U) - 1);
              c_obj->W1_M_PIXLIST_DW[pixIdx] = (int16_T)(walkerIdx % 242U - 1U);
              pixIdx++;
              c_obj->W2_NUM_PIX_DW[currentLabel - 1]++;
              c_obj->W4_STACK_DW[k] = walkerIdx;
              k++;
            }
          }
        }

        if ((c_obj->W2_NUM_PIX_DW[currentLabel - 1] < c_obj->P1_MINAREA_RTP) ||
            (c_obj->W2_NUM_PIX_DW[currentLabel - 1] > c_obj->P2_MAXAREA_RTP)) {
          currentLabel--;
          pixIdx = start_pixIdx;
        }

        if (currentLabel == 50) {
          maxNumBlobsReached = TRUE;
          n = 360;
          maxr = 240;
        }

        if (maxr < 240) {
          currentLabel++;
        }
      }

      idx++;
      maxr++;
    }

    loop++;
    n++;
  }

  if (maxNumBlobsReached) {
    numBlobs = currentLabel;
  } else {
    numBlobs = (uint8_T)(currentLabel - 1U);
  }

  pixListMinc = 0;
  pixListNinc = 0;
  for (i = 0; i < numBlobs; i++) {
    loop = 0;
    idx = 0;
    for (j = 0; j < (int32_T)c_obj->W2_NUM_PIX_DW[i]; j++) {
      loop += c_obj->W0_N_PIXLIST_DW[j + pixListNinc];
      idx += c_obj->W1_M_PIXLIST_DW[j + pixListMinc];
    }

    centroid_idx_0 = (real_T)idx / (real_T)c_obj->W2_NUM_PIX_DW[i];
    centroid_idx_1 = (real_T)loop / (real_T)c_obj->W2_NUM_PIX_DW[i];
    idx = 360;
    minr = 240;
    n = 0;
    maxr = 0;
    for (j = 0; j < (int32_T)c_obj->W2_NUM_PIX_DW[i]; j++) {
      loop = j + pixListNinc;
      if (c_obj->W0_N_PIXLIST_DW[loop] < idx) {
        idx = c_obj->W0_N_PIXLIST_DW[loop];
      }

      if (c_obj->W0_N_PIXLIST_DW[loop] > n) {
        n = c_obj->W0_N_PIXLIST_DW[loop];
      }

      loop = j + pixListMinc;
      if (c_obj->W1_M_PIXLIST_DW[loop] < minr) {
        minr = c_obj->W1_M_PIXLIST_DW[loop];
      }

      if (c_obj->W1_M_PIXLIST_DW[loop] > maxr) {
        maxr = c_obj->W1_M_PIXLIST_DW[loop];
      }
    }

    varargout_1_data[i] = idx + 1;
    varargout_1_data[(uint32_T)numBlobs + i] = minr + 1;
    varargout_1_data[(numBlobs << 1) + i] = (n - idx) + 1;
    varargout_1_data[3 * numBlobs + i] = (maxr - minr) + 1;
    xs = 0.0;
    ys = 0.0;
    xys = 0.0;
    for (k = 0U; (int32_T)k < (int32_T)c_obj->W2_NUM_PIX_DW[i]; k++) {
      uyy = (real_T)c_obj->W0_N_PIXLIST_DW[pixListNinc + (int32_T)k] -
        centroid_idx_1;
      uxx = (real_T)c_obj->W1_M_PIXLIST_DW[pixListMinc + (int32_T)k] -
        centroid_idx_0;
      xs += uyy * uyy;
      ys += uxx * uxx;
      xys += uyy * -uxx;
    }

    uxx = xs / (real_T)c_obj->W2_NUM_PIX_DW[i] + 0.083333333333333329;
    uyy = ys / (real_T)c_obj->W2_NUM_PIX_DW[i] + 0.083333333333333329;
    centroid_idx_0 = xys / (real_T)c_obj->W2_NUM_PIX_DW[i];
    centroid_idx_1 = sqrt((uxx - uyy) * (uxx - uyy) + 4.0 * (centroid_idx_0 *
      centroid_idx_0));
    if (uyy > uxx) {
      xs = (uyy - uxx) + centroid_idx_1;
      centroid_idx_0 *= 2.0;
    } else {
      xs = 2.0 * centroid_idx_0;
      centroid_idx_0 = (uxx - uyy) + centroid_idx_1;
    }

    varargout_2_data[i] = sqrt(8.0 * ((uxx + uyy) + centroid_idx_1));
    varargout_3_data[i] = sqrt(8.0 * ((uxx + uyy) - centroid_idx_1));
    varargout_4_data[i] = atan(xs / (centroid_idx_0 + 2.2204460492503131E-16));
    pixListMinc += (int32_T)c_obj->W2_NUM_PIX_DW[i];
    pixListNinc += (int32_T)c_obj->W2_NUM_PIX_DW[i];
  }

  varargout_1_size[0] = numBlobs;
  varargout_1_size[1] = 4;
  varargout_2_size[0] = numBlobs;
  varargout_2_size[1] = 1;
  varargout_3_size[0] = numBlobs;
  varargout_3_size[1] = 1;
  varargout_4_size[0] = numBlobs;
  varargout_4_size[1] = 1;
}

/* End of code generation (Nondirect1.cpp) */
