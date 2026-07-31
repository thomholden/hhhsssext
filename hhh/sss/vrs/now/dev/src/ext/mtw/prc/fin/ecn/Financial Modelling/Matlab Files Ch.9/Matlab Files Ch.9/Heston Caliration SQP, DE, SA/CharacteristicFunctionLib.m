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



function phi = CharacteristicFunctionLib(model,u,T,r,d,params)
%---------------------------------------------------------
% Characteristic Function Library of the following models:
%---------------------------------------------------------
% Black Scholes
% Merton Jump Diffusion
% Heston Stochastic Volatility Model
% Bates Stochastic Volatility / Jump Diffusion Model
% Variance Gamma
% Normal Inverse Gaussian
% Meixner
% Generalized Hyperbolic
% CGMY
%---------------------------------------------------------


ME1 = MException('VerifyInput:InvalidNrOfArguments',...
    'Invalid number of Input arguments');
ME2 = MException('VerifyInput:InvalidModel',...
    'Undefined Model');


if strcmp(model.ID,'BlackScholes')
    if length(params) == 1
        funobj = @Black_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'Heston')
    if length(params) == 5
        funobj = @Heston_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'Merton')
    if length(params) == 4
        funobj = @Merton_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'Bates')
    if length(params) == 8
        funobj = @Bates_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'VarianceGamma')
    if length(params) == 3
        funobj = @VG_characteristicFn;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'NIG')
    if length(params) == 4
        funobj = @NIG_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model.ID,'CGMY')
    if length(params) == 4
        funobj = @CGMY_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model.ID,'Meixner')
    if length(params) == 3
        funobj = @Meixner_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model.ID,'GH')
    if length(params) == 4
        funobj = @GH_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model.ID,'IntegratedCIR')
    if length(params) == 7
        funobj = @IntegratedCIR_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model.ID,'VarianceGammaOU')
    if length(params) == 6
        funobj = @VarianceGammaOU_characteristicFn;
    else
        throw(ME1)
    end
elseif strcmp(model.ID,'NIGCIR')
    if length(params) == 6
        funobj = @NIGCIR_characteristicFn;
    else
        throw(ME1)
    end
else
    throw(ME2)
end

phi = feval(funobj,u,T,r,d,params);

end


%% Explicit Implementation of the characteristic Functions E[exp(iu*lnS_T)]
%-----------------------------------------------------------------------

% Black Scholes    
function phi = Black_characteristicFn(u,T,r,d,params)
    sigma = params(1);
    %phi = exp(i*u*(lnS+(r-d-0.5*sigma*sigma)*T) - 0.5*sigma*sigma*u.*u*T);
     %phi = 1i*u*(lnS+(r-d-0.5*sigma*sigma)*T) - 0.5*sigma*sigma*u.*u*T;
      omega = -0.5*sigma*sigma;
      phi = 1i*u*((r-d+omega)*T) - 0.5*sigma*sigma*u.*u*T;
end

% Merton Jump Diffusion
function phi = Merton_characteristicFn(u,T,params)
    sigma = params(1); a = params(2); b = params(3); lambda = params(4);
    phi = Black_characteristicFn(u,T,sigma) + LogNormalJump_characteristicFn(u,T,[a;b;lambda]);
end

% Heston
function phi = Heston_characteristicFn(u,T,r,d,params)

vInst = params(1); vLong = params(2); kappa = params(3); 
omega = params(4); rho = params(5);
    
alfa = -0.5*(u.*u + u*1i);
beta = kappa - rho*omega*u*1i;

omega2 = omega * omega;
gamma = 0.5 * omega2;

D = sqrt(beta .* beta - 4.0 * alfa .* gamma);

bD = beta - D;
eDt = exp(- D * T);


G = bD ./ (beta + D);
B = (bD ./ omega2) .* ((1.0 - eDt) ./ (1.0 - G .* eDt));
psi = (G .* eDt - 1.0) ./(G - 1.0);
A = ((kappa * vLong) / (omega2)) * (bD * T - 2.0 * log(psi));

%phi = exp(A + B*V0 + i*u*(lnS+(r-d)*T));

phi = A + B*vInst +1i*u*(r-d)*T;

end
    
