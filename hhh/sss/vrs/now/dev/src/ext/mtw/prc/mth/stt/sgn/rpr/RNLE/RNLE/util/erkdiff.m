function [x,dx]=erkdiff(fun,x0,tseq,mthd) %#ok<*NBRAK>
%ERKDIFF    Differentiation of the explicit Runge-Kutta method
%   
%   ERKDIFF integrates a system of non-stiff, time-independent ordinary
%   differential equations by applying an explicit Runge-Kutta method with
%   given step sizes. It returns the final values of the solution and their
%   derivatives with respect to the initial conditions.
%   
%   Usage: [X,dX]=ERKDIFF(F,X0,T,Mthd)
%   
%   Input arguments:  F    - Vector-valued function
%                     X0   - Initial conditions
%                     T    - Time sequence (the integration step sizes are
%                            determined from T as h=diff(T))
%                     Mthd - Integration method
%   
%   Output arguments: X    - Final values of the solution
%                     dX   - Derivatives of the final values of the
%                            solution with respect to the initial
%                            conditions
%   
%   ERKDIFF integrates the system dX/dt=F(X) from t=T(1) to t=T(N), where
%   N=numel(T), starting from initial conditions X(T(1))=X0. The integrator
%   takes a sequence of N-1 steps of pre-determined size h(i)=T(i+1)-T(i)
%   for i=1 to N-1.
%   
%   The solution to this initial value problem is a trajectory X(t). The
%   final values of this trajectory are returned in X. The derivatives of
%   these final values with respect to X0 are returned in dX.
%   
%   The following table summarizes the input/output convention for this
%   function. Constant Dim is the dimensionality of the system (the number
%   of dependent variables). Constant Len is the number of elements in the
%   time sequence (equal to one minus the number of integration steps).
%   
%       Input/Output   Class              Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       F              function handle    Scalar    1-by-1
%       X0             numeric            Vector    Dim-by-1/1-by-Dim
%       T              numeric            Vector    Len-by-1/1-by-Len
%       Mthd           char               String    1-by-numel(Mthd)   *
%       X              numeric            Vector    Dim-by-1
%       dX             numeric            Matrix    Dim-by-Dim
%       ____________________________________________________________
%       * Must be either Bogacki–Shampine, Runge-Kutta-Fehlberg,
%         Cash-Karp or Dormand-Prince.
%   
%   Below is a summary of the usage and input/output conventions for the
%   vector-valued function.
%   
%       Usage:   [Y,dY]=F(X)
%   
%       Inputs:   X   - Vector of dependent variables
%   
%       Outputs:  Y   - Value of the function
%                 dY  - Derivatives of the function (Jacobian matrix)
%   
%       Input/Output   Class      Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       X              numeric    Vector    Dim-by-1/1-by-Dim
%       Y              numeric    Vector    Dim-by-1/1-by-Dim
%       dY             numeric    Vector    Dim-by-Dim
%   
%   Copyright (c) 2012 Gabriel Agamennoni.

% Check number of input and output arguments.
if nargin()<4
    error('erkdiff:NotEnoughInputs',...
        'Not enough input arguments.')
end
if nargin()>4
    error('erkdiff:TooManyInputs',...
        'Too many input arguments.')
end
if nargout()>2
    error('erkdiff:TooManyOutputs',...
        'Too many output arguments.')
end

% Check input arguments.
chkargs(fun,x0,tseq,mthd)

% Retrieve extended Butcher tableau.
switch lower(mthd)
    case 'bogacki–shampine'
        A=[1/2,0,0;...
            0,3/4,0;...
            2/9,1/3,4/9];
        b=[7/24,1/4,1/3,1/8];
    case 'runge-kutta-fehlberg'
        A=[1/4,0,0,0,0;...
            3/32,9/32,0,0,0;...
            1932/2197,-7200/2197,7296/2197,0,0;...
            439/216,-8,3680/513,-845/4104,0;...
            -8/27,2,-3544/2565,1859/4104,-11/40];
        b=[16/135,0,6656/12825,28561/56430,-9/50,2/55];
    case 'cash-karp'
        A=[1/5,0,0,0,0;...
            3/40,9/40,0,0,0;...
            3/10,-9/10,6/5,0,0;...
            -11/54,5/2,-70/27,35/27,0;...
            1631/55296,175/512,575/13824,44275/110592,253/4096];
        b=[37/378,0,250/621,125/594,0,512/1771];
    case 'dormand-prince'
        A=[1/5,0,0,0,0,0;...
            3/40,9/40,0,0,0,0;...
            44/45,-56/15,32/9,0,0,0;...
            19372/6561,-25360/2187,64448/6561,-212/729,0,0;...
            9017/3168,-355/33,46732/5247,49/176,-5103/18656,0;...
            35/384,0,500/1113,125/192,-2187/6784,11/84];
        b=[5179/57600,0,7571/16695,393/640,-92097/339200,187/2100,1/40];
