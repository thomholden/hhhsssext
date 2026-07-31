function chebcoeffplot(A)
%CHEBCOEFFPLOT   Logarithm plot of the spectral coefficients.
%   CHEBCOEFFPLOT(A) displays the logarithm of the absolute values of the
%   spectral coefficients stored in matrix A.
%
%   See also   CHEBCOEFF

%   Zoltán Csáti
%   2014/09/22

% We are interested in the absolute value of the coefficients
A = abs(A);
% Rotate A to get the minor diagonals
A = rot90(A,-1);
% Initialize figure and axes
n = size(A,2);
fig = figure('Visible','off');
a = axes('Parent',fig, 'YScale','log');
xlabel('m+n+2', 'Parent',a);
ylabel('|a_{mn}|', 'Parent',a,  'Rotation',0);
% Create the "m+n+2 - |a_mn|" plot
for k = 1:2*n-1
    if k <= n % above and on the minor diagonal
        xvec = (k+1)*ones(k,1);
    else      % under the minor diagonal
        xvec = (k+1)*ones(2*n-k,1);
    end
    line(xvec, diag(A,n-k), 'Parent',a, 'Marker','o', 'LineStyle','none');
end
% Make the figure visible 
set(fig, 'Visible','on');