
function [M1,M2,M3,M4,M5,M6,M7,M8] = nn(X,Y,d,gamma,momentum,epochs)

%   [M1,M2,...] = nn(X,Y,NN,gamma,momentum,epochs)
%
% Back-propagation of errors for feedforward perceptron network
% using momentum algorithm.
% PLEASE, rather use the MATLAB NNET Toolbox!
%
% Input parameters:
%  - X: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - NN: Numbers of hidden layer elements in list form
%       (Positive meaning 'tansig', negative linear)
%  - gamma: Learning parameter (default 0.01)
%  - momentum: Momentum term (default 0)
%  - epochs: Number of cycles (default indefinitely) 
% Return parameters:
%  - Mi: Weight matrices for each layer (i <= 8)
%
% Heikki Hyotyniemi Dec.12, 2000


if nargin < 4
   gamma = 0.01;
end
if nargin < 5
   momentum = 0;
end
if nargin < 6
   epochs = inf;
end
[mx,nx] = size(X);
[my,ny] = size(Y);
if mx ~= my
   disp('Incompatible X and Y');
else
   m = mx;
end

D = length(d) + 1;
du = [nx,abs(d)]; du = du + 1;
dy = [abs(d),ny];
nonlinear = [sign(d),-1];
lambda = 2;
a = 2;

args = 'd';
rets = '';
for j = 1:D
   args = [args,',M',num2str(j)];
   rets = ['Y',num2str(j),',',rets];
end
for i = 1:D
   eval(['n',num2str(i),' = [dy(',num2str(i),'),du(',num2str(i),')]']);
   eval(['M',num2str(i),' = 2*(rand(n',num2str(i),')-0.5)/sqrt(du(',num2str(i),'));']);
   eval(['delta',num2str(i),' = zeros(n',num2str(i),');']);
end
for i = 1:D
   eval(['[',rets(1:length(rets)-1),'] = NNR(X,',args,');']);
   eval(['maxz = max(Y',num2str(i),');']);
   eval(['minz = min(Y',num2str(i),');']);
   eval(['avgz = mean(Y',num2str(i),');']);
   eval(['M',num2str(i),'(:,du(',num2str(i),')) = -(avgz''-M',num2str(i),'(:,du(',num2str(i),')));']);
   eval(['M',num2str(i),'(:,1:du(',num2str(i),')-1) = M',num2str(i),'(:,1:du(',num2str(i),')-1).*((1./((maxz-minz)/2))''*ones(1,du(',num2str(i),')-1));']);
end

for loop = 1:epochs
   order = randperm(m);
   cumE = 0;
   for i = 1:m
      Y0 = X(order(i),:);
      eval(['[',rets(1:length(rets)-1),'] = NNR(Y0,',args,');']);
      eval(['e=Y(order(i),:)''-Y',num2str(D),''';']);
      for j = D:-1:1
         
         eval(['M = M',num2str(j),';']);
         eval(['u = [Y',num2str(j-1),''';1];']);
         z = M*u;
         if nonlinear(j) > 0
            grad = ((-2*2*a*exp(-a*z)./(1+exp(-a*z)).^2).*e)*u';
         else
            grad = -2*a*e*u';
         end   
         e = M'*e;
         e = e(1:length(e)-1);
         gam = gamma*lambda^(D-j);
         eval(['delta',num2str(j),' = momentum*delta',num2str(j),' - gam*grad;']);
         eval(['M',num2str(j),' = M',num2str(j),' + delta',num2str(j),';']);         
      end      
   end
   eval(['[Yhat] = NNR(X,',args,');']);
   E = Y - Yhat;
   EE = E.*E;
   ee = sum(sum(EE));
   clf;
   hold on;
   [V,L] = eig(Y'*Y);
   [maxL,maxi] = max(diag(L));
   plot(Y*V(:,maxi),'r*');
   plot(Yhat*V(:,maxi),'bo');
   title('Approximation (projected onto the 1st pc)');
   drawnow;
   if isinf(epochs)
      reply = input([num2str(loop),'. SSE=',num2str(ee),' - Give gamma or ''N'' to break: '],'s');
      if ~isempty(reply) & (reply == 'N' | reply == 'n')
         break;
      end
      if ~isempty(reply)
         lambda = str2num(reply);
      end
   end
      
end
   
            
            
            
            
            
            
      