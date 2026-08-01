function inv = myInv(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:       inv = myInv(mat);
%               inv = myInv(mat,'gauss');
%               inv = myInv(mat,'svd');
%
% Inputs:       mat is an square nonsingular matrix
%               
%               mode can be {'svd','gauss'}. The default is 'svd'
%
% Outputs:      inv is the matrix inverse of input mat
%              
% Description:  This function returns the matrix inverse of the square
%               input mat using the specified method. If input mat is
%               singuar (to working precision,) an error is displayed.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         June 28, 2012
%--------------------------------------------------------------------------

if nargin == 1
    mode = 'svd';
else
    mode = varargin{1};
end

if (size(mat,1) ~= size(mat,2))
    error('Input matrix must be square');
end

if strcmpi(mode,'svd')
    [inv isSingular] = myPInv(mat);
    if strcmp(isSingular,'true')
        error('Input matrix is singular to working precision');
    end
elseif strcmpi(mode,'gauss')
    tolerance = 1e-4;
    dim = size(mat,1);
    inv = eye(dim);  
    for k = 0:(dim-1)
        for i = k:(dim-1)
            valInv = 1.0 / mat(i+1,k+1);
            for j = k:(dim-1)
                mat(i+1,j+1) = mat(i+1,j+1) * valInv;
            end
            for j = 0:(dim-1)
                inv(i+1,j+1) = inv(i+1,j+1) * valInv;
            end
        end
        for i = (k+1):(dim-1)
            for j = k:(dim-1)
                mat(i+1,j+1) = mat(i+1,j+1) - mat(k+1,j+1);
            end
            for j = 0:(dim-1)
                inv(i+1,j+1) = inv(i+1,j+1) - inv(k+1,j+1);
            end
        end
    end

    for i = (dim-2):-1:0
        for j = (dim-1):-1:(i+1)
          for k = 0:(dim-1)
            inv(i+1,k+1) = inv(i+1,k+1) - (mat(i+1,j+1) * inv(j+1,k+1));
          end
          for k = 0:(dim-1)
              mat(i+1,k+1) = mat(i+1,k+1) - (mat(i+1,j+1) * mat(j+1,k+1));
          end
        end
    end

    if sum(sum(abs(mat-eye(dim)))) > dim^2*tolerance
        error('Input matrix is singular to working precision');
    end
else
    error('Inversion method not recognized');
end
