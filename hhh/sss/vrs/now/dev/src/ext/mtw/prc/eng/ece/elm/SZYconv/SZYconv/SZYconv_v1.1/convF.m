function [out] = convF(what, v1, v2, Zo)

% [out] = convF(what, v1, v2, Zo)
%
% out is a size-12 array containing the impedance/reflection coefficient
% described by v1 & v2 transformed to the following formats
%
% what can take the values :
% 'ri'	- gamaRI
% 'mad'	- gamaMAdeg
% 'mar'	- gamaMArad
% 'z'	- Z
% 'y'	- Y
% 'rl' - RL, angle as above - 15.12.2007
% 'wswr'- WSWR :-)

% the componence of [out] is :
%
% gamaRI.real	gamaRI.imag
% gamaMAdeg.mag	gamaMAdeg.ang
% gamaMArad.mag	gamaMArad.ang
% Z.real	Z.imag
% Y.real	Y.imag
% RL
% VSWR

if nargin < 4
 Zo = 50;
 if nargin < 3
  v2 = 1e-12;
  if nargin < 2
   v1 = 1;
   if nargin < 1
    what = 'ri';
   end;
  end;
 end;
end;

InteligibleOption = 0;
what = lower(what);

% ------------ RI ----------------
if strcmp(what, 'ri')
 InteligibleOption = 1;
 out(1) = v1;
 out(2) = v2;
 gammaRI = v1 + j*v2;
 [th, r] = cart2pol(v1, v2);
 out(3) = r;
 out(4) = th*180/pi;
 out(5) = r;
 out(6) = th;
 Z = (1+gammaRI)/(1-gammaRI)*Zo;
 out(7) = real(Z);
 out(8) = imag(Z);
 Y = (1-gammaRI)/(1+gammaRI)/Zo;
 out(9) = real(Y);
 out(10) = imag(Y);
 out(11) = 20*log10(abs(gammaRI));
 out(12) = (1+abs(gammaRI)) / (1-abs(gammaRI));
end;

% ------------ MA ----------------
if strcmp(what, 'mar')
 v2 = v2*180/pi;
end;

if strcmp(what, 'ma') | strcmp(what, 'mad') | strcmp(what, 'mar')
 InteligibleOption = 1;
 out(3) = v1;
 out(4) = v2 - round(v2/360)*360;
 out(5) = v1;
 out(6) = v2*pi/180;
 [out(1) out(2)] = pol2cart(v2*pi/180, v1);
 gammaRI = out(1) + j*out(2);
 Z = (1+gammaRI)/(1-gammaRI)*Zo;
 out(7) = real(Z);
 out(8) = imag(Z);
 Y = (1-gammaRI)/(1+gammaRI)/Zo;
 out(9) = real(Y);
 out(10) = imag(Y);
 out(11) = 20*log10(abs(gammaRI));
 out(12) = (1+abs(gammaRI)) / (1-abs(gammaRI));
end;

% ------------ Z ----------------
if strcmp(what, 'z')
 InteligibleOption = 1;
 out(7) = v1;
 out(8) = v2;
 Z = v1 + j*v2;
 gammaRI = (Z - Zo)/(Z+Zo);
 out(1) = real(gammaRI);
 out(2) = imag(gammaRI);
 [th, r] = cart2pol(out(1), out(2));
 out(3) = r;
 out(4) = th*180/pi;
 out(5) = r;
 out(6) = th;
 Y = 1/Z;
 out(9) = real(Y);
 out(10) = imag(Y);
 out(11) = 20*log10(abs(gammaRI));
 out(12) = (1+abs(gammaRI)) / (1-abs(gammaRI));
end;

% ------------ Y ----------------
if strcmp(what, 'y')
 InteligibleOption = 1;
 out(9) = v1;
 out(10) = v2;
 Y = v1 + j*v2;
 gammaRI = (1-Y*Zo)/(1+Y*Zo);
 out(1) = real(gammaRI);
 out(2) = imag(gammaRI);
 [th, r] = cart2pol(out(1), out(2));
 out(3) = r;
 out(4) = th*180/pi;
 out(5) = r;
 out(6) = th;
 Z = 1/Y;
 out(7) = real(Z);
 out(8) = imag(Z);
 out(11) = 20*log10(abs(gammaRI));
 out(12) = (1+abs(gammaRI)) / (1-abs(gammaRI));
end;

% --- RL --- 15.12.2007 ---
if strcmp(what, 'rl')
    InteligibleOption = 1;
    v1 = min(v1,-1e-12);
    out(11) = v1;
    out(4) = v2; out(6) = v2*pi/180; % really needed ...
    out(3) = 10^(v1/20); out(5) = out(3); % ... to trim out later
    [out(1) out(2)] = pol2cart(out(6), out(3));
    gammaRI = out(1) + j*out(2);    
    Z = (1+gammaRI)/(1-gammaRI)*Zo;
    out(7) = real(Z);
    out(8) = imag(Z);
    Y = (1-gammaRI)/(1+gammaRI)/Zo;
    out(9) = real(Y);
    out(10) = imag(Y);
    out(12) = (1+abs(gammaRI)) / (1-abs(gammaRI));
end;

% --- WSWR --- 15.12.2007 ---
if strcmp(what, 'wswr')
    InteligibleOption = 1;
    v1 = max(v1,1);
    out(12) = v1;
    r = (v1-1)/(1+v1);
    out(3) = r; out(5) = 3; % ... to trim out later    
    out(4) = v2; out(6) = v2*pi/180; % 

    [out(1) out(2)] = pol2cart(out(6), out(3));
    gammaRI = out(1) + j*out(2);    
    Z = (1+gammaRI)/(1-gammaRI)*Zo;
    out(7) = real(Z);
    out(8) = imag(Z);
    Y = (1-gammaRI)/(1+gammaRI)/Zo;
    out(9) = real(Y);
    out(10) = imag(Y);    
    out(11) = 20*log10(r);
end;


if InteligibleOption == 0;
    out = ['nil' 'nil' 'nil' 'nil' 'nil' 'nil' 'nil' 'nil' 'nil' 'nil' 'nil' 'nil'];
 disp('Unrecognized option. Type help convF.');
end;