// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: programargs.h
// Last modified: 27 April 2001
// Author(s):
//   T. A. Hall
//   Wireless Communications Technologies Group
//   National Institute of Standards and Technology
//   100 Bureau Drive, STOP 8920
//   Gaithersburg, MD 20899-8920
//   timhall@nist.gov
//

#ifndef __programargs_h__
#define __programargs_h__

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// Parse command-line arguments
class ProgramArgs  
{
public:
	ProgramArgs(int argc, char* argv[]);
	virtual ~ProgramArgs();

	int count();
	const char* programName();
	bool findOption(const char* option);
	const char* getParameter(const char* option, const char* sdef);

    int getIntParameter(const char* option, int idef);
    double getDoubleParameter(const char* option, double ddef);

private:
	int m_argc;
	char** m_argv;
};

#endif    // __programargs_h__

