function [obsmodel]=MaLikAR(varargin);
% [obsmodel]=MaLikAR(K,X,options);
% contructor for Maximum Likelihood Linear autoregessive observation models
%
% K              State Space dimension
% X              Training data
% options.       options for the observation model
%         p       model order (default 2)
%         gamma		weighting of each of N data points 
% 
% 
% $$$ 
% $$$ DataMembers
% $$$   options        options to the observation model
% $$$   p               model order
% $$$   A               model coefficients
% $$$   Prec            Noise  Precision
% $$$   Cov             Noise  Cov
% $$$ 
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()             evaluate free energy of observation model


ClassName='MaLikAR';
% default state space dimension
defK=2;
% default model order
defp=2;
% default hmm model structure
defobsmodelstruct=struct('p',[],'A',[],...
			 'Prec',[],'Cov',[],...
			 'options',[]);



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


