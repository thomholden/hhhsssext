// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.

// File: main.cpp
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

#include <configure.h>

#if MODE==1 
#include "engine.h"
#endif

#include <math.h>
#include <stdio.h>
#include "stdcpp.h"
#include <string.h>

// include files from project
#include "basetype.h"
#include "random.h"
#include "bluetooth.h"
#include "ieee802.11b.h"
#include "awgnchan.h"
#include "util.h"
#include "programargs.h"

// Helper functions used in main()
// compute bit errors between two bit-arrays
static int bitErrors(const Bits& ba1,const Bits& ba2);
// Compute interference amplitude given the carrier-to-interference ratio
// in dB
static complex<double> interferenceAmplitude(double CIR_dB);
// Compute the noise power given the carrier-to-noise ratio (Eb/No) in dB
static double noisePower(double EbNo_dB, int nSamples);

// Use Standard C++ Library
using namespace std;

static const char sBLUETOOTH[] = "BT";
static const char sIEEE802_11b[] = "802.11";
enum ProtocolType { Bluetooth=0, IEEE802_11b };
static ProtocolType typeFromName(const char* protocolName);

// main program:
int main(int argc,          // argument count
         char* argv[]) {    // argument vector

    //*************************************
    //** Parameters: read from command line
    //*************************************
    ProgramArgs args(argc, argv);
    int packetCount = args.getIntParameter("-c", 1);    // 1 packet is default
    int packetLength = args.getIntParameter("-l", 160); // 160 bits/per packet is default
    double hf = args.getDoubleParameter("-m", 1.0/3.0);     // modulation index for desired signal
    double hf_i = args.getDoubleParameter("-mi", 1.0/3.0);  // modulation index for interference
    double dfreq =args.getDoubleParameter("-f", 4.0);     // Frequency difference in MHz
    double CIR_dB = args.getDoubleParameter("-CIR", 100.0);
    complex<double> J = interferenceAmplitude(CIR_dB);
    double EbNo_dB = args.getDoubleParameter("-EbNo", 0.0);
    const char* outfile = args.getParameter("-o", 0);
    bool printBERonly = args.findOption("-BER");
    const char* desType = args.getParameter("-d", sBLUETOOTH);
    const char* ifType = args.getParameter("-i", sIEEE802_11b);
    int bitrateDes = args.getIntParameter("-bd", 1);
    int bitrateIF = args.getIntParameter("-bi", 1);
    ProtocolType desired = typeFromName(desType);
    ProtocolType interference = typeFromName(ifType);
    
    // Write output to file or stdout?
    FILE* fpOut = null;
    if (outfile != null) { fpOut = fopen(outfile, "w"); }
    if (fpOut == null)    { fpOut = stdout; }


    //****************************
    //** Create system components:
    //****************************
    // 1. Desired signal transmitter and receiver
    aTransmitterPtr txDesiredPtr;
    aReceiverPtr rxDesiredPtr;
    switch (desired) {
    case Bluetooth:
        txDesiredPtr = new BluetoothTransmitter(hf);
        rxDesiredPtr = new BluetoothReceiver;
        break;
    case IEEE802_11b:
        txDesiredPtr = new IEEE802_11b_Transmitter(bitrateDes);
        rxDesiredPtr = new IEEE802_11b_Receiver(bitrateDes);
        break;
    default:    // This case should never happen
        fprintf(fpOut, "Error: desired signal transmitter/receiver type not valid.\n");
        return -1;
        break;
    }

    // 2. Interference signal transmitter
    aTransmitterPtr txIFPtr;
    switch (interference) {
    case Bluetooth:
        txIFPtr = new BluetoothTransmitter(hf_i);
        break;
    case IEEE802_11b:
        txIFPtr = new IEEE802_11b_Transmitter(bitrateIF);
        break;
    default:    // This case should never happen
        fprintf(fpOut, "Error: interference signal transmitter type not valid.\n");
        return -1;
        break;
    }

    // 3. Channel
    // If 11 Mb/s 802.11 (CCK) is desired signal, then pass NsCCK to
    // noise power calculation
    int ns = (bitrateDes == 11) ? (int)NsCCK : (int)Ns;
    double no = noisePower(EbNo_dB, ns);
    AWGNChannel awgn(no);

    // Set/modify various parameters
    int nBitsDes;                       // Number of bits of desired signal to be coded per iteration
    int nBitsIF;                        // "               " interference "                         "
    int nSamples;                       // Number of samples per iteration (per nBitsDes and nBitsIF)
    int ifPacketLength;                 // Length of interference packet; may be
                                        // different if bitrates of desired and interference
                                        // signals are different
    int stopAt;                         // Stop this many bits from the end
    if ((bitrateDes == 11) || (bitrateIF == 11)) {
        nBitsDes = (bitrateDes == 11) ? 88 : 8;
        nBitsIF = (bitrateIF == 11) ? 88 : 8;
        stopAt = (bitrateDes == 11) ? 8 : 4;
        nSamples = Ns*8;
        if (packetLength % nBitsDes > 0) {
            packetLength = (packetLength/nBitsDes + 1)*nBitsDes;
        }
        ifPacketLength = packetLength * txIFPtr->bitrate() / txDesiredPtr->bitrate();
    } else {
        nBitsDes = nBitsIF = 1;
        nSamples = Ns;
        stopAt = 4;
        ifPacketLength = packetLength;
    }
    int sysDelay = rxDesiredPtr->delay();

    //******************************
    //** Write out system parameters
    //******************************
    if (!printBERonly) {
        fprintf(fpOut, "Desired signal transmitter/receiver: %s.\n", desType);
        fprintf(fpOut, "Interference transmitter: %s.\n", ifType);

        fprintf(fpOut, "Number of packets = %d.\n", packetCount);
        fprintf(fpOut, "Packet length = %d.\n", packetLength);
        fprintf(fpOut, "Frequency offset (MHz)= %3.0f\n",dfreq);
        fprintf(fpOut, "Carrier-to-interference ratio (dB) = %g.\n", CIR_dB);
        fprintf(fpOut, "Carrier-to-noise ratio (dB) = %g.\n", EbNo_dB);
    }
	
    //******************************
    //** Main loop:
    //******************************

    int errors = 0; // Total number of bit errors
    int bitsCompared = 0;
    RandomBit rbg;  // Random bit generator:
    
    for (int i=0; i<packetCount; ++i) {	
        Bits pktDesired = rbg.nextNBits(packetLength);
        Bits pktIF = rbg.nextNBits(ifPacketLength);

        // At beginning of each packet, reset phase for desired signal to zero
        // set a random phase difference and time delay for interference signal
        txDesiredPtr->reset();
        txIFPtr->reset();
        double delPhase = Random::drand();
        txIFPtr->reset();
        txIFPtr->setPhase(delPhase);
        rxDesiredPtr->reset();
        int Td = 0;
        if (bitrateDes == bitrateIF) {
            Td = Random::irand(nSamples);
        }
        Signal sigIF(nSamples+Td);

        for (int j=0,k=0; j<packetLength; j += nBitsDes, k+= nBitsIF) {
            // Delay interference signal by Td samples
            //sigIF[slice(Td,nSamples,1)] = J * txIFPtr->transmit(pktIF[slice(k,nBitsIF,1)],dfreq);
            sigIF.set(J * txIFPtr->transmit(pktIF[slice(k,nBitsIF)],dfreq),Td,Td+nSamples-1);
            
			// Transmit desired signal
			// Debug here
            Signal sigDesired = txDesiredPtr->transmit(pktDesired[slice(j,nBitsDes)],0);
            // Compute channel output
		
            Signal sigOut = awgn.process(sigDesired,sigIF[slice(0,nSamples)]);			

            // Decode channel output into received bits
            Bits rxBits = rxDesiredPtr->receive(sigOut);
            if ((j >= sysDelay) && (j<(packetLength-stopAt))) {
                errors += bitErrors(rxBits, pktDesired[slice(j-sysDelay,nBitsDes)]);
                bitsCompared += nBitsDes;
            } else if ((j == 0) && (bitrateDes == 11)) {
                // The first two bits transmitted are subject to transient effects
                // of the transmitter
                errors += bitErrors(rxBits[slice(10,nBitsDes-10)], pktDesired[slice(2,nBitsDes-10)]);
                bitsCompared += nBitsDes-10;
            }
            if (Td > 0) {
                sigIF = sigIF.shift(Td);
            }
        } //for j
    } // for i

    //******************************
    //** Report results:
    //******************************
    double BER = double(errors)/double(bitsCompared);

    if (printBERonly) {
        fprintf(fpOut, "%4.2e", BER);
    } else {
        fprintf(fpOut, "Number of bit errors = %d.\n", errors);
        fprintf(fpOut, "BER = %4.2e.\n", BER);
    }


    //******************************
    //** clean up and return
    //******************************
    delete txDesiredPtr;
    delete txIFPtr;
    delete rxDesiredPtr;

    return 1;
}


