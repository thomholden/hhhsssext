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



function Path = SimulatorFactory(model)
 
    if strcmp(model.ID,'BlackScholes')
        Path = @(S,T,n,m,r)BlackScholesPaths(S, r, T, n, m, model.params(1));
    elseif strcmp(model.ID,'VarianceGamma')
        Path = @(S,T,n,m,r)MC_VG_CGM(S,r,0,T,model.params(1),model.params(2), ...
                model.params(3),n,m,1)';
    elseif strcmp(model.ID,'NIG')
        Path = @(S,T,n,m,r)MC_NIG(S,r,0,T,model.params(1),model.params(2), ...
            model.params(3),n,m,1)';
    elseif strcmp(model.ID,'Heston')
        Path = @(S,T,n,m,r)MC_QE(S,r,0,T,model.params(1),model.params(2),...
                model.params(3),model.params(4),model.params(5),n,m,1)';
    elseif strcmp(model.ID,'Bates')
        Path = @(S,T,n,m,r)MC_QE_j(S,r,0,T,model.params(1),model.params(2),...
                model.params(3),model.params(4),model.params(5),model.params(6), ...
                model.params(7),model.params(8),n,m,1)';
    end
      
end