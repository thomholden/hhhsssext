function IdxNew=clearBad(Idx,bad)
% clearBad   replaces bad sites with NaN.
% 
%    IdxNew=clearBad(Idx,bad) takes a cluster-index matrix Idx 
%    and a vector of bad channels bad. The new cluster-index matrix
%    IdxNew has NaN for the corresponding bad sites.
%
%    Example
%    % three cluster of two sites
%    Idx=[1 2 3 ; 4 5 6];
%    % site 1 and 6 are bad
%    Idx=clearBad(Idx,[1 6]);
%
%    See also getClusters, getSpots, getRegionEEG.


% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.



% Check number of inputs
if nargin < 2
    error('Input missing, only cluster index matrix Idx and bad channels vector bad should be specified');
end

if nargin > 2
    error('Too many inputs, only cluster index matrix Idx and bad channels vector bad should be specified');
end

% replacing bad channels' values by NaNs
tf = ismember(Idx,bad);
Idx(find(tf)) = NaN;

% finally
IdxNew=Idx;

return,
%end