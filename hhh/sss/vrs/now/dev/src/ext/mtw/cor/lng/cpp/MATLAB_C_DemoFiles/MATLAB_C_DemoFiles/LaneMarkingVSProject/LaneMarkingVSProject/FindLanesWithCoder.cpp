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

//#if defined(UseCoderSource)
#include "verifyLanes.h"			/* must come before generated code */
#include "lanemarking_Algorithm.h" /* Include MATLAB Coder generated header file */
#include "lanemarking_Algorithm_initialize.h"
//#endif

#if defined(SingleFrame)
#include "readBinaryImageFile.h"
#elif defined(Video)
#include "readAVIFile_initialize.h"
#include "readAVIFile.h"
#endif



int FindLanesWithCoder()
{
	/* Declare local variables */
	unsigned char* frame = NULL;

	int  row       = 0;
	int  col       = 0;
	int  planes    = 0;
	int  numPixels = 0;

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
	fprintf(fpOut, "*** Calling MATLAB Code Source Code ***\n");

	/* Call lanemarking_algorithm */
	lanemarking_Algorithm_initialize();
	initializeVerifyLanes(row, col, planes);

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

		/* Declare local variables */
		int laneVertices_data[200] ;  /* Algorithm supports max of 50 lanes */
		int laneVertices_size[  2] ;  /* Matrix to store size of vertice array */

		int numLanes = 0;

		/* Initialize local variables to zero */
		memset(laneVertices_data, 0, sizeof(int) * 200);
		memset(laneVertices_size, 0, sizeof(int) * 2  );

		/* Call lanemarking_algorithm */
		lanemarking_Algorithm(frame, laneVertices_data, laneVertices_size);

		/* Verify lanes */
		verifyLanes(frame, laneVertices_data, laneVertices_size);

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


	// Exit cleanly
	return 0;
}

