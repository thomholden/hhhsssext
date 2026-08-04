function [chmm]=VarCHMM(varargin);
% [chmm]=VarCHMM(LagOp,K,X,obsmodel,options);
%        OR
% [chmm]=VarCHMM(LagOp,K,X,obsmodel,options,Y,outlmodel,outloptions);
%
% contructor for variational coupled hidden markov models 
%
% LagOp         cell array of length Nchains containing for each chain
%               a matrix. The matrix encoded the specification of
%               the lags with the corresponding chain number to
%               which the lag refers.  e.g.
%                 LagOp{1}=[-1 -1 -2  -1 -2; 1 2 2 3 3];
%                 LagOp{2}=[-2  -1 -1; 1 2 3];
%                 LagOp{3}=[-2 -1 -1; 1 2  3];
% K             Vector State Space dimensions
% X             Cell array with Training data sets
% obsmodel      cell array observation model names
% options       cell array
%    .obsmodel  structure with observation model options: see obsinit
%    .txmodel   structure with state transition model options: see txinit
%
% Y             Cell array with Training data sets
% oultmodel     cell array outlier model names
% outloptions   cell array outlier model options
%    
% $$$ 
% $$$   
% $$$ Methods
% $$$ 
% $$$   hsinit()          intialise hidden state chain
% $$$   txinit()          intialise state transition model
% $$$   train()           train entire model
% $$$   evalfreeenergy()  evaluate model's convergence
% $$$   evalhsfreeenergy()  evaluate hidden states convergence values
% $$$   evaltxfreeenergy()  evaluate state transition convergence values
% $$$   evalobsfreeenergy() evaluate observation models convergence values
  


ClassName='VarCHMM';
% implemented hidden state inference methods
hsinfmodes={'forwback','gibbs','meanfield','meanfieldchains'};
defhsinfmode=hsinfmodes{1};
% default state space dimension
defK=[2];
defNChains=2;
outlflag=zeros(1,defNChains);
defLagOpSpec={[-1; 1]; [-1; 2]};	% def are 2 indep chains
% default training options
%
deftrain=struct('cyc',30,'debug',0,'inftype',defhsinfmode, ...
		'NSamp',5,'NSweep',1,'obsupdate',repmat(1,1,defNChains),...
		'txupdate',repmat(1,1,defNChains), ...
		'outlupdate',repmat(0,1,defNChains),'checkviol',1,...
		'rdisplay',1,'plot',0,'phtime',.1,'tol',1e-5,'evalallfren',1);  
% fields to be copied from HMM structure
defchainstruct=struct('K',defK,'txmodel',[],'txmodelname','ConstrTxModels',...
		      'obsmodel',{{}},'obsmodelname','Gauss', ...
		      'outlmodel',[],'outlmodelname','');
% default chmm model structure
defchmmstruct=struct('K',[defK defK],'NChains',defNChains,...
		     'LagOpSpec',{defLagOpSpec},...
		     'chain',{repmat({defchainstruct},defNChains,1)},...
		     'train',deftrain,'chschain',[]);

switch nargin
 case 0				% no arguments
  chmm=defchmmstruct;
  chmm=class(chmm,ClassName);
 otherwise
  if isa(varargin{1},ClassName)
    chmm=varargin{1};			% just return;
    return;
  else
    chmm=defchmmstruct;
    [LagOpSpec,chains,inftype]=mydeal(varargin{:}); 
    
    % coupled chain structure
    if ~isempty(LagOpSpec)
      chmm.LagOpSpec=LagOpSpec;
      chmm.NChains=length(LagOpSpec);
    end

    % hidden state chain inference modus
    if ~isempty(inftype) 
      chmm.train.inftype=inftype;
    end


    % chains are VarHMM objects
    if isempty(chains),
      for c=1:chmm.NChains,
    	chains{c}=VarHMM(chmm.K(c));
      end
    else
       if length(chains)~=chmm.NChains,
          error('Number of chains do not match');
       end
       classname='VarHMM';
       if ispc classname=lower(classname); end;
       if ~all(cellfun('isclass',chains,classname))
	  error('Parameter ''chains'' must be of type VarHMM');
       end
    end

    % error checks have passed, now extract fields from HMM;
    for c=1:chmm.NChains,
      chmm.chain{c}=defchainstruct;

      defchainstructfields=fieldnames(rmfield(...
	  defchainstruct,{'txmodel','txmodelname'}));

      for nf=1:length(defchainstructfields),
	chmm.chain{c}=setfield(chmm.chain{c},defchainstructfields{nf},...
			   get(chains{c},defchainstructfields{nf}));  
      end
      % get the training settings
      %chmm.train.obsupdate(1,c)=get(chains{c},'train','obsupdate');
      %chmm.train.txupdate(1,c)=get(chains{c},'train','txupdate');
      %chmm.train.outlupdate(1,c)=get(chains{c},'train','outlupdate');
      % get state space dimension
      chmm.K(c)=chmm.chain{c}.K;
    end
    % create object
    chmm = class(chmm,ClassName);

    % initialise hidden chain
    chmm=hsinit(chmm);
    
    % initialise state space models
    chmm=txinit(chmm);
  
  end
end



