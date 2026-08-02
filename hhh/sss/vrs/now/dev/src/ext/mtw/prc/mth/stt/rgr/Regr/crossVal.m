
function [E] = crossval(X,Y,expr,seqs)

%   [E] = crossval(X,Y,expr,seqs)
%   [E] = crossval(X,Y,expr)
%
% Function for cross-validation of linear regression models. 
%
% Input parameters:
%  - X: Data matrix (size k x n)
%  - Y: Output matrix (size k x m)
%  - expr: String form expression resulting in F, given X and Y
%  - seqs: How many cross-validation rounds (default k)
% Return parameter:
%  - E: Validation error (corresponding x's not applied in model)
%
% Heikki Hyotyniemi Feb.2, 2001


[kx,n] = size(X);
[ky,m] = size(Y);
if kx ~= ky, disp('Incompatible X and Y'); break; 
else k = kx; end

if nargin < 4
   seqs = k;
end

Xorig = X;
Yorig = Y;
E = zeros(size(Y));
seqlen = ceil(k/seqs);

for i = 1:seqs
   begin = (i-1)*seqlen+1;
   endin = min(i*seqlen,k);
   X = Xorig([1:begin-1,endin+1:k],:);
   Y = Yorig([1:begin-1,endin+1:k],:);
   eval(['F = ',expr,';']);
   Xtest = Xorig(begin:endin,:);
   Ytest = Yorig(begin:endin,:);
   Yhat = Xtest*F;
   E(begin:endin,:) = Yhat - Ytest;
end