// compute bit errors between two bit-arrays
int
bitErrors( const Bits& ba1,
           const Bits& ba2) {
    _ASSERTE(ba1.size() == ba2.size());

    int errors = 0;
    for (int i=0; i<(int)ba1.size(); ++i) {
        if (ba1[i] ^ ba2[i]) { ++errors; }
    }

    return errors;
}

// Compute interference amplitude given the carrier-to-interference ratio
// in dB
static
complex<double>
interferenceAmplitude(double CIR_dB) {
    double badJ = sqrt(pow(10.0, -0.1*CIR_dB));
    complex<double> J(badJ, 0.0);
    return J;
}

// Compute the noise power given the carrier-to-noise ratio (Eb/No) in dB
static
double
noisePower(double EbNo_dB, int nSamples) {
	                       // Bug here v
    return 0.5 * nSamples * pow(10.0, -0.1*EbNo_dB); 
}

static
ProtocolType
typeFromName(const char* protocolName) {
    if (strcmp(protocolName,sIEEE802_11b) == 0) {
        return IEEE802_11b;
    } else if (strcmp(protocolName,sBLUETOOTH) == 0) {
        return Bluetooth;
    } else {
        _ASSERTE(false);
        fprintf(stderr,"Error: %s is not a valid protocol name!.\n",
            protocolName);
        fprintf(stderr,"Using Bluetooth protocol instead.\n");
        return Bluetooth;
    }
}

