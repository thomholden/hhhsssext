// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: bluetooth.cpp
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

#include "bluetooth.h"
#include "util.h"


BluetoothTransmitter::BluetoothTransmitter(double hf,
                                           double phase_shift)
{
    m_bitrate = 1;          // 1 Mb/s
    m_hf = hf;              // Modulation index
    m_prev = false;         // Previous bit transmitted
    setPhase(phase_shift);  // Current phase
}

BluetoothTransmitter::BluetoothTransmitter(BluetoothTransmitter& txbt)
{
    m_bitrate = 1;
    m_hf=txbt.m_hf;
    m_prev = txbt.m_prev;
    setPhase(txbt.getPhase());
}


//virtual
BluetoothTransmitter::~BluetoothTransmitter() {
}

// virtual
Signal
BluetoothTransmitter::transmit(const Bits& input,
                               double df) {
    return modulate(input, df);
}

//virtual
void
BluetoothTransmitter::reset() {
    setPhase(0.0);
    m_prev=false;
}

// Modulation
// Gaussian filter coefficients for modulator. Ns=44 samples per bit 
//static
const double BluetoothTransmitter::s_qcoef[2*Ns] =
{.0003384128078, .0007483472705, .001241740730, .001831809714,  // [0..3]
 .002533043604,  .003361167254,  .004333069131, .005466692340,  // [4..7]
 .006780887010,  .008295223730,  .01002976939,  .01200482814,   // [8..11]
 .01424065196,   .01675712682,   .01957344200,  .02270775110,   // [12..15]
 .02617683454,   .02999577350,   .03417764580,  .03873325341,   // [16..19]
 .04367089078,   .04899616180,   .05471185145,  .06081785680,   // [20..23]
 .06731117780,   .07418596970,   .08143365250,  .08904307290,   // [24..27]
 .09700071245,   .1052909327 ,   .1138962464 ,  .1227976077,    // [28..31]
 .1319747047,    .1414062494,    .1510702515,   .1609442679,    // [32..35]
 .1710056206,    .1812315788,    .1915994984,   .2020869202,    // [36..39]
 .2126716262,    .2233316570,    .2340452932,   .2447910090,    // [40..43]
 .2555474036,    .2662931193,    .2770067556,   .2876667864,    // [44..47]
 .2982514925,    .3087389142,    .3191068338,   .3293327920,    // [48..51]
 .3393941448,    .3492681611,    .3589321632,   .3683637078,    // [52..55]
 .3775408048,    .3864421662,    .3950474800,   .4033377002,    // [56..59]
 .4112953398,    .4189047602,    .4261524430,   .4330272350,    // [60..63]
 .4395205560,    .4456265612,    .4513422510,   .4566675220,    // [64..67]
 .4616051594,    .4661607670,    .4703426394,   .4741615782,    // [68..71]
 .4776306617,    .4807649708,    .4835812860,   .4860977608,    // [72..75]
 .4883335846,    .4903086434,    .4920431890,   .4935575258,    // [76..79]
 .4948717204,    .4960053436,    .4969772456,   .4978053692,    // [80..83]
 .4985066031,    .4990966721,    .4995900656,   .5000000000};   // [84..87]


static inline double qsign(bool bval) { return ((bval) ? -1.0 : 1.0); }

Signal
BluetoothTransmitter::modulate(const Bits& input, double df) {
    Signal modOut(Ns * input.size());
    int offset = 0;
    double phase=getPhase();

    for (int i=0; i<input.size(); ++i) {
        for(int j=0; j<Ns; ++j) {
            double tt=twopi*df*(j+Ns*i)/((double)Ns);
            if (tt>twopi) { tt=fmod(tt,twopi); }
            double state = qsign(input[i])*s_qcoef[j] +
                           qsign(m_prev)*s_qcoef[j+Ns] + phase;
            modOut[offset+j] = exp(Sample(0.0,twopi* (m_hf * state)+tt));
        } // end j

        // Update phase and previous bit value
        phase += (m_prev ? -0.5 : 0.5);
        m_prev = input[i];
        offset += Ns;
    } // end i

    setPhase(phase);
    return modOut;
}

/**********************************************************************/
/**********************************************************************/

BluetoothReceiver::BluetoothReceiver()
: bandpassFilter(BPLENGTH),
  differentiatorFilter(DIFFLENGTH)
{
    m_bitrate = 1;
    m_bitDelay = BITDELAYBT;

    // Compute Bandpass filter coefficients and
    const double h0 = sqrt(2.0) * Br;
    const double kexp = -twopi * Br * Br;
    for (int i=0; i<bandpassFilter.size(); ++i) {
        double temp = i - (BPLENGTH *1.)/2.+.5; 
        temp /= Ns;
        double hreal = h0 * exp(kexp * temp * temp);
        bandpassFilter[i] = Sample(hreal,0.0);
    }

    // Set Differentiator filter coefficients
    differentiatorFilter[0] = Sample(-0.0062, 0.0);
    differentiatorFilter[1] = Sample(0.0372, 0.0);
    differentiatorFilter[2] = Sample(-0.4566, 0.0);
    differentiatorFilter[3] = Sample(0.4566, 0.0);
    differentiatorFilter[4] = Sample(-0.0372, 0.0);
    differentiatorFilter[5] = Sample(0.0062, 0.0);
}

//virtual
BluetoothReceiver::~BluetoothReceiver() {
}

// receiver: decode received bits.  Ns samples per bit.
Bits
BluetoothReceiver::receive(const Signal& input) {
    // Input length should be a multiple of Ns
    int nBits = input.size()/Ns;
    _ASSERTE((input.size()) % Ns == 0);
    Bits bitsOut(nBits);

    for (int i=0; i<nBits; ++i) {
        slice sl_i(i*Ns, Ns);
        bitsOut[i] = receiveBit(input[sl_i]);
    }

    return bitsOut;
}

void
BluetoothReceiver::reset(){
    bandpassFilter.reset();
    differentiatorFilter.reset();
}

//virtual
int
BluetoothReceiver::delay() const {
    return m_bitDelay;
}



double
BluetoothReceiver::limiterDiscriminator(Sample X,
                                        Sample Y) {
    double denom = X.real()*X.real() + X.imag()*X.imag();
    return (X.real()*Y.imag() - X.imag()*Y.real())/denom;
}

// receiveBit: decode one bit of received data
bool
BluetoothReceiver::receiveBit(const Signal& inputSlice) {
    // Check input: Ns samples per bit
    _ASSERTE(inputSlice.size() == Ns);
    double phase = 0.0; // Integrate over phase difference
    for (int i=0; i<Ns; ++i) {
        Sample bpOut   = bandpassFilter.FilterStep(inputSlice[i]);
        Sample diffOut = differentiatorFilter.FilterStep(bpOut);
        phase += limiterDiscriminator(bpOut, diffOut);
    }

    return (phase < 0.0);
}

