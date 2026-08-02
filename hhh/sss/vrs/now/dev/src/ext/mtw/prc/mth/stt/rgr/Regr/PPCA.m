
function [theta,lambda,iter] = PPCA(X,N,iterlimit)

%   [theta,lambda,iter] = PPCA(X,N,iterlimit)
%   [theta,lambda,iter] = PPCA(X,N)
%   [theta,lambda,iter] = PPCA(X)
%
% Principal Component Analysis using iterative power method 
%
% Input parameters:
%  - X: Input data block (k x n)
%  - N: Number of latent variables (optional)
%  - iterlimit: Maximum number of iterations (optional)
% Return parameters:
%  - theta: Eigenvectors
%  - lambda: Corresponding eigenvalues
%  - iter: Number of iterations needed
%
% Heikki Hyotyniemi Dec.21, 2000


[k,n] = size(X);
C = X'*X/k;

if nargin < 3
   iterlimit = inf;
end
iter = 0;

OK = 0;
theta = [];
lambda = [];

while OK == 0
   prevtheta = zeros(n,1);
   newtheta = rand(n,1);
   while norm(prevtheta-newtheta) > n*eps
      iter = iter + 1;
      if iter > iterlimit
         error('Maximum number of iterations reached');
      else
         prevtheta = newtheta;
         newtheta = C*prevtheta;
         newlambda = sqrt(newtheta'*newtheta);
         newtheta = newtheta/newlambda;
      end
   end
   for i = 1:n  % Deflation
      C(:,i) = C(:,i) - (C(:,i)'*newtheta) * newtheta;
   end
   theta = [theta,newtheta];
   lambda = [lambda,newlambda];
   
   if size(theta,2) < n
      if nargin<2 | isnan(N)
         inp = input(['Now lambda = ',num2str(newlambda),' - continue? <RETURN> '],'s');
         if ~isnan(inp)
            OK = 1;
         end
      else
         if size(theta,2) == N
            OK = 1;
         end
      end
   else OK = 1;
   end
end
