
function [A,B,C,D,Rxx,Ryy,Rxy] = ssi(U,Y,maxdim,d)

%   [A,B,C,D,Rxx,Ryy,Rxy] = ssi(U,Y,maxdim,d)
%   [A,B,C,D,Rxx,Ryy,Rxy] = ssi(U,Y,maxdim)
%
% Subspace identification (simplified)
%
% Input parameters:
%  - U: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - maxdim: Assumed maximum possible system dimension
%  - d: System dimension (optional)
% Return parameters:
%  - A,B,C,D: System matrices
%  - Rxx,Ryy,Rxy: Noise covariances
%
% Heikki Hyotyniemi Sep.12, 2000


[ku,n] = size(U);
[ky,m] = size(Y);
if ku == ky
   k = ku;
else disp('Input and output dimensions incompatible'); return;
end

UU = zeros(k-2*maxdim+1,2*maxdim*n);
for i = 1:2*maxdim
   UU(:,(i-1)*n+1:i*n) = U(i:k-2*maxdim+i,:);
end
UP = UU(:,1:maxdim*n);
UF = UU(:,maxdim*n+1:2*maxdim*n);

YY = zeros(k-2*maxdim+1,2*maxdim*m);
for i = 1:2*maxdim
   YY(:,(i-1)*m+1:i*m) = Y(i:k-2*maxdim+i,:);
end
YP = YY(:,1:maxdim*m);
YF = YY(:,maxdim*m+1:2*maxdim*m);

WP = [UP,YP];
WW = [WP,UF];
W0 = [WP,zeros(size(UF))];

OO = W0*inv(WW'*WW+0.01*eye(size(WW,2)))*WW'*YF;

if nargin==4
   theta = pca(OO,d);
else
   theta = pca(OO);
   d = size(theta,2);
end

X = OO*theta;
XP = X(1:size(X,1)-1,:);
XF = X(2:size(X,1),:);

LHS = [XF,YF(1:size(YF,1)-1,1:m)];
RHS = [XP,UF(1:size(UF,1)-1,1:n)];
ABCD = (inv(RHS'*RHS+0.01*eye(size(RHS,2)))*RHS'*LHS)';

A = ABCD(1:d,1:d);
B = ABCD(1:d,d+1:d+n);
C = ABCD(d+1:d+m,1:d);
D = ABCD(d+1:d+m,d+1:d+n);

E = LHS - RHS*ABCD';
EE = E'*E/k;
Rxx = EE(1:d,1:d);
Ryy = EE(d+1:d+m,d+1:d+m);
Rxy = EE(1:d,d+1:d+m);

if nargin<4
   Xhat = zeros(k+1,d);
   Yhat = zeros(k,m);
   for i = 1:k
      Yhat(i,:) = Xhat(i,:)*C' + U(i,:)*D';
      Xhat(i+1,:) = Xhat(i,:)*A' + U(i,:)*B';
   end

   clf;
   hold on;
   plot(Y,'*');
   plot(Yhat);
   title('Estimate (solid line) against the measurements');
   hold off;
end
