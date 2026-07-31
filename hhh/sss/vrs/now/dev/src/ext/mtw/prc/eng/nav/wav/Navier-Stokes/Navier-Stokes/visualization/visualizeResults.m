function visualizeResults(varargin)
%VISUALIZERESULTS   Visualize data on 2D grids.
%   Required input arguments (in this order):
%       X - grid data from the x coordinates (MxN matrix)
%       Y - grid data from the y coordinates (MxN matrix)
%       u - function values at (X,Y)
%   Optional input argument
%       v - function values at (X,Y)
%             default: [];
%   Parameter-value pair
%       'method' - one of 'quiver','quiverc','mesh','surf','contour','streamslice'
%             default: 'quiver'
%          'quiverc' can be downloaded from the File Exchange
%       'arrowlength' - one of 'equal' or 'default'
%             default: 'default'
%          If 'equal' is given, the length of the arrows in quiver are equal.
%          Using 'deafult', the default length scaling is applied.
%
%   See also   QUIVER, QUIVERC, STREAMSLICE, CONTOUR, MESH, SURF

%   Zoltán Csáti
%   2014/09/15

% Handle inputs
p = inputParser;
sizeX = size(varargin{1});
validSize = @(x) validateattributes(x,{'numeric'}, {'size',sizeX});
validMethods = @(x) any(strcmpi(x,{'quiver','quiverc','mesh','surf', ...
                                  'contour','streamslice'}));
validArrowLength = @(x) any(strcmpi(x, {'equal','default'}));
p.addRequired('X', @ismatrix);
p.addRequired('Y', validSize);
p.addRequired('u', validSize);
p.addOptional('v', [], validSize);
p.addParamValue('method', 'quiver', validMethods);
p.addParamValue('arrowlength', 'default', validArrowLength);
p.parse(varargin{:});
X = p.Results.X;
Y = p.Results.Y;
u = p.Results.u;
v = p.Results.v;
method = p.Results.method;
arrowLength = p.Results.arrowlength;
if isempty(v) ... % v is not supplied
        && any(strcmp(method,{'quiver','quiverc','streamslice'}))
    error('MATLAB:visualizeResults:notEnoughInputArguments', ...
          'Four matrices are required for the specified method.');
end
% Plot data
method = lower(method);
figure;
if ~strcmp(method,'quiver') && numel(varargin)>6 % arrowlength property is given
    warning('MATLAB:visualizeResults:ignoredInput', ...
   'Arrowlength is taken into account only in case of quiver plot.');
end
switch method
    case 'quiver'
        if strcmpi(arrowLength,'equal')
            L = sqrt(u.^2+v.^2);
            quiver(X,Y,u./L,v./L);
        else
            quiver(X,Y,u,v);
        end
    case 'quiverc'
        if max(sizeX) > 50
            error('MATLAB:visualizeResults:largeInput', ...
                 ['For computer responsiveness, maximum size is ', ...
                  'limited to 50. Use quiver for larger input.']);
        end
        quiverc(X,Y,u,v);
    case 'streamslice'
        streamslice(X,Y,u,v,2); % double density
    case 'contour'
        contour(X,Y,u);
    case 'mesh'
        mesh(X,Y,u);
    case 'surf'
        surf(X,Y,u); shading('interp');
end
% Axes settings
axis square; set(gca,'XLim',[-1 1], 'YLim',[-1,1]);