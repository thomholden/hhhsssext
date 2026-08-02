function [State,Uncert]=Estim(Obj,State,In,Out,varargin)
%RNLE.ESTIM    Estimate sequence of states from data
%   
%   RNLE.ESTIM runs the robust non-linear estimation algorithm on sequences
%   of data and returns the estimated state sequence and its uncertainty.
%   
%   Usage:  [Xest,Xcov]=RNLE.ESTIM(Xinit,Uin,Zout)
%   
%   Inputs:  Xinit - Sequence of hidden states (initial guess)
%            Uin   - Sequence of control inputs
%            Zout  - Sequence of observed outputs
%   
%   Outputs: Xest  - Estimated state sequence
%            Xcov  - Estimates of state uncertainties
%   
%   Columns Uin(:,k) and Zout(:,k) are the kth vectors of control inputs
%   and observed outputs in the sequence, respectively. Column Xest(:,k) is
%   the corresponding vector of state estimates and page Xcov(:,:,k) the
%   corresponding matrix of state uncertainties.
%   
%   The following table summarizes the input/output convention for this
%   function. The constants K, M, D and N are, in that order, the number of
%   states, inputs and outputs, and the length of these sequences (i.e. the
%   number of points).
%   
%       Input/Output   Class      Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       Xinit          numeric    Matrix    K-by-N
%       Uin            numeric    Matrix    M-by-N
%       Zout           numeric    Matrix    D-by-N      *
%       Xest           numeric    Matrix    K-by-N
%       Xcov           numeric    Array     K-by-K-by-N **
%       _____________________________________________
%       *  Missing values (NaNs) are allowed.
%       ** Symmetric and positive-definite pages.
%   
%   In addition to the inputs, the syntax 
%   
%   [...]=RNLE.ESTIM(...,'Prop',Val,...)
%   
%   accepts a list of options in the form of property/value pairs. These
%   options are listed in the following.
%   
%   Options: 'OutParam' - Parameter of outlier weights
%            'OutType'  - Type of outliers (state/input/output)
%            'MaxIter'  - Maximum number of iterations
%            'RelTol'   - Relative tolerance for outer loop
%            'AbsTol'   - Absolute tolerance for inner loop
%            'RejThres' - Line search rejection threshold
%            'RedFact'  - Step size reduction factor
%            'CallBack' - Function to call after each iteration
%   
%   See also RNLE.
%   
%   Copyright (c) 2013 Gabriel Agamennoni.

% Check number of input and output arguments.
if nargin()<4
    error('RNLE:NotEnoughInputs',...
        'Not enough input arguments.')
end
if nargout()>2
    error('RNLE:TooManyOutputs',...
        'Too many output arguments.')
end

% Check input arguments and scan options from property-value pairs.
[OutParam,OutType,MaxIter,RelTol,AbsTol,RejThres,RedFact,CallBack]=...
    CheckArg(Obj,State,In,Out,varargin{:});

% Store functions.
InitFun=Obj.InitFun;
TransFun=Obj.TransFun;
ObsFun=Obj.ObsFun;

% Store size.
[NumState,NumPoint]=size(State);

% Allocate space for weights.
Weight=zeros(NumPoint,1);

% Allocate space for auxiliary variables.
UpperBound=zeros(2*MaxIter,1);
InnerProd=zeros(MaxIter,1);
StepSize=zeros(MaxIter,1);

