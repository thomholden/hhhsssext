function [chmm] = txinit (chmm,options)
% function [chmm] = txinit (chmm,K,txmodeloptions,priors)
% Initialise  CHMM Chain's hidden state transition parameters
%
% chmm		chmm data structure
% options       
%     .txmodel
%         .compri  flag to indicate whether priors are self intialed
%                  or provided
%         .priors    pre-set priors, used if options.[tx|s0]modeloptions.comppri=1
% 
%

  defpriors=[];
  defaultoptions=repmat({struct('comppri',1,'priors',defpriors)},1, ...
			chmm.NChains); 

  if nargin<2,
    options=defaultoptions;
  end;

  % loop chains
  for c=1:chmm.NChains,
    % check if hidden state model options were given
    if ~isempty(options{c}) & isfield(options{c},'txmodel')
        txmodeloptions=options{c}.txmodel;
    else
      txmodeloptions=[];
    end

    txmodelname=getchain(chmm,c,'txmodelname');
    if isempty(txmodelname)
      txmodelname='TxModels';
      chmm=setchain(chmm,c,'txmodelname',txmodelname);
    end
    
    % K(chain(c)),K(1..N)\K(c), first K always refers to current chain
    Kc=[chmm.K(c) chmm.K(chmm.LagOpSpec{c}(2,:))]; 
    
    % initialise state transition model
    switch txmodelname
     case 'TxModels'
      txmodel=MaLikTxModels(Kc,txmodeloptions);
     otherwise
      error('Error: Undefined state transition model');
    end
    chmm=setchain(chmm,c,'txmodel',txmodel);
  end
