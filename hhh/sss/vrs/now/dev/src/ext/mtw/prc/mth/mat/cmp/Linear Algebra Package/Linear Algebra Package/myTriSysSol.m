function X = myTriSysSol(T,Y,mode)
%--------------------------------------------------------------------------
% Syntax:       X = myTriSysSol(U,Y,'upper');
%               X = myTriSysSol(L,Y,'lower');
%
% Inputs:       When mode == 'upper':
%               U is an N x N upper triangular matrix, and Y is an N x P
%               matrix.
%
%               When mode == 'lower':
%               L is an N x N lower triangular matrix, and Y is an N x P
%               matrix.
%
% Outputs:      X is the N x P matrix such that X = U^(-1) * Y;
%              
% Description:  This function solves the linear, triangular system of
%               equations Y = T * X using backsubstitution, and returns
%               X such that X = T^(-1) * Y; (for T = U or T = L)
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 12, 2012
%--------------------------------------------------------------------------

[m n] = size(T);
if (m ~= n)
    error('Input matrix must be square');
end

[m p] = size(Y);

if (m ~= n)
    error('U and Y must have same inner dimensions');
end

X = zeros(n,p);

if strcmpi(mode,'upper')
    for j = 1:p
        for i = n:(-1):1
            X(i,j) = Y(i,j);
            for k = (i+1):n
                X(i,j) = X(i,j) - T(i,k) * X(k,j);
            end
            X(i,j) = X(i,j) / T(i,i);
        end
    end
elseif strcmpi(mode,'lower')
    for j = 1:p
        for i = 1:n
            X(i,j) = Y(i,j);
            for k = 1:(i-1)
                X(i,j) = X(i,j) - T(i,k) * X(k,j);
            end
            X(i,j) = X(i,j) / T(i,i);
        end
    end
end
