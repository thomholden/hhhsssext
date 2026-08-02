function [Score,varargout]=Samp(Obj,State,In,Out,varargin)
%RNLE.SAMP    Sample and score sequence
%   
%   RNLE.SAMP generates a sample sequence from an approximate posterior
%   distribution over state sequences. The sequence is scored by its log-
%   likelihood under the model. This allows the user to estimate properties
%   of the true posterior distribution via importance sampling.
%   
%   Usage:  [lnW,Xseq]=RNLE.SAMP(Xh,Uin,Zout)
%   
%   Inputs:  Xh   - Sequence of hidden states
%            Uin  - Sequence of control inputs
%            Zout - Sequence of observed outputs
%   
%   Outputs: lnW  - Score of sample sequence
%            Xseq - Sample state sequence
%   
%   Columns Xh(:,k), Uin(:,k) and Zout(:,k) are the kth vectors of hidden
%   states, control inputs and observed outputs, respectively. Column
%   Xseq(:,k) is the corresponding vector of state samples.
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
%       lnW            numeric    Scalar    1-by-1
%       Xseq           numeric    Matrix    K-by-N
%       _________________________________________
%       *  Missing values (NaNs) are allowed.
%   
%   In addition to the inputs, the syntax 
%   
%   [...]=RNLE.SAMP(...,'Prop',Val,...)
%   
%   accepts a list of options in the form of property/value pairs. These
%   options are listed in the following.
%   
%   Options: 'OutParam'  - Parameter of outlier weights
%            'OutType'   - Type of outliers (state/input/output)
%            'SampSize'  - Number of sequences in the sample
%            'ScaleFact' - Scale parameter to control sample spread
%   
%   See also RNLE.
%   
%   Copyright (c) 2013 Gabriel Agamennoni.

% Check number of input and output arguments.
if nargin()<4
    error('RNLE:NotEnoughInputs',...
        'Not enough input arguments.')
end

% Check input arguments and scan options from property-value pairs.
[OutParam,OutType,SampSize,ScaleFact]=CheckArg(Obj,State,In,Out,varargin{:});

% Store functions.
InitFun=Obj.InitFun;
TransFun=Obj.TransFun;
ObsFun=Obj.ObsFun;

% Store size.
[NumState,NumPoint]=size(State);

% Allocate space for sequences.
varargout=cell(SampSize,1);

% Compute weights.
[~,~,Weight]=evalobj(State,In,Out,nan(NumPoint,1),...
    InitFun,TransFun,ObsFun,OutParam,OutType);

% Compute moments by solving quadratic sub-problem.
[Mean,Var,Covar]=solveprob(State,In,Out,Weight,...
    InitFun,TransFun,ObsFun,OutType);

% Sample sequence increments and evaluate negative log-densities.
[Seq,Score]=sampseq(Mean,Var,Covar,SampSize);

% Scale sample.
Seq=ScaleFact*Seq;
Score=Score+log(ScaleFact)*NumState*NumPoint;

% Score and store sequences.
for i=1:SampSize
    Score(i)=Score(i)-evalobj(Seq(:,:,i),In,Out,Weight,...
        InitFun,TransFun,ObsFun,OutParam,OutType);
    varargout{i}=State+Seq(:,:,i);
end

% Trim sample.
varargout=varargout(1:nargout()-1);

end



function [OutParam,OutType,SampSize,ScaleFact]=...
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
SampSize=1;
ScaleFact=1;

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
            
        case lower('SampSize')
            
            % Check sample size.
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
            
            % Set sample size.
            SampSize=varargin{i+1};
            
        case lower('ScaleFact')
            
            % Check scale factor.
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
            if varargin{i+1}<=0||varargin{i+1}>1
                error('RNLE:BadInputValue',...
                    'Input %d must contain a number in the unit interval.',Arg)
            end
            
            % Set scale factor.
            ScaleFact=varargin{i+1};
            
        otherwise
            error('RNLE:BadProperty',...
                'Input %d is not a valid option.',Arg-1)
    end
    
end

end