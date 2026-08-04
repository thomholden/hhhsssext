function [vars] = sfs (x,y,p,mtype)
 
% function [vars] = sfs (x,y,p,mtype)
% 
% Stepwise forward selection of variables based, at each step,
% on building a model of type 'mtype'. 
% 
% Starting with the variable most
% correlated with the target, sfs adds a new variable which, together
% with the old one(s), most accurately predicts the target.
%
% Variable selection stops
% when the new candidate model doesn't significantly reduce
% the prediction error.
%
% Significance is measured by a partial F-test:
% see p.128 Kleinbaum or p.229 in Numerical Recipes 1996.
%
% If you wish to add your own model type you will need a function
% which returns SSEXP = SSY-SSE and SSE=sum((y-ypred).^2) where
% SSY = sum((y-mean(y)).^2) and ypred is the prediction of that model.
%
% x		inputs
% y		vector of targets
% p		significance level; DEFAULT=0.05
% mtype		model type 'lin'or 'mlp'; DEFAULT='lin'
%
% vars		selected variables 
  
if nargin < 2, error('Error in sfs: at least two arguments required'); end
if nargin < 3 | isempty(p), p=0.05; end
if nargin < 4 | isempty(mtype), mtype='lin'; end

nvars=size(x,2);
N=size(x,1);

% Assign variable, v, to input most correlated with target
for i=1:nvars,
  c = corrcoef (x(:,i),y);
  r2(i) = c(1,2).^2;
end
[max_r2,v]=max(r2);

% Initialise old_ssexp - the sum of squares explained
old_ssexp = max_r2*N*std(y)^2;

% List of variables not yet selected
notv=get_notv(v,nvars);

for i=2:nvars,
  nm=length(notv);
  % Get next nm models 
  for j=1:nm,
	vars=[v,notv(j)];
	switch mtype
	 case 'lin',
	  %[model(j).w,model(j).ssexp,model(j).sse] = sfslin (x(:,vars),y);
	  [w,ssexp,sse] = sfslin (x(:,vars),y);
	  model(j).w=w;
	  model(j).ssexp=ssexp;
	  model(j).sse=sse;
	 case 'mlp',
	  disp('Error in sfs: mlp model not yet implemented');
	  vars=[];
	  return
	 otherwise,
	  disp('Error in sfs: unknown model type');
	  vars=[];
	  return
	end
  end
  % Find best new model
  [tmp,best]=min([model.sse]);
  
  % Get p-value for new model
  k=length(v);  
  [tmp,pval] = partialf(model(best).ssexp,model(best).sse,old_ssexp,N,k);

  % Add feature if this model is significantly better ?
  if pval < p
    %disp('Adding variable');
    v=[v,notv(best)];
    notv=get_notv(v,nvars);
    old_ssexp=model(best).ssexp;
  else
    vars=v;
    break
  end
end

  