end

% Store dimensionality and order.
dim=numel(x0);
ord=numel(b)-1;

% Allocate space for increments.
hx=zeros(dim,ord+1);
hdx=zeros(dim,dim,ord+1);

% Initialize final values and derivatives.
x=x0(:);
dx=eye(dim);

% Integrate differential equations.
for i=2:numel(tseq)
    
    % Store step size.
    h=tseq(i)-tseq(i-1);
    
    % Evaluate function and derivatives.
    [f,df]=feval(fun,x);
    
    % Initialize increments.
    hx(:,1)=h*f;
    hdx(:,:,1)=h*(df*dx);
    
    % Compute increments and their derivatives.
    for k=1:ord
        
        % Evaluate function and derivatives.
        [f,df]=feval(fun,x+hx(:,1:k)*A(k,1:k)');
        
        % Update increments.
        hx(:,k+1)=h*f;
        hdx(:,:,k+1)=h*(df*(dx+lincomb(hdx(:,:,1:k),A(k,1:k),3)));
        
    end
    
    % Update final values and derivatives.
    x=x+hx*b';
    dx=dx+lincomb(hdx,b,3);
    
end

end



function chkargs(fun,x0,tseq,mthd)

% Initialize input argument counter.
arg=0;

% Check function.
arg=arg+1;
if isa(fun,'function_handle')
    if isempty(fun)
        error('erkdiff:BadInputSize',...
            'Input argument %d must be non-empty.',arg)
    end
    if ndims(fun)>2||numel(fun)>1
        error('erkdiff:BadInputSize',...
            'Input argument %d must be a scalar.',arg)
    end
else
    if ~ischar(fun)
        error('erkdiff:BadInputClass',...
            'Input argument %d must be a string.',arg)
    end
    if isempty(fun)
        error('erkdiff:BadInputSize',...
            'Input argument %d must be non-empty.',arg)
    end
    if ndims(fun)>2||size(fun,1)>1
        error('erkdiff:BadInputSize',...
            'Input argument %d must contain a string.',arg)
    end
    if ~exist(fun,'file')
        error('erkdiff:BadInputValue',...
            'Input argument %d must contain a valid file name.',arg)
    end
end
if any(nargin(fun)==0)
    error('erkdiff:BadInputSize',...
        'Input argument %d must accept at least %d input argument(s).',arg,1)
end
if any(nargout(fun)==0:1)
    error('erkdiff:BadInputSize',...
        'Input argument %d must return at least %d output argument(s).',arg,2)
end

% Check initial conditions.
arg=arg+1;
if ~isnumeric(x0)
    error('erkdiff:BadInputClass',...
        'Input argument %d must be numeric.',arg)
end
if ~isreal(x0)
    error('erkdiff:BadInputClass',...
        'Input argument %d must be real.',arg)
end
if isempty(x0)
    error('erkdiff:BadInputSize',...
        'Input argument %d must be non-empty.',arg)
end
if ndims(x0)>2||min(size(x0))>1
    error('erkdiff:BadInputSize',...
        'Input argument %d must be a vector.',arg)
end
if any(isnan(x0)|isinf(x0))
    error('erkdiff:BadInputValue',...
        'Input argument %d must contain finite numbers.',arg)
end

% Check time sequence.
arg=arg+1;
if ~isnumeric(tseq)
    error('erkdiff:BadInputClass',...
        'Input argument %d must be numeric.',arg)
end
if ~isreal(tseq)
    error('erkdiff:BadInputClass',...
        'Input argument %d must be real.',arg)
end
if isempty(tseq)
    error('erkdiff:BadInputSize',...
        'Input argument %d must be non-empty.',arg)
end
if ndims(tseq)>2||min(size(tseq))>1
    error('erkdiff:BadInputSize',...
        'Input argument %d must be a vector.',arg)
end
if any(isnan(tseq)|isinf(tseq))
    error('erkdiff:BadInputValue',...
        'Input argument %d must contain finite numbers.',arg)
end
if any(diff(tseq)<=0)
    error('erkdiff:BadInputValue',...
        'Input argument %d must contain strictly increasing numbers.',arg)
end

% Check integration method.
arg=arg+1;
if ~ischar(mthd)
    error('erkdiff:BadInputClass',...
        'Input argument %d must be a string.',arg)
end
if isempty(mthd)
    error('erkdiff:BadInputSize',...
        'Input argument %d must be non-empty.',arg)
end
if ndims(mthd)>2||size(mthd,1)>1
    error('erkdiff:BadInputSize',...
        'Input argument %d must be a string.',arg)
end
if ~any(strcmpi(mthd,{'bogacki–shampine','runge-kutta-fehlberg','cash-karp',...
        'dormand-prince'}))
    error('erkdiff:BadInputValue',...
        'Input argument %d must contain a valid option.',arg)
end

end