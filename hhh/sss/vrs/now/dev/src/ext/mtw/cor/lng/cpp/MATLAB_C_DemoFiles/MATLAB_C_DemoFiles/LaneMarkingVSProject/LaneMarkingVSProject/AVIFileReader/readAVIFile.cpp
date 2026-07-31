//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * readAVIFile.cpp
 *
 * Code generation for function 'readAVIFile'
 *
 * C source code generated on: Fri Mar 08 12:33:38 2013
 *
 */

/* Include files */
#include "readAVIFile.h"
#include "step.h"
#include "readAVIFile_data.h"
#include "HostLib_MMFile.h"
#include "HostLib_Multimedia.h"
#include "HostLib_rtw.h"

/* Function Definitions */

/*
 * function [isEOf, frame] = readAVIFile
 *  Copyright 2012 MathWorks, Inc.
 */
void readAVIFile(boolean_T *isEOf, uint8_T frame[259200])
{
  boolean_T d;
  vision_VideoFileReader_0 *obj;

  /* 'readAVIFile:6' isEOf = false; */
  *isEOf = FALSE;

  /* 'readAVIFile:8' if isempty(hReader) */
  if (!hReader_not_empty) {
    /* 'readAVIFile:9' hReader = vision.VideoFileReader('viplanedeparture.avi', ... */
    /* 'readAVIFile:10'         'VideoOutputDataType', 'uint8'); */
    Constructor(&hReader);
    hReader_not_empty = TRUE;
  }

  /* 'readAVIFile:13' if ~isDone(hReader) */
  d = hReader.O1_Y1;
  if (!d) {
    /* 'readAVIFile:14' frame = step(hReader); */
    obj = &hReader;
    if (!obj->S0_isInitialized) {
      obj->S0_isInitialized = TRUE;
      Start(obj);

      /* System object Initialization function: vision.VideoFileReader */
      obj->O1_Y1 = FALSE;
      LibReset(&obj->W0_HostLib[0U]);
    }

    Outputs(obj, frame, &d);
  } else {
    /* 'readAVIFile:15' else */
    /* 'readAVIFile:16' frame = zeros(240, 360, 3, 'uint8'); */
    memset(&frame[0], 0, 259200U * sizeof(uint8_T));

    /* 'readAVIFile:17' isEOf = true; */
    *isEOf = TRUE;

    /* 'readAVIFile:18' reset(hReader); */
    obj = &hReader;

    /* System object Initialization function: vision.VideoFileReader */
    obj->O1_Y1 = FALSE;
    LibReset(&obj->W0_HostLib[0U]);
  }
}

/* End of code generation (readAVIFile.cpp) */
