// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.

// File: ieee802.11b.cpp
// Last modified: 8 June 2001
// Author(s):
//   Amir Soltanian
//   T. A. Hall
//   Wireless Communications Technologies Group
//   National Institute of Standards and Technology
//   100 Bureau Drive, STOP 8920
//   Gaithersburg, MD 20899-8920
//   {amirs,timhall}@nist.gov

#include <configure.h>

#if MODE==2 //Test
#include "engine.h"
#endif

#include <math.h>
#include "ieee802.11b.h"
#include "util.h"

static bool a[11] = {1,0,1,1,0,1,1,1,0,0,0};

//static
const Bits IEEE802_11b_Transmitter::m_chip = Bits(a,11);		

static inline double dsign(bool bval) { return ((bval) ? -1.0 : 1.0); }
static void setRSRCpulseShapingFilter(FIRFilter& rsrc, double rollOff);


IEEE802_11b_Transmitter::IEEE802_11b_Transmitter(int bitrate, 
                                                 double phase_shift)
: m_H(RSLENGTH),
  m_diffEncMem(false),  //diff encoder memory = 0
  m_codeTable(8*256)
{
    m_bitrate = bitrate;
    setPhase(phase_shift);
    setRollOff(1.0);
    m_freqTrack = 0;

    initCodeTable();
}


//virtual
IEEE802_11b_Transmitter::~IEEE802_11b_Transmitter() {
}

//virtual
void
IEEE802_11b_Transmitter::reset() {
    setPhase(0.0);
    m_H.reset();
    m_freqTrack = 0;
    m_diffEncMem = false;
}

Bits
IEEE802_11b_Transmitter::diffEncode(const Bits& input) {
    Bits diffOut(input.size());
    for (int j=0;j<input.size();++j) {
        diffOut[j] = m_diffEncMem^input[j];
        m_diffEncMem = diffOut[j];
    }

    return diffOut;
}

Bits
IEEE802_11b_Transmitter::addChips(const Bits& input) {
    Bits spreadOut(input.size()*Ns,false); //initialize to all zero
    _ASSERTE((spreadOut.size() % Ns) == 0);

    for (int i=0;i<input.size();++i){ // spread each bit individually by the Barker code
        for(int j=0; j<11; ++j) { //insert three zero between each chip bit
            spreadOut[i*Ns+4*j]= m_chip[j]^input[i];
        }	
    }

	return spreadOut;
}

Signal
IEEE802_11b_Transmitter:: modulate_1Mb_s(const Bits& input,
                                         double df) {
    Signal modOut(Ns*input.size());
    double nrzBit;
    double phase = getPhase();
    int offset=0;
	
    for (int i=0; i<input.size(); ++i) {
        Bits diffOut=diffEncode(input[slice(i,1)]);
        Bits spread=addChips(diffOut[slice(i,1)]);

        for (int j=0; j<Ns; ++j){
            double tt=df*(j+Ns*m_freqTrack)/((double)Ns);
            if (tt>1) { tt=fmod(tt,1.); }
            tt *= twopi;
            nrzBit=0;
            if ((j%4)==0) { nrzBit=dsign(spread[i*Ns+j]); }
            Sample phaseOut=m_H.FilterStep(Sample(nrzBit,0.0));
            modOut[offset*Ns+j]=exp(Sample(0.0,phase+tt))*phaseOut;
        } // end j
        offset++;
        m_freqTrack++;
    } // end i

    return modOut;
}

Signal
IEEE802_11b_Transmitter:: modulate_11Mb_s(const Bits& input) {
    _ASSERTE(input.size() == codeLength);

    int nSamples = NsCCK*codeLength;
    Signal codeZero(nSamples, Sample(0.0,0.0));
    Signal modOut(NsCCK*codeLength);
    Signal codeRead(codeLength);

    unsigned Buf8 = 0;

    int j;
    for (j=codeLength-1; j>=0; --j) {
        Buf8 *= 2;
        Buf8 += input[j];
    }

    // generate 8 output phase samples for the 8 bits
    int offset=codeLength*Buf8;
    for (j=0; j<codeLength; ++j) { codeRead[j] = m_codeTable[offset+j]; }

    for (j=0; j<nSamples; j += NsCCK) {
        codeZero[j] = codeRead[j/NsCCK];
    }
    for (j=0; j<nSamples; ++j) {
        Sample out = m_H.FilterStep(codeZero[j]);
        modOut[j] = out;
    }

    return modOut;
}

