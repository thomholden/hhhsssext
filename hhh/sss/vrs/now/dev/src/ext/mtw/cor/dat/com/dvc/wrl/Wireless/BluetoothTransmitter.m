% BluetoothTransmitter Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <math.h>
#include "bluetooth.h"
#include "util.h"
class BluetoothTransmitter : public Transmitter {
%}

classdef BluetoothTransmitter < Transmitter
    properties (GetAccess='private', SetAccess='private')
        % C++ Code
        %{
        bool m_prev;    // previous bit modulated
        double m_hf;    // modulation index
        // Used in implementation of GFSK modulation scheme
        %}
        m_prev; % Boolean previous bit modulated
        m_hf;   % Double modulation index
    end
    properties (Constant=true, GetAccess='private', SetAccess='private')
        % C++ Code
        %{
        // Modulation
        // Gaussian filter coefficients for modulator. Ns=44 samples per bit
        //static
        const double BluetoothTransmitter::s_qcoef[2*Ns] =
        {.0003384128078, .0007483472705, .001241740730, .001831809714,  // [0..3]
         .002533043604,  .003361167254,  .004333069131, .005466692340,  // [4..7]
         .006780887010,  .008295223730,  .01002976939,  .01200482814,   // [8..11]
         .01424065196,   .01675712682,   .01957344200,  .02270775110,   // [12..15]
         .02617683454,   .02999577350,   .03417764580,  .03873325341,   // [16..19]
         .04367089078,   .04899616180,   .05471185145,  .06081785680,   // [20..23]
         .06731117780,   .07418596970,   .08143365250,  .08904307290,   // [24..27]
         .09700071245,   .1052909327 ,   .1138962464 ,  .1227976077,    // [28..31]
         .1319747047,    .1414062494,    .1510702515,   .1609442679,    // [32..35]
         .1710056206,    .1812315788,    .1915994984,   .2020869202,    // [36..39]
         .2126716262,    .2233316570,    .2340452932,   .2447910090,    // [40..43]
         .2555474036,    .2662931193,    .2770067556,   .2876667864,    // [44..47]
         .2982514925,    .3087389142,    .3191068338,   .3293327920,    // [48..51]
         .3393941448,    .3492681611,    .3589321632,   .3683637078,    // [52..55]
         .3775408048,    .3864421662,    .3950474800,   .4033377002,    // [56..59]
         .4112953398,    .4189047602,    .4261524430,   .4330272350,    // [60..63]
         .4395205560,    .4456265612,    .4513422510,   .4566675220,    // [64..67]
         .4616051594,    .4661607670,    .4703426394,   .4741615782,    // [68..71]
         .4776306617,    .4807649708,    .4835812860,   .4860977608,    // [72..75]
         .4883335846,    .4903086434,    .4920431890,   .4935575258,    // [76..79]
         .4948717204,    .4960053436,    .4969772456,   .4978053692,    // [80..83]
         .4985066031,    .4990966721,    .4995900656,   .5000000000};   // [84..87]
        %}

        s_qcoef= [.0003384128078; .0007483472705; .001241740730; .001831809714;  % [0..3]
            .002533043604;  .003361167254;  .004333069131; .005466692340;        % [4..7]
            .006780887010;  .008295223730;  .01002976939;  .01200482814;         % [8..11]
            .01424065196;   .01675712682;   .01957344200;  .02270775110;         % [12..15]
            .02617683454;   .02999577350;   .03417764580;  .03873325341;         % [16..19]
            .04367089078;   .04899616180;   .05471185145;  .06081785680;         % [20..23]
            .06731117780;   .07418596970;   .08143365250;  .08904307290;         % [24..27]
            .09700071245;   .1052909327 ;   .1138962464 ;  .1227976077;          % [28..31]
            .1319747047;    .1414062494;    .1510702515;   .1609442679;          % [32..35]
            .1710056206;    .1812315788;    .1915994984;   .2020869202;          % [36..39]
            .2126716262;    .2233316570;    .2340452932;   .2447910090;          % [40..43]
            .2555474036;    .2662931193;    .2770067556;   .2876667864;          % [44..47]
            .2982514925;    .3087389142;    .3191068338;   .3293327920;          % [48..51]
            .3393941448;    .3492681611;    .3589321632;   .3683637078;          % [52..55]
            .3775408048;    .3864421662;    .3950474800;   .4033377002;          % [56..59]
            .4112953398;    .4189047602;    .4261524430;   .4330272350;          % [60..63]
            .4395205560;    .4456265612;    .4513422510;   .4566675220;          % [64..67]
            .4616051594;    .4661607670;    .4703426394;   .4741615782;          % [68..71]
            .4776306617;    .4807649708;    .4835812860;   .4860977608;          % [72..75]
            .4883335846;    .4903086434;    .4920431890;   .4935575258;          % [76..79]
            .4948717204;    .4960053436;    .4969772456;   .4978053692;          % [80..83]
            .4985066031;    .4990966721;    .4995900656;   .5000000000];         % [84..87]
    end
    methods
        function hObj=BluetoothTransmitter(varargin)
            % C++ Code
            %{
            BluetoothTransmitter(double hf=1./3., double phase_shift=0.0); from header
            BluetoothTransmitter::BluetoothTransmitter(double hf,
                                                       double phase_shift)
            {
                m_bitrate = 1;          // 1 Mb/s
                m_hf = hf;              // Modulation index
                m_prev = false;         // Previous bit transmitted
                setPhase(phase_shift);  // Current phase
            %}

            hf=getArg(1,varargin,1/3);
            phase_shift=getArg(2,varargin,0);

            hObj.m_bitrate = 1;         % 1 Mb/s
            hObj.m_hf = hf;             % Modulation index
            hObj.m_prev = 0;            % Previous bit transmitted
            hObj.m_phase=phase_shift;   % Current phase
        end

        % C++ Code
        %{
        BluetoothTransmitter::BluetoothTransmitter(BluetoothTransmitter& txbt)
        {
            m_bitrate = 1;
            m_hf=txbt.m_hf;
            m_prev = txbt.m_prev;
            setPhase(txbt.getPhase());
        }
        Copy constructor not required

        //virtual
        BluetoothTransmitter::~BluetoothTransmitter() {
        }
        Destructor not required
        %}

        function out=transmit(hObj,input,df)
            % C++ Code
            %{
            // virtual
            Signal
            BluetoothTransmitter::transmit(const Bits& input,
                                           double df) {
                return modulate(input, df);
            }
            %}
            out=modulate(hObj,input,df);
        end
        function reset(hObj)
            % C++ Code
            %{
            //virtual
            void
            BluetoothTransmitter::reset() {
                setPhase(0.0);
                m_prev=false;
            }
            %}
            hObj.m_phase=0; % Just use public property access
            hObj.m_prev=0;
        end
        function modOut=modulate(hObj,input, df)
            % Modulate using GFSK

            % C++ Code
            %{
            Signal modulate(const Bits& input, double df=0);
            Signal
            BluetoothTransmitter::modulate(const Bits& input, double df) {
                Signal modOut(Ns * input.size());
                int offset = 0;
                double phase=getPhase();
            %}
            Ns=constants.Ns; % Get constants now for use later
            twopi=constants.twopi;
            offset=0;
            phase=hObj.m_phase;

            modOut=zeros(Ns*length(input),1);

            % C++ Code
            %{
                for (int i=0; i<input.size(); ++i) {
                    for(int j=0; j<Ns; ++j) {
                        double tt=twopi*df*(j+Ns*i)/((double)Ns);
                        if (tt>twopi) { tt=fmod(tt,twopi); }
                        double state = qsign(input[i])*s_qcoef[j] +
                                       qsign(m_prev)*s_qcoef[j+Ns] + phase;
                        modOut[offset+j] = exp(Sample(0.0,twopi* (m_hf * state)+tt));
                    } // end j
            %}

            jj=(0:Ns-1)'; % Vectorizatrion replaces loop
            for ii=0:length(input)-1
                % Vectorized using jj
                tt=twopi*df*(jj+Ns*ii)/Ns;
                found=tt>twopi;
                tt(found)=mod(tt(found),twopi);
                state = (1-2*input(ii+1))*hObj.s_qcoef(jj+1) +... % Avoid function call
                    (1-2*hObj.m_prev)*hObj.s_qcoef(jj+1+ Ns) + phase;
                modOut(offset+jj+1)= exp(j*(twopi* (hObj.m_hf * state)+tt));

                % C++ Code
                %{
                        // Update phase and previous bit value
                        phase += (m_prev ? -0.5 : 0.5);
                        m_prev = input[i];
                        offset += Ns;
                    } end i
                    setPhase(phase);
                    return modOut;
                }
                %}

                % Update phase and previous bit value
                if hObj.m_prev
                    phase = phase-0.5;
                else
                    phase= phase+.5;
                end
                hObj.m_prev = input(ii+1);
                offset = offset+Ns;
            end

            hObj.m_phase=phase;
        end
    end
end
function out=qsign(bval)
% Not used. In lined instead
% C++ Code
%{
static inline double qsign(bool bval) { return ((bval) ? -1.0 : 1.0); }
%}
if bval
    out=-1;
else
    out =1;
end
end