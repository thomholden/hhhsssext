function [D] = mvgauss_kl (varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   [D] = mvgauss_kl (M_q,M_p,Sigma_q,Sigma_p,Phi_q,Phi_p)
%
%   computes the divergence 
%                /
%      D(q||p) = | q(x)*log(q(x)/p(x)) dx
%               /
%   between two m,n-dimensional matrix Gaussian probability
%   densities  given means M and PRECISION Matrices Sigma and Phi where the
%   matrix variate Gaussian pdf is given by  
%
%              1                                    
%   p(x)= -------------  |Sigma|^(n/2) |Phi|^(n/2) ...
%          (2*pi)^(mn/2)                      
%                                        exp (-0.5 tr(Sigma(X-M)Phi(X-M)')) 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin~=6,
  error('Incorrect number of input arguments');
else
  [M_q,M_p,Sig_q,Sig_p,Phi_q,Phi_p]=deal(varargin{:});
end;


if any(size(M_q)~=size(M_p)),
  error('Distributions must have equal dimensions (Means dimension)');
end;

if any(size(Sig_q)~=size(Sig_p)),
  error('Distributions must have equal dimensions (Prec. <Sigma> dimension)');
end;

if any(size(Phi_q)~=size(Phi_p)),
 error('Distributions must have equal dimensions (Prec. <Phi> dimension)');
end;

lDSq=log(det(Sig_q));
lDSp=log(det(Sig_p));
lDPq=log(det(Phi_q));
lDPp=log(det(Phi_p));

K=size(M_q);
D=K(2)*lDSp-K(2)*lDSq+K(1)*lDPp-K(1)*lDPq-prod(K)+...
  trace(Sig_p*inv(Sig_q))*trace(Phi_p*inv(Phi_q))+...
  trace(Sig_p*(M_q-M_p)*Phi_p*(M_q-M_p)');
D=D*0.5;








































