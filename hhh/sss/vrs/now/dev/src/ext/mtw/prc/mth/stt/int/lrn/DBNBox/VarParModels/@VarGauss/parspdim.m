function [Npar] = parspdim (obsmodel)
% function [Npar] = parspdim (obsmodel,Xtrain)
%
% Count the number of parameters of the variational Gaussian
% observation model
% 
% obsmodel   obsmodel data structure
%
% Npar       number of paramters.


Npar1=length(obsmodel.Norm_Mu);
Npar1=(Npar1+3)*Npar1*0.5;		% #pars of Posterior Mean Normal

Npar2=(obsmodel.Wish_k);
Npar2=1+(Npar2+1)*Npar2*0.5;		% #pars of Posterior Variance Wishart

Npar=Npar1+Npar2;



