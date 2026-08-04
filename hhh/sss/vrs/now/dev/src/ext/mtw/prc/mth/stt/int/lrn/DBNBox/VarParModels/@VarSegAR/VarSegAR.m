function [obsmodel]=VarSegAR(varargin);
% [obsmodel]=VarSegAR(K,X,options);
% contructor for variational segmented autoregessive observation model
%
% K              State Space dimension
% X              Training data
% options.       options for the observation model
%         p     model order (default 2)
%         gamma		weighting of each of N data points 
%         prrasc        prior range scale (scales prior variances);
% 
% 
% $$$ 
% $$$ DataMembers
% $$$   options        options to the observation model
% $$$   p               model order
% $$$   Coeff_MvNorm_p         Coefficients' MV-Normal dimension p
% $$$                          (=data dimensionality)
% $$$   Coeff_MvNorm_q         Coefficients' MV-Normal dimension q
% $$$                          (=data dimensionality x model order)
% $$$   Coeff_MvNorm_Omega     Coefficients' MV-Normal  Mean Matrix
% $$$   Coeff_MvNorm_Sigma     Residual Noise Precision Matrix
% $$$   Coeff_MvNorm_Phi       Coefficients Precision  Matrix
% $$$   Sigma_Wish_alpha       Noise  Precision Sigma's Posterior (Wish)
% $$$                           parameter alpha
% $$$   Sigma_Wish_B           Noise Precisions Sigma's Posterior (Wish)
% $$$                           scale parameter B
% $$$   Sigma_Wish_k           Noise Precisions Sigma's Posterior  d.o.f. 
% $$$                           (MV-Norm dimension p)
% $$$   Phi_Wish_alpha         Coeff. Precisions Phi's Posterior (Wish)
% $$$                           parameter alpha 
% $$$   Phi_Wish_B             Coeff. Precisions Phi's Posterior (Wish)
% $$$                           scale parameter B
% $$$   Phi_Wish_k             Coeff. Precisions Phi's Posterior d.o.f. 
% $$$   prior           prior to parameters above
% $$$    Coeff_MvNorm_Omega     Coefficients' MV-Normal Prior Mean Matrix
% $$$    Coeff_MvNorm_p         Coefficients' MV-Normal Prior dimension p
% $$$                           (=data dimensionality)
% $$$    Coeff_MvNorm_q         Coefficients' MV-Normal Prior dimension q
% $$$                           (=data dimensionality x model order)
% $$$    Sigma_Wish_alpha       Noise Precisions Sigma's Prior (Wish)
% $$$                            parameter alpha
% $$$    Sigma_Wish_B           Noise Precisions Sigma's Prior (Wish)
% $$$                            scale parameter B
% $$$    Sigma_Wish_k           Noise Precisions Sigma's Prior (Wish) d.o.f. 
% $$$                            (MV-Norm dimension p)
% $$$    Phi_Wish_alpha         Coeff. Precisions Phi's Prior (Wish)
% $$$                            parameter alpha 
% $$$    Phi_Wish_B             Coeff. Precisions Phi's Prior (Wish)
% $$$                            scale parameter B
% $$$    Phi_Wish_k             Coeff. Precisions Phi's Prior (Wish) d.o.f. 
% $$$                            (MV-Norm dimension q)
%   
% $$$ 
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()             evaluate free energy of observation model


ClassName='VarSegAR';
% default state space dimension
defK=2;
% default model order
defp=2;
% default prior structure
defstateprior=struct('Coeff_MvNorm_Omega',[],'Coeff_MvNorm_p',[],...
			    'Coeff_MvNorm_q',[],'Sigma_Wish_alpha',[],...
			    'Sigma_Wish_B',[],'Sigma_Wish_k',[],...
			    'Phi_Wish_alpha',[],'Phi_Wish_B',[],...
			    'Phi_Wish_k',[]);
% default hmm model structure
defobsmodelstruct=struct('p',2,'segsize',[],'offset',[],...
			 'Coeff_MvNorm_p',[],...
			 'Coeff_MvNorm_q',[],'Coeff_MvNorm_Omega',[],...
			 'Coeff_MvNorm_Sigma',[],'Coeff_MvNorm_Phi',[],...
			 'Coeff_MvNorm_iSigma',[],'Coeff_MvNorm_iPhi',[],...
			 'Sigma_Wish_k',[],'Sigma_Wish_alpha',[],...
			 'Sigma_Wish_B',[],'Sigma_Wish_iB',[],...
			 'Phi_Wish_k',[],'Phi_Wish_alpha',[],...
			 'Phi_Wish_B',[],'Phi_Wish_iB',[],...
			 'prior',defstateprior,'options',[]);



switch nargin
 case 0				% no arguments
   % create temporary object
   rawobsmodel=repmat(rawobsmodel,[1,defK]);
   rawobsmodel=class(rawobsmodel,ClassName);
   for k=1:defK,
     obsmodel{k}=rawobsmodel(k);
   end
 otherwise
  if isa(varargin{1},ClassName)
    obsmodel=varargin{1};			% just return;
    return;
  else
    rawobsmodel=defobsmodelstruct;
    [K,Xtrain,options]=mydeal(varargin{:});
    
    % dimension of state space
    if isempty(K)
      K=defK;
    end

    % create temporary object
    rawobsmodel=repmat(rawobsmodel,[1,K]);
    rawobsmodel=class(rawobsmodel,ClassName);
    
    % initialise observation model if data is available
    if ~isempty(Xtrain),
      if ~isempty(options),
	rawobsmodel=init(rawobsmodel,Xtrain,options);
      else
	rawobsmodel=init(rawobsmodel,Xtrain);
      end
    end
    % distribute in cell array
    for k=1:K,
      obsmodel{k}=rawobsmodel(k);
    end
  end;
end


