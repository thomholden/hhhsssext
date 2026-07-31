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



% Test-Script: Nelder-Mead Downhill Simplex with constraints
%-----------------------------------------------------------

% %Example 1: Nonconvex, Two-Variable Example
% %--------------------------------------------------------
% %               min f(x) = (x1-10)^3+(x2-20)^3
% % subject to:      g1(x) = -x1+13 <= 0
% %                  g2(x) = -(x1-5)^2-(x2-5)^2+100 <= 0
% %                  g3(x) = (x1-6)^2+(x2-5)^2-82.81 <= 0
% %                  g4(x) = -x2 <= 0
% %--------------------------------------------------------
% 
% % objective function
% objF = @(x)(x(1,:)-10).^3+(x(2,:)-20).^3;
% % constraints function
% conF = @myconEx1;
% % initial guess
% x0 = [14.35;8.6];
% 
% [xMin,fMin,iter] = conNelderMead(objF,conF,x0)


%Example 2: Rosen-Suzuki-Problem: Convex, Four-Variable Example
%--------------------------------------------------------
%               min f(x) = x1^2+x2^2+2*x3^2+x4^2-5*x1-5*x2-21*x3+7*x4
% subject to:      g1(x) = x1^2+x2^2+x3^2+x4^2+x1-x2+x3-x4-8 <= 0
%                  g2(x) = x1^2+2*x2^2+x3^2+2*x4^2-x1-x4-10 <= 0
%                  g3(x) = 2*x1^2+x2^2+x3^2+2*x1-x2-x4-5 <= 0
%--------------------------------------------------------

% objective function
objF = @(x)(x(1,:).^2+x(2,:).^2+2*x(3,:).^2+x(4,:).^2-5*x(1,:)-5*x(2,:)-21*x(3,:)+7*x(4,:));
% constraints function
conF = @myconEx2;
% initial guess
x0 = [0;0;0;0]; %optimal solution xmin = (0,1,2,-1), fmin = -44
% optimal values
xstar = [0;1;2;-1];
fstar = -44;
% reflection coefficient
alfa = [0.98;(0.95:-0.05:0.7)'];
% contraction coeffiecient
beta = 0.5;
% expansion coeffiecient
gamma = 2.0;

xMin = zeros(length(x0),length(alfa));
fMin = zeros(length(alfa),1);
errX = zeros(length(alfa),1);
errF = zeros(length(alfa),1);
iter = zeros(length(alfa),1);
for i = 1:length(alfa)
    %start optimiaztion procedure
    [xMin(:,i),fMin(i),iter(i)] = conNelderMead(objF,conF,x0,alfa(i),beta,gamma);
    errX(i) = norm(xstar-xMin(:,i),inf);
    errF(i) = abs(fstar - fMin(i));
end


% % Example3: Four-Variable Example with an Equality Constraint
% %--------------------------------------------------------
% %               min f(x) = 2-x1*x2*x3
% % subject to:      xi-1 <= 0 i=1,2,3
% %                   -xi <= 0 i=1,2,3,4
% %                  x4-2 <= 0
% %                  x1+2*x2+2*x3-x4 == 0
% %--------------------------------------------------------
% 
% % objective function
% objF = @(x)(2.0 - x(1,:).*x(2,:).*x(3,:));
% % constraints function
% conF = @myconEx3;
% % initial guess
% x0 = [0.1;0.1;0.1;0.5]; %optimal solution xmin = (2/3,1/3,1/3,2), fmin = 1.9259259
% 
% [xMin,fMin,iter] = conNelderMead(objF,conF,x0)


% %Example 4: Nonconvex, Two-Variable Example
% %--------------------------------------------------------
% %               min f(x) = (x1-10)^3+(x2-20)^3
% % subject to:      g1(x) = -x1+13 <= 0
% %                  g2(x) = -(x1-5)^2-(x2-5)^2+100 <= 0
% %                  g3(x) = (x1-6)^2+(x2-5)^2-82.81 <= 0
% %                  g4(x) = -x2 <= 0
% %--------------------------------------------------------
% 
% objF = @(x)exp(x(1,:)).*(4*x(1,:).^2+2*x(2,:).^2+4*x(1,:).*x(2,:) + 2*x(2,:) + 1);
% conF = @myconEx4;
% x0 = [1;-1];
% 
% [xMin,fMin,iter] = conNelderMead(objF,conF,x0)