//virtual
Signal
IEEE802_11b_Transmitter:: transmit(const Bits& input,
                                   double df) {
    switch (m_bitrate) {
    case 1:
        return modulate_1Mb_s(input, df); break;
    case 11: {
        const int nSamples=codeLength*NsCCK;
        _ASSERTE((input.size() % codeLength) == 0);
        Signal modOut(NsCCK*input.size());
        int begin = 0;
        int end = nSamples-1;
        for (int i=0; i<input.size(); i += codeLength) {
            Bits inputSlice = input[slice(i,codeLength)];
            modOut.set(modulate_11Mb_s(inputSlice), begin, end);
            begin += nSamples; end += nSamples;
        }
        return modOut; break;
    }
    default:
        _ASSERTE(false);
        fprintf(stderr,"Error: %d is not a valid bitrate.\n", m_bitrate);
        Signal empty;
        return empty;
        break;
    }
}

//virtual
int
IEEE802_11b_Transmitter::minInputLength() const {
    switch (m_bitrate) {
    case 1:
        return 1; break;
    case 11:
        return codeLength; break;
    default:
        _ASSERTE(false);
        fprintf(stderr,"Error: %d is not a valid bitrate.\n", m_bitrate);
        return 0;
        break;
    }
}

void
IEEE802_11b_Transmitter::setRollOff(double rollOff) {
    m_rollOff = rollOff;
    setRSRCpulseShapingFilter(m_H, rollOff);
}

double
IEEE802_11b_Transmitter::getRollOff() const {
    return m_rollOff;
}

void
IEEE802_11b_Transmitter::initCodeTable() {
    double phase[4] = { 0.0, PI, PI/2.0, 1.5*PI };
    double ph[4];

    for (int i=0; i<256; ++i) {
        // QPSK phase
        ph[0] = phase[i & 0x03];
        ph[1] = phase[(i>>2) & 0x03];
        ph[2] = phase[(i>>4) & 0x03];
        ph[3] = phase[(i>>6) & 0x03];

        // CCK phase output
        m_codeTable[codeLength*i+0] =  exp(Sample(0.0,ph[0]+ph[1]+ph[2]+ph[3]));
        m_codeTable[codeLength*i+1] =  exp(Sample(0.0,ph[0]+ph[2]+ph[3]));
        m_codeTable[codeLength*i+2] =  exp(Sample(0.0,ph[0]+ph[1]+ph[3]));
        m_codeTable[codeLength*i+3] = -exp(Sample(0.0,ph[0]+ph[3]));
        m_codeTable[codeLength*i+4] =  exp(Sample(0.0,ph[0]+ph[1]+ph[2]));
        m_codeTable[codeLength*i+5] =  exp(Sample(0.0,ph[0]+ph[2]));
        m_codeTable[codeLength*i+6] = -exp(Sample(0.0,ph[0]+ph[1]));
        m_codeTable[codeLength*i+7] =  exp(Sample(0.0,ph[0]));
   }
}



/*******************************************************************************/	
/*******************************************************************************/
//static
const double IEEE802_11b_Receiver::m_nchip[] = {1,-1,1,1,-1,1,1,1,-1,-1,-1};

IEEE802_11b_Receiver::IEEE802_11b_Receiver(int bitrate)
: m_H(RSLENGTH),
  m_delay(30),
  m_diffDecMem(-44.,-44.),
  m_receiverBuffer(2*Ns)
{
    // All bitrates:
    m_bitrate = bitrate;
    _ASSERTE((m_bitrate == 1) || (m_bitrate == 11));
    setRollOff(1.0);

    // 1 Mb/s only
    m_receiveFlag = false;
}

//virtual
IEEE802_11b_Receiver::~IEEE802_11b_Receiver() {
}

void
IEEE802_11b_Receiver::reset() {
	m_H.reset();

    // These need to be reset for 1Mb/s case only
    if (m_bitrate == 1) {
        m_diffDecMem=Sample (-44.0,-44.0);
        m_receiveFlag = false;
        for (int i=0; i<m_receiverBuffer.size(); ++i) {
            m_receiverBuffer[i]=Sample(0,0);
        }
    }
}

//virtual
int
IEEE802_11b_Receiver::delay() const {
    switch (m_bitrate) {
    case 1:
        return 1; break;
    case 11:
        return codeLength; break;
    default:
        _ASSERTE(false);    // Should not occur
        return 0; break;
    }
}

// IEEE802_11b_Receiver::setRollOff() used in all modes
void
IEEE802_11b_Receiver::setRollOff(double rollOff) {
    m_rollOff = rollOff;
    setRSRCpulseShapingFilter(m_H, rollOff);
}

// IEEE802_11b_Receiver::getRollOff() used in all modes
double
IEEE802_11b_Receiver::getRollOff() const {
    return m_rollOff;
}


//*************************************************//
//** Begin 1 Mb/s receiver only member functions **//
//*************************************************//

