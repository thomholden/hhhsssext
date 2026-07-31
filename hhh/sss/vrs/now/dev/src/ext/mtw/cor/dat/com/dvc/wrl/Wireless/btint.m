% BTINT Calculate BER for given scenario
%    Example:
%       >>btint % Uses defaults
%       >>BER=btint -EbNo 0 -d BT -i 802.11 -c 10
%       >>BER=btint('-EbNo','0', '-d', 'BT', '-i', '802.11', '-c', '10');
%
% Note: Arguments are all passed in a string parameters to replicate the
% C++ convention and the C++ applications argument processing code and
% class. This is not necessary with MATLAB code and could be made simpler
% by just passing in regular numerical arguments where appropriate.
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
\\Not required
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

// Compute interference amplitude given the carrier-to-interference ratio in dB
static complex<double> interferenceAmplitude(double CIR_dB);

// Compute the noise power given the carrier-to-noise ratio (Eb/No) in dB
static double noisePower(double EbNo_dB, int nSamples);
%}

function [BER, errors]=btint(varargin)

% C++ Code
%{
// Use Standard C++ Library
// main program:
int main(int argc,          // argument count
         char* argv[]) {    // argument vector
From basetype.h
typedef Transmitter* aTransmitterPtr;
typedef Receiver* aReceiverPtr;
typedef Channel* aChannelPtr;
Not required, use handle classes

using namespace std;

static const char sBLUETOOTH[] = "BT";
static const char sIEEE802_11b[] = "802.11";
enum ProtocolType { Bluetooth=0, IEEE802_11b };
static ProtocolType typeFromName(const char* protocolName);
%}

% Simple chars are used instead of enumerated values
sBLUETOOTH = 'BT';
sIEEE802_11b = '802.11';

%% Parameters: read from command line

% C++ Code
%{
ProgramArgs args(argc, argv);
int packetCount = args.getIntParameter("-c", 1);        // 1 packet is default
int packetLength = args.getIntParameter("-l", 160);     // 160 bits/per packet is default
double hf = args.getDoubleParameter("-m", 1.0/3.0);     // modulation index for desired signal
double hf_i = args.getDoubleParameter("-mi", 1.0/3.0);  // modulation index for interference
double dfreq =args.getDoubleParameter("-f", 4.0);       // Frequency difference in MHz
double CIR_dB = args.getDoubleParameter("-CIR", 100.0);
complex<double> J = interferenceAmplitude(CIR_dB);
double EbNo_dB = args.getDoubleParameter("-EbNo", 300.0);
const char* outfile = args.getParameter("-o", 0);
bool printBERonly = args.findOption("-BER");
const char* desType = args.getParameter("-d", sBLUETOOTH);
const char* ifType = args.getParameter("-i", sIEEE802_11b);
int bitrateDes = args.getIntParameter("-bd", 1);
int bitrateIF = args.getIntParameter("-bi", 1);
ProtocolType desired = typeFromName(desType);
ProtocolType interference = typeFromName(ifType);
%}

% The functional notation of calling methods is used here, but you could use
% dot notation e.g. args.getIntParameter(..., to more closely match the C++
% code.

args=programArgs(nargin,varargin);               % Construct *programArgs* class
packetCount = getIntParameter(args,'-c', 1);     % 1 packet is default
packetLength = getIntParameter(args,'-l', 160);  % 160 bits/per packet is default
hf = getDoubleParameter(args,'-m', 1.0/3.0);     % Modulation index for desired signal
hf_i = getDoubleParameter(args,'-mi', 1.0/3.0);  % Modulation index for interference
dfreq =getDoubleParameter(args,'-f', 4.0);       % Frequency difference in MHz
CIR_dB = getDoubleParameter(args,'-CIR', 100.0);
J = interferenceAmplitude(CIR_dB);
EbNo_dB = getDoubleParameter(args,'-EbNo', 0);
outfile = getParameter(args,'-o', '');
printBERonly = findOption(args,'-BER');
desType = getParameter(args,'-d', sBLUETOOTH);
ifType = getParameter(args,'-i',sIEEE802_11b);
bitrateDes = getIntParameter(args,'-bd', 1);
bitrateIF = getIntParameter(args,'-bi', 1);
desired = typeFromName(desType);
interference = typeFromName(ifType);

%% Write output to file or stdout?

% C++ Code
%{
FILE* fpOut = null;
if (outfile != null) { fpOut = fopen(outfile, "w"); }
if (fpOut == null)    { fpOut = stdout; }
%}

if isempty(outfile)
    fpOut=1;                   % To command line
else
    fpOut=fopen(outfile,'wt'); % To file
end

%% Create System Components

%%
% *1. Desired signal transmitter and receiver*

% C++ Code
%{
aTransmitterPtr txDesiredPtr;
aReceiverPtr rxDesiredPtr;
Not necessary

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
%}

switch desired
    case 0
        txDesiredHdl = BluetoothTransmitter(hf);
        rxDesiredHdl = BluetoothReceiver;
    case 1
        txDesiredHdl = IEEE802_11b_Transmitter(bitrateDes);
        rxDesiredHdl = IEEE802_11b_Receiver(bitrateDes);
    otherwise    % This case should never happen
        error('Error: desired signal transmitter/receiver type not valid.\n');
end

%%
% *2. Interference signal transmitter*

% C++ Code
%{
    aTransmitterPtr txIFPtr;
    Not required

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
%}

switch interference
    case 0
        txIFHdl = BluetoothTransmitter(hf_i); % Construct BluetoothTransmitter
    case 1
        txIFHdl = IEEE802_11b_Transmitter(bitrateIF); % Construct IEEE802_11b_Transmitter
    otherwise    % This case should never happen
        error('Error: interference signal transmitter type not valid.\n');
end

%%
% *3. Channel*
% If 11 Mb/s 802.11 (CCK) is desired signal, then pass NsCCK to
% noise power calculation

% C++ Code
%{
% int ns = (bitrateDes == 11) ? (int)NsCCK : (int)Ns;
% double no = noisePower(EbNo_dB, ns);
% AWGNChannel awgn(no);
%}

if (bitrateDes == 11)
    ns =constants.NsCCK;
else
    ns=constants.Ns;
end
no = noisePower(EbNo_dB, ns);  % Set noise power
awgn=AWGNChannel(no);          % Create AWGN channel

%% Set/modify various parameters

% C++ Code_
%{
int nBitsDes;                       // Number of bits of desired signal to be coded per iteration
int nBitsIF;                        // "               " interference "                         "
int nSamples;                       // Number of samples per iteration (per nBitsDes and nBitsIF)
int ifPacketLength;                 // Length of interference packet; may be
                                    // different if bitrates of desired and interference
                                    // signals are different
int stopAt;                         // Stop this many bits from the end

No declarations no required

if ((bitrateDes == 11) || (bitrateIF == 11)) {
    nBitsDes = (bitrateDes == 11) ? 88 : 8;
    nBitsIF = (bitrateIF == 11) ? 88 : 8;
    stopAt = (bitrateDes == 11) ? 8 : 4;
    nSamples = Ns*8;
    if (packetLength % nBitsDes > 0) {
        packetLength = (packetLength/nBitsDes + 1)*nBitsDes;
    }
    ifPacketLength = packetLength * txIFPtr->bitrate() /
    txDesiredPtr->bitrate();
%}

if ((bitrateDes == 11) || (bitrateIF == 11))
    % Use if statements for all of these as ? operator does not exist
    if (bitrateDes == 11), nBitsDes =  88; else nBitsDes=8; end
    if (bitrateIF == 11), nBitsIF =  88; else nBitsIF = 8; end
    if (bitrateDes == 11), stopAt= 8; else stopAt= 4; end
    nSamples = constants.Ns*8;
    if mod(packetLength,nBitsDes) > 0
        packetLength = (floor(packetLength/nBitsDes) + 1)*nBitsDes;
    end
    % Using direct public property acces instead of calling method with C++
    ifPacketLength = packetLength * txIFHdl.m_bitrate/txDesiredHdl.m_bitrate;

    % C++ Code
    %{
    % } else {
    %     nBitsDes = nBitsIF = 1;
    %     nSamples = Ns;
    %     stopAt = 4;
    %     ifPacketLength = packetLength;
    % }
    %}

else
    [nBitsDes,nBitsIF] = deal(1);
    nSamples = constants.Ns;
    stopAt = 4;
    ifPacketLength = packetLength;
end

% C++ Code
%{
% int sysDelay = rxDesiredPtr->delay();
%}
% Call delay method directly as it is a handle class
sysDelay = rxDesiredHdl.m_bitDelay;

%% Write out system parameters

% C++ Code
%{
if (!printBERonly) {
    fprintf(fpOut, "Desired signal transmitter/receiver: %s.\n", desType);
    fprintf(fpOut, "Interference transmitter: %s.\n", ifType);
    fprintf(fpOut, "Number of packets = %d.\n", packetCount);
    fprintf(fpOut, "Packet length = %d.\n", packetLength);
    fprintf(fpOut, "Frequency offset (MHz)= %3.0f\n",dfreq);
    fprintf(fpOut, "Carrier-to-interference ratio (dB) = %g.\n", CIR_dB);
    fprintf(fpOut, "Carrier-to-noise ratio (dB) = %g.\n", EbNo_dB);
}
%}

if ~printBERonly
    fprintf(fpOut,'Desired signal transmitter/receiver: %s.\n', desType);
    fprintf(fpOut,'Interference transmitter: %s.\n', ifType);
    fprintf(fpOut,'Number of packets = %d.\n', packetCount);
    fprintf(fpOut,'Packet length = %d.\n', packetLength);
    fprintf(fpOut,'Frequency offset (MHz)= %3.0f\n',dfreq);
    fprintf(fpOut,'Carrier-to-interference ratio (dB) = %g.\n', CIR_dB);
    fprintf(fpOut,'Carrier-to-noise ratio (dB) = %g.\n', EbNo_dB);
end

%% Main loop

% C++ Code
%{
int errors = 0;         // Total number of bit errors
int bitsCompared = 0;
RandomBit rbg;          // Random bit generator:
%}
errors = 0;     % Total number of bit errors (data type not required)
bitsCompared = 0;
rbg=RandomBit;  % Random bit generator (data type not required)

for ii=1:packetCount

    % C++ Code
    %{
    for (int i=0; i<packetCount; ++i) {
    Bits pktDesired = rbg.nextNBits(packetLength);
    Bits pktIF = rbg.nextNBits(ifPacketLength);
    %}
    pktDesired = nextNBits(rbg,packetLength); % or rbg.nextNBits(packetLength);
    pktIF = nextNBits(rbg,ifPacketLength); % or rbg.nextNBits(ifPacketLength);

    % C++ Code
    %{
    % // At beginning of each packet, reset phase for desired signal to zero
    % // set a random phase difference and time delay for interference signal
    % txDesiredPtr->reset();
    % txIFPtr->reset();
    % double delPhase = Random::drand();
    % txIFPtr->reset();
    % txIFPtr->setPhase(delPhase);
    % rxDesiredPtr->reset();
    % int Td = 0;
    % if (bitrateDes == bitrateIF) {
    %    Td = Random::irand(nSamples);
    %  }
    %  Signal sigIF(nSamples+Td);
    %}

    reset(txDesiredHdl); % or txDesiredHdl.reset()
    reset(txIFHdl); % or txIFHdl.reset();
    delPhase = random.drand(); % Static method call
    txIFHdl.reset(); % Uncecessary
    txIFHdl.m_phase=delPhase; % direct property access
    reset(rxDesiredHdl); % or rxDesiredHdl.reset();
    Td = 0;
    if bitrateDes == bitrateIF
        Td = random.irand(nSamples); % Static method call
    end
    sigIF=zeros(nSamples+Td,1);

    % C++ Code
    %{
    for (int j=0,k=0; j<packetLength; j += nBitsDes, k+= nBitsIF) {
    %}
    k=0;    % Second loop iterator

    for jj=0:nBitsDes:packetLength-1
        % C++ Code
        %{
        // Delay interference signal by Td samples
        sigIF.set(J * txIFPtr->transmit(pktIF[slice(k,nBitsIF)],dfreq),Td,Td+nSamples-1);

        // Transmit desired signal
        Signal sigDesired = txDesiredPtr->transmit(pktDesired[slice(j,nBitsDes)],0);

        // Compute channel output
        Signal sigOut = awgn.process(sigDesired,sigIF[slice(0,nSamples)]);
        %}

        % Delay interference signal by Td samples
        sigIF(Td+1:Td+nSamples-1+1)= J * transmit(txIFHdl,pktIF(k+(0:nBitsIF-1)+1),dfreq);

        % Transmit desired signal
        sigDesired = transmit(txDesiredHdl,pktDesired(jj+(0:nBitsDes-1)+1),0);

        % Compute channel output
        sigOut =  process(awgn, sigDesired,sigIF((0:nSamples-1)+1));

        % C++ Code
        %{
        //Decode channel output into received bits
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
        Decode channel output into received bits
        %}
        rxBits = receive(rxDesiredHdl,sigOut);
        if (jj >= sysDelay) && (jj<(packetLength-stopAt))
            errors = errors+bitErrors(rxBits, pktDesired(jj-sysDelay+(0:nBitsDes-1)+1));
            bitsCompared = bitsCompared+nBitsDes;
        elseif (jj == 0) && (bitrateDes == 11)
            % The first two bits transmitted are subject to transient effects
            % of the transmitter
            errors = errors+bitErrors(rxBits(10+(0:nBitsDes-10-1)+1), pktDesired(2+(0:nBitsDes-10-1)+1));
            bitsCompared = bitsCompared+nBitsDes-10;
        end

        % C++ Code
        %{
        if (Td > 0) {
           sigIF = sigIF.shift(Td);
        }
        %}
        if Td > 0
            sigIF = circshift(sigIF,-Td); % Use built-in circshift function
        end

        k=k+nBitsIF; % Part of for loop. C++ loop has two iterators

    end
end

%% Report results
% C++ Code
%{
double BER = double(errors)/double(bitsCompared);

if (printBERonly) {
    fprintf(fpOut, "%4.2e", BER);
} else {
    fprintf(fpOut, "Number of bit errors = %d.\n", errors);
    fprintf(fpOut, "BER = %4.2e.\n", BER);
}
%}
BER = errors/bitsCompared;
if printBERonly
    fprintf(fpOut,'%4.2e', BER);
else
    fprintf(fpOut,'Number of bit errors = %d.\n', errors);
    fprintf(fpOut,'BER = %4.2e.\n', BER);
end

%% Clean up and return
% C++ Code
%{
delete txDesiredPtr;
delete txIFPtr;
delete rxDesiredPtr;
    return 1;
}
(Not required, memory managed automatically in MATLAB.)
%}
if fpOut~=1;
    fclose(fpOut); % Close file missing from C++ Code
end

% Equivalent of C++ static functions

function errors=bitErrors(ba1, ba2)
% C++ Code
%{
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
%}
assert(length(ba1)==length(ba2));
diff=abs(ba1-ba2);
errors=sum(diff);

function out=noisePower(EbNo_dB,nSamples)
% C++ Code
%{
// Compute the noise power given the carrier-to-noise ratio (Eb/No) in dB
static
double
noisePower(double EbNo_dB, int nSamples) {
    return 0.5 * nSamples * pow(10.0, -0.1*EbNo_dB);
}
%}
out= 0.5 * nSamples * power(10.0, -0.1*EbNo_dB);

% C++ Code
%{
\\Not used
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
%}

function J=interferenceAmplitude(CIR_dB)
% C++ Code
%{
// Compute interference amplitude given the carrier-to-interference ratio
// in dB
static
complex<double>
interferenceAmplitude(double CIR_dB) {
    double badJ = sqrt(pow(10.0, -0.1*CIR_dB));
    complex<double> J(badJ, 0.0);
    return J;
}
%}
J = complex(sqrt(power(10.0, -0.1*CIR_dB)),0); % Default MATLAB variables can be complex

function ProtocolType=typeFromName(protocolName)
% C++ Code
%{
% enum ProtocolType { Bluetooth=0, IEEE802_11b };
% static ProtocolType typeFromName(const char* protocolName);
%}
switch protocolName
    case 'BT'
        ProtocolType=0;
    case '802.11'
        ProtocolType=1;
    otherwise
        error('Not supported');
end