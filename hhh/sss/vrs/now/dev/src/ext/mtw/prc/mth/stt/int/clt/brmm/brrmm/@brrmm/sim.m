function [comp,weight,out]=sim(obj,in,varargin)
%BRRMM.SIM    Generate data by simulating model
%   
%   BRRMM.SIM simulates a set of model parameters and, with these
%   parameters, generates a complete set of data.
%   
%   Usage: [COMP,WEIGHT,OUT] = BRRMM.SIM(IN)
%   
%   Inputs:  IN     - Sets of input vectors
%   
%   Outputs: COMP   - Component indices
%            WEIGHT - Output weights
%            OUT    - Output vectors
%   
%   IN is a set of input vectors. It must be a matrix with NIN rows, where
%   NIN is the number of inputs. The number of columns is arbitrary.
%   
%   COMP contains the indices to the components responsible for generating
%   the output data. If COMP(j)=k, then OUT(:,j) is drawn according to the
%   kth mixture component. WEIGHT contains weights quantifying the quality
%   of the output data. If WEIGHT(j) is close to 0, then OUT(:,j) is an
%   outlier; otherwise, it is an inlier. OUT contains the output data
%   themselves. Rows correspond to outputs and columns to observations.
%   
%   The following table summarizes the input/output convention for this
%   function. NIN and NOUT, respectively, are the number of inputs and
%   outputs. NPOINT is the number of points, i.e. the number of columns of
%   IN.
%   
%       Argument     Class      Shape
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%       IN          numeric    NIN-by-NPOINT
%       COMP        numeric    NPOINT-by-1
%       WEIGHT      numeric    NPOINT-by-1
%       OUT         numeric    NOUT-by-NPOINT
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   
%   In addition to the inputs, the syntax 
%   
%   [...] = BRRMM.SIM(...,'Prop',Val,...)
%   
%   accepts a list of options in the form of property/value pairs.
%   
%   Options: 'NDEG' - Number of degrees of freedom
%   
%   Details: NDEG controls the thickness of the tails of the heavy-tailed
%            component distributions. If NDEG=inf(), then the components
%            are Gaussian; if NDEG is finite, then the components are t
%            distributions.
%   
%   See also BRRMM.
%   
%   Copyright (c) 2014 Gabriel Agamennoni.

% Check number of arguments.
if nargin()<2
    error('BRRMM:NotEnoughInputs', ...
        'Not enough inputs.')
end
if nargout()>3
    error('BRRMM:TooManyOutputs', ...
        'Too many outputs.')
end

% Check inputs and scan options from property-value pairs.
[ndeg]=check(obj,in,varargin{:});

% Generate parameters.
[prop,gain,noise]=genparam(obj.prior);

% With these parameters, generate complete set of data.
[comp,weight,out]=genvar(obj.fun,obj.eff,prop,gain,noise,in,ndeg);

end



function [ndeg]=check(obj,in,varargin)

% Check object.
if isempty(obj)
    error('BRRMM:BadModelSize', ...
        'Object must be non-empty.')
end
if ndims(obj)>2||numel(obj)>1
    error('BRRMM:BadModelSize', ...
        'Object must be a scalar.')
end

% Store model size.
nin=obj.nin;

% Initialize argument counter.
arg=0;

% Check inputs.
arg=arg+1;
if ~isnumeric(in)
    error('BRRMM:BadInputClass',...
        'Input %d must be numeric.',arg)
end
if ~isreal(in)
    error('BRRMM:BadInputClass',...
        'Input %d must be real.',arg)
end
if isempty(in)
    error('BRRMM:BadInputSize',...
        'Input %d must be non-empty.',arg)
end
if ndims(in)>2
    error('BRRMM:BadInputSize',...
        'Input %d must be a matrix.',arg)
end
if size(in,1)~=nin
    error('BRRMM:BadInputSize',...
        'Input %d must have %d rows.',arg,nin)
end
if any(isinf(in(:))|isnan(in(:)))
    error('BRRMM:BadInputValue',...
        'Input %d must contain finite numbers.',arg)
end

% Store default options.
ndeg=inf();

% Scan options from property-value pairs.
for i=1:2:numel(varargin)
    
    % Check for early return.
    if numel(varargin)<i+1
        warning('BRRMM:IgnoringLastInput', ...
            'Ignoring last input.')
        break
    end
    
    % Check property.
    arg=arg+1;
    if ~ischar(varargin{i})
        error('BRRMM:BadInputClass', ...
            'Input %d must be a string.',arg)
    end
    if isempty(varargin{i})
        error('BRRMM:BadInputSize', ...
            'Input %d must be non-empty.',arg)
    end
    if ndims(varargin{i})>2||size(varargin{i},1)>1
        error('BRRMM:BadInputSize', ...
            'Input %d must be a string.',arg)
    end
    
    % Match property to option.
    switch lower(varargin{i})
        case 'ndeg'
            
            % Check number of degrees of freedom.
            arg=arg+1;
            if ~isnumeric(varargin{i+1})
                error('BRRMM:BadInputClass', ...
                    'Input %d must be numeric.',arg)
            end
            if ~isreal(varargin{i+1})
                error('BRRMM:BadInputClass', ...
                    'Input %d must be real.',arg)
            end
            if isempty(varargin{i+1})
                error('BRRMM:BadInputSize', ...
                    'Input %d must be non-empty.',arg)
            end
            if ndims(varargin{i+1})>2||numel(varargin{i+1})>1
                error('BRRMM:BadInputSize', ...
                    'Input %d must be a scalar.',arg)
            end
            if isnan(varargin{i+1})||varargin{i+1}<=0
                error('BRRMM:BadInputValue', ...
                    'Input %d must contain a positive number.',arg)
            end
            
            % Set number of degrees of freedom.
            ndeg=varargin{i+1};
            
        otherwise
            error('BRRMM:BadProperty', ...
                'Input %d is not a valid option.',arg)
    end
    
end

end