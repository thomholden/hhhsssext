function [vars] = sbs (x,y,p,mtype)
 
% function [vars] = sbs (x,y,p,mtype)
% 
% Stepwise backward selection of variables based, at each step,
% on building a model of type 'mtype'. 
% 
% Starting with all the variables, sbs removes the variable which
% leads to the smallest increase in prediction error.
%
% Variable removal stops
% when the new candidate model significantly increases
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

% Assign variable list, v, to include all variables
v=[1:1:nvars];
[w,old_ssexp,old_sse] = sfslin (x(:,v),y);

for i=2:nvars,
  nm=length(v);
  % Get next nm models by removing each of selected variables in turn
  for j=1:nm,
	vars=remove_var (j,v);
	switch mtype
	 case 'lin',
	  %[model(j).w,model(j).ssexp,model(j).sse] = sfslin (x(:,vars),y);
	  [w,ssexp,sse] = sfslin (x(:,vars),y);
	  model(j).w=w;
	  model(j).ssexp=ssexp;
	  model(j).sse=sse;
	  model(j).vars=vars;
	 case 'mlp',
	  disp('Error in sbs: mlp model not yet implemented');
	  vars=[];
	  return
	 otherwise,
	  disp('Error in sbs: unknown model type');
	  vars=[];
	  return
	end
  end
  % Find best new model - this suggests removing variable 'worst'
  [tmp,worst]=max([model(1:nm).ssexp]);
  
  % Get p-value for new model
  k=length(v)-1;  

  [tmp,pval] = partialf(old_ssexp,old_sse,model(worst).ssexp,N,k);

  % Remove feature if it doesn't make a significant difference
  if pval > p
    %disp(sprintf('Removing variable %d, p=%1.4f',v(worst),pval));
    v=model(worst).vars;
    old_ssexp=model(worst).ssexp;
    old_sse=model(worst).sse;
  else
    vars=v;
    break
  end
end

  
