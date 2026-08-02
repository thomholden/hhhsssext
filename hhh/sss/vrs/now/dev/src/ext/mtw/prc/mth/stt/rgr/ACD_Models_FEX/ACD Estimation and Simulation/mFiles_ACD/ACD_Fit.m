% Function to fit a ACD(q,p) model to data
%
% USAGE: [specOut]=ACD_Fit(x,dist,q,p)
%
% INPUT:
%       x - duration series (time betweem events)
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
% Author: Marcelo Perlin (PhD student at ICMA/Uk)
% Date:   16/11/2007

function [specOut]=ACD_Fit(x,dist,q,p)

    if size(x,2)>1
        error('The input x should be a vector')
    end
    
    if strcmp(dist,'exp')==0&&strcmp(dist,'weibull')==0
        error('The input dist should be either ''exp'' or ''weibull''');
    end
    
    if q<1||p<1
        error(' The input q and p should be integers higher or equal than one');
    end
    
    % Some precalculation for param0
   
    for i=0:q-1
        indep(:,i+1)=x(1+i:end-q+i);
    end

    param_OLS=regress(x(q+1:end,1),[ones(length(x)-q,1) , indep]); % simple OLS for alpha0 and beta0

    switch dist

        case 'exp'
            param0=[param_OLS(1) param_OLS(2:end)' repmat((1-sum(param_OLS(2:end)))/p,1,p)];
            lB=repmat(0,1,p+q+1);
            uB=[inf repmat(1,1,p+q)];
            
        case 'weibull'

            param0=[param_OLS(1) param_OLS(2:end)' repmat((1-sum(param_OLS(2:end)))/p,1,p) .8];
            lB=repmat(0,1,p+q+1+1);
            uB=[inf repmat(1,1,p+q) 2];

    end

    options=optimset('fmincon');
    options=optimset(options,'display','off','LargeScale','off');

    warning('off');
    
    global global_p; % I'm using those globals here because I need to pass the value of p and q to confuneq.m
    global global_q;
    
    global_p=p;
    global_q=q;
    
    [param,fval,exitflag,output,lambda,grad,hessian]=fmincon(@(param)ACD_Lik(x,param,q,p,dist),param0,[],[],[],[],lB,uB,@confuneq,options);
   
    [sumLik,specOut]=ACD_Lik(x,param,q,p,dist); % filtering it again in order to recover the conditional durations
    
    % Printing result to screen

    fprintf(1,'\n\n******* Optimization Finished *******\n\n');
    fprintf(1,['Maximum Log Likelihoood: ' num2str(-sumLik) '\n\n']);
    
    fprintf(1,['Parameters for ACD(' num2str(q) ',' num2str(p) ') Model:'])
    fprintf(1,['\n  Const (Coeff.w) = ' num2str(specOut.w)]);
    fprintf(1,['\n  Alpha (Coeff.q) = ' num2str(specOut.q)]);
    fprintf(1,['\n  Beta  (Coeff.p) = ' num2str(specOut.p)]);
    
    switch dist
        case 'weibull'
            fprintf(1,['\n  Weibull param (Coeff.y) = ' num2str(specOut.y)]);
            fprintf(1,'\n\n');
        case 'exp'
            fprintf(1,'\n\n');
    end