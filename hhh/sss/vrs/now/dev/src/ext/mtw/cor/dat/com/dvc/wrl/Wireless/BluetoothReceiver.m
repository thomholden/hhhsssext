% BluetoothReceiver Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <math.h>
#include "bluetooth.h"
#include "util.h"
%}

classdef BluetoothReceiver < Receiver
    % C++ Code
    %{
    % class BluetoothReceiver : public Receiver {
    % private:
    % FIRFilter bandpassFilter;
    % FIRFilter differentiatorFilter;
    % int m_bitDelay;
    %}
    properties (GetAccess='private', SetAccess='private')
        bandpassFilter       % FIR Filter
        differentiatorFilter % FIR Filter
    end
    properties
        m_bitDelay % Instead of public access method
    end
    methods
        % Constructor
        function hObj=BluetoothReceiver()
            % C++ Code
            %{
            BluetoothReceiver::BluetoothReceiver()
            : bandpassFilter(BPLENGTH),
              differentiatorFilter(DIFFLENGTH)
            {
            %}
            % Get constants for user later
            BPLENGTH=constants.BPLENGTH;
            Ns=constants.Ns;
            Br=constants.Br;

            hObj.bandpassFilter=FIRFilter(BPLENGTH);
            hObj.differentiatorFilter=FIRFilter(constants.DIFFLENGTH);

            % C++ Code
            %{
            m_bitrate = 1;
            m_bitDelay = BITDELAYBT;
            %}
            hObj.m_bitrate = 1;
            hObj.m_bitDelay = constants.BITDELAYBT;

            % C++ Code
            %{
            // Compute Bandpass filter coefficients and
            const double h0 = sqrt(2.0) * Br;
            const double kexp = -twopi * Br * Br;
            for (int i=0; i<bandpassFilter.size(); ++i) {
                double temp = i - (BPLENGTH *1.)/2.+.5;
                temp /= Ns;
                double hreal = h0 * exp(kexp * temp * temp);
                bandpassFilter[i] = Sample(hreal,0.0);
            }
            %}
            h0 = sqrt(2.0) * Br;
            kexp = -constants.twopi * Br * Br;
            for ii=0:size(hObj.bandpassFilter)-1
                temp = ii - (BPLENGTH *1)/2+.5;
                temp=temp / Ns;
                hreal = h0 * exp(kexp * temp * temp);
                hObj.bandpassFilter(ii+1) = hreal;
            end

            % C++ Code
            %{
            differentiatorFilter[0] = Sample(-0.0062, 0.0);
            differentiatorFilter[1] = Sample(0.0372, 0.0);
            differentiatorFilter[2] = Sample(-0.4566, 0.0);
            differentiatorFilter[3] = Sample(0.4566, 0.0);
            differentiatorFilter[4] = Sample(-0.0372, 0.0);
            differentiatorFilter[5] = Sample(0.0062, 0.0);
            %}

            % Set Differentiator filter coefficients
            hObj.differentiatorFilter(1) = -0.0062;
            hObj.differentiatorFilter(2) = 0.0372;
            hObj.differentiatorFilter(3) = -0.4566;
            hObj.differentiatorFilter(4) = 0.4566;
            hObj.differentiatorFilter(5) = -0.0372;
            hObj.differentiatorFilter(6) = 0.0062;
        end

        % C++ Code
        %{
        //virtual
        BluetoothReceiver::~BluetoothReceiver() {
        }
        Not required
        %}

        function bitsOut=receive(hObj,input)
            % C++ Code
            %{
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
            %}
            Ns=constants.Ns; % Get constant for use later

            nBits = length(input)/Ns;
            assert(mod(length(input),Ns)==0);
            bitsOut=zeros(nBits,1);
            for ii=0:nBits-1
                sl_i=ii*Ns+ (1:Ns); % just list of indices
                bitsOut(ii+1) = hObj.receiveBit(input(sl_i));
            end
        end
        function reset(hObj)
            % C++ Code
            %{
            % void
            % BluetoothReceiver::reset(){
            %     bandpassFilter.reset();
            %     differentiatorFilter.reset();
            % }
            %}
            reset(hObj.bandpassFilter);
            reset(hObj.differentiatorFilter);
        end

        % C++ Code
        %{
        % Not required. using publis properties instead

        //virtual
        int
        BluetoothReceiver::delay() const {
            return m_bitDelay;
        }

        %}

        function out=receiveBit(hObj,inputSlice)
            % Decode one bit of received data

            % C++ Code
            %{
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
            %}
            assert(length(inputSlice)==constants.Ns);

            % Vectorized and call new FilterStepN method
            bpOut   = FilterStepN(hObj.bandpassFilter,inputSlice);
            diffOut = FilterStepN(hObj.differentiatorFilter,bpOut);
            phaseLoop = limiterDiscriminator(bpOut, diffOut); % Static method
            phase=sum(phaseLoop);

            % C++ Code
            %{
                 return (phase < 0.0);
            }
            %}
            out=phase<0;
        end
    end


end
function out=limiterDiscriminator(X,Y)
% C++ Code
%{
            double
            BluetoothReceiver::limiterDiscriminator(Sample X,
                                                    Sample Y) {
                double denom = X.real()*X.real() + X.imag()*X.imag();
                return (X.real()*Y.imag() - X.imag()*Y.real())/denom;
            }
%}
denom=real(X).^2 + imag(X).^2;
out=(real(X).*imag(Y) - imag(X).*real(Y))./denom;
end