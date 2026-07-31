% AWGNChannel Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include "awgnchan.h"
#include "random.h"
#include "util.h"
class AWGNChannel : public Channel {
%}

% Inheritence from empty Channel class is not necessary and could be
% replaced with inheritence from just handle class.

classdef AWGNChannel < Channel
    % C++ Code
    %{
    private:
       AWGN* m_awgn;   // Complex additive white Gaussian noise generator
    };
    %}

    properties (GetAccess='private', SetAccess='private')
        m_awgn
    end
    methods
        function hObj=AWGNChannel(varargin)
            % C++ Code
            %{
            AWGNChannel(double dB_noise=1.0);
            // Default constructor
            AWGNChannel::AWGNChannel(double dB_noise)
            {
                m_awgn = new AWGN(dB_noise);
            }
            %}
            dB_noise=getArg(1,varargin,1);
            hObj.m_awgn = AWGN(dB_noise);
        end

        % C++ Code
        %{
        // Copy constructor
        AWGNChannel::AWGNChannel(AWGNChannel& awgnchan)
        {
            m_awgn = new AWGN(*(awgnchan.m_awgn));
        }

        Not necessary

        // Destructor
        // virtual
        AWGNChannel::~AWGNChannel() {
            delete m_awgn;
        }
        Not necessary
        %}

        function out=process(hObj,desired, interference)
            % C++ Code
            %{
            // Return channel output given desired and interference signals
            //virtual
            Signal
            AWGNChannel::process(const Signal& desired,
                                 const Signal& interference) {
                int N = desired.size();
                _ASSERTE(N == interference.size());

                // add signal and interference and noise samples
                return desired + interference + m_awgn->nextNSamples(N);
            %}
            N=length(desired);
            assert(N==length(interference));
            noise=nextNSamples(hObj.m_awgn,N);
            out=desired+interference+noise;
        end
    end
end
