// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: basetype.cpp
// Last modified: 8 June 2001
// Author(s):
//   Amir Soltanian
//   T. A. Hall
//   Wireless Communications Technologies Group
//   National Institute of Standards and Technology
//   100 Bureau Drive, STOP 8920
//   Gaithersburg, MD 20899-8920
//   {amirs,timhall}@nist.gov
//
#include <math.h>

#include "basetype.h"
#include "util.h"


Transmitter::Transmitter()
{
}

//virtual
int
Transmitter::minInputLength() const { // minimum input length, in bits
    return 1;   // 1 bit is the default
}


double
Transmitter::getPhase() const {
    return m_phase;
}

void
Transmitter::setPhase(double phase) {
    m_phase = phase;
}

int
Transmitter::bitrate() const {  // Bitrate in Mb/s
    return m_bitrate;
}


Receiver::Receiver()
{
}

int
Receiver::bitrate() const {     // Bitrate in Mb/s
    return m_bitrate;
}


Channel::Channel()
{
}

Sample czero(0.0, 0.0);

// FIR filter class, will be used either in tx or rx.
FIRFilter::FIRFilter(int filterLength)
: m_fc(filterLength,czero),
  m_sIn(filterLength,czero)
{
}

FIRFilter::~FIRFilter() {
}

// reset: set input signal to all zeros
void FIRFilter::reset() {
    for (int i=0; i<m_fc.size(); ++i) { m_sIn[i] = 0.0; }
}

Sample
FIRFilter::FilterStep(Sample nextIn) {
    m_sIn = m_sIn.shift(-1);
    m_sIn[0] = nextIn;
    Sample out(0.0, 0.0);

    int len = m_fc.size();
    for (int i=0; i<len; ++i) {
        out += (m_fc[len-i-1] * m_sIn[i]); 
    }
    return out;
}

void FIRFilter::SetCoef(int filterLength, const Filter& filter1)
{
    for (int i=0;i<size();++i) {
        m_fc[i]=filter1[i];
    }
}

int FIRFilter::size() const {
    return m_fc.size();
}

Sample& FIRFilter::operator [](int index) {
    return m_fc[index];
}