% Bates
function phi = Bates_characteristicFn(u,T,r,d,params)
    
    V0 = params(1); theta = params(2); kappa = params(3); 
    omega = params(4); rho = params(5); a = params(6);
    b = params(7); lambda = params(8);

    phiHes = Heston_characteristicFn(u,r,d,T,[V0;theta;kappa;omega;rho]);
    phi = phiHes + LogNormalJump_characteristicFn(u,T,[a;b;lambda]); 
end

% LogNormalJump for Merton and Bates
function phiJump = LogNormalJump_characteristicFn(u,T,params)

    a = params(1); b = params(2); lambda = params(3);

    %phiJump = exp(lambda*T*(-a*u*i + (exp(u*i*log(1.0+a)+0.5*b*b*u*i.*(u*i-1.0))-1.0)));
    phiJump = lambda*T*(-a*u*1i + (exp(u*1i*log(1.0+a)+0.5*b*b*u*1i.*(u*1i-1.0))-1.0));
end

% Variance Gamma
function phi = VG_characteristicFn(u,T,r,d,params)

    sigma = params(1); nu = params(2); theta = params(3);

    omega = (1/nu)*( log(1-theta*nu-sigma*sigma*nu/2) );
    tmp = 1 - 1i * theta * nu * u + 0.5 * sigma * sigma * u .* u * nu;
    %tmp = tmp.^(-T / nu);
    %phi = exp( i * u * (lnS + (r + omega - d) * T )) .* tmp;
    %phi = 1i * u * (lnS + (r + omega - d) * T ) - T*log(tmp)/nu;
    phi = 1i * u * (r-d+omega)* T  - T*log(tmp)/nu;
    
end

% Normal Inverse Gaussian
function phi = NIG_characteristicFn(u,T,r,d,params)

    alfa = params(1); beta = params(2); delta = params(3); mu = params(4);

    omega = delta*(sqrt(alfa*alfa-(beta+1)^2)-sqrt(alfa*alfa-beta*beta));
    %tmp = exp(i*u*mu*T-delta*T*(sqrt(alfa*alfa-(beta+i*u).^2)-sqrt(alfa*alfa-beta*beta)));
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp;
    tmp = 1i*u*mu*T-delta*T*(sqrt(alfa*alfa-(beta+1i*u).^2)-sqrt(alfa*alfa-beta*beta));
    phi = 1i*u*((r-d+omega)*T) + tmp;
end

% Meixner
function phi = Meixner_characteristicFn(u,T,r,d,params)

    alfa = params(1); beta = params(2); delta = params(3);

    omega = -2*delta*(log(cos(0.5*beta)) - log(cos((alfa+beta)/2)));
    tmp = (cos(0.5*beta)./cosh(0.5*(alfa*u-1i*beta))).^(2*T*delta);
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp;
    phi = 1i*u*((r-d+omega)*T) + log(tmp);
end

% Generalized Hyperbolic
function phi = GH_characteristicFn(u,T,r,d,params)

    alfa = params(1); beta = params(2); delta = params(3); nu = params(4);

    arg1 = alfa*alfa-beta*beta;
    arg2 = arg1-2*1i*u*beta + u.*u;
    argm = arg1-2*beta-1;
    omega = -log((arg1./argm).^(0.5*nu).*besselk(nu,delta*sqrt(argm))./besselk(nu,delta*sqrt(arg1)));
    tmp = (arg1./arg2).^(0.5*nu).*besselk(nu,delta*sqrt(arg2))./besselk(nu,delta*sqrt(arg1));
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp.^T;
    phi = 1i*u*((r-d+omega)*T) + log(tmp).*T;
end

% CGMY
function phi = CGMY_characteristicFn(u,T,r,d,params)

    C = params(1); G = params(2); M = params(3); Y = params(4);

    omega = -C*gamma(-Y)*((M-1)^Y-M^Y+(G+1)^Y-G^Y);
    %tmp = exp(C*T*gamma(-Y)*((M-i*u).^Y-M^Y+(G+i*u).^Y-G^Y));
    %phi = exp( i*u*(lnS + (r-d+m)*T)).*tmp;
    tmp = C*T*gamma(-Y)*((M-1i*u).^Y-M^Y+(G+1i*u).^Y-G^Y);
    phi = 1i*u*((r-d+omega)*T) + tmp;
end

%function phi = IntegratedCIR_characteristicFn(u,lnS,T,r,d,sigma,nu,theta,kappa,eta,lambda,y0)

