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

#if defined(UseMATLABEngine)
#include "FindLanesWithEngine.h"
#endif

#if defined(UseCompilerDLL) 
#include "FindLanesWithCompiler.h"
#endif

#if defined(UseCoderSource)
#include "FindLanesWithCoder.h"
#endif


int main(int argc, char* argv[])
{
	/* Declare local variables */
	int  RetVal = 0;

	///////////////
	// Find Lanes
	///////////////
#if defined(UseMATLABEngine)
	RetVal = FindLanesWithEngine();
#endif

#if defined(UseCompilerDLL)
	RetVal = FindLanesWithCompiler();
#endif

#if defined(UseCoderSource)
	RetVal = FindLanesWithCoder();
#endif

	// Exit cleanly
	return 0;
}

