%hmg_default_settings

function HMG = hmg_default_settings

%Define default settings used by harmonograph.m into structure HMG
HMG.types = {
    'Lateral',...
    'Rotary',...
    'Contra-rotary',...
    'Lateral freq-damp',...
    'Rotary freq-damp',...
    'Contra-rotary freq-damp'
    };
HMG.philimits = [-pi,pi];
HMG.Dlimits = [0,5];
HMG.Flimits = [-8,8];
HMG.Alimits = [0,1];
HMG.type = 'Rotary';
HMG.f_Hz = 440;
HMG.filename = 'Rotary harmonograph N=50 A=0.5 F=-1 phi=90 D=3.png';
HMG.N = 50;
HMG.M = 1000;
HMG.phi = 2;
HMG.D = 2.15;
HMG.F = 7.04;
HMG.A = 0.5;

%End of code