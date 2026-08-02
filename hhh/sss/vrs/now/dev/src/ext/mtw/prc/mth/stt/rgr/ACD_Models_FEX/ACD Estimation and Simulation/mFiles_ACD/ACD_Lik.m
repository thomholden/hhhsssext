% Likelihood function for ACD_Fit.m
%
% USAGE: [sumLik,specOut]=ACD_Lik(x,param,q,p,dist)
%
% INPUT:
%       x - duration series (time betweem events)
% 
%       param - parameter vector
% 
%       dist - distribution assumption (so far, only 'exp' and 'weibull'
%       accepted
% 
%       q - maximum lag at alpha coefficients
% 
%       p - maximum lag at beta coefficients 
% 
% OUTPUT:
%       specOut - A structure with the fitted coefficients and the fitted
%       duration (more details at example script).
%       
%       sumLik - sum of log likelihood (in negative since fmincon minimizes it)       
%
% Author: Marcelo Perlin (PhD student at ICMA/Uk)
% Date:   16/11/2007

function [sumLik,specOut]=ACD_Lik(x,param,q,p,dist)

    % Organizing Coefficients
    
    Coeff.w=param(1);
    Coeff.q=param(2:q+1);
    Coeff.p=param(q+2:q+1+p);
    
    nr=size(x,1);

    switch dist
        case 'weibull'
            Coeff.y=param(end); % the extra parameter of weibull distribution
    end

    h1=Coeff.w+filter(Coeff.q,1,x);     % Vectorized Filter for conditional Durations
    h=filter([0 1],[1 -Coeff.p],h1);    % Vectorized Filter for conditional Durations
    
    % The next lines are the old unvectorized calculations of conditional
    % durations. I'm not erasing it so people can see the process of the
    % ACD model. Using filter() or for loops will yeld the same result.
    
%     for i=(max(p,q)+1):nr
%         h(i,1)=Coeff.w+flipdim(Coeff.q,2)*(x(i-q:i-1,1))+flipdim(Coeff.p,2)*h(i-p:i-1,1);   % this is the psi equation
%     end

    switch dist
        case 'exp'
            loglik(:,1)=log(1./h(:,1).*exp(-x(:,1)./h(:,1))); % this is the log likelihood
        case 'weibull'
            % this is the log likelihood
            loglik(:,1)=log(Coeff.y./x(:,1).*((x(:,1).*gamma(1+1/Coeff.y))./h(:,1)).^Coeff.y.*exp(-(((x(:,1).*(gamma(1+1/Coeff.y))./h(:,1)).^Coeff.y))));
    end

    % control for inf and nan
    
    infIdx=isinf(loglik);
    loglik(infIdx)=-10000;
    
    nanIdx=isnan(loglik);
    loglik(nanIdx)=-10000;
    
    % fmincon minimizes it, so I need the negative log likelihood
    
    sumLik=-sum(loglik);

    if isnan(sumLik)||isreal(sumLik)==0||isinf(sumLik)
        sumLik=inf;
    end
    
    % building specOut structure
    
    specOut.h=h;
    specOut.w=param(1);
    specOut.q=param(2:q+1);
    specOut.p=param(q+2:q+1+p);

    switch dist
        case 'weibull'
            specOut.y=param(end);
    end

    fprintf(1,['Log Likelihood ' dist ' ACD=' num2str(-sumLik) '\n']);