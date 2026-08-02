
function [theta] = iica(X)

%   [theta] = iica(X)
%
% Interactive Independent Component Analysis
%
% Input parameter:
%  - X: Input data block, mixture of signals (k x n)
% Return parameter:
%  - theta: Independent components
%
% Heikki Hyotyniemi Jan.31, 2001


[k,n] = size(X);
if norm(eye(n)-X'*X/k) > 10^-5, disp('First whiten data!'); return; end

nn = (n^2+n)/2;
XX = zeros(k,(n^2+n)/2);
index = 0;
for i = 1:n
   for j = i:n
      index = index + 1;
      XX(:,index) = X(:,i).*X(:,j);
      if i ~= j
         XX(:,index) = sqrt(2)*XX(:,index);
      end
   end
end

[THETAXX,LAMBDAXX] = pca(XX,nn);

LAMBDAX = zeros(nn,n);
signals = zeros(k,nn*n);
for i = 1:nn
   thetaXX = THETAXX(:,i);
   RXX = zeros(n,n);
   index = 0;
   for j = 1:n
      for l = j:n
         index = index + 1;
         if j == l
            RXX(j,j) = thetaXX(index);
         else
            RXX(j,l) = thetaXX(index)/sqrt(2);
            RXX(l,j) = thetaXX(index)/sqrt(2);
         end
      end
   end
   [THETA,LAMBDA] = eig(RXX);
   LAMBDA = diag(LAMBDA);
   [dummy,order] = sort(abs(LAMBDA));
   LAMBDAX(i,:) = LAMBDA(order)';
   THETA = THETA(:,order);
   signals(:,(i-1)*n+1:i*n) = X*THETA;
end

selected = [];
signal = zeros(k,1);
while 1==1
   for i = 1:nn
      figure(i);
      clf;
      for j = 1:n
         signals(:,(i-1)*n+j) = signals(:,(i-1)*n+j) - ...
            (signals(:,(i-1)*n+j)'*signal)/(signal'*signal+eps) * signal;
         subplot(n,1,j);
         plot(signals(:,(i-1)*n+j));
         if j == 1
%            title(['Frame ',num2str(i)]); 
            title(['\lambda = ',num2str(LAMBDAXX(i))]); 
         end
%         ylabel(['Curve ',num2str(j)]);
         ylabel(['\lambda = ',num2str(LAMBDAX(i,j))]);
      end
   end
   frameno = input('Select good-looking frame number (or press only <return>): ');
   if isempty(frameno), break; end
   figure(frameno);
   figno = input('Additionally, give the best-looking curve number: ');
   signal = signals(:,(frameno-1)*n+figno);
   selected = [selected,signal];
end

theta = mlr(X,selected);
