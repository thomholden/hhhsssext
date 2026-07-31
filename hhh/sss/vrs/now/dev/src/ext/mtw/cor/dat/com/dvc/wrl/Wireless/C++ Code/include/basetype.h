// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: basetype.h
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
#ifndef __basetype_h__
#define __basetype_h__

#include "datatype.h"


// Constants used:
// ---------------
// Ns: Number of samples per bit
// BPLENGTH: Length of Bandpass filter for the Bluetooth RX
// DIFFLENGTH: Length of differentiator filter for the Bluetooth Rx
// RSLENGTH: Lenght of the BPF for the 802.11 RX
// DLY: TX,RX delay for 802
enum { Ns=44, BPLENGTH=3*Ns-1, DIFFLENGTH=6, DLYBT=2*Ns, BITDELAYBT=2 };
enum { RSLENGTH=33, RBUF=2*Ns, DLY802=30, BITDELAY802=1};


// Abstract base classes for the three network component models:
// ...Transmitter
// ...Receiver
// .. Channel
class Transmitter {
public:
    Transmitter();
    virtual ~Transmitter() { }

    virtual Signal transmit(const Bits& input, double df) = 0; // This pure virtual function gets an
	// stream of random bits and generates an array of inphase and quadrature samples,
	// This transmitter may be used for the desired signal or the interference and includes different
	// transmission schemes like Bluetooth, 802.11 1 Mb/sec and 11 Mb/sec.
	// df is the difference between the carrier frequency of the desired signal and the interference
	// assuming that the interfernce is transmitted at baseband.
									
	double getPhase() const;		 //get the initial phase of transmission
    void setPhase(double phase);	 // set the initial phase of the transmitter
    // Reset phase to zero, 
	virtual void reset()=0;			// reset the initial phase of transmission
    virtual int minInputLength() const; // minimum input length, in bits

    int bitrate() const;    // Bitrate in Mb/s

protected:
    int m_bitrate;  // Bitrate in Mb/s

private:
	double	m_phase; //initial phase of the tx
};

class Receiver {
public:
    Receiver();
    virtual ~Receiver() { }

    // receive() takes an input signal and returns the decoded bit(s)
	virtual Bits receive(const Signal& samples) = 0;
    // reset the receiver
	virtual void reset() = 0;
    // system delay in bits
	virtual int delay() const = 0;

    int bitrate() const;    // Bitrate in Mb/s

protected:
    int m_bitrate;  // Bitrate in Mb/s
};

class Channel {
public:
    Channel();
    virtual ~Channel() { }

    // process() takes the desired and interference signals and returns the channel output,
    // which is a combination of the input signals and possibly other distortion (i.e., AWGN)
    virtual Signal process(const Signal& desired,
                           const Signal& interference) = 0;
};

// FIR filter class, will be used either in tx or rx.
class FIRFilter {
public:
    FIRFilter(int filterLength);
    virtual ~FIRFilter();
    void reset();

    Sample FilterStep(Sample nextIn); // do the convolution
    void SetCoef(int filterLength, const Filter& filter1);
    int size() const;

    // Access individual filter coefficients
    Sample& operator[](int index);
	Filter GetCoef(); // Added

private: 
    Filter m_fc;	//filter coefficients
    Signal m_sIn;  // Time-reversed signal for convolution
};

//pointer to abstract classes
typedef Transmitter* aTransmitterPtr;
typedef Receiver* aReceiverPtr;
typedef Channel* aChannelPtr;

#endif  //__basetype_h__

