%
% Find the most likely transformation for each training image, and for each 
% model
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

hood_list=zeros(1,T);

if iter < num_refinements
  scope=scopes{iter};
else
  scope=scopes{num_refinements};
end

for t=1:T

  im = training_data{t};
  old_tran=transforms(:,t);
  [hood, new_tran, w_data]=likelihood(im,template,old_tran,scope,...
	finest_scope);
  transforms(:,t)=new_tran;
  hood_list(t) = hood;
  wavelet_data(:,:,t)=w_data;
end

log_likelihood=sum(hood_list);
