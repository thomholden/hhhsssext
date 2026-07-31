//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * findlanes.cpp
 *
 * Code generation for function 'findlanes'
 *
 * C source code generated on: Fri Mar 08 12:36:03 2013
 *
 */

/* Include files */
#include "lanemarking_Algorithm.h"
#include "findlanes.h"

/* Function Definitions */

/*
 * function lane_idx = findlanes(bbox, Major, Minor)
 *  function lanes=findlanes(B,h, stats)
 *  Find the regions that look like lanes
 */
void findlanes(const int32_T bbox_data[200], const int32_T bbox_size[2], const
               real_T Major_data[50], const real_T Minor_data[50], boolean_T
               lane_idx_data[50], int32_T lane_idx_size[1])
{
  int32_T loop_ub;
  int32_T q0;
  int32_T q1;
  int32_T qY;

  /*  Copyright 2006-2012 MathWorks, Inc. */
  /*  Pre-allocate return vector */
  /* 'findlanes:8' num_blobs = size(bbox, 1); */
  /* 'findlanes:9' lane_idx = false(num_blobs, 1); */
  lane_idx_size[0] = bbox_size[0];
  loop_ub = bbox_size[0];
  for (q0 = 0; q0 < loop_ub; q0++) {
    lane_idx_data[q0] = FALSE;
  }

  /* 'findlanes:11' for k = 1:num_blobs */
  for (loop_ub = 0; loop_ub < bbox_size[0]; loop_ub++) {
    /* 'findlanes:12' metric = abs(Major(k)/Minor(k)); */
    /* 'findlanes:14' bottom_of_blob = bbox(k, 2) + bbox(k, 4); */
    /* 'findlanes:16' if metric > 2 && all(bottom_of_blob > 100) */
    if (fabs(Major_data[loop_ub] / Minor_data[loop_ub]) > 2.0) {
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

      if (qY > 100) {
        /* 'findlanes:17' lane_idx(k) = true; */
        lane_idx_data[loop_ub] = TRUE;
      }
    }
  }
}

/* End of code generation (findlanes.cpp) */
