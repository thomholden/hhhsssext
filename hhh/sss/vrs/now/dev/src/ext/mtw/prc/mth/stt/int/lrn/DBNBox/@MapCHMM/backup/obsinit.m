function [chmm,Xtrain] = obsinit (chmm,X,outlflag,options)
% function [chmm] = obsinit (chmm,X,outflag,options)
%
% Initialise observation models in CHMM
% 
% X         N x p data matrix
% K         number of obsmodels to intialise
% chmm       chmm data structure
% options   see
%           VarGauss,
%           etc 
%

  % loop chains
  for c=1:chmm.NChains,

    % check if observation model options were given
    if ~isempty(options{c}) & isfield(options{c},'obsmodel')
	obsmodeloptions=options{c}.obsmodel;
    else
      obsmodeloptions=[];
    end

    obsmodelname=getchain(chmm,c,'obsmodelname');
    if isempty(obsmodelname)
      obsmodelname='Gauss';
      chmm=setchain(chmm,c,'obsmodelname',obsmodelname);
    end
    
    % if outlier model was specified, 
    if outlflag(c)
      K=chmm.K(c)-1;			% need one less for init
    else
      K=chmm.K(c);
    end

    % initialise observation model
    switch obsmodelname,
     case 'Gauss'
      [obsmodel]=VarGauss(K,X{c},obsmodeloptions);
     case {'Uniform'}
      [obsmodel]=VarUniform(K,X{c},obsmodeloptions);
     case {'LIKE'}
      [obsmodel]=initLIKE(K,X{c},obsmodeloptions);
     otherwise
      error('Error: Undefined observation model');
    end

    % stored 
    chmm=setchain(chmm,c,'obsmodel',obsmodel);
  end

