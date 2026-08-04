function indx = mlp2index(net, type)
%MLP2INDEX Create indexes for mlp2 input variable selection.
%
%          Description
%          INDX = MLP2INDEX(NET, TYPE) takes a network structure
%          NET and prior weight type vector TYPE and returns
%          indexes for input variable selection.
%
% Copyright (c) 1999 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

if nargin < 2
  type=[0 0 0 0];
end

w=1:net.nwts;
net=mlp2unpak(net,w);

switch type(1)
 case 0
  indx{1}=net.w1(:);
 case 1
  indx{1}=net.w1';
 case 2
  indx{1}=net.w1;
end
indx{2}=net.b1';
switch type(3)
 case 0
  indx{3}=net.w2(:);
 case 1
  indx{3}=net.w2';
 case 2
  indx{3}=net.w2;
end
indx{4}=net.b2';
