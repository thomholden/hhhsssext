%pitch_shifter
% Function which changes the pitch of an audio recording by factor F
% Let x be a row vector of audio samples which are samples at rate Fs Hz.
% Common musical factors are (which differ slightly from the equi-tempered
% scale, where an octave is divided logarithmically into powers of the
% twelth root of 2)
%
% F=1       unison
% F=2       Octave
% F=3/2     Fifth
% F=4/3     Fourth
% F=5/3     Major sixth
% F=5/4     Major third
% F=6/5     Minor third
% F=8/5     Minor sixth
% F=9/8     Wholetone (second)
%
% LAST UPDATED by Andy French 12th March 2011
%
% y = pitch_shifter( x, fs_Hz, delta_f_Hz )

function y = pitch_shifter( x, fs_Hz, F )

%% Inputs %%

% Define length N of FFT used to determine the dominant frequency in a
% particular 'frame' of the audio sample. This corresponds to time interval
% N/fs_Hz seconds. Note 1024/44kHz is 0.0233 seconds.
N = 1024;

% Plot spectra for diagnostics?
plot_spectra = 0;

%

%Compute vector of dominant tones /Hz
fmax_Hz = spectra( x, fs_Hz, N, plot_spectra );

% Use vector of dominant tones to define a pitch modulator
y = pitch_shift( x, fs_Hz, F, median(fmax_Hz)*ones(1,length(x)) );

% Plot modified spectrum
if plot_spectra == 1
    fmax_Hz = spectra( y, fs_Hz, N, plot_spectra );
end

%%

%Pitch shift audio signal x by a factor F times the dominant tones
function y = pitch_shift( x, fs_Hz, F, fmax_Hz )

%Construct time /s and frequency modulation vectors
t = linspace( 0, (length(x)-1)/fs_Hz, length(x) );
f_mod = exp( 2*pi*i*t.*fmax_Hz*(F-1) );

%Pitch shift
y = real( x.*f_mod );

%%

%Compute power spectrum of audio signal for each 'frame' of length N
%samples and return a vector of dominant tones /Hz
function fmax_Hz = spectra( x, fs_Hz, N, plot_spectra )

% Reshape x into a matrix of size N x L. Lose the last few samples.
Lx = length(x);
L = floor( Lx/N );
if Lx>L*N
    x(L*N+1:end)=[];
end
x = reshape(x,[N,L]);

% Construct a window matrix to prepare y to be Fourier Transformed
W = repmat( blackman(N).',[1,L] );

% Window x and determine power spectrum. Calculate a vector of dominant
% tones for each of the L frames. Only use the first half of the spectrum to
% avoid the aliases 'reflected from fs_Hz.' (i.e. the top end of the
% spectrum).
x = abs( fft( W.*x, [], 1 ) );
x = x(1:round(N/2),:);
fmax_Hz = zeros(1,L);
for n=1:L
    imax = find( x(:,n)==max(x(:,n)) );
    fmax_Hz(n) = 0.5*fs_Hz*( imax(1) - 1 )/(round(N/2)-1);
end

% Plot spectrum with dominant tone highlighted in black for each frame
if plot_spectra==1
    figure;
    f = linspace( 0,0.5*fs_Hz/1000, round(N/2) );
    t = linspace( 0, (N*L-1)/fs_Hz, L );
    [tt,ff] = meshgrid(t,f);
    surf(tt,ff,x); view(2); shading interp; ylabel('Freq/ kHz'); xlabel('Time /s');
    hold on; plot3( t, fmax_Hz/1000, max(max(x))*ones(1,L), 'k' );
    title('Audio sample spectrum'); axis tight; colorbar;
end

% Interpolate dominant tones to match audio sample vector x
fmax_Hz = interp1( 1:L, fmax_Hz, linspace(1,L,Lx) );

%%

function pitch_shifter_demo

%Load .wav file snippet and play
load handel;

%Pitch shift by and octave and replay
F=2;
yy = pitch_shifter( y.', Fs, F ) ;
sound(y + yy.',Fs);

%%

%blackman
% Returns the n-point symmetric Blackman window in the column vector w,
% where N is a positive integer. Blackman windows have slightly wider
% central lobes and less sideband leakage than equivalent length Hamming
% and Hann windows
%
% LAST UPDATED by Andrew French. 17/09/2004.
%
% Syntax: w = blackman(N)
%
% N   - Length of window
% w   - Vector of window weights of length N

function w = blackman(N)

if N==1
    w=1;
else
    %Compute vector of window weights
    t = (0:N-1)/(N-1);
    w = .42*ones(1,N) -.5*cos(2*pi*t) + .08*cos(4*pi*t);
end

%End of code