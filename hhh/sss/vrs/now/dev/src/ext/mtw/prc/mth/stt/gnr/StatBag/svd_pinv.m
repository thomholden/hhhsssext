function [U,S,V,X,s,r] = svd_pinv (A)

% function [U,S,V,X,s,r] = svd_pinv (A)
% This routine is exactly the same as pinv but returns U,S,V as well
% U,S,V		As SVD routine
% X			The pseudoinverse -as pinv
% s			Inverse matrix of singular values above tolerance
% r			The number of singular values above tolerance

[U,S,V] = svd(A,0);
[m,n] = size(A);
if m > 1, 
	s = diag(S);
elseif m == 1, 
	s = S(1);
else 
	s = 0;
end
tol = max(m,n) * max(s) * eps;
r = sum(s > tol);
if (r == 0)
   X = zeros(size(A'));
else
   s = diag(ones(r,1)./s(1:r));
   X = V(:,1:r)*s*U(:,1:r)';
end

