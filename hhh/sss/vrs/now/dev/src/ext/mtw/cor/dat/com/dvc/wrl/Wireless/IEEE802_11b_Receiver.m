% IEEE802_11b_Receiver Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <configure.h>
#include <math.h>
#include "ieee802.11b.h"
#include "util.h"
%}

classdef IEEE802_11b_Receiver < Receiver
    % C++ Code
    %{
    static bool a[11] = {1,0,1,1,0,1,1,1,0,0,0};
    //static
    const Bits IEEE802_11b_Transmitter::m_chip = Bits(a,11);
    %}

    properties
        % C++ Code
        %{
          //** All bitrates **//
         FIRFilter m_H;                      // RSRC pulse shaping filter
         double m_rollOff;                   // roll-off factor for RSRC pulse-shaping filter
         int m_bitDelay;                     // delay in terms of bit
         const int m_delay;                  // total system delay in terms of number of samples
         //** End all bitrates **//
         Sample m_diffDecMem;                // differential decoder memory
         static const double m_nchip[11];    // PN Barker code at the receiver
         bool m_receiveFlag;					// indicates the recieption of the first bit
         Signal m_receiverBuffer;			// reciver input buffer
        %}
        m_H;                      % RSRC pulse shaping filter
        m_rollOff;                % Roll-off factor for RSRC pulse-shaping filter
        m_bitDelay;               % Delay in terms of bit    Error, not used?
        m_delay;                  % Total system delay in terms of number of samples

        m_diffDecMem;             % Fifferential decoder memory
        m_receiveFlag;	          % Indicates the recieption of the first bit
        m_receiverBuffer;		  % Reciver input buffer

        m_chip= [1,0,1,1,0,1,1,1,0,0,0]'; % Barker code

        % C++ Code
        %{
        static inline double dsign(bool bval) { return ((bval) ? -1.0 : % 1.0); } No used in this class
        static void setRSRCpulseShapingFilter(FIRFilter& rsrc, double rollOff); X already

        //static, implment as property
        const double IEEE802_11b_Receiver::m_nchip[] = {1,-1,1,1,-1,1,1,1,-1,-1,-1};
        %}
        m_nchip= [1,-1,1,1,-1,1,1,1,-1,-1,-1]'; % Barker code bipolar
    end
    methods
        function hObj=IEEE802_11b_Receiver(bitrate)
            % C++ Code
            %{
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
            %}
            hObj.m_H=FIRFilter(constants.RSLENGTH);
            hObj.m_delay=30;
            hObj.m_diffDecMem=-44-j*44;
            hObj.m_receiverBuffer=zeros(2*constants.Ns,1);

            % All bitrates:
            hObj.m_bitrate = bitrate;
            assert((hObj.m_bitrate == 1) || (hObj.m_bitrate == 11));
            hObj.setRollOff(1.0);

            % 1 Mb/s only
            hObj.m_receiveFlag = false;
        end


        % C++ Code
        %{
        //virtual
        IEEE802_11b_Receiver::~IEEE802_11b_Receiver() {
        }
        Not required
        %}

        function reset(hObj)
            % C++ Code
            %{
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
            %}
            reset(hObj.m_H)

            % These need to be reset for 1Mb/s case only
            if hObj.m_bitrate == 1
                hObj.m_diffDecMem=-44 -j*44;
                hObj.m_receiveFlag = false;
                hObj.m_receiverBuffer=zeros(length(hObj.m_receiverBuffer),1);
            end
        end

        % C++ Code
        %{
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
        %}
        function out=get.m_bitDelay(hObj)
            switch hObj.m_bitrate
                case 1
                    out=1;
                case 11
                    out= constants.codeLength;
                otherwise
                    error('');   % Should not occur
                    out=0;
            end
        end
        function setRollOff(hObj,rollOff)
            % C++ Code
            %{
            // IEEE802_11b_Receiver::setRollOff() used in all modes
            void
            IEEE802_11b_Receiver::setRollOff(double rollOff) {
                m_rollOff = rollOff;
                setRSRCpulseShapingFilter(m_H, rollOff);
            }
            %}
            hObj.m_rollOff=rollOff;
            hObj.m_H=setRSRCpulseShapingFilter(hObj.m_H,rollOff);
        end

        % C++ Code
        %{
        // IEEE802_11b_Receiver::getRollOff() used in all modes
        double
        IEEE802_11b_Receiver::getRollOff() const {
            return m_rollOff;
        }
        Not required, public property
        %}

        function out= receive(hObj,input)
            % C++ Code
            %{
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
            %}
            switch hObj.m_bitrate
                case 1
                    out=receive_1Mb_s(hObj,input);
                case 11
                    out=receive_11Mb_s(hObj,input);
                otherwise
                    error('Error: %d is not a valid bitrate.\n', hObj.m_bitrate);
                    out=[];
            end
        end
        function bitsOut=receive_1Mb_s(hObj,input)
            % C++ Code
            %{
            Bits
            IEEE802_11b_Receiver::receive_1Mb_s(const Signal& input) {
                // Input length should be a multiple of Ns
                int nBits = input.size()/Ns;
                int delay=m_delay;
                _ASSERTE((input.size()) % Ns == 0);

                Bits bitsOut(nBits,false);
                Signal inputSlice=input[slice(0,Ns)];
                Signal sBpOut(Ns);
            %}

            % Get constants for use later
            Ns=constants.Ns;
            nBits = length(input)/Ns;
            delay=hObj.m_delay;
            assert(mod(length(input), Ns) == 0);

            bitsOut=zeros(nBits,1);
            inputSlice=input(1+(0:Ns-1));

            % C++ Code
            %{
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
            %}
            if nBits == 1
                if ~hObj.m_receiveFlag

                    % Vectorized
                    sBpOut = FilterStepN(hObj.m_H,inputSlice);
                    hObj.m_receiverBuffer(1:Ns-delay) = sBpOut((1:Ns-delay)+delay);
                    hObj.m_receiveFlag=true;

                    % C++ Code
                    %{
                    %         } else {
                    %             for (i=0; i<nBits; ++i) {
                    %}
                else
                    for ii=0:nBits-1
                        % C++ Code
                        %{
                        inputSlice = input[slice(i*Ns, Ns)];
                        %}
                        inputSlice = input(ii*Ns+(0:Ns-1)+1);

                        % C++ Code
                        %{
                         for (j=0; j<Ns; ++j) {
                          sBpOut[j] = m_H.FilterStep(inputSlice[j]);
                         }
                        %}
                        sBpOut = FilterStepN(hObj.m_H,inputSlice);

                        % C++ Code
                        %{
                         for (j=0; j<Ns; ++j) {
                           m_receiverBuffer[j+Ns-delay] = sBpOut[j];
                          }
                        %}
                        hObj.m_receiverBuffer(Ns-delay +(0:Ns-1)+1) = sBpOut;

                        % C++ Code
                        %{
                        bitsOut[i] = receiveBit(m_receiverBuffer[slice(0,Ns)]);
                        for (j=0; j<Ns-delay; ++j) {
                           m_receiverBuffer[j] = m_receiverBuffer[j+Ns];
                        }
                        %}
                        bitsOut(ii+1)= hObj.receiveBit(hObj.m_receiverBuffer((0:Ns-1)+1));
                        hObj.m_receiverBuffer(1:Ns-delay) = hObj.m_receiverBuffer(Ns+1 +(0:Ns-delay-1));
                    end

                end

                % C++ Code
                %{
                    } else if (nBits > 1) {
                        for ( i=0; i<Ns; ++i) {
                            sBpOut[i]  = m_H.FilterStep(inputSlice[i]);
                        }
                        for (i=0; i<(Ns-delay); ++i) {
                            m_receiverBuffer[i] = sBpOut[i+delay];
                        }
                %}
            elseif nBits > 1

                sBpOut = FilterStep(hObj.m_H,inputSlice);
                hObj.m_receiverBuffer= sBpOut((0:Ns-delay-1)+delay+1);

                % C++ Code
                %{
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
                %}
                for ii=1:nBits-1
                    inputSlice= input(ii*Ns+1+(0:Ns-1));

                    for jj=1:Ns
                        sBpOut(jj) = FilterStep(hObj.m_H,inputSlice(jj));
                    end
                    for jj=1:Ns
                        hObj.m_receiverBuffer(jj+Ns-delay) = sBpOut(jj);
                    end
                    bitsOut(ii) = receiveBit(hObj.m_receiverBuffer(1:Ns));
                    for jj=1:Ns-delay
                        hObj.m_receiverBuffer(jj) = hObj.m_receiverBuffer(jj+Ns);
                    end

                    % Vectorized
                    sBpOut = FilterStep(hObj.m_H,inputSlice);
                    hObj.m_receiverBuffer((1:Ns)+Ns-delay) = sBpOut;
                    bitsOut(ii) = receiveBit(hObj.m_receiverBuffer(1:Ns));
                    hObj.m_receiverBuffer(1:Ns-delay) = hObj.m_receiverBuffer((1:Ns-delay)+Ns);
                end
            end
        end
        function phaseOut=despreader(hObj,X)
            % C++ Code
            %{
            Sample
            IEEE802_11b_Receiver::despreader(const Signal& X) {
                Sample phaseOut(0.,0.);
                for(int i=0; i<X.size(); ++i) {
                    phaseOut += X[i]*Sample(m_nchip[i/4],0);
                }
                return phaseOut;
            }
            %}

            % Vectorized. Dot product
            phaseOut=sum(reshape(X,4,11)*hObj.m_nchip);

        end
        function out=diffDecoder(hObj,X)
            % C++ Code
            %{
            bool
            IEEE802_11b_Receiver::diffDecoder(const Sample& X) {
                double phaseOut = m_diffDecMem.real()*X.real() + m_diffDecMem.imag()*X.imag();
                m_diffDecMem = X;
                return (phaseOut<0.0);
            }
            %}
            phaseOut = real(hObj.m_diffDecMem)*real(X) + imag(hObj.m_diffDecMem)*imag(X);
            hObj.m_diffDecMem = X;
            out=phaseOut<0;
        end
        function out=receiveBit(hObj,inputSlice)
            % C++ Code
            %{
            bool
            IEEE802_11b_Receiver::receiveBit(const Signal& inputSlice) {
                // Check input:
                _ASSERTE(inputSlice.size() == Ns);
                Sample desOut = despreader(inputSlice);
                return diffDecoder(desOut);
            }
            %}
            assert(length(inputSlice) == 44);

            % In line. Don't call despreader funcion
            desOut=sum(reshape(inputSlice,4,11)*hObj.m_nchip);

            % In line. Don't call diffdecoder
            phaseOut = real(hObj.m_diffDecMem)*real(desOut) + imag(hObj.m_diffDecMem)*imag(desOut);
            hObj.m_diffDecMem = desOut;
            out=phaseOut<0;
        end

        function bitsOut=receive_11Mb_s(hObj,input)
            % C++ Code
            %{
            Bits
            IEEE802_11b_Receiver::receive_11Mb_s(const Signal& input) {
                const int codeSample = codeLength * NsCCK;
                // Input length should be a multiple of Nscck*codLength*11
                _ASSERTE((input.size()) % codeSample == 0);
            %}

            % Get constants for use later
            codeLength=constants.codeLength;
            NsCCK=constants.NsCCK;

            codeSample = codeLength * NsCCK;
            assert(mod(length(input), codeSample) == 0);

            % C++ Code
            %{
            int nBits  = input.size()/NsCCK;
            Bits bitsOut(nBits);
            %}
            nBits  = length(input)/NsCCK;
            bitsOut=zeros(nBits,1);

            % C++ Code
            %{
            for(int i=0; i<input.size(); i+=codeSample) {
                Signal inputSlice=input[slice(i,codeSample)];
                //bitsOut[slice(i/NsCCK,codeLength,1)]=receiveCode(inputSlice);
                int begin = i/NsCCK;
                bitsOut.set(receiveCode(inputSlice), begin,begin+codeLength-1);
            }
            return bitsOut;
            }
            %}
            for ii=0:codeSample:length(input)-1
                inputSlice=input(ii+(0:codeSample-1)+1);
                begin = floor(ii/NsCCK);
                bitsOut(begin+1:begin + (codeLength-1)+1)=hObj.receiveCode(inputSlice);
            end
        end
        function outBits=receiveCode(hObj, inputSlice)
            % C++ Code
            %{
            Bits
            IEEE802_11b_Receiver::receiveCode(const Signal& inputSlice) {
                const int codeSample = codeLength * NsCCK;
            %}

            % Get constants for use later
            codeLength=constants.codeLength;
            NsCCK=constants.NsCCK;
            PI=constants.PI;

            codeSample=codeLength*NsCCK;

            % C++ Code
            %{
            _ASSERTE((inputSlice.size()) == codeSample );
            Bits   outBits(codeLength);
            Signal sampleBpOut(codeLength);
            Signal conjSampleBpOut(codeLength);
            Signal BpOut(codeSample);
            double ph[4];
            int d[4];
            %}
            assert(length(inputSlice) == codeSample);
            outBits=zeros(codeLength,1);
            ph=zeros(4,1);
            d=uint32(zeros(4,1));

            % C++ Code
            %{
            int i;  // loop index
            for (i = 0; i < codeSample; i++) {
                BpOut[i] = m_H.FilterStep(inputSlice[i]);
            } //for i
            %}
            BpOut = FilterStepN(hObj.m_H,inputSlice);

            % C++ Code
            %{
                for (i = 0; i < codeLength; i++){
                    sampleBpOut[i] = BpOut[i*NsCCK];
                    conjSampleBpOut[i] = conjugate(sampleBpOut[i]);
                } //for i
            %}
            sampleBpOut = BpOut(1:NsCCK:end);
            conjSampleBpOut = conj(sampleBpOut); % instead of function

            % C++ Code
            %{
            conjSampleBpOut[3] = -conjSampleBpOut[3];
            conjSampleBpOut[6] = -conjSampleBpOut[6];
            sampleBpOut[3] = -sampleBpOut[3];
            sampleBpOut[6] = -sampleBpOut[6];
            %}
            conjSampleBpOut(4) = -conjSampleBpOut(4);
            conjSampleBpOut(7) = -conjSampleBpOut(7);
            sampleBpOut(4) = -sampleBpOut(4);
            sampleBpOut(7) = -sampleBpOut(7);

            % Calculate the received phases

            % C++ Code
            %{
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
            %}
            out2=sampleBpOut(1)*conjSampleBpOut(2) +...
                sampleBpOut(3)*conjSampleBpOut(4) +...
                sampleBpOut(5)*conjSampleBpOut(6) +...
                sampleBpOut(7)*conjSampleBpOut(8);

            out3=sampleBpOut(1)*conjSampleBpOut(3) +...
                sampleBpOut(2)*conjSampleBpOut(4) +...
                sampleBpOut(5)*conjSampleBpOut(7) +...
                sampleBpOut(6)*conjSampleBpOut(8);

            out4=sampleBpOut(1)*conjSampleBpOut(5) +...
                sampleBpOut(2)*conjSampleBpOut(6) +...
                sampleBpOut(3)*conjSampleBpOut(7) +...
                sampleBpOut(4)*conjSampleBpOut(8);

            % C++ Code
            %{
            double ph2=atan2(out2.imag(),out2.real());
            double ph3=atan2(out3.imag(),out3.real());
            double ph4=atan2(out4.imag(),out4.real());
            %}
            ph2=atan2(imag(out2),real(out2));
            ph3=atan2(imag(out3),real(out3));
            ph4=atan2(imag(out4),real(out4));

            % C++ Code
            %{
            Sample out1=sampleBpOut[3]*exp (Sample(0.0,-ph4))+
                        sampleBpOut[5]*exp (Sample(0.0,-ph3))+
                        sampleBpOut[6]*exp (Sample(0.0,-ph2))+
                        sampleBpOut[7];
            double ph1=atan2(out1.imag(),out1.real());
            %}
            out1=sampleBpOut(4)*exp (j*-ph4)+...
                sampleBpOut(6)*exp (j*-ph3)+...
                sampleBpOut(7)*exp (j*-ph2)+...
                sampleBpOut(8);
            ph1=atan2(imag(out1),real(out1));

            % C++ Code
            %{
            ph[0]=ph1;
            ph[1]=ph2;
            ph[2]=ph3;
            ph[3]=ph4;
            %}
            ph(1)=ph1;
            ph(2)=ph2;
            ph(3)=ph3;
            ph(4)=ph4;

            % Decode bits

            % C++ Code
            %{
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
            %}
            for ii=1:4
                % Put ph in [0, 2*pi]
                if ph(ii)<0, ph(ii)=ph(ii)+2*PI; end

                if 0<=ph(ii) && ph(ii)<PI/4,                d(ii)=0;
                elseif (7*pi/4<=ph(ii) && (ph(ii)<2*PI)),   d(ii)=0;
                elseif (pi/4<=ph(ii) && (ph(ii)<3*PI/4)),   d(ii)=2;
                elseif (3*pi/4<=ph(ii) && (ph(ii)<5*PI/4)), d(ii)=1;
                else                                        d(ii)=3;
                end

                outBits(2*(ii-1)+1)=bitand(d(ii),uint32(1)); % Even
                outBits(2*(ii-1)+2)=bitand(bitshift(d(ii),-1), uint32(1)); % Odd
            end
        end
    end
end

% C++ Code
%{
static inline
Sample
conjugate(const Sample& in) {
    return Sample(in.real(), -in.imag());
}
\\Not necessary, function in MATLAB
%}
