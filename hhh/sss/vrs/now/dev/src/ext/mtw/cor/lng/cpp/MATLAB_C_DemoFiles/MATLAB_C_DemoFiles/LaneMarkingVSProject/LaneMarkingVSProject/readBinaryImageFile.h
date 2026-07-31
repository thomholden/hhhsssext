//
// This code is provided for example purposes only.
// 
// Copyright 2011-2013 MathWorks, Inc.
//

#ifndef readBinaryImageFile_H
#define readBinaryImageFile_H

#include <stdlib.h>
#include <stdio.h>

#define _CRT_SECURE_NO_WARNINGS

extern bool readBinaryImageFile(char* filename, unsigned char** img,
								int& row, int& col, int& planes);


#endif