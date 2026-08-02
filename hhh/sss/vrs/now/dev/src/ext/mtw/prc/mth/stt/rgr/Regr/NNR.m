
function [Y,Z1,Z2,Z3,Z4,Z5,Z6,Z7] = NNR(X,d,M1,M2,M3,M4,M5,M6,M7,M8)

%   [Y,Z1,Z2,...] = NNR(X,d,M1,M2,...)
%
% Feedforward perceptron network simulation
% PLEASE, rather use the MATLAB NNET Toolbox!
%
% Input parameters:
%  - X: Input data block (m x nx)
%  - d: Numbers of hidden layer elements in list form
%       (Positive meaning 'tansig', negative linear)
%  - Mi: Weight matrices for each layer (i <= 8)
% Return parameters:
%  - Y: Output data block (m X ny)
%  - Zi: Hidden layer activations
%
% Heikki Hyotyniemi Dec.21, 2000


[m,nx] = size(X);

eval(['ny = size(M',num2str(nargin-2),',1);']);
for i = 1:nargin-3
   eval(['Z',num2str(i),' = zeros(m,',num2str(abs(d(nargin-2-i))),');']);
end
Y = zeros(m,ny);
d = [d,-ny];
a = 2;

for i = 1:m
   z = X(i,:)';
   for j = 1:nargin-2
%      eval(['M',num2str(j)]);
      eval(['z = M',num2str(j),'*[z;1];']);
      if d(j) > 0
         z = 2./(1+exp(-a*z))-1;
      else
         z = a*z;
      end
      if j < nargin-2
         eval(['Z',num2str(nargin-2-j),'(i,:) = z'';']);
      else
         Y(i,:) = z';
      end
   end
end

