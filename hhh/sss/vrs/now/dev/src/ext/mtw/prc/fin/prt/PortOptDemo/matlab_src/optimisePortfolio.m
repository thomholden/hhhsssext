function [portRisk, portReturn, portWeights, efficientFrontierImage] = ...
    optimisePortfolio(expRets, expCov, assetMin, assetMax, nPorts)
%performs the portfolio optimisation
%

portRisk = [];
portReturn = [];
portWeights = [];

if nargin > 2 && nargin < 4
    error('optimisePortfolio: must specifiy both min and max asset limits');
end

if nargin > 2
    if ~(isvector(assetMin) && isvector(assetMax))
        error('optimisePortfolio: asset limits must be vectors');
    else
        %make sure the asset limits are row vectors
        assetMin = assetMin(:)';
        assetMax = assetMax(:)';

    end
else
    assetMin = [];
    assetMax = [];
end

if nargin < 5
    nPorts = [];
end


if ~isempty(expRets) && ~isempty(expCov)
    nAssets = size(expRets, 2);

    conSet  = [];
    if nargin > 2
        %fix the total value of the portfolio to 1
        conSet = portcons('PortValue', 1, nAssets);
        %apply the asset limits
        conSet = [conSet; pcalims(assetMin, assetMax)];
    end

    [portRisk, portReturn, portWeights] = portopt(expRets, expCov, nPorts, [], conSet);
    
    if nargout == 4
        efficientFrontierImage = getEfficientFrontierPlot(portRisk, portReturn);
    end
end