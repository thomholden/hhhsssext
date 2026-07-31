% FIRFilter Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <math.h>
#include "basetype.h"
#include "util.h"
class FIRFilter {
%}

classdef FIRFilter < handle
    properties (GetAccess='private')
        % C++ Code
        %{
        private:
        Filter m_fc;	//filter coefficients
        Signal m_sIn;  // Time-reversed signal for convolution
        %}
        m_fc;	% Just array, Filter type, filter coefficients
        m_sIn;  % Time-reversed signal for convolution
    end
    methods
        function hObj=FIRFilter(filterLength)
            % C++ Code
            %{
            // FIR filter class, will be used either in tx or rx.
            FIRFilter::FIRFilter(int filterLength)
            : m_fc(filterLength,czero),
              m_sIn(filterLength,czero)
            {
            }
            % Sample czero(0.0, 0.0); not required
            %}
            hObj.m_fc=zeros(filterLength,1);    % Coeffs
            hObj.m_sIn=zeros(filterLength-1,1); % State one less than C++ code for M code filter function
        end

        % C++ Code
        %{
        FIRFilter::~FIRFilter() {
        }
        Destructor not required
        %}

        function reset(hObj)
            % C++ Code
            %{
            // reset: set input signal to all zeros
            void FIRFilter::reset() {
                for (int i=0; i<m_fc.size(); ++i) { m_sIn[i] = 0.0; }
            }
            %}
            hObj.m_sIn=zeros(length(hObj.m_fc)-1,1); % One less for M Filter function
        end

        function out=FilterStep(hObj,nextIn)
            % C++ Code
            %{
            Sample
            FIRFilter::FilterStep(Sample nextIn) {
                m_sIn = m_sIn.shift(-1);
                m_sIn[0] = nextIn;
                Sample out(0.0, 0.0);
                int len = m_fc.size();
                for (int i=0; i<len; ++i) {
                    out += (m_fc[len-i-1] * m_sIn[i]);
                }
                return out;
            %}
            [out,hObj.m_sIn] = filter(flipud(hObj.m_fc),1,nextIn,hObj.m_sIn); % flip it

        end
        function out=FilterStepN(hObj,nextInArray)
            flippedCoeffs=flipud(hObj.m_fc);
            [out,hObj.m_sIn] = filter(flippedCoeffs,1,nextInArray,hObj.m_sIn);
            
        end
        function SetCoef(hObj,filterLength,filter1)
            % C++ Code
            %{
            void FIRFilter::SetCoef(int filterLength, const Filter& filter1)
            {
                for (int i=0;i<size();++i) {
                    m_fc[i]=filter1[i];
                }
            }
            %}
            hObj.m_fc=filter1;
        end
        function out=size(hObj)
            % C++ Code
            %{
            int FIRFilter::size() const {
                return m_fc.size();
            }
            %}
            out=length(hObj.m_fc);
        end
        function out=subsref(hObj,s)
            % C++ Code
            %{
            Sample& FIRFilter::operator [](int index) {
                return m_fc[index];
            }
            %}

            switch s.type
                case '()' % Subs ref
                    if length(s.subs)==1
                        index = s.subs{1};
                        out=hObj.m_fc(index);
                    else
                        error('Only one dimension indexing supported');
                    end
                case '.' % Property access
                    out=hObj.(s.subs);
                otherwise
                    error('Indexing method not supported');
            end
        end
        function hObj=subsasgn(hObj,s,value)
            % C++ Code
            %{
            Sample& FIRFilter::operator [](int index) {
                return m_fc[index];
            }
            %}

            switch s.type
                case '()' % Subs assign
                    if length(s.subs)==1
                        index = s.subs{1};
                        hObj.m_fc(index)=value;
                    else
                        error('Only one dimension indexing supported');
                    end
                case '.' % Property access not necessary as properties are private
                    hObj.(s.subs)=value;
                otherwise
                    error('Indexing method not supported');
            end
        end
    end
end