// virtual
Bits
IEEE802_11b_Receiver::receive(const Signal& input) {
    switch (m_bitrate) {
    case 1:
        return receive_1Mb_s(input); break;
    case 11:
        return receive_11Mb_s(input); break;
    default:
        _ASSERTE(false);
        Bits empty;
        return empty; break;
    }
}


Bits
IEEE802_11b_Receiver::receive_1Mb_s(const Signal& input) {
    // Input length should be a multiple of Ns
    int nBits = input.size()/Ns;
    int delay=m_delay;
    _ASSERTE((input.size()) % Ns == 0);

    Bits bitsOut(nBits,false);
    Signal inputSlice=input[slice(0,Ns)];
    Signal sBpOut(Ns);

    int i, j;   // loop index variables
    if (nBits == 1) {
        if (!m_receiveFlag) {		
            for (i=0; i<Ns; ++i) {
                sBpOut[i] = m_H.FilterStep(inputSlice[i]);
            }
            for (i=0; i<Ns-delay; ++i) {
                m_receiverBuffer[i] = sBpOut[i+delay];
            }
            m_receiveFlag=true;
        } else {
            for (i=0; i<nBits; ++i) {
                inputSlice = input[slice(i*Ns, Ns)];
                for (j=0; j<Ns; ++j) {
                    sBpOut[j] = m_H.FilterStep(inputSlice[j]);
                }
                for (j=0; j<Ns; ++j) {
                    m_receiverBuffer[j+Ns-delay] = sBpOut[j];
                }
                bitsOut[i] = receiveBit(m_receiverBuffer[slice(0,Ns)]);
                for (j=0; j<Ns-delay; ++j) {
                    m_receiverBuffer[j] = m_receiverBuffer[j+Ns];
                }
            } // for i
        } //else
    } else if (nBits > 1) {
        for ( i=0; i<Ns; ++i) {
            sBpOut[i]  = m_H.FilterStep(inputSlice[i]);
        }
        for (i=0; i<(Ns-delay); ++i) {
            m_receiverBuffer[i] = sBpOut[i+delay];
        }
        for (i=1; i<nBits; ++i) {
            inputSlice= input[slice(i*Ns, Ns)];
            for (j=0; j<Ns; ++j) {
                sBpOut[j] = m_H.FilterStep(inputSlice[j]);
            }
            for (j=0; j<Ns; ++j) {
                m_receiverBuffer[j+Ns-delay] = sBpOut[j];
            }
            bitsOut[i-1] = receiveBit(m_receiverBuffer[slice(0,Ns)]);	
            for (j=0; j<(Ns-delay); ++j) {
                m_receiverBuffer[j] = m_receiverBuffer[j+Ns];
            }
        } //for
    } //else if

    return bitsOut;
}

Sample
IEEE802_11b_Receiver::despreader(const Signal& X) {
    Sample phaseOut(0.,0.);
    for(int i=0; i<X.size(); ++i) {
        phaseOut += X[i]*Sample(m_nchip[i/4],0);
    }
    return phaseOut;
}

bool
IEEE802_11b_Receiver::diffDecoder(const Sample& X) {
    double phaseOut = m_diffDecMem.real()*X.real() + m_diffDecMem.imag()*X.imag();
    m_diffDecMem = X;
    return (phaseOut<0.0);
}

bool
IEEE802_11b_Receiver::receiveBit(const Signal& inputSlice) {
    // Check input:
    _ASSERTE(inputSlice.size() == Ns);
    Sample desOut = despreader(inputSlice);
    return diffDecoder(desOut);
}

//***********************************************//
//** End 1 Mb/s receiver only member functions **//
//***********************************************//



//**************************************************//
//** Begin 11 Mb/s receiver only member functions **//
//**************************************************//

Bits
IEEE802_11b_Receiver::receive_11Mb_s(const Signal& input) {
    const int codeSample = codeLength * NsCCK;
    // Input length should be a multiple of Nscck*codLength*11
    _ASSERTE((input.size()) % codeSample == 0);

    int nBits  = input.size()/NsCCK;
    Bits bitsOut(nBits);
    for(int i=0; i<input.size(); i+=codeSample) {
        Signal inputSlice=input[slice(i,codeSample)];
        //bitsOut[slice(i/NsCCK,codeLength,1)]=receiveCode(inputSlice);
        int begin = i/NsCCK;
        bitsOut.set(receiveCode(inputSlice), begin,begin+codeLength-1);
    }
    return bitsOut;
}


static inline
Sample
conjugate(const Sample& in) {
    return Sample(in.real(), -in.imag());
}

