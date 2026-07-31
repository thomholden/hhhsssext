#ifndef __datatype_h__
#define __datatype_h__

// Use Standard C++ Library, which includes
// Standard Template Library (STL)

#include "stdcpp.h"
#include "templates.h"

using namespace std;

// Array of bits
typedef Array<bool> Bits; //an array of bits with 0 and 1

// A (modulated) Signal is an array of complex-valued samples
typedef complex<double> Sample; // a complex sample consisting of real and imaginary parts 
typedef Array<Sample> Signal; // an array of complex numbers

typedef complex<double> Coeff;  // a complex coefficient for the filter 
typedef Array<Coeff> Filter; // an array of complex coefficients

#endif  //__datatype_h__

