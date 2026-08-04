function [chschain]=FwBwCHMM(varargin);
% contructor for Forward Backward CHMM Chains
% 
% [chschain]=ForwardBack(K,T) 
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
% $$$   fwbw()          forward backward routines
% $$$
  


ClassName='FwBwCHMM';
% default topology: HMM
defK=[2];
defNChains=2;
outlflag=zeros(1,defNChains);
defLagOpSpec={[-1; 1]; [-1; 2]};	% def are 2 indep chains
defLagOp=LagOperator(defLagOpSpec);
% default decoding structure
defdecstr=struct('q_star',[],'delta',[],'psi',[]);
% default engine structure
defchschainstruct=struct('T',0,'K',2,'N',1,...
			'P',[],'Pi',[],'Xi',[],...
			 'cartXi',[],'cartGamma',[],...
			'LagOp',defLagOp,...
			'LagOpSpec',{defLagOpSpec},...
			'NChains',defNChains,...
			'Gamma',[],'Gammasum',[],...
			'Scale',[],'B',[],'LL',[],...
			'LL_best',[],'decode',defdecstr);

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
    [LagOpSpec,K,T]=mydeal(varargin{:});
    
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

    
    % length of chain
    if ~isempty(T)
      chschain.T=T;
    end
    
    % create object
    chschain = class(chschain,ClassName);
  end;
end


