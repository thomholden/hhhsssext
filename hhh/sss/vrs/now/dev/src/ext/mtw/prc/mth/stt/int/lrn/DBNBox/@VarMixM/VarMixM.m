function [mix]=VarMixM(varargin);
% [mix]=VarMixM(K,X,obsmodel,options);
%       or
% [mix]=VarMixM(K,X,obsmodel,options,Y,outlmodel,outloptions);
%
% contructor for variational mixture models 
%
% K              State Space dimension
% X              Training data
% obsmodel       observation model
% options        
%    .obsmodel   structure with observation model options: see obsinit
%    .txmodel    structure with kernel weight model options: see txinit
% Y              Outlier Training data
% outlmodel      Outlier model
% outloptions    Outlier model options
%    
% $$$ 
% $$$ DataMembers
% $$$   train     Training Setting of Mixture Model
% $$$   obsmodel  Observation Models
% $$$   txmodel   Kernel Weight Model
% $$$   outlmodel Outlier Model
% $$$   K         dimension of state space
% $$$   
% $$$ Methods
% $$$ 
% $$$   hsinit()          intialise hidden state chain
% $$$   obsinit()         intialise observation models
% $$$   outlinit()        intialise outlier model
% $$$   txinit()          intialise kernel weights  model
% $$$   train()           train entire model
% $$$   evalfreeenergy()  evaluate model's convergence
% $$$   evalhsfreeenergy()  evaluate hidden states convergence values
% $$$   evaltxfreeenergy()  evaluate kernel weights convergence values
% $$$   evalobsfreeenergy() evaluate observation models convergence values
% $$$   decode()          Viterbi sequence of mixture model
  


ClassName='VarMixM';
% default state space dimension
defK=2;
% no outlier model as default
outlflag=0;
% default training options
deftrain=struct('cyc',100,'debug',0,...
		'obsupdate',1,'txupdate',1, ...
		'outlupdate',0,'checkviol',0,...
		'rdisplay',1,'plot',0,'phtime',.1,'tol',1e-5);
defhsnodestruct=struct('T',0,'K',[defK],'N',1,...
    'P',{{}},'Gamma',{{}},'decode',[]);
% default mix model structure
defmixstruct=struct('K',defK,'txmodel',[],'txmodelname','MwModel', ...
		    'obsmodelname','Gauss', ...
		    'outlmodelname','', 'train',deftrain, ...
		    'outlmodel',[],'obsmodel',{{}},'hsnodes',defhsnodestruct);

switch nargin
 case 0				% no arguments
  mix=defmixstruct;
  mix=class(mix,ClassName);
 otherwise
  if isa(varargin{1},ClassName)
    mix=varargin{1};			% just return;
    return;
  else
    mix=defmixstruct;
    [K,Xtrain,obsmodelname,options,Xoutl,outlmodelname, ...
     outloptions]=mydeal(varargin{:}); 
    
    % dimension of state space
    if ~isempty(K)		
      mix.K=K;				% save K
    end

    % check if obsmodel name was given
    if ~isempty(obsmodelname)
      mix.obsmodelname=obsmodelname;
    end

    % were options given,
    if ~isempty(options)
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
      % mix.train.inftype=deftrain.inftype; % already assigned
      obsmodeloptions=[];
      txmodeloptions=[];
    end
    
    % check if oultier model name was given
    if ~isempty(outlmodelname)
      outlflag=1;
      mix.outlmodelname=outlmodelname;
      % check if outlier model options were given
      if  ~isempty(outloptions)
	outlmodeloptions=outloptions;
      else
	outlmodeloptions=[];
      end
    end

    % create object
    mix = class(mix,ClassName);

    % initialise hidden chain
    mix = hsinit(mix);
    
    % initialise state space models
     if ~isempty(txmodeloptions),
       mix=txinit(mix,txmodeloptions);	% with options
     else
       mix=txinit(mix);			% without options
     end;

    if ~isempty(obsmodeloptions),
      % initialise observation model- with options
      mix=obsinit(mix,Xtrain,mix.K-outlflag,obsmodeloptions);
    else
      % initialise observation model- no options
      mix=obsinit(mix,Xtrain,mix.K-outlflag);
    end

    % if outlier model is wanted
    if outlflag,
      if ~isempty(outlmodeloptions),
	% initialise outlier model - with options
	mix=outlinit(mix,Xtrain,outlmodeloptions);
      else
	% initialise outlier model - no options
	mix=outlinit(mix,Xtrain);
      end
    end
    
    
  end
end

