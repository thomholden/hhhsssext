// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: awgnchan.cpp
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
#include "awgnchan.h"
#include "random.h"
#include "util.h"

// Default constructor
AWGNChannel::AWGNChannel(double dB_noise)
{
    m_awgn = new AWGN(dB_noise);
}

// Copy constructor
AWGNChannel::AWGNChannel(AWGNChannel& awgnchan)
{
    m_awgn = new AWGN(*(awgnchan.m_awgn));
}

// Destructor
// virtual
AWGNChannel::~AWGNChannel() {
    delete m_awgn;
}

// Return channel output given desired and interference signals
//virtual
Signal
AWGNChannel::process(const Signal& desired,
                     const Signal& interference) {
    int N = desired.size();
    _ASSERTE(N == interference.size());

    // add signal and interference and noise samples	
    return desired + interference + m_awgn->nextNSamples(N);
}
