function [derx dery Xmesh Ymesh] = partialder_standalone(fcn,x)
%PARTIALDER   First order partial derivatives of a two-variable function.
%   [DERX DERY X Y] = PARTIALDER(FCN) approximates the first order partial
%   derivatives of the function FCN at the default Chebyshev tensor product
%   grid [XMESH,YMESH].
%   [DERX DERY X Y] = PARTIALDER(FCN,X) approximates the first order partial
%   derivatives of the function FCN at the points given by X.
%
%   Example: Approximate the derivatives of the function sin(x)*sin(y)
%       Solution: fcn = @(x,y) sin(x).*sin(y);
%                 [derX derY X Y] = partialder(fcn);
%                 % Compare with the exact derivatives
%                  derx_true = cos(X).*sin(Y);
%                  dery_true = sin(X).*cos(Y);
%                  norm(derX-derx_true,Inf);
%                  norm(derY-dery_true,Inf);
%
%   See also   DERMATRIX

%   Zoltán Csáti
%   2014/09/08

if nargin < 2
    % Use the extremes of the Chebyshev polynomials of the first kind
    N = 10;
    x = -cos(pi*(0:N)/N); % reverse ordering
end
% Create the first derivative matrix
D = dermatrix(x,1);
D = D{1}; 
[Xmesh Ymesh] = meshgrid(x);
% Put the function to be differentiated into correct form
if isa(fcn,'function_handle')
    f = fcn(Xmesh,Ymesh);
elseif isa(fcn,'numeric')
    f = fcn;
else
    error('MATLAB:partialder:wrongClass', ...
          'Input must be either a function handle or a numeric matrix.');
end
% Perform spectral differentiation
derx = f*D.';
dery = D*f;

% % Stretch 2D grid to 1D vectors
% f = f(:);
% % The spectral derivative is gives as a Kronecker product
% Dx = kron(D,I);
% Dy = kron(I,D);
% % Evaluate the derivatives by matrix-vector multiplication
% derx = Dx*f;
% dery = Dy*f;
% % Reshape the solution to the 2D grid
% derx = reshape(derx,sizex,sizex);
% dery = reshape(dery,sizex,sizex);