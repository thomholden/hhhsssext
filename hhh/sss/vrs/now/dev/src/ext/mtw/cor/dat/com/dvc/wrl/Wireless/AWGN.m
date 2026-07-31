% AWGN Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <math.h>
#include <stdlib.h>
#include "random.h"
#include "util.h"
class AWGN;
%}

classdef AWGN < handle
    % C++ Code
    %{
    private:
    double m_dB_noise;
    int m_x1, m_x2, m_x3, m_x4, m_x5, m_x6;
    %}

    properties (GetAccess='private', SetAccess='private')
        m_dB_noise;
        m_x1;
        m_x2;
        m_x3;
        m_x4;
        m_x5;
        m_x6;
    end
    methods
        function hObj=AWGN(dB_noise)
            % C++ Code
            %{
            // Constructor takes noise power in dB as parameter
            AWGN::AWGN(double dB_noise) {
                setdBNoise(dB_noise);
                m_x1=6666;
                m_x2=18888;
                m_x3=121;
                m_x4=178;
                m_x5=2140;
                m_x6=25000;
            }
            %}
            hObj.m_dB_noise=dB_noise; % Has set method
            hObj.m_x1=6666;
            hObj.m_x2=18888;
            hObj.m_x3=121;
            hObj.m_x4=178;
            hObj.m_x5=2140;
            hObj.m_x6=25000;
        end

        % C++ Code
        %{
        // Copy constructor
        AWGN::AWGN(AWGN& awgn) {
            setdBNoise(awgn.m_dB_noise);

            m_x1 = awgn.m_x1;
            m_x2 = awgn.m_x2;
            m_x3 = awgn.m_x3;
            m_x4 = awgn.m_x4;
            m_x5 = awgn.m_x5;
            m_x6 = awgn.m_x6;
        }

        Copy constructor Not necessary

        //virtual
        AWGN::~AWGN() {
        }

        Destructor not necessary
        %}

%         function hObj=set.m_dB_noise(hObj, dB_noise)
%             % C++ Code
%             %{
%             // Set noise power in dB
%                 void
%                 AWGN::setdBNoise(double dB_noise) {
%                 _ASSERTE(dB_noise > 0.0);
%                 m_dB_noise = dB_noise;
%             }
%             %}
%             assert(dB_noise > 0.0);
%             hObj.m_dB_noise = dB_noise;
%         end

        % C++ Code
        %{
        double
        AWGN::getdBNoise() const {
            return m_dB_noise;
        }
        Not required
        %}

        function out=nextSample(hObj) % Need to return hObj and value
            % C++ Code
            %{
            // Generate the next complex-valued random noise sample
            Sample
            AWGN::nextSample() {
                m_x1 = (171 * m_x1)%30269;
                m_x2 = (172 * m_x2)%30307;
                m_x3 = (170 * m_x3)%30323;
            %}
            hObj.m_x1 = mod((171 * hObj.m_x1),30269);
            hObj.m_x2 = mod((172 * hObj.m_x2),30307);
            hObj.m_x3 = mod((170 * hObj.m_x3),30323);

            % C++ Code
            %{
            double m1 = fmod(m_x1/30269.0 + m_x2/30307.0 + m_x3/30323.0,1.0);
            %}
            % m1 is a uniform rv
            m1 = rem(hObj.m_x1/30269.0 + hObj.m_x2/30307.0 + hObj.m_x3/30323.0, 1.0);

            % C++ Code
            %{
            m_x4 = (171 * m_x4)%30269;
            m_x5 = (172 * m_x5)%30307;
            m_x6 = (170 * m_x6)%30323;
            %}
            hObj.m_x4 = mod((171 * hObj.m_x4),30269);
            hObj.m_x5 = mod((172 * hObj.m_x5),30307);
            hObj.m_x6 = mod((170 * hObj.m_x6),30323);

            % C++ Code
            %{
            double m2 = fmod(m_x4/30269.0 + m_x5/30307.0 + m_x6/30323.0, 1.0);
            %}
            % m2 is a uniform rv
            m2 = rem(hObj.m_x4/30269.0 + hObj.m_x5/30307.0 + hObj.m_x6/30323.0, 1.0);

            % C++ Code
            %{
            double k1 = sqrt(-2.0 * m_dB_noise * log(m1));
            double k2 = twopi * m2;
            %}
            k1 = sqrt(-2.0 * hObj.m_dB_noise * log(m1));
            k2 = constants.twopi* m2;

            % R eturn complex-valued sample
            % C++ Code
            %{
            return Sample(k1*cos(k2), k1*sin(k2));
            %}
            out= k1*cos(k2) +j* (k1*sin(k2)); % Don't need to use sample type
        end
        function awgnSignal=nextNSamples(hObj,N)
            % C++ Code
            %{
            // Generate the next N complex-valued random noise samples
            Signal
            AWGN::nextNSamples(int N) {
                Signal awgnSignal(N);
                for (int i=0; i<N; ++i) {
                    awgnSignal[i] = nextSample();
                }

                return awgnSignal;
            }
            %}
            awgnSignal = zeros(N,1);
            twopi=constants.twopi;
       
            % Option 1)
            
            %{
            for ii=0:N-1
            % Execute nextSample operation in line
                hObj.m_x1 = mod((171 * hObj.m_x1),30269);
                hObj.m_x2 = mod((172 * hObj.m_x2),30307);
                hObj.m_x3 = mod((170 * hObj.m_x3),30323);
                m1 = rem(hObj.m_x1/30269.0 + hObj.m_x2/30307.0 + hObj.m_x3/30323.0, 1.0);
                hObj.m_x4 = mod((171 * hObj.m_x4),30269);
                hObj.m_x5 = mod((172 * hObj.m_x5),30307);
                hObj.m_x6 = mod((170 * hObj.m_x6),30323);
                m2 = rem(hObj.m_x4/30269.0 + hObj.m_x5/30307.0 + hObj.m_x6/30323.0, 1.0);
                k1 = sqrt(-2.0 * hObj.m_dB_noise * log(m1));
                k2 = twopi* m2;
                awgnSignal(ii+1)= k1*cos(k2) +j* (k1*sin(k2));
            end
            %}
            
            
            % Option 2: Get properties
            m_dB_noise=hObj.m_dB_noise;
            m_x1=hObj.m_x1; m_x2=hObj.m_x2;
            m_x3=hObj.m_x3; m_x4=hObj.m_x4;
            m_x5=hObj.m_x5; m_x6=hObj.m_x6; 
            
            for ii=0:N-1
            % Execute nextSample operation in line
                m_x1 = mod((171 * m_x1),30269);
                m_x2 = mod((172 * m_x2),30307);
                m_x3 = mod((170 * m_x3),30323);
                m1 = rem(m_x1/30269.0 + m_x2/30307.0 + m_x3/30323.0, 1.0);
                m_x4 = mod((171 * m_x4),30269);
                m_x5 = mod((172 * m_x5),30307);
                m_x6 = mod((170 * m_x6),30323);
                m2 = rem(m_x4/30269.0 + m_x5/30307.0 + m_x6/30323.0, 1.0);
                k1 = sqrt(-2.0 * m_dB_noise * log(m1));
                k2 = twopi* m2;
                awgnSignal(ii+1)= k1*cos(k2) +j* (k1*sin(k2));
            end
            hObj.m_x1=m_x1; hObj.m_x2=m_x2;
            hObj.m_x3=m_x3; hObj.m_x4=m_x4;
            hObj.m_x5=m_x5; hObj.m_x6=m_x6;                       
        end
    end
end