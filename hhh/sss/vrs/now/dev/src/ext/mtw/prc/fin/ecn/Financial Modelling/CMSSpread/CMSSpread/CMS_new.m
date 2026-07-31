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


function [ CMScaplet ] = CMS_new( TimeGrid,K,fixingTime,endTime1,endTime2,...
    kappa,xi,delta,V,a,b,c,d,coeff1, coeff2, nu, eta,w,N,discountRates,Basis )
% Pricing CMS Spread Optionen in a Stochastic Volatility Libor Market Model
% with time-dependent displacement, volatility and mean reversion
%
% The valuation is based on the paper by Lutz/Kiesel 2010.
% The method is described in Chapter 4 of the book
%      Financial Modelling  - Theory, Implementation and Practice with
%      Matlab
% It applies Parameter Averaging and is implemented in a
% sequential fashion without function calls for gaining speed

tic; % start the timing
% calculation of the corresponding index in the array
fix=fixingTime/Basis; end1=fix+endTime1/Basis; end2=fix+endTime2/Basis;

N=max(N,max(end1+1,end2+1));

% yield curve
dates=daysadd(today,(TimeGrid)*360);
curve=IRDataCurve('discount',today,dates,discountRates, ...
    'Basis',2,'InterpMethod','spline');

% yield curve calcualtion
T = Basis:Basis:(N)*Basis;                    % tenor structre
L = curve.getForwardRates(today+T*360)';      % Libor rates
P = curve.getDiscountFactors(today+T*360)';   % discounts
tau = Basis.*ones(size(P));                   % year fraction

% Parameter Averaging for displacement coefficient beta of SR1
%   determine the coefficients for computing sigmaSR and sigmaSRsquared
annuity = cumsum(tau.*P);
annuity1 = annuity(end1)-annuity(fix); annuity2=annuity(end2)-annuity(fix);

S1 = (P(fix)-P(end1))/annuity1; S2 = (P(fix)-P(end2))/annuity2; 

endmax = max(end1,end2);

tmp = P(fix:endmax-1); tmp2 = P(fix+1:endmax);
q1 = zeros(1,endmax-1); q2 = zeros(1,endmax-1);

q1(fix:max(end1,end2)-1) = (tmp-tmp2)./tmp.*(P(end1)/(P(fix)-P(end1))...
    +(annuity(end1)-annuity(fix:endmax-1))/annuity1);
q2(fix:max(end1,end2)-1) = (tmp-tmp2)./tmp.*(P(end2)/(P(fix)-P(end2))...
    +(annuity(end2)-annuity(fix:endmax-1))/annuity2);

tmp=@(t) (V^2 ...
    * quadv(@(t) sigmaSRsquared(t,fix,end1,T,q1,a,b,c,d,nu,eta),0,t)...
    + V*xi^2*exp(-kappa*t) ...
    * quadv(@(t) sigmaSRsquared(t,fix,end1,T,q1,a,b,c,d,nu,eta) ...
    * (exp(kappa*t)-exp(-kappa*t))/(2*kappa),0,t))... 
    * sigmaSRsquared(t,fix,end1,T,q1,a,b,c,d,nu,eta);
tmp2=@(t) tmp(t)*betaSR(t,fix, end1,T,q1,a,b,c,d, nu,eta, coeff1, coeff2);

% averaged beta_1
betaQuer1=quadv(tmp2,realmin,T(fix))/quadv(tmp,realmin,T(fix)); 

% Parameter Averaging for the volatility sigma of SR1
tmp=@(t) sigmaSRsquared(t,fix,end1,T,q1,a,b,c,d,nu,eta);
zeta1 = V * quadv(tmp,realmin,T(fix));

tmp2 = @(t,y)odefkt(y,kappa,xi,1/(2*zeta1) ...
    + betaQuer1^2/8,sigmaSRsquared(t,fix,end1,T,q1,a,b,c,d,nu,eta),V);
lsg = ode23(tmp2,[0,T(fix)],[0 0]);

tmp2 = exp(lsg.y(1,length(lsg.x))-V*lsg.y(2,length(lsg.x)));
tmp = @(x) fHut(x.^2.*(1/(2*zeta1)+betaQuer1^2/8),kappa,xi,T(fix),V)-tmp2;
xval = 0:0.01:1; yval = tmp(xval);
lowval = max(xval(yval<0)); highval = max(xval(yval>0));

sigmaQuer1=fzero(tmp,[lowval,highval]);        % averaged sigma_1


% Parameter Averaging for the displacement beta for SR2
tmp3=@(t) (V^2 ...
    * quadv(@(t)sigmaSRsquared(t,fix,end2,T,q2,a,b,c,d,nu,eta),0,t) ...
    + V*xi^2*exp(-kappa*t) ...
    * quadv(@(t) sigmaSRsquared(t,fix,end2,T,q2,a,b,c,d,nu,eta) ...
    * (exp(kappa*t)-exp(-kappa*t))/(2*kappa),0,t)) ...
    * sigmaSRsquared(t,fix,end2,T,q2,a,b,c,d,nu,eta);
tmp2=@(t) tmp3(t) * betaSR(t,fix, end2,T,q2,a,b,c,d,nu,eta,coeff1, coeff2);

% averaged beta_2
betaQuer2=quadv(tmp2,realmin,T(fix))/quadv(tmp3,realmin,T(fix));    

