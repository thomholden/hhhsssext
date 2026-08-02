% This m-file compiles and test
% a MEX file making use of the FFTmt
% source to do FFTs in multi-threads.

% The FFTmt.cpp file should be in the same  folder.

% Works only on UNIX/LINUX, assuming "pthreads" are supported
% Our test system is Fedora Core 5, 64 bits, AMD opteron dual core.

% Open FFTmt.cpp to change the number of threads (line : #define numCPU 2).

% Real odd fft has a smaller speedup ratio, see FFTmt.cpp for the reason.

% Jerome Genest and Simon Potvin, August 2006
% Centre d'optique, photonique et laser (COPL)
% Universite Laval
% Quebec, Canada

close all
clear all
clc

mex FFTmt.cpp

%%% Input parameters
N =2;
Nfft=256;
Lenfft=2^14;


time_rFFTmt=[];
time_InvrFFTmt=[];
time_rfft=[];
time_Invrfft=[];
time_cFFTmt=[];
time_InvcFFTmt=[];
time_cfft=[];
time_Invcfft=[];


for i=1:N
    
    a=rand(Lenfft,Nfft);
    %%% Real fft Test
    tic;
    Rmt=FFTmt(a,1);
    time_rFFTmt = [time_rFFTmt toc];
    
    tic;
    RmtInv=FFTmt(a,-1);
    time_InvrFFTmt = [time_InvrFFTmt toc];
    
    tic;
    R=fft(a);
    time_rfft = [time_rfft toc];
    
    tic;
    RInv=ifft(a);
    time_Invrfft = [time_Invrfft toc];
    
    
    a=a+sqrt(-1).*rand(Lenfft,Nfft);    
    %%% Complex fft Test
    tic;
    Cmt=FFTmt(a,1);
    time_cFFTmt = [time_cFFTmt toc];
    
    tic;
    CmtInv=FFTmt(a,-1);
    time_InvcFFTmt = [time_InvcFFTmt toc];
    
    tic;
    C=fft(a);
    time_cfft = [time_cfft toc];
    
    tic;
    CInv=ifft(a);
    time_Invcfft = [time_Invcfft toc];

end

error_cFFTmt=Cmt-C;
error_rFFTmt=Rmt-R;
error_InvcFFTmt=CmtInv-CInv;
error_InvrFFTmt=RmtInv-RInv;

ratioTime_Complex=time_cfft./time_cFFTmt
ratioTime_ComplexInv=time_Invcfft./time_InvcFFTmt
ratioTime_Real=time_rfft./time_rFFTmt
ratioTime_RealInv=time_Invrfft./time_InvrFFTmt


