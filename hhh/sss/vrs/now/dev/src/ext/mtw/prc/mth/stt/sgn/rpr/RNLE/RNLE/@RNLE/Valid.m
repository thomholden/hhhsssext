function Res=Valid(Obj,State,In,Out,varargin)
%RNLE.VALID    Validate differentiation of the objective function
%   
%   RNLE.VALID calculates the numerical derivatives of the objective
%   function with respect to the sequence of states and compares them to
%   the analytical derivatives evaluated with its own, user-supplied member
%   functions. This allows the user to check whether the functions provided
%   and their derivatives are well-specified.
%   
%   Usage:  Res=RNLE.VALID(Xh,Uin,Zout)
%   
%   Inputs:  Xh   - Sequence of hidden states
%            Uin  - Sequence of control inputs
%            Zout - Sequence of observed outputs
%   
%   Outputs: Res  - Sequence of residuals between analytical and numerical
%                   derivatives of the objective function
%   
%   Columns Xh(:,k), Uin(:,k) and Zout(:,k) are the kth vectors of hidden
%   states, control inputs and observed outputs, respectively.
%   
%   The following table summarizes the input/output convention for this
%   function. The constants K, M, D and N are, in that order, the number of
%   states, inputs and outputs, and the length of these sequences (i.e. the
%   number of points).
%   
%       Input/Output   Class      Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       Xh             numeric    Matrix    K-by-N
%       Uin            numeric    Matrix    M-by-N
%       Zout           numeric    Matrix    D-by-N *
%       Res            numeric    Matrix    K-by-N
%       _________________________________________
%       *  Missing values (NaNs) are allowed.
%   
%   In addition to the inputs, the syntax 
%   
%   [...]=RNLE.VALID(...,'Prop',Val,...)
%   
%   accepts a list of options in the form of property/value pairs. These
%   options are listed in the following.
%   
%   Options: 'OutParam' - Parameter of outlier weights
%            'OutType'  - Type of outliers (state/input/output)
%            'DiffType' - Type of differences (forward/backward/central)
%            'DiffOrd'  - Order of finite differences
%            'StepSize' - Step size for approximating derivatives
%   
%   See also RNLE.
%   
%   Copyright (c) 2013 Gabriel Agamennoni.

% Check number of input and output arguments.
if nargin()<4
    error('RNLE:NotEnoughInputs',...
        'Not enough input arguments.')
end
if nargout()>1
    error('RNLE:TooManyOutputs',...
        'Too many output arguments.')
end

% Check input arguments and scan options from property-value pairs.
[OutParam,OutType,DiffType,DiffOrd,StepSize]=...
    CheckArg(Obj,State,In,Out,varargin{:});

% Store functions.
InitFun=Obj.InitFun;
TransFun=Obj.TransFun;
ObsFun=Obj.ObsFun;

% Store number of points.
[~,NumPoint]=size(State);

% Evaluate analytical derivatives and compute weights.
[~,Deriv,Weight]=evalobj(State,In,Out,nan(NumPoint,1),...
    InitFun,TransFun,ObsFun,OutParam,OutType);

% Store handle to objective function.
Fun=@(State)evalobj(State,In,Out,Weight,...
    InitFun,TransFun,ObsFun,OutParam,OutType);

% Approximate numerical derivatives via finite differences.
Diff=approxderiv(Fun,State,DiffType,DiffOrd,StepSize);

% Return residuals.
Res=Diff-Deriv;

end



function [OutParam,OutType,DiffType,DiffOrd,StepSize]=...
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
NumState=Obj.NumState;
NumIn=Obj.NumIn;
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
DiffType='central';
DiffOrd=1;
StepSize=1e-5;

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
            
        case lower('DiffType')
            
            % Check type of differences.
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
            if ~any(strcmpi(varargin{i+1},{'forward','backward','central'}))
                error('RNLE:BadInputValue',...
                    'Input %d must contain a valid option.',Arg)
            end
            
            % Set type of differences.
            DiffType=varargin{i+1};
            
        case lower('DiffOrd')
            
            % Check order of differences.
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
            
            % Set order of differences.
            DiffOrd=varargin{i+1};
            
        case lower('StepSize')
            
            % Check step size.
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
            
            % Set step size.
            StepSize=varargin{i+1};
            
        otherwise
            error('RNLE:BadProperty',...
                'Input %d is not a valid option.',Arg-1)
    end
    
end

end