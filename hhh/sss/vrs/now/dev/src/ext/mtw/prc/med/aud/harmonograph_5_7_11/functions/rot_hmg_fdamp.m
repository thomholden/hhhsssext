%rot_hmg_fdamp
% Computes a vector of pen coordinates as a function of time for a
% three pendulum 'rotary harmonograph'. Note damping is enhanced by frequency.
%
% LAST UPDATED by Andy French 17-Jan-2009
%
% Syntax: [x,y,t] = rot_hmg( N,M, f_Hz, F, A, D, phi, contra )
%
% f_Hz is the rotation frequency in Hz of the 'x' and 'y' pendulum assembly
% The number of time points is determined by N periods of the x pendulum
% M is the number of data points per period
% F is the frequency ratio of the third pendulum rotation to the x,y assembly rotation
% A is the amplitude of the third pendulum rotation to the x,y assembly rotation
% D is the percentage amplitude of damping per oscillation
% phi is the phase of the third pendulum rotation to the x,y assembly rotation
% contra is a binary flag which sets (if ==1) contra-rotating pen and paper circles
%
% t is the corresponding time array to the x and y coordimates.

function [x,y,t] = rot_hmg( N,M, f_Hz, F, A, D, phi, contra )

%Determine times /s for N periods
t = linspace( 0, N/f_Hz, N*M );

%Determine angular frequency of the two rotations/ radians per seconds
W1 = 2*pi * f_Hz;
W2 = F * W1;

%Compute damping time factors /s
tor1 = 2*pi / ( W1 * log( 100/(100-D) ) );
tor2 = 2*pi / ( W2 * log( 100/(100-D) ) );

%Define oscillation amplitudes. 
A = [ 1, A, 1, A];

%Define oscillation angular frequencies. Note the third pendulum rotates the paper, not
%the pen
if contra==1
    c = -1;
else
    c = 1;
end
W = [ W1, -W2, c*W1, -c*W2 ];

%Define oscillation initial phases. Note pi/2 extra phase to enable the
%rotations resulting from the phase relationship beween the x,y pendula, or
%the intrisic rotation of the third pendulum
P = [ 0, phi, pi/2, pi/2+phi];

%Define oscillation daming factors
T = [tor1,tor2,tor1,tor2];

%Compute Harmonograph x,y, coordinates from generalised equations
[x,y] = ghmg( t, A, W, P, T );

%End of code
