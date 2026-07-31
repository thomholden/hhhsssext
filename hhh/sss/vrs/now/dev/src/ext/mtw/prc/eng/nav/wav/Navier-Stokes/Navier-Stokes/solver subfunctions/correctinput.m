function varargout = correctinput(x,method,varargin)
%CORRECTINPUT   Helper function to handle boundary conditions.
%   VARARGOUT = CORRECTINPUT(X,METHOD,VARARGIN) processes inputs (numeric
%   arrays or function handles), evaluate them at either the boundary points
%   without the ends (METHOD='inner') or on the whole boundary (METHOD='all')
%   of a side of the square domain.
%
%   See also   SOLVENS_SIBE

%   Zoltán Csáti
%   2014/08/19

x = x(:);
N = numel(x)-1;
method = lower(method);
switch method
    case 'inner'
        nodes = x(2:N);
    case 'all'
        nodes = x;
    otherwise
        error('MATLAB:correctinput:incorrectString', ...
              'Input method must be either ''inner'' or ''all''.');
end
nroInput = length(varargin);
for k = 1:nroInput
    element = varargin{k}; % current input
    % Input given as a function handle
    if isa(element,'function_handle')
        varargout{k} = element(nodes);
        if numel(varargout{k}) == 1
            varargout{k} = varargout{k}*ones(size(nodes));
        end
    % Input given as a numeric array
    elseif isa(element,'numeric')
        if numel(element) ~= numel(nodes)
            error('MATLAB:correctinput:incorrectArray', ...
               ['Array length must match the number of boundary nodes ' ...
                '(%d).'], numel(nodes));
        else
            varargout{k} = element;
        end
    else
        error('MATLAB:correctinput:wrongClass', ['Boundary conditions ' ...
              'must be given as function handles or numeric arrays.']);
    end
end