%v1 = i*log(1 - i * theta * nu * u + 0.5 * sigma * sigma * u .* u * nu)/nu;
%v2 = i*log(1 - i * theta * nu *(-i) + 0.5 * sigma * sigma * (-i) .* (-i) * nu)/nu;

function phi = IntegratedCIR_characteristicFn(u,T,r,d,params)

C = params(1); G = params(2); M = params(3); kappa = params(4);
eta = params(5); lambda = params(6); y0 = params(7);

v1 = -1i*C*(log(G*M)-log(G*M+(M-G)*1i*u + u.*u));
v2 = -1i*C*(log(G*M)-log(G*M+(M-G)*1i*(-1i) + (-1i).*(-1i)));


gamma1 = sqrt(kappa^2 - 2*lambda^2*1i*v1);
gamma2 = sqrt(kappa^2 - 2*lambda^2*1i*v2);
phi1 = kappa^2*eta*T/lambda^2 + 2*y0*1i*v1 ./ (kappa + gamma1.*coth(0.5*gamma1*T))...
    - 2*kappa*eta/lambda^2*log(cosh(0.5*gamma1*T) + kappa*sinh(0.5*gamma1*T)./gamma1);
phi2 = kappa^2*eta*T/lambda^2 + 2*y0*1i*v2 / (kappa + gamma2*coth(0.5*gamma2*T))...
    - 2*kappa*eta/lambda^2*log(cosh(0.5*gamma2*T) + kappa*sinh(0.5*gamma2*T)/gamma2);

gam = sqrt(kappa^2-2*lambda^2);
omega = 0;%- (kappa^2*eta*T/lambda^2 + 2*y0/(kappa+gam*coth(gam*T/2))) + 2*kappa*eta/lambda^2*log(cosh(gam*T/2)+kappa*sinh(gam*T/2)/gam);
phi = 1i*u*((r-d+omega)*T) + phi1 - 1i*u*phi2;%0.5*(log(phi1.^2) - i*u*log(phi2.^2));

end

function phi = VarianceGammaOU_characteristicFn(u,T,r,d,params)

    C = params(1); G = params(2); M = params(3); lambda = params(4);
    a = params(5); b = params(6);

    psiX1 = (-1i)*log((G*M./(G*M+(M-G)*1i*u+u.*u)).^C);
    psiX2 = (-1i)*log((G*M/(G*M+(M-G)-1)).^C);    
    phiCIR1 = 1i*psiX1*lambda^(-1)*(1-exp(-lambda*T)) + lambda*a./(1i*psiX1-lambda*b).*(b*log(b./(b-1i*psiX1*lambda^(-1)*(1-exp(-lambda*T))))-1i*psiX1*T);
    phiCIR2 = 1i*psiX2*lambda^(-1)*(1-exp(-lambda*T)) + lambda*a./(1i*psiX2-lambda*b).*(b*log(b./(b-1i*psiX2*lambda^(-1)*(1-exp(-lambda*T))))-1i*psiX2*T);
    phi = phiCIR1 - 1i*u.*phiCIR2 + 1i*u*(r-d)*T;
end


function phi = NIGCIR_characteristicFn(u,T,r,d,params)

alpha = params(1); beta = params(2); delta = params(3);
lambda = params(4); kappa = params(5); eta = params(6);
% NIG CIR
y0 = 1;

psiX_u = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1i*u).^2)-sqrt(alpha^2-beta^2));
psiX_i = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1)^2)-sqrt(alpha^2-beta^2));

gamma_u = sqrt(kappa^2-2*lambda^2*1i*psiX_u); 
gamma_i = sqrt(kappa^2-2*lambda^2*1i*psiX_i); 

f2_u = (kappa^2*eta*T/(lambda^2))'-log(cosh(0.5*gamma_u*T) ...
    +kappa*sinh(0.5*gamma_u*T)./gamma_u)*(2*kappa*eta*lambda^(-2));
f3_u = 2*psiX_u./(kappa+gamma_u.*coth(gamma_u*T/2));

f1_u = f2_u + 1i*f3_u*y0;

phi_T = kappa^2*eta*T*lambda^(-2) ...
    + 2*y0*1i*psiX_i./(kappa+gamma_i*coth(gamma_i*T/2)) ...
        -log( cosh(0.5*gamma_i*T) + kappa*sinh(0.5*gamma_i*T)/gamma_i )...
        *(2*kappa*eta/lambda^2);

phi = 1i*u*((r-d).*T- phi_T) + f1_u;
end