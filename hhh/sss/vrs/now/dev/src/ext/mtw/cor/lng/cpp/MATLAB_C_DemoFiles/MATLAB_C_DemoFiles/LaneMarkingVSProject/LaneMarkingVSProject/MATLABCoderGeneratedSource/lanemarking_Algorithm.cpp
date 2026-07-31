//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * lanemarking_Algorithm.cpp
 *
 * Code generation for function 'lanemarking_Algorithm'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "getLaneVerticies.h"
#include "findlanes.h"
#include "SystemCore.h"
#include "BlobAnalysis.h"
#include "Autothresholder.h"
#include "ColorSpaceConverter.h"
#include "lanemarking_Algorithm_data.h"

/* Variable Definitions */
static visioncodegen_Autothresholder hThresh;
static visioncodegen_BlobAnalysis hBlob;
static c_visioncodegen_ColorSpaceConve hColor;

/* Function Declarations */
static void eml_li_find(const boolean_T x_data[50], const int32_T x_size[1],
  int32_T y_data[50], int32_T y_size[1]);
static real_T rt_roundd(real_T u);

/* Function Definitions */

/*
 *
 */
static void eml_li_find(const boolean_T x_data[50], const int32_T x_size[1],
  int32_T y_data[50], int32_T y_size[1])
{
  int32_T k;
  int32_T i;
  k = 0;
  for (i = 1; i <= x_size[0]; i++) {
    if (x_data[i - 1]) {
      k++;
    }
  }

  y_size[0] = k;
  k = 0;
  for (i = 1; i <= x_size[0]; i++) {
    if (x_data[i - 1]) {
      y_data[k] = i;
      k++;
    }
  }
}

static real_T rt_roundd(real_T u)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/*
 * function laneVertices = lanemarking_Algorithm(frameRGB)
 *  Copyright 2012 MathWorks, Inc.
 */
