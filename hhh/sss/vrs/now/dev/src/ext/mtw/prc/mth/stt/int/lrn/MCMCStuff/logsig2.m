function a = logsig2(n)
%LOGSIG2     Logarithmic sigmoid transfer function.
%
%  A = LOGSIG2(X) takes a vektor X and transfers its 
%  elements through logarithmic sigmoid to get A. 
%  A = 1 ./ (1 + exp(-N));

% Copyright (c) 1998-2006 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.


%LOGSIG2 Logarithmic sigmoid transfer function.
maxcut = -log(eps);
mincut = -log(1/realmin - 1);
a = 1 ./ (1 + exp(-max(min(n,maxcut),mincut)));

