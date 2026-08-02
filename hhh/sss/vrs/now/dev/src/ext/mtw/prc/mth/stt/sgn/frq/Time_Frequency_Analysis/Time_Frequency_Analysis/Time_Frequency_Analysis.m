%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Time-Frequency Analysis with MATLAB Implementation  %
%                                                      %
% Authors: M.Sc. Eng. Hristo Zhivomirov      02/01/14  %
%          M.Sc. Eng. Kiril Nenkov                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc, close all

[x, fs] = wavread('track.wav');     % get the samples of the .wav file
x = x(:, 1);                        % get the first channel
xmax = max(abs(x));                 % find the maximum abs value
x = x/xmax;                         % scalling the signal

% signal parameters
xlen = length(x);                   % signal length
xdur = xlen/fs;                     % signal duration
time = (0:xlen-1)/fs;               % time scale

% analysis parameters
wlen = 1024;                        % window length (recomended to be power of 2)
h = wlen/4;                         % hop size (recomended to be power of 2)
nfft = 2*wlen;                      % number of fft points (recomended to be power of 2)
TimeRes = wlen/fs;                  % time resulution of the analysis (= window duration), s
FreqRes = fs/wlen;                  % frequency resolution of the analysis, Hz

% time-frequency grid parameters
k = 1+fix((xlen-wlen)/h);           % number of time segments
TimeResGrid = xdur/k;               % time resolution of the grid, s
FreqResGrid = fs/nfft;              % frequency resolution of the grid, Hz 

% define the coherent amplification of the window
K = sum(hamming(wlen, 'periodic'))/wlen;

% perform STFT
[stft, f, t] = stft(x, wlen, h, nfft, fs);

% take the amplitude of fft(x) and scale it, so not to be a
% function of the length of the window and its coherent amplification
SA = abs(stft)/wlen/K;

% correction of the DC & Nyquist component
if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    SA(2:end, :) = SA(2:end, :).*2;
else                                % even nfft includes Nyquist point
    SA(2:end-1, :) = SA(2:end-1, :).*2;
end

% convert the amplitude spectrogram to dB
SA = 20*log10(SA);

% plot the signal in time domain
figure(1)
subplot(3, 3, [2 3])
plot(time, x)
grid on
xlim([0 max(time)])
ylim([-1.1*max(abs(x)) 1.1*max(abs(x))])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Normalized amplitude')
title('The signal in the time domain')

% plot the amplitude spectrogram
subplot(3, 3, [5 6 8 9])
imagesc(t, f, SA)
set(gca, 'YDir', 'normal')
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Amplitude spectrogram of the signal')
handl = colorbar('East');
set(handl, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(handl, 'Magnitude, dB')

% plot the amplitude spectrum
subplot(3, 3, [4 7])
[Xamplitude, XPhase, freq] = spectrum(x, fs);
plot(freq, Xamplitude); 
grid on
xlim([0 max(freq)])
ylim([min(Xamplitude)-10 max(Xamplitude)+10])
view(-90, 90)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Frequency, Hz')
ylabel('Magnitude, dB')
title('Amplitude spectrum of the signal')