function [chschain]=MFCHMM(varargin);
% contructor for Coulple Hidden Markov Chains with 
% Mean Field  Belief Propagation Inference
%
% [chschain]=MFCHMM(LagOp,K,NSweep) 
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
% $$$ 
% $$$ Methods
% $$$ 
% $$$   update()        compute posterior of hidden states
% $$$   mfprop()        meanfield belief update routines
% $$$   evalue()        compute entropy of hidden states
  


ClassName='MFCHMM';
% default topology: 2x HMM
defK=[2];
defNChains=2;
outlflag=zeros(1,defNChains);
defLagOpSpec={[-1; 1]; [-1; 2]};	% def are 2 indep chains
defLagOp=LagOperator(defLagOpSpec);
% default decoding structure
defdecstr=struct('q_star',[]);
% default engine structure
defchschainstruct=struct('T',0,'K',[defK defK],'N',1,...
			 'P',{{}},'Pi',{{}},'Xi',{{}},...
			 'Gamma',{{}},...
			 'LagOp',defLagOp,...
			 'LagOpSpec',{defLagOpSpec},...
			 'NChains',defNChains,'NSweep',1,...
			 'decode',defdecstr);

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
    [LagOpSpec,K,NSweep]=mydeal(varargin{:});

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

    % Number of Sweeps
    if ~isempty(NSweep)
      chschain.NSweep=NSweep;
    end
    
    % create object
    chschain = class(chschain,ClassName);
  end;
end



