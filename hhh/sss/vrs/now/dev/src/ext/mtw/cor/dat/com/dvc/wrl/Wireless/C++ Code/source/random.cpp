// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: random.cpp
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
#include <math.h>
#include <stdlib.h>

#include "random.h"
#include "util.h"

// Constructor takes noise power in dB as parameter
AWGN::AWGN(double dB_noise) {
    setdBNoise(dB_noise);

    m_x1=6666;
    m_x2=18888;
    m_x3=121;
    m_x4=178;
    m_x5=2140;
    m_x6=25000;
}

// Copy constructor
AWGN::AWGN(AWGN& awgn) {
    setdBNoise(awgn.m_dB_noise);

    m_x1 = awgn.m_x1;
    m_x2 = awgn.m_x2;
    m_x3 = awgn.m_x3;
    m_x4 = awgn.m_x4;
    m_x5 = awgn.m_x5;
    m_x6 = awgn.m_x6;
}

//virtual
AWGN::~AWGN() {
}

// Set nose power in dB
void
AWGN::setdBNoise(double dB_noise) {
    _ASSERTE(dB_noise > 0.0);
    m_dB_noise = dB_noise;
}

double
AWGN::getdBNoise() const {
    return m_dB_noise;
}

// Generate the next complex-valued random noise sample
Sample
AWGN::nextSample() {

    m_x1 = (171 * m_x1)%30269;
    m_x2 = (172 * m_x2)%30307;
    m_x3 = (170 * m_x3)%30323;
    double m1 = fmod(m_x1/30269.0 + m_x2/30307.0 + m_x3/30323.0, 1.0);
    // m1 is a uniform rv

    m_x4 = (171 * m_x4)%30269;
    m_x5 = (172 * m_x5)%30307;
    m_x6 = (170 * m_x6)%30323;
    double m2 = fmod(m_x4/30269.0 + m_x5/30307.0 + m_x6/30323.0, 1.0);
    // m2 is a uniform rv

    double k1 = sqrt(-2.0 * m_dB_noise * log(m1));
    double k2 = twopi * m2;

    // Return complex-valued sample
    return Sample(k1*cos(k2), k1*sin(k2));
}

// Generate the next N complex-valued random noise samples
Signal
AWGN::nextNSamples(int N) {
    Signal awgnSignal(N);
    for (int i=0; i<N; ++i) {
        awgnSignal[i] = nextSample();
    }

    return awgnSignal;
}


// Implementation of RandomBit class
// ..Initialize seed before first call of RandomBit::nextBit()
RandomBit::RandomBit() {
    m_seed = 0x80000;
}

//virtual
RandomBit::~RandomBit() {
}

// Fill the bits with consecutive 0 and 1
// for test purpose
Bits
RandomBit::fillWith01(int N) {
    Bits bits(N,false);

    for(int i=0; i<N; i+=2)
    bits[i] = true;

    return bits;
}

// Generate the next random bit
bool
RandomBit::nextBit() {
    unsigned int newbit = ((m_seed & IB20) >> 19) ^ ((m_seed & IB3) >> 2);
    m_seed = (m_seed << 1) | newbit;
    return (newbit > 0);
	//return false;
}

// Generate the next N random bits
Bits
RandomBit::nextNBits(int N) {
    Bits bits(N);
    for (int i=0; i<N; ++i) {
        bits[i] = nextBit();
    }

    return bits;
}

// Construct Random object
Random::Random(int iseed) {
    if (iseed >= 0) {
        seed((unsigned int)iseed);
    }
}

// Set the seed for random number generation
//static
void
Random::seed(unsigned int uiseed) {
    srand(uiseed);
}

// Store RAND_MAX as a double
static const double dRAND_MAX = (double)RAND_MAX;
// Return a random number in [0.0,1.0] as generated
// by rand()
static inline double rand0_1() {
    return ((double)rand())/dRAND_MAX;
}

// Use rand to return a double in [0.0, scale]
//static
double
Random::drand(double scale) {
    return scale * rand0_1();
}

// Use rand() to return an integer in [0, scale]
//static
int
Random::irand(int scale) {
    double dval = drand((double)scale);
    if (dval >= 0.0) { return int(floor(dval + 0.5)); }
    else             { return int(ceil(dval - 0.5)); }
}