% Parameter Averaging for the volatility sigma for SR2
tmp=@(t) sigmaSRsquared(t,fix,end2,T,q2,a,b,c,d,nu,eta);

zeta2 = V*quadv(tmp,realmin,T(fix));
tmp2 = @(t,y) odefkt(y,kappa,xi,1/(2*zeta2)+betaQuer2^2/8, ...
    sigmaSRsquared(t,fix,end2,T,q2,a,b,c,d,nu,eta),V);
lsg = ode23(tmp2,[0,T(fix)],[0 0]);
tmp2 =exp(lsg.y(1,length(lsg.x))-V*lsg.y(2,length(lsg.x)));
tmp = @(x) fHut(x.^2.*(1/(2*zeta2)+betaQuer2^2/8),kappa,xi,T(fix),V)-tmp2;
xval = 0:0.01:1; yval = tmp(xval);
lowval = max(xval(yval<0)); highval = max(xval(yval>0));

% averaged sigma_2
sigmaQuer2=fzero (tmp,[lowval,highval]);    

% Parameter Averaging for the correlation rho of SR1 and SR2
rhoQuer=0;
J=fix:end2-1;

for i=fix:end1-1
    tmp= @(t) q1(i).*sigma(T(i)-t,a,b,c,d) ...
        .* q2(J).*sigma(T(J)-t,a,b,c,d).*rho_new(T(i),T(J),t,nu,eta);
    rhoQuer = rhoQuer + sum(quadv(tmp,0,T(fix)));
end
  
rhoQuer=rhoQuer/(sqrt(zeta1*zeta2)/V);     % averaged correlation rho

% what is going on ?
Sigma=zeros(max(end1,end2)-fix);
J=1:max(end1,end2)-fix;

for i=1:max(end1,end2)-fix
    tmp=@(x) rho_new(T(i+fix),T(J+fix),x,nu,eta).*sigma(T(i+fix)-x,a,b,c,d) ...
        .* sigma(T(J+fix)-x,a,b,c,d);
    Sigma(i,J)=1/T(fix)*quadv( tmp,0,T(fix));
end

D=diag(L(fix:max(end1,end2)-1));

% numerically determine the gradients
gradF1 = zeros(1,(max(end1,end2)-fix));
gradG1 = gradF1; gradF2=gradF1; gradG2=gradF1;

gradF1(1:end1-fix) = tau(1-1+(fix-1):end1-fix-1+(fix-1))...
    .* P(1 +1+(fix-1):end1-fix +1+(fix-1))...
    ./(P(1 +(fix-1):end1-fix +(fix-1))*annuity1) ...
    .* (P(end1)+(P((fix))-P(end1))...
    .*(annuity(end1)-annuity(1 +(fix-1):end1-fix +(fix-1)))/annuity1);
gradF2(1:end2-fix) = tau(1-1+(fix-1):end2-fix-1+(fix-1))...
    .*P(1 +1+(fix-1):end2-fix +1+(fix-1))...
    ./(P(1 +(fix-1):end2-fix +(fix-1))*annuity2)...
    .*(P(end2)+(P((fix))-P(end2))...
    .*(annuity(end2)-annuity(1 +(fix-1):end2-fix +(fix-1)))/annuity2);
gradG1(delta+1:end1-fix) = tau(1+delta-1+(fix-1):end1-fix-1+(fix-1))...
    .*P(1+delta+1+(fix-1):end1-fix+1+(fix-1))...
    ./(P(1+delta+(fix-1):end1-fix+(fix-1)).*P(fix+delta))...
    .*(annuity(end1)-annuity(1+delta+(fix-1):end1-fix+(fix-1)));
gradG2(delta+1:end2-fix) = tau(1+delta-1+(fix-1):end2-fix-1+(fix-1))...
    .*P(1+delta+1+(fix-1):end2-fix+1+(fix-1))...
    ./(P(1+delta+(fix-1):end2-fix+(fix-1)).*P(fix+delta))...
    .*(annuity(end2)-annuity(1+delta+(fix-1):end2-fix+(fix-1)));

% convexity correction for SR1 and SR2
muQuer1 = P((fix)+delta)/annuity1*gradF1*D*Sigma*D*gradG1'; % convexity SR1
muQuer2 = P((fix)+delta)/annuity2*gradF2*D*Sigma*D*gradG2'; % convexity SR2
% 
muTilde1 = muQuer1*betaQuer1/S1;
muTilde2 = muQuer2*betaQuer2/S2;
sigmaTilde1=betaQuer1*sigmaQuer1; sigmaTilde2=betaQuer2*sigmaQuer2;
KTilde=(1-betaQuer1)/betaQuer1.*S1-(1-betaQuer2)/betaQuer2.*S2+K;

% determine the cms caplet prices
CMScaplet=zeros(size(K));

ulow = -5; uup = 5; vlow = realmin; vup = 100;
simp1 = 32; simp2 = 256;

for i=1:length(K)
    tmp=@(u,v) g_new( u,v,betaQuer1,betaQuer2, sigmaTilde1, sigmaTilde2, ...
        muTilde1,muTilde2, rhoQuer, S1,S2, KTilde(i), w)...
        .*DichteVar_new(v,T(fix),kappa,xi,V);
    CMScaplet(i)=P(fix+delta)/sqrt(2*pi) ...
        .*simp2D(tmp,ulow,uup,vlow,vup,simp1,simp2)/0.0001;
end
toc

end
