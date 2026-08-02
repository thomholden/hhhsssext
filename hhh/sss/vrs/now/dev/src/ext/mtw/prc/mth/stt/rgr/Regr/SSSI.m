
function [A,C,Rxx,Ryy,Rxy] = sssi(Y,maxdim,d)

%   [A,C,Rxx,Ryy,Rxy] = sssi(Y,maxdim,d)
%
% Stochastic SubSpace Identification (simplified)
%
% Input parameters:
%  - Y: Output data block (k x m)
%  - maxdim: Assumed maximum possible system dimension
%  - d: System dimension (optional)
% Return parameters:
%  - A,C: System matrices
%  - Rxx,Ryy,Rxy: Noise covariance matrices
%
% Heikki Hyotyniemi Feb.1, 2001


[k,m] = size(Y);

YY = zeros(k-2*maxdim+1,2*maxdim*m);
for i = 1:2*maxdim
   YY(:,(i-1)*m+1:i*m) = Y(i:k-2*maxdim+i,:);
end
YP = YY(:,1:maxdim*m);
YF = YY(:,maxdim*m+1:2*maxdim*m);

if nargin==3
   theta = pca(YP,d);
else
   theta = pca(YP);
   d = size(theta,2);
end

X = YP*theta;
XP = X(1:size(X,1)-1,:);
XF = X(2:size(X,1),:);

LHS = [XF,YF(1:size(YF,1)-1,1:m)];
RHS = [XP];
AC = (inv(RHS'*RHS+0.01*eye(size(RHS,2)))*RHS'*LHS)';

A = AC(1:d,1:d);
C = AC(d+1:d+m,1:d);

E = LHS - RHS*AC';
EE = E'*E/k;
Rxx = EE(1:d,1:d);
Ryy = EE(d+1:d+m,d+1:d+m);
Rxy = EE(1:d,d+1:d+m);

[Xhat,Yhat] = kalman(Y,A,C,Rxx,Ryy,Rxy);

clf;
hold on;
plot(Y,'*');
plot(Yhat);
title('Estimate (solid line) against the measurements');
hold off;

