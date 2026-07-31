// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: bluetooth.h
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
#ifndef __bluetooth_h__
#define __bluetooth_h__

#include "basetype.h"


// Br: Bandwidth of Bandpass receiver in MHz
const double Br = 1.1;

// Bluetooth transmitter and receiver classes:

class BluetoothTransmitter : public Transmitter { 
public:
    // Default constructor takes modulation index and phase shift
    // (initial phase value) as parameters
    BluetoothTransmitter(double hf=1./3., double phase_shift=0.0);
    // Copy constructor
    BluetoothTransmitter(BluetoothTransmitter& txbt);
    // Destructor
    virtual ~BluetoothTransmitter();

	virtual void reset();
    // Transmit input bits
    virtual Signal transmit(const Bits& input, double df=0);

private:
    // Modulate using GFSK
    Signal modulate(const Bits& input, double df=0);

    bool m_prev;    // previous bit modulated
    double m_hf;    // modulation index
    // Used in implementation of GFSK modulation scheme
    static const double s_qcoef[2*Ns];// Gaussian filter coefficient
};


class BluetoothReceiver : public Receiver {
public:
	BluetoothReceiver(); 
    virtual ~BluetoothReceiver();

    // Decode input received signal into bits
    virtual Bits receive(const Signal& input);
	virtual void reset();
	virtual int delay() const;

private:
    bool receiveBit(const Signal& inputSlice);
    double limiterDiscriminator(Sample X, Sample Y);
	FIRFilter bandpassFilter;
	FIRFilter differentiatorFilter;
	int m_bitDelay;
};


#endif  //__bluetooth_h__

