function [State,Out]=Sim(Obj,In,varargin)
%RNLE.SIM    Simulate sequences of data
%   
%   RNLE.SIM takes a sequence of inputs and generates corresponding
%   sequences of states and outputs by simulating the robust non-linear
%   estimator's underlying state-space model.
%   
%   Usage:  [Xh,Zout]=RNLE.SIM(Uin)
%   
%   Inputs:  Uin  - Sequence of control inputs
%   
%   Outputs: Xh   - Sequence of hidden states
%            Zout - Sequence of observed outputs
%   
%   Column Uin(:,k) is the kth vector of control inputs in the sequence.
%   Columns Xh(:,k) and Zout(:,k) are the corresponding vectors of hidden
%   states and observed outputs, respectively.
%   
%   The following table summarizes the input/output convention for this
%   function. The constants M, K, D and N are, in that order, the number of
%   inputs, states and outputs and the length of the sequences (i.e. the
%   number of points).
%   
%       Input/Output   Class      Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       Uin            numeric    Matrix    M-by-N
%       Xh             numeric    Matrix    K-by-N
%       Zout           numeric    Matrix    D-by-N
%   
%   In addition to the inputs, the syntax 
%   
%   [...]=RNLE.SIM(...,'Prop',Val,...)
%   
%   accepts a list of options in the form of property/value pairs. These
%   options are listed in the following.
%   
%   Options: 'OutParam' - Parameter of outlier weights
%            'OutType'  - Type of outliers (state/input/output)
%   
%   See also RNLE.
%   
%   Copyright (c) 2013 Gabriel Agamennoni.

% Check number of input and output arguments.
if nargin()<2
    error('RNLE:NotEnoughInputs',...
        'Not enough input arguments.')
end
if nargout()>2
    error('RNLE:TooManyOutputs',...
        'Too many output arguments.')
end

% Check input arguments and scan options from property-value pairs.
[OutParam,OutType]=CheckArg(Obj,In,varargin{:});

% Store size.
NumState=Obj.NumState;
NumOut=Obj.NumOut;

% Store functions.
InitFun=Obj.InitFun;
TransFun=Obj.TransFun;
ObsFun=Obj.ObsFun;

% Generate data.
[State,Out]=gendata(In,NumState,NumOut,InitFun,TransFun,ObsFun,...
    OutParam,OutType);

end



function [OutParam,OutType]=CheckArg(Obj,In,varargin)

% Check object.
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

% Initialize argument counter.
Arg=0;

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
if any(isnan(In(:)))||any(isinf(In(:)))
    error('RNLE:BadInputValue',...
        'Input %d must contain finite numbers.',Arg)
end

% Store default options.
OutParam=inf();
OutType='none';

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
            
        otherwise
            error('RNLE:BadProperty',...
                'Input %d is not a valid option.',Arg-1)
    end
    
end

end