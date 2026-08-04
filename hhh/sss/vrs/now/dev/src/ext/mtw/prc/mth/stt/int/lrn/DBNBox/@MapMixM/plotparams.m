function [plotoptions]=plotparams(mix,Xtrain,T);
% [plotoptions]=plotparams(mix,X,T);
% 
% Creat parameters for plotting
%
%


X=cat(1,Xtrain.block(:).X);
if ~mix.train.plot
  plotoptions=cell(1);
  return
end

% grid for plotting contours
dmin=min(X);
dmax=max(X);
dspace=range(X)./30;
if length(dmin)>1,
  [Xgrid,Ygrid] = meshgrid(dmin(1):dspace(1):dmax(1),dmin(2): ...
			   dspace(2):dmax(2));
  [nXgrid,nYgrid]=size(Xgrid);
else
  [Xgrid,Ygrid] = meshgrid(1:T/30:T,dmin(1):dspace(1):dmax(1));
  [nXgrid,nYgrid]=size(Xgrid);
end
colstr={'y.';'m.';'c.';'r.';'g.';'b.';'k.'};
Ncols=length(colstr);
dpf=(mix.train.plot==2);
cpf=(mix.train.plot==3);
plotoptions{1}=nXgrid;
plotoptions{2}=nYgrid;
plotoptions{3}=Xgrid;
plotoptions{4}=Ygrid;
plotoptions{5}=Ncols;
plotoptions{6}=colstr;
plotoptions{7}=dpf;
plotoptions{8}=cpf;
plotoptions{9}=mix.train.phtime;
h=figure;
plotoptions{10}=h;
