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



clear; clc;

%option parameter
T = 1.0;                    %option maturity
t0 = 0.0;                   %current time
S0 = 100;                   %spot price of underlying asset
d = 0.0;                    %dividend yield
df = 1.0;                   %discount factor
vecK = [1;(5:5:200)'];            %strike vector
ID = 1;                     %option Type ( call = 1, put = 2 )

%vaiance gamma model parameter (nu, sigma, theta)
sigma = 0.25;  nu = 2; theta = -.1;        

params(1) = 1/nu;
params(2) = 1/(sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)-0.5*theta*nu); 
params(3) = 1/(sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)+0.5*theta*nu);

% modelbuilder
mbd = modelbuilderdirector();
vg.c = params(1); vg.g = params(2); vg.m = params(3); vg.cgm = true;
vg.usec = true; vg.useg = true; vg.usem = true;

mbd.setmodelbuilder(vgmodelbuilder());
model = mbd.buildmodel(vg, 'eq');
    
%fft parameter
vecN = (8:13)'; eta = 0.1;

%dampening parameter of carr/madan
alpha = 1.5;                
%volatility parameter for black scholes wise method
sigmabs = 0.4;

matPrice = zeros(length(vecK),length(vecN));

for i = 1:length(vecN)
% black/scholes-wise method
%     fftpricer = fftbs(vecN(i),eta,alpha,sigmabs,model);
%     matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK./S0,ID);    
% cosine method 
%    fftpricer = fftcos(vecN(i),12,@model.cf,model);
%    matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK./S0,ID);
% carr/madan
%     fftpricer = fftcm(vecN(i),eta,alpha,model);
%     matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK/S0,ID);
% lewis method
     fftpricer = fftlewis(vecN(i),eta,model);
     matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK./S0,ID);
end

figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1); box('on'); hold('all');

plot1 = plot(vecK,log10(abs(repmat(matPrice(:,end),1,length(vecN)-1) ...
    - matPrice(:,1:end-1))),'Parent',axes1,'Color',[0 0 0]);
set(plot1(1),'Marker','x','LineStyle','-');
set(plot1(2),'Marker','diamond','LineStyle','-');
set(plot1(3),'Marker','square','LineStyle','-');
set(plot1(4),'Marker','o','LineStyle','-');
set(plot1(5),'Marker','v','LineStyle','-');

xlabel('Strike')
ylabel(strcat({'Log_{10}(C_{'},num2str(2.^vecN(end)),'} - C_N)'), ...
    'Interpreter', 'tex','Position',[-15 -3])
legend(strcat({'N = '} ,num2str(2.^vecN(1:end-1))), ...
    'Position',[0.7264 0.174 0.1476 0.2409])
