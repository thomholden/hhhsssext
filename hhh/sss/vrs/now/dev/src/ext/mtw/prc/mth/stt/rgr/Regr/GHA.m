
function [theta,lambda] = GHA(X,N,gamma,epochs)

%   [theta,lambda] = gha(X,N,gamma,epochs)
%   [theta,lambda] = gha(X,N)
%
% Principal Component Analysis using Generalized Hebbian Algorithm 
%
% Input parameters:
%  - X: Input data block (k x n)
%  - N: Number of latent variables to be extracted
%  - gamma: Step size (default gamma=0.001)
%  - epochs: Number of iterations (default epochs=10)
% Return parameters:
%  - theta: Eigenvectors
%  - lambda: Corresponding eigenvalues
%
% Heikki Hyotyniemi Dec.20, 2000


[k,n] = size(X);

if nargin < 4
   epochs = 10;
end
if nargin < 3
   gamma = 0.001;
end

theta = rand(n,N);
theta = theta./(ones(n,1)*sqrt(sum(theta.*theta)));

for i = 1:epochs
   X = X(randperm(k),:);
   z = zeros(N,1);
   sumz = zeros(N,1);

   for j = 1:k,
      x = X(j,:)'; 
      delta = zeros(size(theta));
      z(1) = theta(:,1)'*x;
      delta(:,1) = gamma*z(1)*(x-z(1)*theta(:,1));
      for l = 2:N,
	      z(l) = theta(:,l)'*x;
    	   temp = 0; 
         for m = 1:l
            temp = temp + theta(:,m)*z(m); 
         end
	      delta(:,l) = gamma*z(l)*(x-temp);    
      end
      theta = theta + delta;
      sumz = sumz + z.*z;
   end
end

lambda = sumz/k;
