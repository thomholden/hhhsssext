function cMat = searchCoint(P)
% function to identify cointegrated pairs.
% example:
% load Portfolio_Data
% cMat = searchCoint(P);
% imagesc(cMat); colorbar

if nargin < 1
    % load the data
    load('c:\work\QuantFactory\Portfolio_data')
end
% initialise the cointegtation matrix
%dts=P(:,1); P(:,1)=[];
numEq= size(P,2);
cMat = zeros(numEq);

for i=1:numEq
    for j=i+1:numEq
        cMat(i,j)=isCoint(P(:,i),P(:,j));
    end
end

function cointres=isCoint(X,Y)
% first perform an OLS and get residuals
beta = [ones(length(X),1),X]\Y;
res = Y - [ones(length(X),1),X]*beta;
% do a simple unit root test on the residuals
[H,PValue,TestStat] = dfARTest(res);
if H
    cointres=TestStat;
else
    cointres=0;
end