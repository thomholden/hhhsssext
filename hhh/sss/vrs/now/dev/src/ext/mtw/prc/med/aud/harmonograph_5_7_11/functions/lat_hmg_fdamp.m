%lat_hmg_fdamp
% Computes a vector of pen coordinates as a function of time for a
% two pendulum 'lateral harmonograph'. Note damping is enhanced by frequency.
%
% LAST UPDATED by Andy French 17-Jan-2010
%
% Syntax: [x,y,t] = lat_hmg_fdamp( N,M, fx_Hz, F, A, D, phi )
%
% f_Hz is the frequency in Hz of the 'x' pendulum
% The number of time points is determined by N periods of the x pendulum
% M is the number of data points per period
% F is the frequency ratio of 'y' pendulum to 'x' pendulum
% A is the amplitude of 'y' pendulum relative to 'x' pendulum
% D is the percentage amplitude of damping per oscillation
% phi is the phase of 'y' pendulum relative to 'x' pendulum
%
% t is the corresponding time array to the x and y coordimates.

function [x,y,t] = lat_hmg_fdamp( N,M, fx_Hz, F, A, D, phi )

%Determine times /s for N periods
t = linspace( 0, N/fx_Hz, N*M );

%Determine angular frequency of 'x' and 'y' pendulua / radians per seconds
W_x = 2*pi * fx_Hz;
W_y = F * W_x;

%Compute damping time factors /s
tor_x = 2*pi / ( W_x * log( 100/(100-D) ) );
tor_y = 2*pi / ( W_y * log( 100/(100-D) ) );

%Define oscillation amplitudes. Note the 'y' pendulum moves the paper, not
%the pen
A = [ 1, 0, -A, 0];

%Define oscillation angular frequencies
W = [ W_x, 0, W_y, 0 ];

%Define oscillation initial phases
P = [ 0, 0, phi, 0];

%Define oscillation damping factors
T = [tor_x,inf,tor_y,inf];

%Compute Harmonograph x,y, coordinates from generalised equations
[x,y] = ghmg( t, A, W, P, T );

%End of code
