% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function VolaParas = VolaFactory(model,data,levyData)

    if strcmp(model.ID,'BlackScholes')
        VolaParas = @(varargin)interp2(data.volaMaturities,data.volaStrikes,data.volaValues(:,:,varargin{1}),varargin{4},varargin{2}/varargin{3},'spline'); 
    elseif strcmp(model.ID,'VarianceGamma')
        VolaParas = @(varargin)levyData.vg(varargin{1},:);  
    elseif strcmp(model.ID,'NIG')
        VolaParas = @(varargin)levyData.nig(varargin{1},:);  
    elseif strcmp(model.ID,'Heston')
         VolaParas = @(varargin)levyData.heston(varargin{1},:);  
    elseif strcmp(model.ID,'Bates')
         VolaParas = @(varargin)levyData.bates(varargin{1},:);  
    end
     
end