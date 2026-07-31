% Transmitter Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
class Transmitter {
%}
classdef Transmitter < handle
    % C++ Code
    %{
    protected:
    int m_bitrate;  // Bitrate in Mb/s

    private:
    	double	m_phase; //initial phase of the tx
    %}

    properties % Leave public (access method was public)
        m_bitrate
    end
    properties
        m_phase
    end
    % C++ Code
    %{
        Transmitter::Transmitter()
        {
        }
        Not required if does nothing

        //virtual
        int
        Transmitter::c() const { // minimum input length, in bits
            return 1;   // 1 bit is the default
        }

        Not required if does nothing

        double
        Transmitter::getPhase() const {
            return m_phase;
        }
        not necessary

        void
        Transmitter::setPhase(double phase) {
            m_phase = phase;
        }
        not necessary leave as public property


        int
        Transmitter::bitrate() const {  // Bitrate in Mb/s
            return m_bitrate;
        }
        Not necessary, leave as public property
    %}
end