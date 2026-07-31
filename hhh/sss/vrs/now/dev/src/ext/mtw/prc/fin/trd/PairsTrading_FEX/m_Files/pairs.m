% DESCRIPTION:
%     This function is part of pairstrading.m function. The basic objective
%     of the present function is to find the pairs of each stock in a matrix
%     of normalized prices series.
%
%       USAGE: [pairs]=pairs(x,method)
%
%       INPUT:
%               x - A matrix with the normalized prices of all tested assets in the
%               pairs trading framework. The rows represents the time and
%               the collums represents each asset.
%
%       OUTPUT:
%               pairs - A matrix were the first colum is the respective
%               pair for each stock and the second collum is the found qerror or correlation found.
%
%
%   Author: Marcelo Scherer Perlin
%   Email:  marceloperlin@gmail.com
%   University of Rio Grande do Sul/ Brazil -
%   Business School/Department of Finance
%   Created: November/2006 Last Update: -

function [pairs]=pairs(x)

[n2]=size(x,2);

Qdist=zeros(n2,n2);

for i=1:n2
    for j=1:n2
        Qdist(i,j)=sum((x(:,i)-x(:,j)).^2);
        if i==j
            Qdist(i,j)=nan;
        end
    end
end

[m,n]=min(Qdist);
pairs(:,1)=n';
pairs(:,2)=m';