void lanemarking_Algorithm(const uint8_T frameRGB[259200], int32_T
  laneVertices_data[200], int32_T laneVertices_size[2])
{
  uint8_T frameGray[86400];
  boolean_T binary[86400];
  int32_T Orientation_size[2];
  real_T Orientation_data[50];
  int32_T Minor_size[2];
  real_T Minor_data[50];
  int32_T Major_size[2];
  real_T Major_data[50];
  int32_T bbox_size[2];
  int32_T bbox_data[200];
  int32_T laneIndex_size[1];
  boolean_T laneIndex_data[50];
  int32_T tmp_size[1];
  int32_T tmp_data[50];
  int32_T b_tmp_size[1];
  int32_T b_tmp_data[50];
  int32_T b_bbox_data[200];
  int32_T loop_ub;
  int32_T b_bbox_size[2];
  int32_T i0;
  int32_T b_loop_ub;
  int32_T i1;
  real_T b_laneVertices_data[200];
  real_T d0;

  /* % */
  /*  Create a |ColorSpaceConverter| System object to */
  /*  convert the RGB image to an intensity image. */
  /* 'lanemarking_Algorithm:12' if isempty(hColor) */
  if (!hColor_not_empty) {
    /* 'lanemarking_Algorithm:13' hColor = vision.ColorSpaceConverter( ... */
    /* 'lanemarking_Algorithm:14'                    'Conversion', 'RGB to intensity'); */
    c_ColorSpaceConverter_ColorSpac(&hColor);
    hColor_not_empty = TRUE;
  }

  /* % */
  /*  Create an |AutoThresholder| system object to  */
  /*  convert intensity image to black and white image */
  /* 'lanemarking_Algorithm:20' if isempty(hThresh) */
  if (!hThresh_not_empty) {
    /* 'lanemarking_Algorithm:21' hThresh = vision.Autothresholder; */
    Autothresholder_Autothresholder(&hThresh);
    hThresh_not_empty = TRUE;
  }

  /*  %% */
  /*  Create Blob Detecter */
  /* 'lanemarking_Algorithm:26' if isempty(hBlob) */
  if (!hBlob_not_empty) {
    /* 'lanemarking_Algorithm:27' hBlob = vision.BlobAnalysis(            ... */
    /* 'lanemarking_Algorithm:28'         'MinimumBlobAreaSource',     'Property', ... */
    /* 'lanemarking_Algorithm:29'         'MinimumBlobArea',           10        , ... */
    /* 'lanemarking_Algorithm:30'         'MajorAxisLengthOutputPort', true      , ... */
    /* 'lanemarking_Algorithm:31'         'MinorAxisLengthOutputPort', true      , ... */
    /* 'lanemarking_Algorithm:32'         'OrientationOutputPort',     true      , ... */
    /* 'lanemarking_Algorithm:33'         'CentroidOutputPort',        false     , ... */
    /* 'lanemarking_Algorithm:34'         'BoundingBoxOutputPort',     true      , ... */
    /* 'lanemarking_Algorithm:35'         'LabelMatrixOutputPort',     false     , ... */
    /* 'lanemarking_Algorithm:36'         'AreaOutputPort',            false     ); */
    BlobAnalysis_BlobAnalysis(&hBlob);
    hBlob_not_empty = TRUE;
  }

  /*         %% Convert to Intensity */
  /* 'lanemarking_Algorithm:40' frameGray = step(hColor, frameRGB); */
  SystemCore_step(&hColor, frameRGB, frameGray);

  /*         %% Thresholding image using Otsu's method */
  /* 'lanemarking_Algorithm:43' binary = step(hThresh, frameGray); */
  b_SystemCore_step(&hThresh, frameGray, binary);

  /*          level = graythresh(frameGray) * intmax(class(frameGray)); */
  /*          binary = frameGray > level; */
  /*         %% Perform blob detection */
  /* 'lanemarking_Algorithm:48' [bbox, Major, Minor, Orientation] = step(hBlob, binary); */
  c_SystemCore_step(&hBlob, binary, bbox_data, bbox_size, Major_data, Major_size,
                    Minor_data, Minor_size, Orientation_data, Orientation_size);

  /*         %% Find lanes */
  /* 'lanemarking_Algorithm:51' laneIndex = findlanes(bbox, Major, Minor); */
  findlanes(bbox_data, bbox_size, Major_data, Minor_data, laneIndex_data,
            laneIndex_size);

  /*         %% Mark Lanes on original image */
  /* 'lanemarking_Algorithm:54' laneVertices = getLaneVerticies(bbox(laneIndex, :), Orientation(laneIndex)); */
  eml_li_find(laneIndex_data, laneIndex_size, tmp_data, tmp_size);
  eml_li_find(laneIndex_data, laneIndex_size, b_tmp_data, b_tmp_size);
  loop_ub = bbox_size[1];
  b_bbox_size[0] = b_tmp_size[0];
  b_bbox_size[1] = bbox_size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    b_loop_ub = b_tmp_size[0];
    for (i1 = 0; i1 < b_loop_ub; i1++) {
      b_bbox_data[i1 + b_tmp_size[0] * i0] = bbox_data[(b_tmp_data[i1] +
        bbox_size[0] * i0) - 1];
    }
  }

  loop_ub = tmp_size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    Major_data[i0] = Orientation_data[tmp_data[i0] - 1];
  }

  getLaneVerticies(b_bbox_data, b_bbox_size, Major_data, b_laneVertices_data,
                   bbox_size);

  /* 'lanemarking_Algorithm:55' laneVertices = int32(laneVertices); */
  laneVertices_size[0] = bbox_size[0];
  laneVertices_size[1] = 4;
  loop_ub = bbox_size[0] * bbox_size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    d0 = rt_roundd(b_laneVertices_data[i0]);
    if (d0 < 2.147483648E+9) {
      if (d0 >= -2.147483648E+9) {
        i1 = (int32_T)d0;
      } else {
        i1 = MIN_int32_T;
      }
    } else {
      i1 = MAX_int32_T;
    }

    laneVertices_data[i0] = i1;
  }
}

/* End of code generation (lanemarking_Algorithm.cpp) */
