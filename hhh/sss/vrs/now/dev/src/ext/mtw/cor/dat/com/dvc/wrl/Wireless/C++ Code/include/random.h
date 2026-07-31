// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: random.h
// Last modified: 8 June 2001
// Author(s):
//   T. A. Hall
//   Amir Soltanian
//   Wireless Communications Technologies Group
//   National Institute of Standards and Technology
//   100 Bureau Drive, STOP 8920
//   Gaithersburg, MD 20899-8920
//   {timhall,amirs}@nist.gov
//

#ifndef __random_h__
#define __random_h__

#include "datatype.h"

// Complex-valued additive white Gaussian noise (AWGN) generator
class AWGN {
public:
    // Default and copy constructors
    AWGN(double dB_noise = 1.0);
    AWGN(AWGN& awgn);
    // Destructor
    virtual ~AWGN();

    void setdBNoise(double dB_noise);   // set noise power in dB
    double getdBNoise() const;          // return noise power in dB
    Sample nextSample();                // generate one complex Gaussian random sample
    Signal nextNSamples(int N);         // generate N complex Gaussian random variable

private:
    double m_dB_noise;
    int m_x1, m_x2, m_x3, m_x4, m_x5, m_x6;
};

// Random bit generation class
class RandomBit {
public:
    // Default constructor
    RandomBit();
    virtual ~RandomBit();

    bool nextBit();                     // Generate one random bit
    Bits nextNBits(int N);              // Generate N random bits
	Bits fillWith01(int N);             // Return N bits in 010101... pattern

private:
    // Shift register
    enum {IB3=4, IB20=524288 };
    unsigned m_seed;
};

// Interface to rand() and srand() C library calls
class Random {
public:
    // Default constructor
    Random(int iseed=-1);

    static void seed(unsigned int uiseed);  // set seed for random number generator
    static double drand(double scale=1.0);  // Random double in range [0.0, scale]
    static int irand(int scale=1);          // Random integer in range [0, scale]
};

#endif  //__random_h__

