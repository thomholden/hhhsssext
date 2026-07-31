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


% This is the test script for pricing CMS Spread Options
% This covers material from Chapter 4

InitVariables                            % Call to init example parameters

% scenarios for comparison
kappavec = [kappa-0.05 kappa  kappa+0.05];% scenario values for kappa
xivec = [xi-.5 xi xi+.5];                 % scenario values for xi

price= ones(size(K,1),3);                % output variable

% price CMS Spread with different kappa values
for k = 1:3
    price(:,k) = CMS_new( TimeGrid,K,fixingTime,endTime1,endTime2,kappavec(k),xi,delta,V,a,b,c,d,coeff1, coeff2, nu, eta, w,N,discountRates,Basis );
end
% output
figure('Color',[1 1 1]);
bar(K,price,1); title('CMS Spread Call Prices for different \kappa');
xlabel('Strike'); ylabel('Price (bp)');

% price CMS Spread with different xi values
for k = 1:3
    if k==2
    else
        price(:,k) = CMS_new( TimeGrid,K,fixingTime,endTime1,endTime2,kappa,xivec(k),delta,V,a,b,c,d,coeff1, coeff2, nu, eta, w,N,discountRates,Basis );
    end
end
% output
figure('Color',[1 1 1]);
bar(K,price,1); title('CMS Spread Call Prices for different \nu');
xlabel('Strike'); ylabel('Price (bp)');

% price CMS with different yield curves
discountRates = [0.985169904746796;0.969603417144602;0.953519883690517; ...
    0.937072285590863;0.920373645632750;0.903510864949698;0.886552715323107; ...
    0.869554800715134;0.852562813781781;0.835614770440747;0.818742599951822; ...
    0.801973311199580;0.785329870362619;0.768831876083534;0.752496088859194; ...
    0.736336853104236;0.720366438622605;0.704595320492679;0.689032411146406; ...
    0.673685254812677;0.658560191951215;0.643662499478890;0.628996511260826; ...
    0.614565722355520;0.600372879766439;0.586420061893654;0.572708748450192; ...
    0.559239882275316;0.546013924216600;0.533030902047023;0.520290454219452; ...
    0.507791869129272;0.495534120449490;0.483515899015890;0.471735641668668; ...
    0.460191557398297;0.448881651094625;0.437803745157532;0.426955499193344];
zeroRates = -log(discountRates)./TimeGrid;
discountRates1 = exp(-(zeroRates-0.01).*TimeGrid);  % rates 1
discountRates2 = exp(-(zeroRates+0.01).*TimeGrid);  % rates 2


price(:,1) = CMS_new( TimeGrid,K,fixingTime,endTime1,endTime2,kappa, ...
    xivec(k),delta,V,a,b,c,d,coeff1, coeff2, nu, eta, w,N,discountRates1,Basis );
price(:,2) = CMS_new( TimeGrid,K,fixingTime,endTime1,endTime2,kappa, ...
    xivec(k),delta,V,a,b,c,d,coeff1, coeff2,nu, eta, w,N,discountRates,Basis );
price(:,3) = CMS_new( TimeGrid,K,fixingTime,endTime1,endTime2,kappa, ...
    xivec(k),delta,V,a,b,c,d,coeff1, coeff2,nu, eta, w,N,discountRates2,Basis );

% output
figure('Color',[1 1 1]);
bar(K,price,1); title('CMS Spread Call Prices for different Curves (+/- 1%)');
xlabel('Strike'); ylabel('Price (bp)');

clear; clc;