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
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



% Test-Script: unconstrained Nelder-Mead Downhill Simplex
% -----------------------------------------------------------

% Example 1: Beale function, Two-Variable Example
%--------------------------------------------------------
%     min f(x) = (1.5 - x1 + x1*x2)^2 
%                + (2.25 - x1 + x1*x2^2)^2
%                + (2.625 - x1 + x1*x2^3)^2
%
% Global minimum f(x*) = 0 with x* = (3, 0.5)'
%--------------------------------------------------------
% 
% objective function
objF = @(x)(1.5 - x(1,:)+ x(1,:).*x(2,:)).^2 ...
    + (2.25 - x(1,:) + x(1,:).*x(2,:).^2).^2 ...
    + (2.625 - x(1,:)+ x(1,:).*x(2,:).^3).^2;
% initial guess
x0 = [1;1];
% init Nelder-Mead parameter
alpha = 1; % reflection coefficient
beta = 0.5;  % contraction coefficient
gamma = 2.0; % expansion coefficient

% start optimiaztion procedure
[xMin,fMin] = NelderMead(objF,x0,alpha,beta,gamma)


% % Example 2: Extended Rosenbrock Function, N variable but even
% %--------------------------------------------------------
% %     min f(x) = 100(x2 - x1^2)^2 + (1 - x1)^2
% %               + 100(x4 - x3^2)^2 + (1 - x3)^2
% %               + ...
% %               + 100(xN - x_N-1^2)^2 + (1 - x_N-1)^2
% %
% % Global minimum f(x*) = 0 with x* = (1,...,1)'
% %--------------------------------------------------------
% % 
% % objective function
% objF = @(x)sum(100*(x(2:2:end,:) - x(1:2:end-1,:).^2).^2 ...
%            + (1 - x(1:2:end-1,:)).^2);
% 
% N = 10;       
% % initial guess
% x0 = repmat([-1.2;1],N/2,1);
% 
% % start optimiaztion procedure with deafult parameters
% [xMin,fMin] = NelderMead(objF,x0)
