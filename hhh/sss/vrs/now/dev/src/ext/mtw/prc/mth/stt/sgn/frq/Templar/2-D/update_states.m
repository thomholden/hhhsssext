
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the value of high/low_hoods at (i,j) is the sum over all training
% data of the log-likelihood (up to a constant, which is irrelevant since 
% we are only interested in the difference high_hoods - low_hoods) 
% of the collection of 
% training images given the most likely transforms for each training
% image (mltrans) and the high/low mean and variance.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

high_hoods = zeros(N1,N2); low_hood = zeros(N1,N2);
low_var=template.low_var; 
	% don't let variances go to zero to avoid numerical  problems
thresh = low_var/10;
%thresh = 0.0001;	% too small!
adj_high_var=max(template.high_var,thresh);
high_mean = template.high_mean;

for i=1:N1
  for j=1:N2
    high_hoods(i,j)=(-1/2)*(T*log(adj_high_var(i,j))...
	+sum((wavelet_data(i,j,:)-high_mean(i,j)).^2)/adj_high_var(i,j));
    low_hoods(i,j)=(-1/2)*(T*log(low_var) ...
	+sum(wavelet_data(i,j,:).^2)/low_var);
  end
end


% convert to a row vector so we can apply sort and max functions
diffs=reshape(high_hoods-low_hoods,1,N1*N2); 

% don't let edge coeffs be signif in finest two levels
if 1	
  xx =length (scaling_filter); % # of coefficients
  yy =floor (xx/2);
  ww = zeros (N1,N2);
  ww (end-yy+1:end,:)=ones(yy,N2);
  ww (:, end-yy+1:end)=ones(N1,yy);
  ww (:,N2/2-yy+1:N2/2)=ones(N1,yy);
  ww (N1/2-yy+1:N1/2,:)=ones(yy,N2);
  diffs(find(ww))=-Inf;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maximize the overall penalized likelihood (or posterior, depending on
% how you view your prior/penalty fuction) by computing all possible
% values of the penalized likelihood function (as the number of high
% states varies)
% and taking the maximum. the index of the maximum is the optimal number
% of high states.  note we reverse the order of sorted_diffs so that 
% the coefficients are ordered from highest to lowest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pen_diffs = diffs + log_penalty;

[sorted_diffs, sorted_ind]=sort(pen_diffs);

incremental_pll = cumsum([0, sorted_diffs(end:-1:1)]);

[peak, peak_ind]=max(incremental_pll);
num_high_states = peak_ind - 1;

if num_high_states == 0
  high_ind = [];
else
  high_ind = sorted_ind(end-num_high_states+1:end);
end

states_vec=zeros(1,N1*N2);
states_vec(high_ind)=1;
template.states=reshape(states_vec,N1,N2);


