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





% This script demonstrates the LBFGS optimization algorithm
% using function FMINLBFGS available from:
% http://www.mathworks.de/matlabcentral/fileexchange/authors/29180

p = path;
addpath(genpath(pwd));

% number of parameters
N = [2, 10, 20:20:100,200:200:1000];
% initial guess
x0 = repmat([-1.2;1],N(end)/2,1);
% global minimizer
xstar = ones(N(end),1);

% L-BFGS
%----------------------------------------------------------------------------
% option struct
options = struct('GradObj','on','Display','off','HessUpdate',...
                'lbfgs','GoalsExactAchieve',1,'MaxIter',100*N(end));

disp('                         L-BFGS');
disp('   N     ||xstar-xk||         f(xk)        TotalTime      Iteration');
disp('----------------------------------------------------------------------');
for i = 1:length(N)
    options.StoreN = min(N(i)/2,20);
    % start L-BFGS method
    [xMin,fMin,exitflag,output] = ...
                fminlbfgs(@objfunExtendedRosenbrock,x0(1:N(i)),options);
    errX = norm(xMin - xstar(1:N(i)),inf);
    s=sprintf('%4d     %1.4e       %0.4e   %10.5f      %5d    ', ...
             N(i),errX,fMin,output.timeTotal,output.iteration); disp(s);
end
s=sprintf('\n');disp(s);

% BFGS Initial Inverse Hessian invH0 set to identity
%------------------------------------------------------------------------------
options.HessUpdate ='bfgs';

disp('                       BFGS with invH0 = eye');
disp('   N     ||xstar-xk||         f(xk)        TotalTime      Iteration');
disp('----------------------------------------------------------------------');
for i = 1:length(N)
    % start BFGS-method
    [xMin,fMin,exitflag,output] = fminlbfgs(@objfunExtendedRosenbrock,x0(1:N(i)),options);
    errX = norm(xMin - xstar(1:N(i)),inf);
    s=sprintf('%4d     %0.4e       %0.4e   %10.5f      %5d    ',N(i),errX,fMin,output.timeTotal,output.iteration); disp(s);
end
s=sprintf('\n');disp(s);

% BFGS Explicit Initial Inverse Hessian invH0 = inv(f''(x0))
%------------------------------------------------------------------------------

% estimate inverse Hessian matrix invH0
aux = 400*(3*x0(1:2:end-1).^2-x0(2:2:end)) + 2;
dm = 200*ones(size(x0));
dm(1:2:end-1) = aux;
dul = zeros(N(end)-1,1);
dul(1:2:end) = -400*x0(1:2:end-1);
invH0 = inv(diag(dul,1) + diag(dm) + diag(dul,-1));


disp('                       BFGS with invH0 = inv(f''''(x0))');
disp('   N     ||xstar-xk||         f(xk)        TotalTime      Iteration');
disp('----------------------------------------------------------------------');
for i = 1:length(N)
    % start BFGS-method
    [xMin,fMin,exitflag,output] = fminlbfgs(@objfunExtendedRosenbrock,x0(1:N(i)),options,invH0(1:N(i),1:N(i)));
    errX = norm(xMin - xstar(1:N(i)),inf);
    s=sprintf('%4d     %0.4e       %0.4e   %10.5f      %5d    ',N(i),errX,fMin,output.timeTotal,output.iteration); disp(s);
end

path(p)