Bits
IEEE802_11b_Receiver::receiveCode(const Signal& inputSlice) {
    const int codeSample = codeLength * NsCCK;

    // Check input:
    _ASSERTE((inputSlice.size()) == codeSample );

    Bits   outBits(codeLength);
    Signal sampleBpOut(codeLength);
    Signal conjSampleBpOut(codeLength);
    Signal BpOut(codeSample);
    double ph[4];
    int d[4];

    int i;  // loop index
    for (i = 0; i < codeSample; i++) {
        BpOut[i] = m_H.FilterStep(inputSlice[i]);
    } //for i
    for (i = 0; i < codeLength; i++){
        sampleBpOut[i] = BpOut[i*NsCCK];
        conjSampleBpOut[i] = conjugate(sampleBpOut[i]);
    } //for i

    conjSampleBpOut[3] = -conjSampleBpOut[3];
    conjSampleBpOut[6] = -conjSampleBpOut[6];
    sampleBpOut[3] = -sampleBpOut[3];
    sampleBpOut[6] = -sampleBpOut[6];

    // calculate the received phases
    Sample out2=sampleBpOut[0]*conjSampleBpOut[1] +
                sampleBpOut[2]*conjSampleBpOut[3] +
                sampleBpOut[4]*conjSampleBpOut[5] +
                sampleBpOut[6]*conjSampleBpOut[7];

    Sample out3=sampleBpOut[0]*conjSampleBpOut[2] +
                sampleBpOut[1]*conjSampleBpOut[3] +
                sampleBpOut[4]*conjSampleBpOut[6] +
                sampleBpOut[5]*conjSampleBpOut[7];
	
    Sample out4=sampleBpOut[0]*conjSampleBpOut[4] +
                sampleBpOut[1]*conjSampleBpOut[5] +
                sampleBpOut[2]*conjSampleBpOut[6] +
                sampleBpOut[3]*conjSampleBpOut[7];

    double ph2=atan2(out2.imag(),out2.real());
    double ph3=atan2(out3.imag(),out3.real());
    double ph4=atan2(out4.imag(),out4.real());

    Sample out1=sampleBpOut[3]*exp (Sample(0.0,-ph4))+
                sampleBpOut[5]*exp (Sample(0.0,-ph3))+
                sampleBpOut[6]*exp (Sample(0.0,-ph2))+
                sampleBpOut[7];
    double ph1=atan2(out1.imag(),out1.real());
    ph[0]=ph1;
    ph[1]=ph2;
    ph[2]=ph3;
    ph[3]=ph4;
    //decod bits
    for (i=0; i<4; i++) {
        // Put ph in [0, 2*pi]
        if(ph[i]<0) { ph[i]+=2*PI; }

        if((0<=ph[i]) && (ph[i]<PI/4))                  { d[i]=0; }
        else if((7*PI/4<=ph[i]) && (ph[i]<2*PI))        { d[i]=0; }
        else if((PI/4<=ph[i]) && (ph[i]<3*PI/4))        { d[i]=2; }
        else if((3*PI/4<=ph[i]) && (ph[i]<5*PI/4))      { d[i]=1; }
        else /*if((5*PI/4<=ph[i]) && (ph[i]<7*PI/4))*/  { d[i]=3; }

        outBits[2*i]=(d[i]&0x1);
        outBits[2*i+1]=((d[i]>>1)&0x1);
    }

    return (outBits);
}

//************************************************//
//** End 11 Mb/s receiver only member functions **//
//************************************************//

//** Used to set filter coefficients for RSRC pulse-shaping **//
//** filter in 11 Mb/s transmitter and receiver             **//
static
void
setRSRCpulseShapingFilter(FIRFilter& rsrc,
                          double rollOff) {
    double a = rollOff; // raised cosine filter roll-off factor
    double hr = 0.0;    // real-valued raised cosine filter coefficient
    double mid = ((double)rsrc.size()-1.0)/2.0;
    static const double sqrt2 = sqrt(2.0);
    for (int i = 0; i < rsrc.size(); i++) {
        double temp = 11.0*((double)i - mid)/Ns;
        double at = a*temp;
        double pt = PI*temp;
        if ((temp != 0.0) && ((1.0-16.0*at*at) != 0.0)) {
	         hr = (sin((1.0-a)*pt) + 4.0*at*cos((1.0+a)*pt))/(pt * (1.0-16.0*at*at));
        } else if (temp == 0.0) {
	         hr = 1-a+4*a/PI;
        } else { //if((1-16*temp*temp*a*a) == 0.0)
	         hr = (a/sqrt2)*((1+2.0/PI)*sin(PI/(4*a))+(1-2.0/PI)*cos(PI/(4*a)));
        }
        rsrc[i] = Sample(hr,0.0);
    }
}

