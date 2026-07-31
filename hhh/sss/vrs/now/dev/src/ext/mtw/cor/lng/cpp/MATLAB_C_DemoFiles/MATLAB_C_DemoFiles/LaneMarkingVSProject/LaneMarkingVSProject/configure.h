//
// This code is provided for example purposes only.
// 
// Copyright 2011-2013 MathWorks, Inc.
//

#ifndef __CONFIGUREDEMO_H__
#define __CONFIGUREDEMO_H__
/********************************/
/*  Define Operating Mode Below */
/********************************/

/* *********************** */
/*  Single Frame or Video  */
/* *********************** */
//#define SingleFrame
#define Video


/* *************** */
/*  MATLAB Engine  */
/* *************** */
#define UseMATLABEngine

/* ************** */
/*  MATLAB Coder  */
/* ************** */
//#define UseCoderSource

/* ***************** */
/*  MATLAB Compiler  */
/* ***************** */
//#define UseCompilerDLL


/********************************/
/*  Configure Demo Path Below   */
/********************************/
#define BASEDIR "C:\\Demos\\AlgorithmDevelopment\\"
//#define BASEDIR "C:\\dave\\docs - work\\Seminars\\AlgDevel\\Demos"


/*********************************************/
/*  Helper functions to Return Paths Below   */
/*********************************************/
enum locations {
	IMAGE       ,
	VIDEO		,
	ALGORITHM   ,
	VERIFICATION
};

extern char * getLocation(locations);
extern char * getCDCommand();


#endif