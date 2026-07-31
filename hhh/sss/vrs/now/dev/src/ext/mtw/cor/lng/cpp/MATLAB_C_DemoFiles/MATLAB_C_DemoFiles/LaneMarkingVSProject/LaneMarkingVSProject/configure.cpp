//
// This code is provided for example purposes only.
// 
// Copyright 2013 MathWorks, Inc.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "configure.h"

char * getLocation(locations whichLocation)
{
	char * RetVal = NULL; 
	char * path   = NULL;
	char * part   = NULL;
	int    length = 0;

	switch(whichLocation) 
	{
	case (IMAGE): 
		//path = "\\LaneMarkingVSProject\\Utilities\\singleFrame.bin";
		path = "\\Data\\singleFrame.bin";
		break;
	case (VIDEO): 
		path = "\\Data\\viplanedeparture.avi";
		break;
	case(ALGORITHM):
		path = "\\7-LanesCompilerLibrary";
		break;
	case(VERIFICATION):
		path = "\\4-VerifyLanesOnVideo";
		break;
	default:
		return(RetVal);
	}


	length = strlen(path) + strlen(BASEDIR);
	RetVal = (char *) malloc(sizeof(char) * length);

	RetVal = strcpy(RetVal, BASEDIR);
	RetVal = strcat(RetVal, path   );

	return(RetVal);
}

char * getCDCommand()
{
	/* Local Variables */
	int  cmdLength   = 0      ;

	char * cdStart   = "cd('" ;
	char * cdEnd     = "   ')";
	char * cdCommand = NULL   ;

	/* Determine Algorithm Path */
	char * dirname = getLocation(VERIFICATION);

	/* Determine command length */
	cmdLength = strlen(dirname) + strlen(cdStart) + strlen(cdEnd);

	cdCommand = (char *) malloc(sizeof(char) * cmdLength);

	/* Assemble CD Command */
	cdCommand = strcpy(cdCommand, cdStart);
	cdCommand = strcat(cdCommand, dirname);
	cdCommand = strcat(cdCommand, cdEnd  );

	return(cdCommand);
}