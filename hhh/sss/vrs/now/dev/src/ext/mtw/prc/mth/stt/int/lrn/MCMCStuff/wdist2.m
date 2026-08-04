function  dist = wdist2(expSigmas, tx, x)
%WDIST2 Evaluate weighted and squared distance matrix of two input data sets.
%
% Description
%   DIST = WDIST2(EXPSIGMAS, TX, X) takes two matrixes Tx and X and weight 
%   vector EXPSIGMAS and returns a weighted distance matrix DIST. Every row 
%   of TX and X corresponds one data vector. The number of rows in TX and X
%   has to be same. Every element ij of DIST matrix contains a squared distance
%   of i'th row in TX and j'th row in X multiplied by expSigmas.

% Copyright (c) 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

[tn,tm]=size(tx);
[nn,nm]=size(x);

if tm~=nm
  error('the number of columns of TX and X has to be same')
end

if nm==1 & tm==1
  tx2=repmat(tx,1,nn);
  x2=repmat(x',tn,1);
  dist=expSigmas*(tx2-x2).^2;
else
  % If ARD is not used make expSigmas a vector of 
  % equal elements 
  if size(expSigmas)==1
    expSigmas = repmat(expSigmas,1,tm);
  end
  tx2=[];
  x2=[];
  D=[];
  for i=1:tm
    tx2(:,:,i)=repmat(tx(:,i),1,nn);
    x2(:,:,i)=repmat(x(:,i)',tn,1);
  end
  for j=1:tm
    D(:,:,j)=(tx2(:,:,j)-x2(:,:,j)).^2*expSigmas(:,j);
  end
  dist=zeros(tn,nn);
  for k=1:tm
    dist=dist+D(:,:,k);
  end
end
 