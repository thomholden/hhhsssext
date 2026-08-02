function [log_likelihood, new_tran, w_data] = ...
	likelihood(im, template, old_tran, scope, finest_scope)
%
% compute most likely transform giving rise to im.  return transform and 
% corresponding likelihood.
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

new_tran=zeros(4,1); 	% most likely transform
[N1, N2]=size(im); N=N1*N2;

states=template.states; high_mean=template.high_mean; 
low_var=template.low_var;
high_var=max(template.high_var, low_var/10);
antistates=ones(N1,N2)-states;

wavelet_mean=states.*high_mean;
wavelet_var=antistates.*low_var + states.*high_var;


log_norm=(-1/2)*(N*log(2*pi)+sum(sum(log(wavelet_var))));
	% log of normalization factor in likelihood function

log_likelihood=-Inf;  

% search through all possible transformations for transformation that
% most likely gave rise to training image t from the given template.

%hshifts=intersect(scope.hshifts+old_tran(1), finest_scope.hshifts);
hshifts=scope.hshifts+old_tran(1);
angles=mod(scope.angles+old_tran(3),360);

for i=1:length(hshifts)
  h=hshifts(i);
  im1=translate(im,-h,0);
  for v=(scope.vshifts{i})+old_tran(2)
  %for v=intersect((scope.vshifts{i})+old_tran(2), finest_scope.vshifts{i})
    im2=translate(im1,0,-v);
      for r=angles
        im3=rot(im2,-r);

        w=atomic_rep(im3);
        offset=w-wavelet_mean;

        temp=(-1/2)*(sum(sum(offset.^2./wavelet_var)));
        if temp > log_likelihood
      	  log_likelihood=temp;
          new_tran=[h;v;r];
          w_data=w;
        end

      end
  end
end 

% add in normalization constant
log_likelihood = log_norm + log_likelihood;


