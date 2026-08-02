%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update common low variance with new information about states
% (high means and variances are the same, as they don't depend on states).
% since low states are assumed to be zero mean, their variance is their
% second moment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

antistates = ones(N1,N2)-template.states;
num_low_states = sum(sum(antistates));

if num_low_states > 0
  % second_moment computed in update_marginals.m
  template.low_var=sum(sum(antistates.*second_moment))/num_low_states;
end

