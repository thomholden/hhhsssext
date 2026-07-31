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



function C = BuildMatricesC(LD, Delta, E)
%Builds all the matrices C^{(j)}(n) at time index n for path omega
%C(i,k,j,n) contains entry (i,k) of C^{(j)}(n)

    C = zeros(LD.m,LD.m,LD.m,LD.m-1);    
    for n = 1:LD.m-1
        for i = 1:LD.m
            C(i,:,:,n) = Delta(:,:,n).'  * E(:,:,i,n).' * Delta(:,:,n);
        end
    end
    
end
