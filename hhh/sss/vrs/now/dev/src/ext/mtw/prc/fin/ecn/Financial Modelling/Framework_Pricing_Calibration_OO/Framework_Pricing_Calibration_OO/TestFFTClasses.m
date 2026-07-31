% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [FFTopt, rmsec, aapc, aaec, arpec, runt] = TestFFTClasses(P_struct, model,params)          
% calculating call prices in VG model by FFT based on Carr, Madan 1999 and Tankov
S0 = P_struct.S0;
df = P_struct.df;
d = P_struct.d;
dataT = P_struct.dataT;

dataK = P_struct.dataK;
dataO = P_struct.dataOpt;

type = P_struct.type;

[rows, cols] = size(dataO);

t_star = P_struct.t_star;       % fwd start at t_star

FFTopt = ones(rows,cols);       % initializing matrix -> stores the model prices 

alpha = 1.5;                    % dampening parameter
                               
bsvolatility = 0.34;            % black scholes vol used for bs method

if(type == 1 || type == 2 || type == 11)
    % constructior fftcm(N,lambda,charfunc); N exponent 2^N, lambda ...
    fftpricer = fftcm(14,.1,alpha,model);
else
    fftpricer = fftbs(14,.1,alpha, bsvolatility,model);
end

% bind part

price = @(T,df) fftpricer.price(T,t_star,S0, d,df,params,dataK,ones(size(dataK)));

% looped version
tic;
if(rows > 0 && cols >0)
    for j=1:cols    %wrt time
        FFTopt(:,j) = price(dataT(j),df(j));
    end
else
   
end
cl1 = toc;
fprintf('\n Time for loop: %s', cl1);

% Vecotrized Version
tic
              
FFTopt1 = fftpricer.price(P_struct.dataT, ...
                  P_struct.t_star, ...
                  P_struct.S0, ...
                 P_struct.d, ...
                  P_struct.df, ...
                  params, ...
                 P_struct.dataK, ...
                  P_struct.dataOptType);

cl2 = toc;
fprintf('\n Time price5: %s', cl2);

fprintf('\n Time advatage for vec: %s', (cl1-cl2)/cl1);
FFTopt = FFTopt .* (FFTopt>0);
%Computing the errors

weights = ones(rows, cols);

objectivefunction = objectivefunc(dataO,FFTopt,weights);

rmsec = rmse_base(objectivefunction);    
aapc  = aae_base(objectivefunction);     
aaec  = ape_base(objectivefunction);     
arpec = arpe_base(objectivefunction);    

runt = 1;
figure; surf(FFTopt);
figure; surf(FFTopt1);
clear fftpricer;
clear objectivefunction;
end