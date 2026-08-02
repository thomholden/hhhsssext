function [w,vars] = pruned_lda (x,y,plevel);

% function [w,vars] = pruned_lda (x,y,plevel);
% Train and prune linear discriminant analysis unit
% See Press p.698-699

N=size(x,1);
x=[x,ones(N,1)];

% Use SVD to get solution
[U,S,V,pi,s,r]=svd_pinv(x);
w=pi*y;

% Use SVD to get covariance matrix
C = V(:,1:r)*(s^2)*V(:,1:r)';
%C = V*(inv(S)^2)*V';

% Prune weights if they are not significantly non-zero
%plevel=0.2;
Nw=length(w);
keep=ones(1,Nw-1);
for j= 1:Nw-1,
	chisq_obs=(w(j)^2) / C(j,j);
	p_chisq_obs = pchisq (chisq_obs, 1);
	if p_chisq_obs > plevel
		%disp(sprintf('Prune weight %d', j));
		keep(j)=0;
	end
	disp(sprintf('Weight %d: %1.4f  p=%1.4f, Keep=%d',j,w(j), p_chisq_obs,keep(j)));
end

% Keep unpruned nodes AND threshold
vars=[find(keep==1)];

% Retrain LDA on kept inputs
x=[x(:,vars),ones(N,1)];
w=pinv(x)*y;

