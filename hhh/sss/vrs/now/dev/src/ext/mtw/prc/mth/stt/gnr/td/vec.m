function Y_big = vec(Y)
% PURPOSE: Create a matrix stacking the columns of Y
% ------------------------------------------------------------
% SYNTAX: Y_big = vec(Y)
% ------------------------------------------------------------
% OUTPUT: Y_big = matrix of columns of Y
% ------------------------------------------------------------
% INPUT: Y = an nxM matrix of original series, columnwise
% ------------------------------------------------------------
% NOTE: A sensible alternative is provided by the vec() function
% included in UTILITIES, see: J. LeSage <<Econometrics Toolbox>>

% written by:
% Enrique M. Quilis
%  D.G. del Tesoro
%  Paseo del Prado, 6. Office 4.1-3.
%  28014 - Madrid (SPAIN)
%  <equilis@tesoro.meh.es>

% Version 1.1 [August 2006]

[n,M] = size(Y);

Y_big = Y(:,1);   % Initialization of the recursion
j = 2;
while (j <=  M)
   Y_big = [Y_big
          Y(:,j) ];
   j = j+1;
end;
