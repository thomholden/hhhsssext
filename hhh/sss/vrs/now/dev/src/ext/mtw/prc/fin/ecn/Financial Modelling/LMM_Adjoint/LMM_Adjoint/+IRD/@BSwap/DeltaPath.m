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



function Delta = DeltaPath(B,D,V,method,omega)
    Delta = zeros(1,B.m);
    r = B.optimal(omega);    
    if(r)  %otherwise the delta in this path is zero
        if(strcmp(method,'for'))
            v = sum(V);
            Delta = B.forward_method(eye(B.m),D,[],v);
        elseif(strcmp(method,'adj'))
            v = sum(V);
            Delta = B.adjoint_method(eye(B.m), D, [] , v);
        elseif(strcmp(method,'ads'))
            Delta = B.bermudan_method(eye(B.m), D, [], V, r);
        end
    end
end