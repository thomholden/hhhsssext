function h=ExpVol(asset,lambda)
% The RiskMetrics approach to volatility measurement using exponential 
% forecast
% asset is array of asset prices (generally daily close)

% Calculate asset return
N=size(asset,1);
r=log(asset(2:N)./asset(1:N-1));

h(1)=(1-lambda)*r(1)^2; 
for i=2:N-1
    h(i) = lambda*h(i-1)+(1-lambda)*r(i)^2;
end
