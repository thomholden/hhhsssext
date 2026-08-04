function [chvit]=splitviterbi(chschain,q_star,T);
% Split the merged viterbi squence into one for each chain
%
% Output
% chvit    cell array with viterbi sequence, one cell element/chain
%


K=chschain.K;

MaxLag=get(chschain.LagOp,'MaxLag');
MaxCha=get(chschain.LagOp,'MaxCha');

chvit=zeros(MaxCha,T);
L=convbase(repmat(prod(K),1,MaxLag),q_star);
for l=1:MaxLag  %=length(L)
  t=MaxLag-l+1:MaxLag:T;
  M=convbase(K,L{l});
  for m=1:length(K)   % = length(M)
    chvit(m,t)=M{m};
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONVBASE  %%%%%%%%%%%%%%%%%%%%%%%%%%
function [clv] = convbase(siz,ndx)
% essentially a skimmed version of ind2sub, but outputs cell rather than 
% a set of double arrays.
n = length(siz);
k = [1 cumprod(siz(1:end-1))];
ndx = ndx - 1;
for i = n:-1:1,
  clv{i} = floor(ndx/k(i))+1;
  ndx = rem(ndx,k(i));
end
