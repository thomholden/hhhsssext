
function [f] = ident(u,y,d,lambda,f)

%   [f] = ident(u,y,d,lambda,f)
%   [f] = ident(u,y,d,lambda)
%   [f] = ident(u,y,d)
%
% Identify SISO system recursively.
%
% Input parameters:
%  - u: Scalar input sequence
%  - y: Scalar output sequence
%  - d: System dimension
%  - lambda: Forgetting factor (default 1, no forgetting)
%  - f: Initial parameter vector (default zero)
% Return parameters:
%  - f: Final parameter vector
%
% Heikki Hyotyniemi Feb.20, 2001


[ku,n] = size(u);
[ky,m] = size(y);
if ku~=ky, disp('Input and output sequences incompatible!'); return;
else k = ku; end
if n~=1 | m~=1, disp('SISO system assumed!'); return; end

if nargin < 4
   lambda = 1;
end
if nargin < 5
   f = zeros(2*d,1);
end

X = zeros(k-d,2*d);
Y = y(d+1:k);
F = zeros(k-d,2*d);
for i = 1:d
   X(:,i) = u(i:k-d+i-1);
end
for i = 1:d
   X(:,d+i) = y(i:k-d+i-1);
end

R = 0.01*eye(2*d);
for i = 1:length(Y)
   F(i,:) = f';
   R = lambda*R + X(i,:)'*X(i,:);
   f = f + inv(R)*X(i,:)'*(Y(i)-X(i,:)*f);
end

figure; clf
plot(F); 
hold on;
fMLR = mlr(X,Y);
plot(ones(k-d,1)*fMLR');
