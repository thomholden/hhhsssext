// LaneMarkingVSProject.cpp : Defines the entry point for the console application.
//
// This code is provided for example purposes only.
// 
// Copyright 2011-2013 MathWorks, Inc.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "configure.h"

//#if defined(UseMATLABEngine)
#include "engine.h" /* Include Engine header file from MATLAB */
//#endif


#if defined(SingleFrame)
#include "readBinaryImageFile.h"
#elif defined(Video)
#include "readAVIFile_initialize.h"
#include "readAVIFile.h"
#endif


int FindLanesWithEngine()
{
	/* Declare local variables */
	unsigned char* frame = NULL;

	int  row       = 0;
	int  col       = 0;
	int  planes    = 0;
	int  numPixels = 0;
	//int  i         = 0;

	bool doneLooping = false;
	bool aviDone     = false;

	/* Determine path to image */
	char * filename = getLocation(IMAGE);

	/* Write mode output to stdout */
	FILE* fpOut = stdout;

	//////////////////
	// Acquire Image
	//////////////////
#if defined(Video)
	row    = 240;
	col    = 360;
	planes =   3;

	numPixels = row*col*planes;

	// allocate memory
	frame = (unsigned char*) malloc(numPixels);

	// initialize AVI Reader
	readAVIFile_initialize();
#endif


	///////////////
	// Find Lanes
	///////////////
	/* Declare Engine pointer */
	Engine *ep = engOpen(NULL); /* Connect to MATLAB engine */
	fprintf(fpOut, "*** Sending data to MATLAB. See results in MATLAB.***\n");

	/* Create a Matrix for MATLAB */
	mxArray *pmxImg;
	mwSize nDims  = 3;
	mwSize dims[] = {row, col, planes};

	/* Create MX Array to represent frame of video in MATLAB */
	pmxImg = mxCreateNumericArray(nDims, dims, mxUINT8_CLASS, mxREAL);

	/* Get pointer to real portion of data */
	double *pmxImgReal = mxGetPr(pmxImg);


	//////////////////
	// Begin Looping
	//////////////////
	while (!doneLooping) {

#if defined(Video)
		// read frame
		readAVIFile( (unsigned char *) &aviDone, frame );

		if (aviDone) {
			doneLooping = true;
			return(-1);
		}

#else /* defined(SingleFrame) */
		if (!readBinaryImageFile(filename, &frame, row, col, planes))
		{
			return(-1);
		}

		numPixels = row * col * planes;
		doneLooping = true;
#endif

		/* Copy image data into Matrix */
		memcpy(pmxImgReal, frame, numPixels*sizeof(unsigned char));

		/* Send data to MATLAB */
		engPutVariable(ep, "img", pmxImg);

		/* Verify lane marking algorithm on new image */
		engEvalString(ep, getCDCommand()                             );
		engEvalString(ep, "laneVertices = lanemarking_Algorithm(img)");
		engEvalString(ep, "displayLanes(img, laneVertices)"          );

	}

	////////////
	// Cleanup
	////////////

	/* Free MX Array resources */
	mxDestroyArray(pmxImg);

	/* Close Engine */ 
	engClose(ep);

	// Exit cleanly
	return 0;
}
