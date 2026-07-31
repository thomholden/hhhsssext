//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * readAVIFile_terminate.cpp
 *
 * Code generation for function 'readAVIFile_terminate'
 *
 * C source code generated on: Fri Mar 08 12:33:38 2013
 *
 */

/* Include files */
#include "readAVIFile.h"
#include "readAVIFile_terminate.h"
#include "readAVIFile_data.h"
#include "HostLib_MMFile.h"
#include "HostLib_Multimedia.h"
#include "HostLib_rtw.h"

/* Function Definitions */
void readAVIFile_terminate()
{
  vision_VideoFileReader_0 *obj;
  char_T *sErr;
  obj = &hReader;

  /* System object Destructor function: vision.VideoFileReader */
  if (obj->S0_isInitialized) {
    obj->S0_isInitialized = FALSE;
    if (!obj->S1_isReleased) {
      obj->S1_isReleased = TRUE;

      /* System object Terminate function: vision.VideoFileReader */
      sErr = GetErrorBuffer(&obj->W0_HostLib[0U]);
      LibTerminate(&obj->W0_HostLib[0U]);
      if (*sErr != 0) {
        PrintError(sErr);
      }

      LibDestroy(&obj->W0_HostLib[0U], 0);
      DestroyHostLibrary(&obj->W0_HostLib[0U]);
    }
  }
}

/* End of code generation (readAVIFile_terminate.cpp) */
