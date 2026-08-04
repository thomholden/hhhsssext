function [chschain]=GibbsCHMM(varargin);
% contructor for Coulple Hidden Markov Chains with 
% MCMC Belief Propagation Inference
%
% [chschain]=GibbsSamp(LagOp,K,NSamp) 
% 
% $$$ 
% $$$ DataMembers
% $$$   T:              length of chain
% $$$   N:              number of blocks
% $$$   K               state space dimension
% $$$   P               transition probability
% $$$   Pi              initial state  probability
% $$$   Xi              probability of two neighbouring states
% $$$   Gamma           probability of one state
% $$$   Gammasum        sum of Gamma over length of chain
% $$$   Scale           Normalisation Variable
% $$$   B               Data likelihood conditioned on state
% $$$   infmode         inference modus
% $$$ 
% $$$ Methods
% $$$ 
% $$$   update()        compute posterior of hidden states
% $$$   samplchain()   forward backward routines
% $$$
  


ClassName='GibbsCHMM';
% default topology: HMM
defK=[2];
defNChains=2;
outlflag=zeros(1,defNChains);
defLagOpSpec={[-1; 1]; [-1; 2]};	% def are 2 indep chains
defLagOp=LagOperator(defLagOpSpec);
% default decoding structure
defdecstr=struct('q_star',[]);
% default engine structure
defchschainstruct=struct('T',0,'K',[defK defK],'N',1,...
			 'P',{{}},'Pi',{{}},'Xi',struct('block',{{}}),...
			 'Gamma',struct('block',{{}}),'S',struct('block',{{}}),...
			 'LagOp',defLagOp,...
			 'LagOpSpec',{defLagOpSpec},...
			 'NChains',defNChains,'NSamp',20,...
			 'NSampBurnin',0,'decode',defdecstr);

switch nargin
 case 0				% no arguments
  chschain=defchschainstruct;
  chschain=class(chschain,ClassName);
 otherwise
  if isa(varargin{1},ClassName)
    chschain=varargin{1};			% just return;
    return;
  else
    chschain=defchschainstruct;
    [LagOpSpec,K,NSamp]=mydeal(varargin{:});

    % toplogy
    if ~isempty(LagOpSpec)
      chschain.LagOpSpec=LagOpSpec;
      chschain.LagOp=LagOperator(LagOpSpec);
      chschain.NChains=length(LagOpSpec);
    end

    % state space dimension
    if ~isempty(K)
      if length(K)~=chschain.NChains
	if length(K)~=1,
	  error('State space dimension vector mismatches no. of Chains.');
	end
	K=repmat(K,1,chschain.NChains);
      end
      chschain.K=K;
    else   % need one per chain
      chschain.K=repmat(chschain.K,1,chschain.NChains);
    end

    % Number of Samples
    if ~isempty(NSamp)
      chschain.NSamp=NSamp;
    end
    
    % create object
    chschain = class(chschain,ClassName);
  end;
end



