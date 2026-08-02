% This program calculates and plots output of spectral estimation methods discussed in [4]:
%	- Discrete Fourier Transform (DFT);
%	- Extended DFT (EDFT);
%	- High-Resolution DFT (HRDFT) [2];
%	- Iterative algorithms based on the Capon filter approach and GWLS solution.
% EDFT spectral estimate is tested on four K(64)-point sequences:
% 1) x_uni - uniform complex-value test sequence used in [3];
% 2) x_non - nonuniform complex-value test sequence used in [3];
% 3) x_mak - well known Marple&Kay 64-point real sample sequence [1];
% 4) x_wgn - uniform white Gaussian noise sequence.
% The estimates will differ on each run for sequences 1,2 and 4 as the random seed
% is not predefined.
% References:
% [1] - S.M.Kay, S.L.Marple. Spectrum analysis - a modern perspective. 
% Proceedings IEEE 69, 1981.
% [2] - Mauricio D. Sacchi, Tadeusz J. Ulrych, Colin J. Walker. Interpolation and
% Extrapolation Using a High-Resolution Discrete Fourier Transform. IEEE Trans. 
% on Signal Proc., 46(1), 1998.
% [3] - Vilnis Liepins. High-resolution spectral analysis by using basis function adaptation
% approach. Doctoral Thesis for Scientific Degree of Dr.Sc.Comp., University of Latvia,
% 1997. Abstract available on http://www.opengrey.eu/item/display/10068/330816
% [4] - Vilnis Liepins. Extended Fourier analysis of signals. CoRR abs/1303.2033 (2013).
%       Available online at http://arxiv.org/abs/1303.2033
%
% Vilnis Liepins (vilnislp@gmail.com)

	clear
	it=15;				% Number of iterations
	N=1000;				% Number of frequencies
	fn=[-ceil((N-1)/2):floor((N-1)/2)]/N;	% Uniform frequency set [-0.5 ... 0.5[
	fne=[-ceil((2*N-1)/2):floor((2*N-1)/2)]/N;% Extended uniform frequency set [-1 ... 1[
	K=64;				% Length of test sequences 1, 2 and 4
	t_u=0:K-1;			% Uniform time set (sampling period=1)
	t_n=t_u+rand(1,K)*0.8;	% Nonuniform time set (mean sampling period=1)
	Eu=exp(-i*2*pi*t_u.'*fn);	% Exponents matrix (Uniform time), dim (KxN)
	En=exp(-i*2*pi*t_n.'*fn);	% Exponents matrix (Nonuniform time), dim (KxN)
	Eue=exp(-i*2*pi*t_u.'*fne);	% Extended Exponents matrix (Uniform time), dim (Kx2N)
	Ene=exp(-i*2*pi*t_n.'*fne);	% Extended Exponents matrix (Nonuniform time), dim (Kx2N)

% Uniform K-point complex-value sequence: x_uni
	PHT=2*pi*(rand-0.5);		% Random initial phase for the complex exponent
	x_s1=exp(i*(2*pi*0.35*t_u+PHT));	% Complex exponent at normalized frequency 0.35
	x_i=20*sin(pi*(t_u-K/2)*0.25)./(pi*(t_u-K/2)+eps).*exp(i*pi*0.25*(t_u-K/2));
	if round(K/2)==K/2, x_i(K/2+1)=5;end	% Rectangular pulse [0 ... 0.25]
	f_x=-0.5:1/1024:-0.25;	% Set 257 frequencies for simulation of a band-limited noise
	rand_ph=2*rand(257,1)*ones(1,K);
	x_n=sum(exp(i*2*pi*(f_x'*t_u+rand_ph)))/sqrt(K); % Band-limited noise [-0.5 ...-0.25]
	x_uni=x_s1+x_i+x_n;		% x_uni - uniform composite sequence
	xmax=ceil(max(abs(x_uni)));
	lim=2^9+0.5;
	sigm_x=x_uni*x_uni'/K;
	x_uni=xmax*round(x_uni/xmax*lim)/lim; 	% Simulate 10-bit Analog-to-Digital Converter
	sigm_n=sqrt((xmax/lim)^2/6/K); 
	WT=[20*ones(1,N/4)/K sigm_n*ones(1,N/4) 20*ones(1,N/4)/K sigm_n*ones(1,N/4)];
	WT(find(fn==0.35))=1;	% WT - true spectrum of signals x_uni and x_non
	WE=[sigm_n*ones(1,N/2) WT sigm_n*ones(1,N/2)]; 
	sigm_p=(xmax/lim)^2*6/N; % WE - extended true spectrum of signals x_uni and x_non
WP=[(20*ones(1,N/4)).^2/N sigm_p*ones(1,N/4) (20*ones(1,N/4)).^2/N sigm_p*ones(1,N/4)];
	WP(find(fn==0.35))=N;	% WP - true power spectal density of signals x_uni and x_non

% Nonuniform K-point complex-value sequence: x_non
x_ns=exp(i*(2*pi*0.35*t_n+PHT)); % Complex exponent at frequency 0.35
x_ni=20*sin(pi*(t_n-K/2)*0.25)./(pi*(t_n-K/2)).*exp(i*pi*0.25*(t_n-K/2));% Pulse [0 ... 0.25]
x_nn=sum(exp(i*2*pi*(f_x'*t_n+rand_ph)))/sqrt(K);% Band-limited noise [-0.5 ...-0.25]
x_non=x_ns+x_ni+x_nn;	% x_non - nonuniform composite test sequence
x_non=xmax*round(x_non/xmax*lim)/lim; % Simulate 10-bit Analog-to-Digital Converter

% Sparse sequences (NaNs inserted):
% x_u48 - sequence x_uni with 1/4 missing samples
% x_u40 - sequence x_uni with 3/8 missing samples
% x_u32 - sequence x_uni with 1/2 missing samples
% Generate missing samples numbers for sequences x_u48, x_u40, x_u32
	x_u48=x_uni;x_u40=x_uni;x_u32=x_uni;
	x_48=x_uni;x_40=x_uni;x_32=x_uni;
	f2k=floor(K/2);
	k32=(1:2:f2k*2)+round(rand(1,f2k));
	k24=k32(round(1:4/3:f2k));
	k16=k32(1:2:f2k);
% Insert zeros (FFT input) or NaNs (EDFT input) where samples are missing
x_48(k16)=zeros(1,length(k16));	% x_48 - sparse data with 1/4 (16) zeros (FFT input)
x_u48(k16)=NaN*ones(1,length(k16));	% x_u48 - sparse data with 1/4 (16) NaNs (EDFT input)
x_40(k24)=zeros(1,length(k24));	% x_40 - sparse data with 3/8 (24) zeros (FFT input)
x_u40(k24)=NaN*ones(1,length(k24));	% x_u40 - sparse data with 3/8 (24) NaNs (EDFT input)
x_32(k32)=zeros(1,length(k32));	% x_32 - sparse data with 1/2 (32) zeros (FFT input)
x_u32(k32)=NaN*ones(1,length(k32));	% x_u32 - sparse data with 1/2 (32) NaNs (EDFT input)

% Marple&Kay 64-point data set x_mak /apmplified two times/ 
x_mak=2*[1.291061 -2.086368 -1.691316 1.243138 1.641872 -0.008688 -1.659390 -1.111467 ...
0.985908 1.991979 -0.046613 -1.649269 -1.040818 1.054665 1.855816 -0.951182 -1.476495 ...
-0.212242 0.780202 1.416003 0.199282 -2.027026 -0.483577 1.664913 0.614114 -0.791469 ...
-1.195311 0.119801 0.807635 0.895236 -0.012734 -1.763842 0.309840 1.212892 -0.119905 ...
-0.441686 -0.879733 0.306181 0.795431 0.189598 -0.342332 -0.328700 0.197881 0.071179 ...
0.185931 -0.324595 -0.366092 0.368467 -0.191935 0.519116 0.008328 -0.425946 0.651478 ...
-0.639978 -0.344389 0.814130 -0.385168 0.064218 -0.380008 -0.163008 1.180961 0.114206 ...
-0.667626 -0.814997];
KK=64;
Emk=exp(-i*2*pi*(0:KK-1).'*fn);	

% Generate white Gaussian noise sequence x_wgn - K uniform samples	
	x_wgn=randn(1,K);

% Calculate DFTs
	disp('Calculating DFT output...');	
	dft_x_uni=fftshift(fft(x_uni,N))/K;
	dft_x_ue=x_uni*Eue/K;
	dft_x_non=x_non*En/K;
	dft_x_ne=x_non*Ene/K;
	fft_xmak=fft(x_mak,N);
	fft_xwgn=fft(x_wgn,N);
	dft_x_mak=fftshift(fft_xmak)/length(x_mak);
	dft_x_48=fftshift(fft(x_48,N))/length(x_48);
	dft_x_40=fftshift(fft(x_40,N))/length(x_40);
	dft_x_32=fftshift(fft(x_32,N))/length(x_32);

% Calculate EDFTs
	disp('Calculating Extended DFT (EDFT) output...');
	[F1,S1]=edft(x_uni,N,it);
	S1b=fftshift(S1);F1b=fftshift(F1);
	[F1a,S1a]=edft(x_uni,N,1,fftshift(WT));
	[F2,S2]=nedft(x_non,t_n,fn,it);
	[F2a,S2a]=nedft(x_non,t_n,fn,1,WT);
	[F3a,S3a]=nedft(x_uni,t_u,fne);
	[F3b,S3b]=nedft(x_non,t_n,fne);
	[F4a,S4a]=edft(x_u48,N);
	[F4b,S4b]=edft(x_u40,N);
	[F4c,S4c]=edft(x_u32,N);
	[F6b,S5b]=edft(x_mak,N,it);
	F7b=edft(x_wgn,N,it);

% Calculate HRDFTs
	disp('Calculating High-Resolution DFT (HRDFT) output...');
	W=ones(1,N);			% Initial conditions W for Marple&Kay sequence
	W1=ones(1,N);			% Initial conditions W1 for white Gaussian noice
	for l=1:it
	fh56=edft(x_mak,N,1,W);		% Perform one EDFT iteration with weight W
	fh7=edft(x_wgn,N,1,W1);		% Perform one EDFT iteration with weight W1
       	W=fh56/N;			% Calculate weights as by HRDFT 
	W1=fh7/N;			% definition for the next iteration
	end 

% Calculate plots on figures 1-7
% Figure 1
       	dft_f1=20*log10(abs(dft_x_uni));
	edft_f1a=20*log10(abs(fftshift(S1a)));
       	edft_f1b=20*log10(abs(S1b));
	dft_f1c=10*log10(abs(K*dft_x_uni).^2/N);
       	edft_f1c=10*log10(abs(F1b).^2/N);
	edft_f1d=real(F1b./S1b/K);
% Figure 2
       	dft_f2=20*log10(abs(dft_x_non));
	edft_f2a=20*log10(abs(S2a));
       	edft_f2b=20*log10(abs(S2));
       	dft_f2c=10*log10(abs(K*dft_x_non).^2/N);
       	edft_f2c=10*log10(abs(F2).^2/N);
	edft_f2d=real(F2./S2/K);
% Figure 3
	dft_f3a=20*log10(abs(dft_x_ue));
	edft_f3a=20*log10(abs(S3a));
	dft_f3b=20*log10(abs(dft_x_ne));
	edft_f3b=20*log10(abs(S3b));
	edft_f3c=real(F3b./S3b/K/2);
% Figure 4
      	dft_f4a=20*log10(abs(dft_x_48));
      	edft_f4a=20*log10(abs(fftshift(S4a)));
      	dft_f4b=20*log10(abs(dft_x_40));
      	edft_f4b=20*log10(abs(fftshift(S4b)));
      	dft_f4c=20*log10(abs(dft_x_32));
      	edft_f4c=20*log10(abs(fftshift(S4c)));
% Figure 5
	dft_f5a=20*log10(abs(dft_x_mak));
    	edft_f5b=20*log10(abs(fftshift(S5b)));
       	hrf_f5c=20*log10(abs(fftshift(fh56/N))+eps);
% Figure 6
	ifft_f6a=real(ifft(fft_xmak));
	iedft_f6b=real(ifft(F6b));
	ihrdft_f6c=real(ifft(fh56));
% Figure 7
	ifft_f7a=real(ifft(fft_xwgn));
	iedft_f7b=real(ifft(F7b));
	ihrdft_f7c=real(ifft(fh7));

% Plot figures...
% Figure 1: True spectrums (red), DFT (blue) and non-iterative estimate by EDFT              
	figure(1)
	clf
	db_min=-80;			% Axis min [db]
	db_max=10;			% axis max [db]
	%True spectrum for test sequences in Subplot 1 and 2
	true_sp=20*log10(WT);		% True Power spectrum of test sequences 1 and 2
	true_psd=10*log10(WP);		% True PSD of test sequences 1 and 2	
	subplot(411)
	plot(fn,true_sp,'r-',fn,dft_f1,'b-',fn,edft_f1a)% Plot True, DFT, non-iterative EDFT
	axis([-0.5 0.5 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
title('UNIFORM sequence: (a) - True Power Spectrum [red], DFT [blue] and non-iterative EDFT')
	subplot(412)
	plot(fn,true_sp,'r-',fn,dft_f1,'b-',fn,edft_f1b) % Plot True, DFT and EDFT
	axis([-0.5 0.5 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
title(['(b) - True Power Spectrum [red], DFT [blue] and EDFT ',int2str(it),'th iteration'])
	subplot(413)
	plot(fn,true_psd,'r-',fn,dft_f1c,'b-',fn,edft_f1c) % Plot True, DFT and EDFT
	axis([-0.5 0.5 db_min db_max+30])
	xlabel('Frequency')
	ylabel('PSD [dB]')
	title(['(c) - True PSD [red], DFT [blue] and EDFT ',int2str(it),'th iteration'])
	subplot(414)
	plot(fn,ones(1,N),'b-',fn,edft_f1d)	% Plot DFT and EDFT relative resolution
	axis([-0.5 0.5 0 ceil(N/K)])
	xlabel('Frequency')
	ylabel('Resolution')
	title(['(d) - Relative frequency resolution of DFT [blue] and EDFT ',int2str(it),'th iteration'])
	
% Figure 2: True spectrums (red) and estimates, DFT (blue), EDFT 15th iteration           
	figure(2)
	clf
	subplot(411)
	plot(fn,true_sp,'r-',fn,dft_f2,'b-',fn,edft_f2a)% Plot True, DFT, non-iterative EDFT
	axis([-0.5 0.5 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
title('NONUNIFORM sequence: (a) - True Power Spectrum [red], DFT [blue] and non-iterative EDFT')
	subplot(412)
	plot(fn,true_sp,'r-',fn,dft_f2,'b-',fn,edft_f2b);% Plot spectrum- True, DFT, EDFT
	axis([-0.5 0.5 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
title(['(b) - True Power Spectrum [red], DFT [blue] and EDFT ',int2str(it),'th iteration'])
	subplot(413)
	plot(fn,true_psd,'r-',fn,dft_f2c,'b-',fn,edft_f2c);% Plot PSD - True, DFT, EDFT
	axis([-0.5 0.5 db_min db_max+30])
	xlabel('Frequency')
	ylabel('PSD [dB]')
	title(['(c) - True PSD [red], DFT [blue] and EDFT ',int2str(it),'th iteration'])
	subplot(414)
	plot(fn,ones(1,N),'b-',fn,edft_f2d)	% Plot DFT and EDFT relative resolution
	axis([-0.5 0.5 0 ceil(N/K)])
	xlabel('Frequency')
	ylabel('Resolution')
title(['(d) - Relative frequency resolution of DFT [blue] and EDFT ',int2str(it),'th iteration'])

% Figure 3: Extended True spectrums (red) and estimates by DFT (blue) and EDFT              
	figure(3)
	clf
	true_e=20*log10(WE);	% Extended True spectrum of test sequences 1 and 2
	subplot(311)
	plot(fne,true_e,'r-',fne,dft_f3a,'b-',fne,edft_f3a) % Spectrums- True, DFT, EDFT
	axis([-1 1 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
title(['UNIFORM sequence: (a) - True Power Spectrum [red], DFT [blue] and EDFT'])
	subplot(312)
	plot(fne,true_e,'r-',fne,dft_f3b,'b-',fne,edft_f3b) % Spectrums- True, DFT, EDFT
	axis([-1 1 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
title(['NONUNIFORM sequence: (b) - True Power Spectrum [red], DFT [blue] and EDFT'])
	subplot(313)
	plot([-0.5 0;-0.25 0.25],[1 1;1 1],'r:');
	axis([-1 1 0 ceil(N/K)])
	hold on
	line([0.35; 0.35],[N/K; 0],'linestyle',':','color','r')
	plot(fne,ones(1,2*N)/2,'b-',fne,edft_f3c)	% Plot DFT and EDFT relative resolution
	hold off
	xlabel('Frequency')
	ylabel('Resolution')
title(['NONUNIFORM sequence: (c) - Relative frequency resolution of DFT [blue] and EDFT'])

% Figure 4: True spectrums (red), DFT (blue) and EDFT estimate for sequences with NaNs             
	figure(4)
	clf
	subplot(311)
	plot(fn,true_sp,'r-',fn,dft_f4a,'b-',fn,edft_f4a) % Spectrums for sequence with 16 NaNs 
	axis([-0.5 0.5 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
title('True Power Spectrum [red], DFT [blue] and EDFT. UNIFORM sequence: (a) - 16 lost samples' )
	subplot(312)
	plot(fn,true_sp,'r-',fn,dft_f4b,'b-',fn,edft_f4b) % Spectrums for sequence with 24 NaNs
	axis([-0.5 0.5 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('UNIFORM sequence: (b) - 24 lost samples')
	subplot(313)
	plot(fn,true_sp,'r-',fn,dft_f4c,'b-',fn,edft_f4c) % Spectrums for sequence with 32 NaNs
	axis([-0.5 0.5 db_min db_max])
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('UNIFORM sequence: (c) - 32 lost samples')

% Figure 5: True spectrums (red) and estimates by DFT, EDFT, HRDFT of Marple&Kay sequence
	figure(5)
	clf
	subplot(311)
	fr_true=[0.1 0.2 0.21; 0.1 0.2 0.21;]; % True spectrum for Marple&Kay test sequence
	amp_true=[-20 0 0; db_min db_min db_min];
	col_n=15*log10(0.1*(sin(pi*(eps:0.001:1))).^2); % Colored noice as described in [1]
	plot(0.2:0.0003:0.5,col_n,'-r')
	axis([0 0.5 db_min db_max])
	hold on 
	line(fr_true,amp_true,'linestyle','-','color','r')
	plot(fn,dft_f5a)			% Plot DFT Power Spectrum
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Marple&Kay sequence: (a) - True Power Spectrum [red] and DFT')
	subplot(312)
	plot(0.2:0.0003:0.5,col_n,'-r')
	axis([0 0.5 db_min db_max])
	hold on
	line(fr_true,amp_true,'linestyle','-','color','r')
	plot(fn,edft_f5b)			% Plot EDFT Power Spectrum
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title(['(b) - True Power Spectrum [red] and EDFT ',int2str(it),'th iteration'])
	subplot(313)
	plot(0.2:0.0003:0.5,col_n,'-r')
	axis([0 0.5 db_min db_max])
	hold on  
	line(fr_true,amp_true,'linestyle','-','color','r')
	plot(fn,hrf_f5c)			% Plot HRDFT Power Spectrum
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title(['(c) - True Power Spectrum [red] and HRDFT ',int2str(it),'th iteration'])

% Figure 6: Plot Marple&Kay sequence and reconstructed data by DFT, EDFT and HRDFT.
	figure(6)
	clf
	subplot(311)
	x_m6=max(abs(ihrdft_f6c));
	plot(ifft_f6a)			% Plot Inverse DFT sequence
	axis([0 N+1 -x_m6 x_m6])
	hold on
	plot(x_mak,'b-')			% Plot Marple&Kay sequence
	hold off
	xlabel('Sample number')
	ylabel('Magnitude')
	title('Marple&Kay sequence: (a) - True (blue) and reconstructed by Inverse DFT')
	subplot(312)
	plot(iedft_f6b)			% Plot Inverse EDFT sequence
	axis([0 N+1 -x_m6 x_m6])
	hold on
	plot(x_mak,'b-')			% Plot Marple&Kay sequence
	hold off
	xlabel('Sample number')
	ylabel('Magnitude')
	title('(b) - True (blue) and reconstructed by Inverse EDFT')
	subplot(313)
	plot(ihrdft_f6c)			% Plot Inverse HRDFT sequence
	axis([0 N+1 -x_m6 x_m6])
	hold on
	plot(x_mak,'b-')			% Plot Marple&Kay sequence
	hold off
	xlabel('Sample number')
	ylabel('Magnitude')
	title('(c) - True (blue) and reconstructed by Inverse HRDFT')

% Figure 7: Plot white Gaussian noice sequence and reconstructed data by DFT, EDFT and HRDFT.
	figure(7)
	clf
	subplot(311)
	x_m7=max(abs(ihrdft_f7c));
	plot(ifft_f7a)			% Plot Inverse DFT sequence
	axis([0 N+1 -x_m7 x_m7])
	hold on
	plot(x_wgn,'b-')			% Plot white Gaussian noice sequence
	hold off
	xlabel('Sample number')
	ylabel('Magnitude')
title('White Gaussian noice sequence: (a) - True (blue) and reconstructed by Inverse DFT')
	subplot(312)
	plot(iedft_f7b)			% Plot Inverse EDFT sequence
	axis([0 N+1 -x_m7 x_m7])
	hold on
	plot(x_wgn,'b-')			% Plot white Gaussian noice sequence
	hold off
	xlabel('Sample number')
	ylabel('Magnitude')
	title('(b) - True (blue) and reconstructed by Inverse EDFT')
	subplot(313)
	plot(ihrdft_f7c)			% Plot Inverse HRDFT sequence
	axis([0 N+1 -x_m7 x_m7])
	hold on
	plot(x_wgn,'b-')			% Plot white Gaussian noice sequence
	hold off
	xlabel('Sample number')
	ylabel('Magnitude')
	title('(c) - True (blue) and reconstructed by Inverse HRDFT')

%% NOTE: Code below is commented because of power spectrums coincide with EDFT (Figure 5b).
%% Calculate Capon filter output and GWLS of Marple&Kay sequence and Power spectrums
%	disp('Calculating Capon filter output...');
%	x_mr=(flipud(x_mak.')).';	% Re-ordering Marple&Kay sequence for Capon filter input
%	W3=ones(1,N);		% Initial conditions for iterative algorithm
%	for l=1:it
%	r=ifft(fftshift(W));		% Calculate autocorrelation function by applying ifft
%	RT=toeplitz(r(1:KK)).';	% Compose and transpose the autocorrelation matrix
%	ER=inv(RT)*conj(Emk);
%	sc1=(x_mr*ER)./sum(Emk.*ER);% Calculate amplitude spectrum for iteration (l)
%	W3=sc1.*conj(sc1);	% Weight for the next iteration
%	end
%	cap_f6a=20*log10(abs(sc1));
%	disp('Calculating GWLS solution output...');
%	W4=ones(1,N);		% Initial conditions for iterative algorithm
%	for l=1:it
%	r=ifft(fftshift(W4));		% Calculate autocorrelation function by applying ifft
%	RT=toeplitz(r(1:KK)).';	% Compose and transpose the autocorrelation matrix
%	ER=Emk.'*inv(RT);
%	sc2=((ER*x_mak.').')./sum(conj(Emk).*ER.'); % Calculate spectrum of iteration (l)
%	W4=sc2.*conj(sc2);	% Weight for the next iteration
%	end
%	gwls_f6b=20*log10(abs(sc2));
%% Figure 8: Plot True spectrum (red) and estimates by DFT (blue), Capon filter and GWLS 
%	figure(8)
%	clf
%	subplot(211)
%	plot(0.2:0.0003:0.5,col_n,'-r') 
%	axis([0 0.5 db_min db_max])
%	hold on
%	line(fr_true,amp_true,'linestyle','-','color','r')  
%	plot(fn,dft_f4a,'b-',fn,cap_f6a)	 % Plot DFT and Capon filter Power Spectrums
%	hold off
%	xlabel('Frequency')
%	ylabel('Power [dB]')
% title(['Marple&Kay sequence: (a) - True Power Spectrum [red], DFT [blue] and Capon filter ',int2str(it),'th iteration'])
%	subplot(212)
%	plot(0.2:0.0003:0.5,col_n,'-r') 
%	axis([0 0.5 db_min db_max])
%	hold on
%	line(fr_true,amp_true,'linestyle','-','color','r')
%	plot(fn,dft_f4a,'b-',fn,gwls_f6b)	% Plot DFT and GWLS solution Power Spectrums
%	hold off
%	xlabel('Frequency')
%	ylabel('Power [dB]')
% title(['(b) - True Power Spectrum [red], DFT [blue] and GWLS solution ',int2str(it),'th iteration'])