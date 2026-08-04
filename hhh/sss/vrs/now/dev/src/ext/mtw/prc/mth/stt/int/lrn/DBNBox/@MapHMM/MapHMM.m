function [hmm]=MapHMM(varargin);
% [hmm]=MapHMM(K,X,obsmodel,options);
%       or
% [hmm]=MapHMM(K,X,obsmodel,options,Y,outlmodel,outloptions);
%
% contructor for maximum aposteriori hidden markov models 
%
% K              State Space dimension
% X              Training data
% obsmodel       observation model
% options        
%    .obsmodel   structure with observation model options: see obsinit
%    .txmodel    structure with state transition model options: see txinit
%    .s0model    structure with initial state model options
% Y              Outlier Training data
% outlmodel      Outlier model
% outloptions    Outlier model options
%    
% $$$ 
% $$$ DataMembers
% $$$   train     Training Setting of HMM
% $$$   obsmodel  Observation Models
% $$$   txmodel   State Transition Model
% $$$   outlmodel Outlier Model
% $$$   K         dimension of state space
% $$$   
% $$$ Methods
% $$$ 
% $$$   hsinit()          intialise hidden state chain
% $$$   obsinit()         intialise observation models
% $$$   outlinit()        intialise outlier model
% $$$   txinit()          intialise state transition model
% $$$   train()           train entire model
% $$$   evalfreeenergy()  evaluate model's convergence
% $$$   evalhsfreeenergy()  evaluate hidden states convergence values
% $$$   evaltxfreeenergy()  evaluate state transition convergence values
% $$$   evalobsfreeenergy() evaluate observation models convergence values
% $$$   decode()          Viterbi sequence of HMM
  


ClassName='MapHMM';
% implemented hidden state inference methods
hsinfmodes={'forwback'};
% default state space dimension
defK=2;
% no outlier model as default
outlflag=0;
% default training options
deftrain=struct('cyc',100,'debug',0,'inftype',hsinfmodes{1}, ...
		'NSamp',1,'obsupdate',1,'txupdate',1, ...
		'outlupdate',0,'checkviol',0,...
		'rdisplay',1,'plot',0,'phtime',.1,'tol',1e-5);
% default hmm model structure
defhmmstruct=struct('K',defK,'txmodel',[],'txmodelname','TxModels', ...
		    'obsmodelname','Gauss', ...
		    'outlmodelname','', 'train',deftrain, ...
		    'outlmodel',[],'obsmodel',{{}},'hschain',[]);

switch nargin
 case 0				% no arguments
  hmm=defhmmstruct;
  hmm=class(hmm,ClassName);
 otherwise
  if isa(varargin{1},ClassName)
    hmm=varargin{1};			% just return;
    return;
  else
    hmm=defhmmstruct;
    [K,Xtrain,obsmodelname,options,Xoutl,outlmodelname, ...
     outloptions]=mydeal(varargin{:}); 
    
    % dimension of state space
    if ~isempty(K)		
      hmm.K=K;				% save K
    end

    % check if obsmodel name was given
    if ~isempty(obsmodelname)
      hmm.obsmodelname=obsmodelname;
    end

    % were options given,
    if ~isempty(options)
      % initialise hidden state inference 
      if isfield(options,'inftype')
	if ismember(options.inftype,hsinfmodes),
	  hmm.train.inftype=options.inftype;
	end
      end
      
      % check if obsmodel options were given
      if isfield(options,'obsmodel')
	obsmodeloptions=options.obsmodel;
      else
	obsmodeloptions=[];
      end
    
      % check if hidden state model options were given
      if isfield(options,'txmodel')
	txmodeloptions=options.txmodel;
      else
	txmodeloptions=[];
      end
    else
      % hmm.train.inftype=deftrain.inftype; % already assigned
      obsmodeloptions=[];
      txmodeloptions=[];
    end
    
    % check if oultier model name was given
    if ~isempty(outlmodelname)
      outlflag=1;
      hmm.outlmodelname=outlmodelname;
      % check if outlier model options were given
      if  ~isempty(outloptions)
	outlmodeloptions=outloptions;
      else
	outlmodeloptions=[];
      end
    end

    % create object
    hmm = class(hmm,ClassName);

    % initialise hidden chain
    hmm = hsinit(hmm);
    
    % initialise state space models
     if ~isempty(txmodeloptions),
       hmm=txinit(hmm,txmodeloptions);	% with options
     else
       hmm=txinit(hmm);			% without options
     end;

    if ~isempty(obsmodeloptions),
      % initialise observation model- with options
      hmm=obsinit(hmm,Xtrain,hmm.K-outlflag,obsmodeloptions);
    else
      % initialise observation model- no options
      hmm=obsinit(hmm,Xtrain,hmm.K-outlflag);
    end

    % if outlier model is wanted
    if outlflag,
      if ~isempty(outlmodeloptions),
	% initialise outlier model - with options
	hmm=outlinit(hmm,Xtrain,outlmodeloptions);
      else
	% initialise outlier model - no options
	hmm=outlinit(hmm,Xtrain);
      end
    end
    
    
  end
end

