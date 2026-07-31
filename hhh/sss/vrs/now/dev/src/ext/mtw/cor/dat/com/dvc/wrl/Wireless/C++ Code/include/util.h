#ifndef __util_h__
#define __util_h__

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifdef _UNIX_BUILD
  #define max(a, b) ((a > b)?(a):(b))
  #define min(a, b) ((a < b)?(a):(b))
  #include <assert.h>
  #define _ASSERTE assert
#else // Windows
  #define _WINDOWS_BUILD
  #define WIN32_LEAN_AND_MEAN
  #include <minmax.h>
  #include <crtdbg.h>
#endif

#include <stdio.h>

//****************************************//
//* commonly used typedefs, defines, and *//
//* short inline functions               *//
//****************************************//
typedef unsigned char byte;
typedef unsigned short word;

#define nil 0
#ifndef null
  #define null 0
#endif
const double twopi = 6.2831853071;
const double PI = 3.141592654;

#endif  //__util_h__

