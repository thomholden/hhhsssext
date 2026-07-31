% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Nikolai Nowaczyk
%   	    Joerg Kienitz
%           Daniel Wetterau
%           
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Nikolai Nowaczyk, Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function w = GammaPath(TS, D, C, V, method, omega)
    w = zeros(TS.m,TS.m);
    if(strcmp(method,'for'))
        v = sum(V);
        for j=1:TS.m
            w(j,:) = TS.forward_method(zeros(TS.m,TS.m),D, squeeze(C(:,:,j,:)), v);
        end
    elseif(strcmp(method,'adj'))
            v = sum(V);
        for j = 1:TS.m
            w(j,:) = TS.adjoint_method([], D, squeeze(C(:,:,j,:)), v);
        end                
    elseif(strcmp(method,'ads'))
        for j=1:TS.m
            w(j,:) = TS.bermudan_method([], D, squeeze(C(:,:,j,:)), V, TS.e);
        end
    end
        
end