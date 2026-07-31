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

//#if defined(UseCompilerDLL) 
#include "laneMarkingAlgorithmWithVisualization.h" /* Include Compiler-generated header file */
//#endif

#if defined(SingleFrame)
#include "readBinaryImageFile.h"
#elif defined(Video)
#include "readAVIFile_initialize.h"
#include "readAVIFile.h"
#endif



int FindLanesWithCompiler()
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
#if defined(SingleFrame)
	if (!readBinaryImageFile(filename, &frame, row, col, planes))
	{
		return(-1);
	}

	numPixels = row * col * planes;

#elif defined(Video)
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
	/* Initialize MCR and library  function*/
	mclInitializeApplication(NULL,0);	/* Initialize MATLAB Compiler Runtime */
	laneMarkingAlgorithmWithVisualizationInitialize();		/* Initialize generated DLL */

	fprintf(fpOut, "*** Calling MATLAB Generated DLL***\n");

	/* Create a Matrix for MATLAB */
	mxArray *pmxImg;
	mwSize nDims  = 3;
	mwSize dims[] = {row, col, planes};

	//pmxImg = mxCreateNumericMatrix(row, col, mxUINT8_CLASS, mxREAL);
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
#endif

		/* Copy image data into Matrix */
		memcpy(pmxImgReal, frame, numPixels*sizeof(unsigned char));

		/* Call algorithm from generated DLL */

		mlfLaneMarkingAlgorithmWithVisualization(pmxImg);

		/////////////
		// End Loop
		/////////////
#if !defined(Video)
		doneLooping = true;
#endif
	}

	////////////
	// Cleanup
	////////////

	/* The command mclWaitForFiguresToDie will block execution
	untill the last MATLAB figure has been closed.  To force
	the program to wait to terminate until the last figure 
	window has been closed, uncomment out the following line */
	mclWaitForFiguresToDie(NULL);

	/* Terminate library function */
	laneMarkingAlgorithmWithVisualizationTerminate();

	/* Free MX Array resources */
	mxDestroyArray(pmxImg);

	/* Terminate MCR */ 
	mclTerminateApplication();

	// Exit cleanly
	return 0;
}

