%
% Evaluate the current penalized log-likelihood value
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice Univ.     
% Author: Clay Scott (cscott@rice.edu).  See License.txt

hood_list=zeros(1,T);

scope=trivial_scope;

for t=1:T
  im = training_data{t};
  old_tran=transforms(:,t);
  hood=likelihood(im,template,old_tran,scope, finest_scope);
  hood_list(t) = hood;
end

log_like=sum(hood_list);

log_pen = log_penalty(num_high_states+1);

npll = log_like + log_pen;

