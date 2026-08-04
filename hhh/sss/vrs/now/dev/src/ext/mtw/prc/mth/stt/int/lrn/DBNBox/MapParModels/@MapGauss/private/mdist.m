function [dist] = mdist (x,mu,C)
%
%   [dist] =  mdist(x,mu,C)
%
%   computes from x values given mean mu and precision C
%   the distance, actually the quantity
%                           
%        -0.5  (x-mu)' C (x-mu)  

d=size(C,1);
if (size(x,1)~=d)  x=x'; end;
if (size(mu,1)~=d)  mu=mu'; end;

[ndim,N]=size(x);
if size(mu,2)~=size(x,2)
  d=x-mu*ones(1,N);			% one Mue given
else
  d=x-mu;				% several mu given
end

% too slow
% dist=zeros(N,1);
% for l=1:N,
%   dist(l)=-0.5*d(:,l)'*C*d(:,l);
% end;


Cd=C*d;
% costs memory
% dist=-0.5*diag(d'*C*d);

% less expensive 
dist=sum(d.*Cd,1);
dist=-0.5*dist';

return;

