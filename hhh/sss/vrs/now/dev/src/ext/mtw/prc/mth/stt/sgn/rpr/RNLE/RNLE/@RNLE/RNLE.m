classdef (ConstructOnLoad) RNLE %#ok<*MCSUP,*PROP>
%RNLE    Construct robust non-linear estimator
%   
%   RNLE constructs a robust non-linear estimator with a given number of
%   inputs, states and outputs.
%   
%   Usage:   Obj=RNLE(K,M,D)
%   
%   Inputs:  K   - Number of hidden states
%            M   - Number of control inputs
%            D   - Number of observed outputs
%   
%   Outputs: Obj - Robust non-linear estimator
%   
%   Inputs K, M and D should be positive integer scalars.
%   
%   The RNLE object Obj has the following set of properties, all of which
%   should be function names or handles:
%   
%   InitFun:  Initialization function. Returns the mean and variance-
%             covariance parameters of the initial states, given initial
%             inputs.
%   
%   TransFun: Transition function. Returns the conditional mean and
%             variance-covariance parameters of the current states, given
%             the previous states and the current inputs.
%   
%   ObsFun:   Observation function. Returns the conditional mean and
%             variance-covariance parameters of the current outputs, given
%             the current states and inputs.
%   
%   Below is a summary of the usage and input/output conventions for the
%   initialization, transition and observation functions.
%   
%   Initialization function
%   
%       Usage:   [M0,V0]=InitFun(U0)
%   
%       Inputs:   U0 - Current control inputs
%   
%       Outputs:  M0 - Mean parameters
%                 V0 - Var-covariance parameters
%   
%       Input/Output   Class      Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       U0             numeric    Vector    M-by-1/1-by-M
%       M0             numeric    Vector    K-by-1/1-by-K
%       V0             numeric    Matrix    K-by-K        *
%       ______________________________________________
%       * Must be symmetric and positive-definite.
%   
%   Transition function
%   
%       Usage:   [Gk,Qk,dGk,dQk]=TransFun(Xk-1,Uk)
%   
%       Inputs:  Xk-1 - Previous hidden states
%                Uk   - Current control inputs
%   
%       Outputs: Gk   - Mean parameters
%                Qk   - Var-covariance parameters
%                dGk  - Derivatives of mean parameters
%                dQk  - Derivatives of variance-covariance parameters
%   
%       Input/Output   Class      Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       Xk-1           numeric    Vector    K-by-1/1-by-K
%       Uk             numeric    Vector    M-by-1/1-by-M
%       Gk             numeric    Vector    K-by-1/1-by-K
%       Qk             numeric    Matrix    K-by-K        *
%       dGk            numeric    Matrix    K-by-K
%       dQk            numeric    Array     K-by-K-by-K   **
%       _______________________________________________
%       *  Must be symmetric and positive-definite.
%       ** Individual pages must be symmetric.
%   
%   Observation function
%   
%       Usage:   [Hk,Rk,dHk,dRk]=ObsFun(Xk,Uk)
%   
%       Inputs:  Xk  - Current hidden states
%                Uk  - Current control inputs
%   
%       Outputs: Hk  - Mean parameters
%                Rk  - Var-covariance parameters
%                dRk - Derivatives of mean parameters
%                dRk - Derivatives of variance-covariance parameters
%   
%       Input/Output   Class      Size      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       Xk             numeric    Vector    K-by-1/1-by-K
%       Uk             numeric    Vector    M-by-1/1-by-M
%       Hk             numeric    Vector    D-by-1/1-by-D
%       Rk             numeric    Matrix    D-by-D        *
%       dHk            numeric    Matrix    D-by-K
%       dRk            numeric    Array     D-by-D-by-K   **
%       _______________________________________________
%       *  Must be symmetric and positive-definite.
%       ** Individual pages must be symmetric.
%   
%   See also RNLE.SIMULATE, RNLE.VALIDATE, RNLE.ESTIMATE and RNLE.ITERATE.
%   
%   Copyright (c) 2013 Gabriel Agamennoni.

    % Size.
    properties (SetAccess=private)
        NumIn
        NumState
        NumOut
    end
    
    % Functions.
    properties
        InitFun
        TransFun
        ObsFun
    end
    
    % Constructor.
    methods
        function Obj=RNLE(NumIn,NumState,NumOut)
            
            % Construct instance.
            if nargin()>0
                
                % Check number of arguments.
                if nargin()<3
                    error('RNLE:NotEnoughInputs',...
                        'Not enough input arguments.')
                end
                if nargin()>3
                    error('RNLE:TooManyInputs',...
                        'Too many input arguments.')
                end
                if nargout()>1
                    error('RNLE:TooManyOutputs', ...
                        'Too many output arguments.')
                end
                
                % Check input arguments.
                CheckArg(NumIn,NumState,NumOut)
                
                % Set size.
                Obj.NumIn=NumIn;
                Obj.NumState=NumState;
                Obj.NumOut=NumOut;
                
                % Set default functions.
                Obj.InitFun=@InitFun;
                Obj.TransFun=@TransFun;
                Obj.ObsFun=@ObsFun;
                
            end
            
            % Define default initialization function.
            function [Mean,Var]=InitFun(~)
                Mean=zeros(NumState,1);
                Var=eye(NumState);
            end
            
            % Define default transition function.
            function [Mean,Var,dMean,dVar]=TransFun(State,~)
                Mean=State;
                Var=eye(NumState);
                dMean=eye(NumState);
                dVar=zeros(NumState,NumState,NumState);
            end
            
            % Define default observation function.
            function [Mean,Var,dMean,dVar]=ObsFun(State,~)
                Mean=[State(1:min(NumState,NumOut));...
                    zeros(max(NumOut-NumState,0),1)];
                Var=eye(NumState);
                dMean=eye(NumOut,NumState);
                dVar=zeros(NumOut,NumOut,NumState);
            end
            
        end
    end
    
    % Access methods.
    methods
        function Obj=set.InitFun(Obj,InitFun)
            
            % Check initialization function.
            if isa(InitFun,'function_handle')
                if isempty(InitFun)
                    error('RNLE:BadInputSize',...
                        'Input must be non-empty.')
                end
                if ndims(InitFun)>2||numel(InitFun)>1
                    error('RNLE:BadInputSize',...
                        'Input must be a scalar.')
                end
            else
                if ~ischar(InitFun)
                    error('RNLE:BadInputClass',...
                        'Input must be a string.')
                end
                if isempty(InitFun)
                    error('RNLE:BadInputSize',...
                        'Input must be non-empty.')
                end
                if ndims(InitFun)>2||size(InitFun,1)>1
                    error('RNLE:BadInputSize',...
                        'Input must contain a string.')
                end
                if ~exist(InitFun,'file')
                    error('RNLE:BadInputValue',...
                        'Input must contain a valid file name.')
                end
            end
            if any(nargin(InitFun)==0)
                error('RNLE:BadInputSize',...
                    'Input must accept at least %d input(s).',1)
            end
            if any(nargout(InitFun)==0:1)
                error('RNLE:BadInputSize',...
                    'Input must return at least %d output(s).',2)
            end
            
            % Set initialization function.
            Obj.InitFun=InitFun;
            
        end
        function Obj=set.TransFun(Obj,TransFun)
            
            % Check transition function.
            if isa(TransFun,'function_handle')
                if isempty(TransFun)
                    error('RNLE:BadInputSize',...
                        'Input must be non-empty.')
                end
                if ndims(TransFun)>2||numel(TransFun)>1
                    error('RNLE:BadInputSize',...
                        'Input must be a scalar.')
                end
            else
                if ~ischar(TransFun)
                    error('RNLE:BadInputClass',...
                        'Input must be a string.')
                end
                if isempty(TransFun)
                    error('RNLE:BadInputSize',...
                        'Input must be non-empty.')
                end
                if ndims(TransFun)>2||size(TransFun,1)>1
                    error('RNLE:BadInputSize',...
                        'Input must contain a string.')
                end
                if ~exist(TransFun,'file')
                    error('RNLE:BadInputValue',...
                        'Input must contain a valid file name.')
                end
            end
            if any(nargin(TransFun)==0:1)
                error('RNLE:BadInputSize',...
                    'Input must accept at least %d input(s).',2)
            end
            if any(nargout(TransFun)==0:3)
                error('RNLE:BadInputSize',...
                    'Input must return at least %d output(s).',4)
            end
            
            % Set transition function.
            Obj.TransFun=TransFun;
            
        end
        function Obj=set.ObsFun(Obj,ObsFun)
            
            % Check observation function.
            if isa(ObsFun,'function_handle')
                if isempty(ObsFun)
                    error('RNLE:BadInputSize',...
                        'Input must be non-empty.')
                end
                if ndims(ObsFun)>2||numel(ObsFun)>1
                    error('RNLE:BadInputSize',...
                        'Input must be a scalar.')
                end
            else
                if ~ischar(ObsFun)
                    error('RNLE:BadInputClass',...
                        'Input must be a string.')
                end
                if isempty(ObsFun)
                    error('RNLE:BadInputSize',...
                        'Input must be non-empty.')
                end
                if ndims(ObsFun)>2||size(ObsFun,1)>1
                    error('RNLE:BadInputSize',...
                        'Input must contain a string.')
                end
                if ~exist(ObsFun,'file')
                    error('RNLE:BadInputValue',...
                        'Input must contain a valid file name.')
                end
            end
            if any(nargin(ObsFun)==0:1)
                error('RNLE:BadInputSize',...
                    'Input must accept at least %d input(s).',2)
            end
            if any(nargout(ObsFun)==0:3)
                error('RNLE:BadInputSize',...
                    'Input must return at least %d output(s).',4)
            end
            
            % Set observation function.
            Obj.ObsFun=ObsFun;
            
        end
    end
    
    % Other methods.
    methods
        [State,Out]=Sim(Obj,In,varargin)
        Res=Valid(Obj,State,In,Out,varargin)
        [State,Uncert]=Estim(Obj,State,In,Out,varargin)
        [Score,varargout]=Samp(Obj,State,In,Out,varargin)
    end
    
end



function CheckArg(varargin)

% Check input arguments.
for i=1:nargin()
    if ~isnumeric(varargin{i})
        error('RNLE:BadInputClass',...
            'Input %d must be numeric.',varargin{i})
    end
    if ~isreal(varargin{i})
        error('RNLE:BadInputClass',...
            'Input %d must be real.',varargin{i})
    end
    if isempty(varargin{i})
        error('RNLE:BadInputSize',...
            'Input %d must be non-empty.',varargin{i})
    end
    if ndims(varargin{i})>2
        error('RNLE:BadInputSize',...
            'Input %d must be a scalar.',varargin{i})
    end
    if numel(varargin{i})>1
        error('RNLE:BadInputSize',...
            'Input %d must be a scalar.',varargin{i})
    end
    if isnan(varargin{i})||isinf(varargin{i})
        error('RNLE:BadInputValue',...
            'Input %d must contain a finite number.',varargin{i})
    end
    if round(varargin{i})~=varargin{i}||varargin{i}<=0
        error('RNLE:BadInputValue',...
            'Input %d must contain a positive integer.',varargin{i})
    end
end

end