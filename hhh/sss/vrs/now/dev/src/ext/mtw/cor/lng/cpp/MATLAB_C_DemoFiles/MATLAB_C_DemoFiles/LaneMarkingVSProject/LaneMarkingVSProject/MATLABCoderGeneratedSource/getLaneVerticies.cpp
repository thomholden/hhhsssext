//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * getLaneVerticies.cpp
 *
 * Code generation for function 'getLaneVerticies'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "getLaneVerticies.h"

/* Function Definitions */

/*
 * function laneVertices = getLaneVerticies(bbox, Orientation)
 *  Copyright 2012 MathWorks, Inc.
 */
void getLaneVerticies(const int32_T bbox_data[200], const int32_T bbox_size[2],
                      const real_T Orientation_data[50], real_T
                      laneVertices_data[200], int32_T laneVertices_size[2])
{
  int32_T loop_ub;
  int32_T q0;
  int32_T q1;
  int32_T qY;

  /* 'getLaneVerticies:5' numLines = size(bbox, 1); */
  /* 'getLaneVerticies:6' laneVertices = zeros(numLines, 4); */
  laneVertices_size[0] = bbox_size[0];
  laneVertices_size[1] = 4;
  loop_ub = bbox_size[0] << 2;
  for (q0 = 0; q0 < loop_ub; q0++) {
    laneVertices_data[q0] = 0.0;
  }

  /* 'getLaneVerticies:8' for idx = 1:numLines */
  for (loop_ub = 0; loop_ub < bbox_size[0]; loop_ub++) {
    /* 'getLaneVerticies:9' x = bbox(idx, 1); */
    /* 'getLaneVerticies:10' y = bbox(idx, 2); */
    /* 'getLaneVerticies:11' w = bbox(idx, 3); */
    /* 'getLaneVerticies:12' h = bbox(idx, 4); */
    /* 'getLaneVerticies:14' if Orientation(idx) >= 0 */
    if (Orientation_data[loop_ub] >= 0.0) {
      /* 'getLaneVerticies:15' laneVertices(idx, :) = [x+w y   x y+h]; */
      q0 = bbox_data[loop_ub];
      q1 = bbox_data[loop_ub + (bbox_size[0] << 1)];
      qY = q0 + q1;
      if ((q0 < 0) && ((q1 < 0) && (qY >= 0))) {
        qY = MIN_int32_T;
      } else {
        if ((q0 > 0) && ((q1 > 0) && (qY <= 0))) {
          qY = MAX_int32_T;
        }
      }

      laneVertices_data[loop_ub] = qY;
      laneVertices_data[loop_ub + bbox_size[0]] = bbox_data[loop_ub + bbox_size
        [0]];
      laneVertices_data[loop_ub + (bbox_size[0] << 1)] = bbox_data[loop_ub];
      q0 = bbox_data[loop_ub + bbox_size[0]];
      q1 = bbox_data[loop_ub + bbox_size[0] * 3];
      qY = q0 + q1;
      if ((q0 < 0) && ((q1 < 0) && (qY >= 0))) {
        qY = MIN_int32_T;
      } else {
        if ((q0 > 0) && ((q1 > 0) && (qY <= 0))) {
          qY = MAX_int32_T;
        }
      }

      laneVertices_data[loop_ub + bbox_size[0] * 3] = qY;
    } else {
      /* 'getLaneVerticies:16' else */
      /* 'getLaneVerticies:17' laneVertices(idx, :) = [x+w y+h x y  ]; */
      q0 = bbox_data[loop_ub];
      q1 = bbox_data[loop_ub + (bbox_size[0] << 1)];
      qY = q0 + q1;
      if ((q0 < 0) && ((q1 < 0) && (qY >= 0))) {
        qY = MIN_int32_T;
      } else {
        if ((q0 > 0) && ((q1 > 0) && (qY <= 0))) {
          qY = MAX_int32_T;
        }
      }

      laneVertices_data[loop_ub] = qY;
      q0 = bbox_data[loop_ub + bbox_size[0]];
      q1 = bbox_data[loop_ub + bbox_size[0] * 3];
      qY = q0 + q1;
      if ((q0 < 0) && ((q1 < 0) && (qY >= 0))) {
        qY = MIN_int32_T;
      } else {
        if ((q0 > 0) && ((q1 > 0) && (qY <= 0))) {
          qY = MAX_int32_T;
        }
      }

      laneVertices_data[loop_ub + bbox_size[0]] = qY;
      laneVertices_data[loop_ub + (bbox_size[0] << 1)] = bbox_data[loop_ub];
      laneVertices_data[loop_ub + bbox_size[0] * 3] = bbox_data[loop_ub +
        bbox_size[0]];
    }
  }
}

/* End of code generation (getLaneVerticies.cpp) */
