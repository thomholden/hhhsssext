
function [Xhat,Yhat] = fixval(X,Y,F,Wx,Wy)

%   [Xhat,Yhat] = fix(X,Y,F,Wx,Wy)
%
% Function tries to fix missing values matching data against model. 
%
% Input parameters:
%  - X: Data matrix to be fixed (size k x n)
%  - Y: Output matrix to be fixed (size k x m)
%  - F: Model matrix, Y=X*F
%  - Wx: Matrix containing 1 for each valid data in X
%  - Wy: Matrix containing 1 for each valid data in Y
% Return parameter:
%  - Xhat: Fixed data matrix
%  - Yhat: Fixed output matrix
%
% Heikki Hyötyniemi Feb.20, 2001


[kx,n] = size(X);
[ky,m] = size(Y);
if kx ~= ky, disp('Incompatible X and Y'); break; 
else k = kx; end
if size(X) ~= size(Wx), disp('Incompatible X and Wx'); break; end
if size(Y) ~= size(Wy), disp('Incompatible Y and Wy'); break; end

V = [X,Y];
W = [Wx,Wy];
tofix = find(any(W'==0));
FF = [F',-eye(m)];

for i = 1:length(tofix)
   v = V(tofix(i),:)';
   w = W(tofix(i),:)';
   NOK = find(w==0);
   OK = find(w~=0);
   FOK = FF(:,OK);
   FNOK = FF(:,NOK);
   V(tofix(i),NOK) = (-pinv(FNOK'*FNOK)*FNOK'*FOK*v(OK))';
end

Xhat = V(:,1:n);
Yhat = V(:,n+1:n+m);

