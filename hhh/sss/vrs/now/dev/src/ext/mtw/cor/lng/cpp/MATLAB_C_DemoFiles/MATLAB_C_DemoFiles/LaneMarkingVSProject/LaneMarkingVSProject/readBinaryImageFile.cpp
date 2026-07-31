//
// This code is provided for example purposes only.
// 
// Copyright 2011-2013 MathWorks, Inc.
//


#include "readBinaryImageFile.h"

bool readBinaryImageFile(char* filename, unsigned char** img, int& row, int& col, int& planes)
{
	// declare local variables
	bool RetVal = false;

	FILE* FID    = NULL;
	//unsigned char* newImg = NULL;
	
	int   count     = 0;
	int	  numPixels = 0;

	// open file
	FID = fopen(filename, "rb");
	
	if ( FID == NULL) {
        return(RetVal);
    }

	// read image size
	count = fread(&row, sizeof(unsigned short), 1, FID);
	if (count != 1)
	{
        return(RetVal);
	}

	count = fread(&col, sizeof(unsigned short), 1, FID);
	if (count != 1)
	{
        return(RetVal);
	}
		
	count = fread(&planes, sizeof(unsigned short), 1, FID);
	if (count != 1)
	{
        return(RetVal);
	}

	// calculate number of pixels
	numPixels = row*col*planes;

	// allocate memory
	*img = (unsigned char*) malloc(numPixels);

	// read image
	count = fread(*img, sizeof(unsigned char), numPixels, FID);

	if (count != numPixels)
	{
        return(RetVal);
	}

	RetVal = true;
	return(RetVal);

}
