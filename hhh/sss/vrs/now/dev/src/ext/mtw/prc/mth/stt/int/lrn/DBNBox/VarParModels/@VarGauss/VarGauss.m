function [obsmodel]=VarGauss(varargin);
% [obsmodel]=VarGauss(K,X,options);
% contructor for variational Gaussian observation models 
%
% K              State Space dimension
% X              Training data
% options        options for the observation model
% 
% 
% $$$ 
% $$$ DataMembers
% $$$   options:        options to the observation model
% $$$   Norm_Mu         Posterior Mean Mean
% $$$   Norm_Cov        Posterior Mean Covariance
% $$$   Norm_Prec       Posterior Mean Precision
% $$$   Wish_B          Posterior Variance Scale
% $$$   Wish_iB         Posterior Variance inverse Scale
% $$$   Wish_alpha      Posterior Variance shape
% $$$   Wish_k          Posterior Variance dimension
% $$$   prior           prior to parameters above
% $$$      Norm_Mu         Prior Mean Mean
% $$$      Norm_Cov        Prior Mean Covariance
% $$$      Norm_Prec       Prior Mean Precision
% $$$      Wish_B          Prior Variance Scale
% $$$      Wish_iB         Prior Variance inverse Scale
% $$$      Wish_alpha      Prior Variance shape
% $$$      Wish_k          Prior Variance dimension
% $$$ 
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()           evaluate free energy of observation model

  

ClassName='VarGauss';
% default state space dimension
defK=2;
% default prior structure
defpriorstruct=struct('Norm_Mu',[],'Norm_Cov',[], ...
    'Norm_Prec',[],'Wish_B',[],'Wish_iB',[],...
    'Wish_alpha',[],'Wish_k',[]);
% default hmm model structure
defobsmodelstruct=struct('Norm_Mu',[],'Norm_Cov', ...
      [],'Norm_Prec',[],'Wish_B',[],'Wish_iB',[],...
      'Wish_alpha',[],'Wish_k',[],'prior',defpriorstruct,'options',[]);




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