% Enter outer loop.
for i=1:MaxIter
    
    % Clear weights.
    Weight(:)=nan();
    
    % Evaluate objective function and gradient and update weights.
    [UpperBound(i),Grad,Weight]=evalobj(State,In,Out,Weight,...
        InitFun,TransFun,ObsFun,OutParam,OutType);
    
    % Enter inner loop.
    for j=1:MaxIter
        
        % Compute search directions by solving quadratic sub-problem.
        [SearchDir,Uncert]=solveprob(State,In,Out,Weight,...
            InitFun,TransFun,ObsFun,OutType);
        
        % Ensure search directions are in fact descent directions.
        InnerProd(j)=sum(Grad(:).*SearchDir(:));
        if InnerProd(j)>0
            
            % If not, switch to steepest descent.
            SearchDir=-Grad;
            InnerProd(j)=-sum(Grad(:).^2);
            
        end
        
        % Perform line search.
        StepSize(j)=1;
        while true()
            
            % Evaluate upper bound and gradient for current step size.
            [UpperBound(i+j),Grad]=evalobj(State+StepSize(j)*SearchDir,...
                In,Out,Weight,InitFun,TransFun,ObsFun,OutParam,OutType);
            
            % Apply Armijo's rule and check for sufficient relative decrease.
            Accept=UpperBound(i+j)<=UpperBound(i+j-1)+...
                RejThres*StepSize(j)*InnerProd(j);
            
            % Accept/reject current step size.
            if Accept
                break
            else
                
                % If rejected, reduce step size and try again.
                StepSize(j)=RedFact*StepSize(j);
                
            end
            
        end
        
        % Update states.
        State=State+StepSize(j)*SearchDir;
        
        % Check for convergence.
        if abs(InnerProd(j))<=AbsTol*NumState*NumPoint
            break
        end
        
    end
    
    % Evaluate callback function and check for early return.
    if ~isempty(CallBack)
        if feval(CallBack,State,Uncert)
            break
        end
    end
    
    % Check convergence.
    if isconv(UpperBound(1:i),RelTol)
        break
    end
    
end

end



function [OutParam,OutType,MaxIter,RelTol,AbsTol,RejThres,RedFact,CallBack]=...
    CheckArg(Obj,State,In,Out,varargin)

% Check estimator object.
if isempty(Obj)
    error('RNLE:BadObjectSize',...
        'Object must be non-empty.')
end
if ndims(Obj)>2||numel(Obj)>1
    error('RNLE:BadObjectSize',...
        'Object must be a scalar.')
end

% Store size.
NumIn=Obj.NumIn;
NumState=Obj.NumState;
NumOut=Obj.NumOut;

% Initialize argument counter.
Arg=0;

% Check sequence of states.
Arg=Arg+1;
if ~isnumeric(State)
    error('RNLE:BadInputClass',...
        'Input %d must be numeric.',Arg)
end
if ~isreal(State)
    error('RNLE:BadInputClass',...
        'Input %d must be real.',Arg)
end
if isempty(State)
    error('RNLE:BadInputSize',...
        'Input %d must be non-empty.',Arg)
end
if ndims(State)>2
    error('RNLE:BadInputSize',...
        'Input %d must be a matrix.',Arg)
end
if size(State,1)~=NumState
    error('RNLE:BadInputSize',...
        'Input %d must have %d row(s).',Arg,NumState)
end
if any(isnan(State(:)))||any(isinf(State(:)))
    error('RNLE:BadInputValue',...
        'Input %d must contain finite numbers.',Arg)
end

% Store number of points.
[~,NumPoint]=size(State);

% Check sequence of inputs.
Arg=Arg+1;
if ~isnumeric(In)
    error('RNLE:BadInputClass',...
        'Input %d must be numeric.',Arg)
end
if ~isreal(In)
    error('RNLE:BadInputClass',...
        'Input %d must be real.',Arg)
end
if isempty(In)
    error('RNLE:BadInputSize',...
        'Input %d must be non-empty.',Arg)
end
if ndims(In)>2
    error('RNLE:BadInputSize',...
        'Input %d must be a matrix.',Arg)
end
if size(In,1)~=NumIn
    error('RNLE:BadInputSize',...
        'Input %d must have %d row(s).',Arg,NumIn)
end
if size(In,2)~=NumPoint
    error('RNLE:BadInputSize',...
        'Input %d must have %d column(s).',Arg,NumPoint)
end
if any(isnan(In(:)))||any(isinf(In(:)))
    error('RNLE:BadInputValue',...
        'Input %d must contain finite numbers.',Arg)
end

% Check sequence of outputs.
Arg=Arg+1;
if ~isnumeric(Out)
    error('RNLE:BadInputClass',...
        'Input %d must be numeric.',Arg)
end
if ~isreal(Out)
    error('RNLE:BadInputClass',...
        'Input %d must be real.',Arg)
end
if isempty(Out)
    error('RNLE:BadInputSize',...
        'Input %d must be non-empty.',Arg)
end
if ndims(Out)>2
    error('RNLE:BadInputSize',...
        'Input %d must be a matrix.',Arg)
