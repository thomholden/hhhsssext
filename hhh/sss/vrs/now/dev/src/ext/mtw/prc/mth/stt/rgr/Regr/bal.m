
function [Ared,Bred,Cred,theta,sigma] = bal(A,B,C,N)

%   [Ared,Bred,Cred,theta,sigma] = bal(A,B,C,N)
%   [Ared,Bred,Cred,theta,sigma] = bal(A,B,C)
%
% State-space dynamic system reduction. 
%
% Input parameters:
%  - A,B,C: System matrices
%  - N: Number of remaining states (optional)
% Return parameters:
%  - Ared,Bred,Cred: Reduced system matrices
%  - theta: State transformation matrix, z=theta'*x
%  - sigma: Corresponding Hankel singular values
%
% Heikki Hyotyniemi Dec.20, 2000


[nA1,nA2] = size(A);
[nB1,nB2] = size(B);
[nC1,nC2] = size(C);
if nA1~=nA2, disp('System matrix A not square!'); return; 
else d = nA1; end
if nB1~=d, disp('System matrix B incompatible!'); return; 
else n = nB2; end
if nC2~=d, disp('System matrix C incompatible!'); return; 
else m = nC1; end
normA = norm(A);
if (normA>=1)
   disp('System is not asymptotically stable!'); return;
end

loops = round(-10/log10(normA));
PC = zeros(d,d);   
PO = zeros(d,d);   
for i = 1:loops
   PC = A*PC*A' + B*B';
   PO = A'*PO*A + C'*C;
end

R = PC*PO;

[THETA,LAMBDA] = eig(R);
[LAMBDA,order] = sort(abs(diag(LAMBDA)));
LAMBDA = sqrt(flipud(LAMBDA));
THETA = THETA(:,flipud(order));

theta = inv(THETA)';
sigma = sqrt(LAMBDA);
if nargin<4 | isnan(N) | isinf(N) | isempty(N)
   N = askorder(sigma);
end

Abal = inv(THETA)*A*THETA;
Bbal = inv(THETA)*B;
Cbal = C*THETA;
Ared = real(Abal(1:N,1:N));
Bred = real(Bbal(1:N,:));
Cred = real(Cbal(:,1:N));

% Visualization
k = 20;
if nargin<4
   U1 = zeros(n,k); U1(:,1) = ones(n,1);
   U2 = ones(n,k);
   X1 = zeros(d,k+1);
   X1red = zeros(N,k+1);
   X2 = zeros(d,k+1);
   X2red = zeros(N,k+1);
   Y1 = zeros(m,k);
   Y1red = zeros(m,k);
   Y2 = zeros(m,k);
   Y2red = zeros(m,k);
   for i = 1:k
      X1(:,i+1) = A*X1(:,i) + B*U1(:,i);
      X1red(:,i+1) = Ared*X1red(:,i) + Bred*U1(:,i);
      X2(:,i+1) = A*X2(:,i) + B*U2(:,i);
      X2red(:,i+1) = Ared*X2red(:,i) + Bred*U2(:,i);
      Y1(:,i) = C*X1(:,i);
      Y1red(:,i) = Cred*X1red(:,i);
      Y2(:,i) = C*X2(:,i);
      Y2red(:,i) = Cred*X2red(:,i);
   end
   figure(1); clf
   plot(Y1','r'); hold on;
   plot(Y1red','b'); 
   title('Pulse responses');
   figure(2); clf
   plot(Y2','r'); hold on;
   plot(Y2red','b'); 
   title('Step responses');
end
   