% S Toolbox.
% Version 0.1 Sept-2005
%
%   computeS            - Computes S estimator.
%   computeED           - Estimates the delay embedding parameters 
%                         for multivariate time series.
%   Embed               - Embeds multivariate time series by delay embedding.
%   DelReconstructor    - Reconstructs state-spce of a scalar time series 
%                         by delay embedding.
%   timedelay_am        - Computes time lag by means of first minimum 
%                         of auto mutual information function.
%   false_neighbor      - Estimates the false nearest neighbors statistic 
%                         for a state-space.
%   composeData         - Merges data matrices.
%   fileSelector        - Merges data from files.
%   IncidenceMatrix     - Computes incidence matrix.
%   getClusters         - Computes clusters of sites on a area.
%   getSpots            - Computes cluster spots of given sites.
%   getRegionEEG        - Returns indexes of sites belonging to predefined 
%                         brain regions.
%   getClustersEEG      - Computes clusters over predefined brain regions.
%   clearBad            - Replaces bad sites with NaN.
%   plotS               - 2-D plot of S estimator.
%   MultiTest           - Performs a non-parametric permutation version 
%                         of the Hotelling's T^2 test. 
%   MBF                 - Computes F-distribution value for a multivariate
%                         Behrens-Fisher test.
%   Tutorial            - Tutorial exemple.
%

%
%
% Copyright (c) 2005 
% Cristian Carmeli / Oscar De Feo / Olivier Neal, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%
% This toolbox is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License 
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
