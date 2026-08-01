function [v varargout] = myInvIteration(mat,lambda,varargin)
%--------------------------------------------------------------------------
% Syntax:       v = myInvIteration(mat,mu);
%               v = myInvIteration(mat,mu,'its',k);
%               v = myInvIteration(mat,mu,'prec',eps);
%               [v its] = myInvIteration(mat,mu);
%               [v its] = myInvIteration(mat,mu,'prec',eps);
%
% Inputs:       mat is a symmetric square matrix
%
%               lambda is an estimated (or exact) eigenvalue of mat
%
%               eps is the desired Rayleigh quotient precision threshold.
%               The default value is 1e-4.
%
%               k is the maximum number of inverse iterations to apply.
%
%               NOTE: When lambda is "close" (to your desired precision) to
%               an actual eigenvalue of mat, inverse iteration will
%               converge in k = 1 steps.
%
% Outputs:      v is the eigenvector corresponding to the eigenvalue of mat
%               closest to lambda
%
%               its is the number of inverse iterations required to achieve
%               Rayleigh quotient convergence to eps precision.
%
% Description:  This function applies inverse iteration to compute the
%               eigenvector of a symmetric input mat corresponding to its
%               eigenvalue closest to the specified lambda.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

% Check input size
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Parse inputs
if (nargin == 4)
    if strcmpi(varargin{1},'its')
        k = varargin{2};
        eps = 0;
    elseif strcmpi(varargin{1},'prec')
        eps = varargin{2};
    else
        error('Input syntax error. Type ''help myInvIteration'' for assistance');
    end
else
    eps = 1e-4;
end

% Initialize variables
%rng(1);
v = randn(n,1);
v = v / norm(v);

% Compute pseduoinverse
%matPinv = myPInv(mat - diag(lambda * ones(n,1)));
matPinv = pinv(mat - diag(lambda * ones(n,1)));

% Perform inverse iteration
if (eps > 0)
    % Compute inverse iterations until Rayleigh coefficient stabilizes
    its = 1;
    lastLambda = lambda;
    w = matPinv * v;
    v = w / norm(w);
    lambda = v' * mat * v;
    eps_i = (lambda - lastLambda) / lastLambda;
    while (eps_i > eps)
        its = its + 1;
        w = matPinv * v;
        v = w / norm(w);
        lastLambda = lambda;
        lambda = v' * mat * v;
        eps_i = (lambda - lastLambda) / lastLambda;
    end
    
    % Return iteration count if requested
    if (nargout == 2)
        varargout{1} = its;
    end
else
    % Compute specified number of inverse iterations
    for i = 1:k
        w = matPinv * v;
        v = w / norm(w);
    end
end

% v now contains the eigenvector estimate, so return it
