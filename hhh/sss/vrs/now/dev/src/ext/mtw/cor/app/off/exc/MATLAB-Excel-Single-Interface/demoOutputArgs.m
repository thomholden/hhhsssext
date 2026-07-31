function [str,R] = demoOutputArgs( randSize, cellOfStrings, M )

%   Copyright 2006 The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2006/08/17 09:11:48 $

% generate random matrix of the right size
R = rand( randSize );

% do nothing with the cell array of strings

% check whether M is magic and return an appropriate string
if iIsMagic( M )
    str = 'The matrix is magic.';
else
    str = 'The matrix is not magic.';
end

end % function

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function isMagic = iIsMagic( M )

% sum along one column - can be any
sM = sum( M(:,1) );

% and see whether sums in all directions are equal to it
if all( sum( M, 1 ) == sM ...
        & sum( M, 2 )' == sM ...
        & repmat( sum( diag( M ) ), 1, length( M ) ) == sM ...
        & repmat( sum( diag( M' ) )', 1, length( M ) ) == sM )
    isMagic = true;
else
    isMagic = false;
end

end %subfunction