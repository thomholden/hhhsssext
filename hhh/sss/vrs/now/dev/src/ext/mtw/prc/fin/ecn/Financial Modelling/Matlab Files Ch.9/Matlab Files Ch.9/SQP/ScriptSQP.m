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





% This script demonstrates the SQP optimization algorithm

p = path;
addpath(genpath(pwd));

% %Example 1:         min f(x1,x2) = -5x1+x1^2-5x2+x2^2
% % accoring to       g1(x1,x2) = x1+2x2-8  <= 0
% %                   g2(x1,x2) = 3x1+x2-9  <= 0
% %                                   x1,x2 >= 0
% 
% %The optimal solution is given by x1 = 2.2, x2 = 2.4
% 
% %feasible initial guess
% x0 = [1.0;1.0];
% %objective function
% objF = @objectiveFunctionExample1;
% %contraints function
% constF = @constraintsFunctionExample1;
% 
% %start optimization
% [xMin,fMin,vecX] = modSQP(objF,x0,constF,[0;0]);
% 
% fprintf('Minimum solution vector:\n\n')
% disp('xMin =')
% disp(xMin)
% fprintf('Minimum function value:\n\n') 
% disp('fMin =')
% disp(fMin)



% %Example 2:         min f(x1,x2) = exp(x1)[4x1^2+2x2^2+4x1x2+2x1+1]
% % accoring to       g1(x1,x2) = x1x2-x1-x2+1.5  <= 0
% %                   g2(x1,x2) = -x1x2-10  <= 0
% %
% 
% %The optimal solution given by Matlab fmincon is x1 = -9.5474, x2 = 1.0474
% 
% %initial guess
% x0 = [-3;2];
% %objective function
% objF = @objectiveFunctionExample2;
% %contraints function
% constF = @constraintsFunctionExample2;
% 
% %start optimization
% [xMin,fMin] = modifiedSQP(objF,x0,constF);
% 
% fprintf('Minimum solution vector:\n\n')
% disp('xMin =')
% disp(xMin)
% fprintf('Minimum function value:\n\n') 
% disp('fMin =')
% disp(fMin)


% %Example 3: Rosen-Suzuki-Problem: Convex, Four-Variable Example
% %--------------------------------------------------------
% %               min f(x) = x1^2+x2^2+2*x3^2+x4^2-5*x1-5*x2-21*x3+7*x4
% % subject to:      g1(x) = x1^2+x2^2+x3^2+x4^2+x1-x2+x3-x4-8 <= 0
% %                  g2(x) = x1^2+2*x2^2+x3^2+2*x4^2-x1-x4-10 <= 0
% %                  g3(x) = 2*x1^2+x2^2+x3^2+2*x1-x2-x4-5 <= 0
% %--------------------------------------------------------
% 
% %The optimal solution is given by xmin = (0,1,2,-1), fmin = -44
% 
% % initial guess
% x0 = [0;0.5;1;0]; 
% % objective function
% objF = @objectiveFunctionExample3;
% % constraints function
% constF = @constraintsFunctionExample3;
% 
% %start optimization
% [xMin,fMin] = modSQP(objF,x0,constF);
% 
% fprintf('Minimum solution vector:\n\n')
% disp('xMin =')
% disp(xMin)
% fprintf('Minimum function value:\n\n') 
% disp('fMin =')
% disp(fMin)

%Example 4: Ackley's function

%feasible initial guess
x0 = [-2.5;2.5];
%objective function
objF = @ackley;

lb = [-3;-3];
ub = [3; 3];

%start optimization
[xMin,fMin,vecX] = modSQP(objF,x0,[],lb,ub);

fprintf('Minimum solution vector:\n\n')
disp('xMin =')
disp(xMin)
fprintf('Minimum function value:\n\n') 
disp('fMin =')
disp(fMin)

path(p)
