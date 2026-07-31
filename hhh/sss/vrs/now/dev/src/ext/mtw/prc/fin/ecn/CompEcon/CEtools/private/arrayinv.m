% ARRAYINV Computes linear solves on arrays
% USAGE
%   y=arrayinv(r,rx);
% Given r (m by p) and rx (m by p by p)
% returns y (m by p) with y(i,:)=rx(i,:,:)\r(i,:)

% Copyright (c) 2000 by Paul L. Fackler

function y=arrayinv(r,rx);
[m,p]=size(r);
y=zeros(m,p);
for i=1:m
  y(i,:)=(reshape(rx(i,:,:),p,p)\reshape(r(i,:),p,1))';
end