end
if size(Out,1)~=NumOut
    error('RNLE:BadInputSize',...
        'Input %d must have %d row(s).',Arg,NumOut)
end
if size(Out,2)~=NumPoint
    error('RNLE:BadInputSize',...
        'Input %d must have %d column(s).',Arg,NumPoint)
end
if any(isinf(Out(:)))
    error('RNLE:BadInputValue',...
        'Input %d must not contain infinite numbers.',Arg)
end

% Store default options.
OutParam=inf();
OutType='none';
MaxIter=1e2;
RelTol=1e-3;
AbsTol=1e-1;
RejThres=1e-4;
RedFact=.5;
CallBack='';

% Scan options from property-value pairs.
for i=1:2:numel(varargin)
    
    % Check for early return.
    if numel(varargin)<i+1
        warning('RNLE:IgnoringLastInput',...
            'Ignoring last input.')
        break
    end
    
    % Check property.
    Arg=Arg+1;
    if ~ischar(varargin{i})
        error('RNLE:BadInputClass',...
            'Input %d must be a string.',Arg)
    end
    if isempty(varargin{i})
        error('RNLE:BadInputSize',...
            'Input %d must be non-empty.',Arg)
    end
    if ndims(varargin{i})>2||size(varargin{i},1)>1
        error('RNLE:BadInputSize',...
            'Input %d must contain a string.',Arg)
    end
    
    % Check value.
    Arg=Arg+1;
    switch lower(varargin{i})
        case lower('OutParam')
            
            % Check outlier parameter.
            if ~isnumeric(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be numeric.',Arg)
            end
            if ~isreal(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be real.',Arg)
            end
            if isempty(varargin{i+1})
                error('RNLE:BadInputSize',...
                    'Input %d must be non-empty.',Arg)
            end
            if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                error('RNLE:BadInputSize',...
                    'Input %d must be a scalar.',Arg)
            end
            if isnan(varargin{i+1})||varargin{i+1}<=0
                error('RNLE:BadInputValue',...
                    'Input %d must contain a positive number.',Arg)
            end
            
            % Set outlier parameter.
            OutParam=varargin{i+1};
            
        case lower('OutType')
            
            % Check type of outliers.
            if ~ischar(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be a string.',Arg)
            end
            if isempty(varargin{i+1})
                error('RNLE:BadInputSize',...
                    'Input %d must be non-empty.',Arg)
            end
            if ndims(varargin{i+1})>2||size(varargin{i+1},1)>1
                error('RNLE:BadInputSize',...
                    'Input %d must be a string.',Arg)
            end
            if ~any(strcmpi(varargin{i+1},{'none','state','input','output'}))
                error('RNLE:BadInputValue',...
                    'Input %d must contain a valid option.',Arg)
            end
            
            % Set type of outliers.
            OutType=varargin{i+1};
            
        case lower('MaxIter')
            
            % Check maximum number of iterations.
            if ~isnumeric(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be numeric.',Arg)
            end
            if ~isreal(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be real.',Arg)
            end
            if isempty(varargin{i+1})
                error('RNLE:BadInputSize',...
                    'Input %d must be non-empty.',Arg)
            end
            if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                error('RNLE:BadInputSize',...
                    'Input %d must be a scalar.',Arg)
            end
            if isnan(varargin{i+1})||isinf(varargin{i+1})
                error('RNLE:BadInputValue',...
                    'Input %d must contain a finite number.',Arg)
            end
            if round(varargin{i+1})~=varargin{i+1}||varargin{i+1}<=0
                error('RNLE:BadInputValue',...
                    'Input %d must contain a positive integer.',Arg)
            end
            
            % Set maximum number of iterations.
            MaxIter=varargin{i+1};
            
        case lower('RelTol')
            
            % Check relative tolerance.
            if ~isnumeric(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be numeric.',Arg)
            end
            if ~isreal(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be real.',Arg)
            end
            if isempty(varargin{i+1})
                error('RNLE:BadInputSize',...
                    'Input %d must be non-empty.',Arg)
            end
            if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                error('RNLE:BadInputSize',...
                    'Input %d must be a scalar.',Arg)
            end
            if isnan(varargin{i+1})||isinf(varargin{i+1})||varargin{i+1}<=0
                error('RNLE:BadInputValue',...
                    'Input %d must contain a positive finite number.',Arg)
            end
            
            % Set relative tolerance.
            RelTol=varargin{i+1};
            
        case lower('AbsTol')
            
            % Check absolute tolerance.
            if ~isnumeric(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be numeric.',Arg)
            end
            if ~isreal(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be real.',Arg)
            end
            if isempty(varargin{i+1})
                error('RNLE:BadInputSize',...
                    'Input %d must be non-empty.',Arg)
            end
            if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                error('RNLE:BadInputSize',...
                    'Input %d must be a scalar.',Arg)
            end
            if isnan(varargin{i+1})||isinf(varargin{i+1})||varargin{i+1}<=0
                error('RNLE:BadInputValue',...
                    'Input %d must contain a positive finite number.',Arg)
            end
            
            % Set absolute tolerance.
            AbsTol=varargin{i+1};
            
        case {lower('RejThres'),lower('RejThres')}
            
            % Check rejection threshold.
            if ~isnumeric(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be numeric.',Arg)
            end
            if ~isreal(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be real.',Arg)
            end
            if isempty(varargin{i+1})
                error('RNLE:BadInputSize',...
                    'Input %d must be non-empty.',Arg)
            end
            if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                error('RNLE:BadInputSize',...
                    'Input %d must be a scalar.',Arg)
            end
            if isnan(varargin{i+1})||isinf(varargin{i+1})
                error('RNLE:BadInputValue',...
                    'Input %d must contain a finite number.',Arg)
            end
            if varargin{i+1}<=0||varargin{i+1}>=1
                error('RNLE:BadInputValue',...
                    'Input %d must contain a number in the unit interval.',Arg)
            end
            
            % Set rejection threshold.
            RejThres=varargin{i+1};
            
        case lower('RedFact')
            
            % Check reduction factor.
            if ~isnumeric(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be numeric.',Arg)
            end
            if ~isreal(varargin{i+1})
                error('RNLE:BadInputClass',...
                    'Input %d must be real.',Arg)
            end
            if isempty(varargin{i+1})
                error('RNLE:BadInputSize',...
                    'Input %d must be non-empty.',Arg)
            end
            if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                error('RNLE:BadInputSize',...
                    'Input %d must be a scalar.',Arg)
            end
            if isnan(varargin{i+1})||isinf(varargin{i+1})
                error('RNLE:BadInputValue',...
                    'Input %d must contain a finite number.',Arg)
            end
            if varargin{i+1}<=0||varargin{i+1}>=1
                error('RNLE:BadInputValue',...
                    'Input %d must contain a number in the unit interval.',Arg)
            end
            
            % Set reduction factor.
            RedFact=varargin{i+1};
            
        case {lower('CallBack'),lower('CBackFun')}
            
            % Check callback function.
            if isa(varargin{i+1},'function_handle')
                if isempty(varargin{i+1})
                    error('RNLE:BadInputSize',...
                        'Input %d must be non-empty.',Arg)
                end
                if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                    error('RNLE:BadInputSize',...
                        'Input %d must be a scalar.',Arg)
                end
            else
                if ~ischar(varargin{i+1})
                    error('RNLE:BadInputClass',...
                        'Input %d must be a string.',Arg)
                end
                if isempty(varargin{i+1})
                    error('RNLE:BadInputSize',...
                        'Input %d must be non-empty.',Arg)
                end
                if ndims(varargin{i+1})>2||size(varargin{i+1},1)>1
                    error('RNLE:BadInputSize',...
                        'Input %d must contain a string.',Arg)
                end
                if ~exist(varargin{i+1},'file')
                    error('RNLE:BadInputValue',...
                        'Input %d must contain a valid file name.',Arg)
                end
            end
            if any(nargin(varargin{i+1})==0:1)
                error('RNLE:BadInputSize',...
                    'Input %d must accept at least %d input(s).',Arg,2)
            end
            if any(nargout(varargin{i+1})==0)
                error('RNLE:BadInputSize',...
                    'Input %d must return at least %d output(s).',Arg,1)
            end
            
            % Set callback function.
            CallBack=varargin{i+1};
            
        otherwise
            error('RNLE:BadProperty',...
                'Input %d is not a valid option.',Arg-1)
    end
    
end

end