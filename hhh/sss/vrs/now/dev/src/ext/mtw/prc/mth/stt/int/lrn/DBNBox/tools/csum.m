% column sum
% function Z=csum(X)

function Z=csum(X)

Z=rsum(X')';


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% row sum
% function Z=rsum(X)

function Z=rsum(X)

Z=zeros(size(X(:,1)));

for i=1:length(X(1,:))
  Z=Z+X(:,i);
end
