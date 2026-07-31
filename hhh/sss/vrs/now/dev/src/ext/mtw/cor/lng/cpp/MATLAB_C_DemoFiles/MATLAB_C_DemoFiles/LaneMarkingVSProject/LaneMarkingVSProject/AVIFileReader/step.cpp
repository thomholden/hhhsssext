//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//
/*
 * step.cpp
 *
 * Code generation for function 'step'
 *
 * C source code generated on: Fri Mar 08 12:33:38 2013
 *
 */

#include "configure.h"

/* Include files */
#include "readAVIFile.h"
#include "step.h"
#include "HostLib_MMFile.h"
#include "HostLib_Multimedia.h"
#include "HostLib_rtw.h"

/* Function Definitions */
vision_VideoFileReader_0 *Constructor(vision_VideoFileReader_0 *obj)
{
  vision_VideoFileReader_0 *b_obj;
  int32_T i;
  static const uint8_T uv0[9] = { 78U, 111U, 116U, 32U, 117U, 115U, 101U, 100U,
    0U };

  /* System object Constructor function: vision.VideoFileReader */
  b_obj = obj;
  b_obj->S0_isInitialized = FALSE;
  b_obj->S1_isReleased = FALSE;
  b_obj->P0_PLUGIN_PATH = 0;
  for (i = 0; i < 9; i++) {
    b_obj->P1_AR_CONVERTER_PATH[i] = uv0[i];
  }

  b_obj->O1_Y1 = FALSE;
  return b_obj;
}

void Outputs(vision_VideoFileReader_0 *obj, uint8_T Y0[259200], boolean_T *Y1)
{
  char_T *sErr;
  void *source_R;
  void *eof;

  /* System object Outputs function: vision.VideoFileReader */
  sErr = GetErrorBuffer(&obj->W0_HostLib[0U]);
  source_R = (void *)&Y0[0U];
  eof = (void *)&obj->O1_Y1;
  LibOutputs_FromMMFile(&obj->W0_HostLib[0U], eof, GetNullPointer(), source_R,
                        GetNullPointer(), GetNullPointer());
  if (*sErr != 0) {
    PrintError(sErr);
  }

  *Y1 = obj->O1_Y1;
}

void Start(vision_VideoFileReader_0 *obj)
{
  char_T *sErr;

  /* System object Start function: vision.VideoFileReader */
  sErr = GetErrorBuffer(&obj->W0_HostLib[0U]);
  CreateHostLibrary("frommmfile.dll", &obj->W0_HostLib[0U]);
  createAudioInfo(&obj->W1_AudioInfo[0U], 0, 0, 0.0, 0, 0, 0, 0, 0);
  createVideoInfo(&obj->W2_VideoInfo[0U], 1, 30.00003000003, 30.00003000003,
                  "RGB ", 1, 3, 360, 240, 0, 3, 1, 0);
  if (*sErr == 0) {
	      LibCreate_FromMMFile(&obj->W0_HostLib[0U], 0,
                         getLocation(VIDEO),
                         "", "Not used", &obj->W1_AudioInfo[0U],
                         &obj->W2_VideoInfo[0U], 0U, 1, 1, 0, 0);
//    libcreate_frommmfile(&obj->w0_hostlib[0u], 0,
//                         "c:\\matlab\\r2013a\\toolbox\\vision\\visiondemos\\viplanedeparture.avi",
//                         "", "not used", &obj->w1_audioinfo[0u],
//                         &obj->w2_videoinfo[0u], 0u, 1, 1, 0, 0);
  }

  if (*sErr == 0) {
    LibStart(&obj->W0_HostLib[0U]);
  }

  if (*sErr != 0) {
    DestroyHostLibrary(&obj->W0_HostLib[0U]);
    if (*sErr != 0) {
      PrintError(sErr);
    }
  }
}

/* End of code generation (step.cpp) */
