function h = mySymEigHist(mat,binCenters,plotFlag)
%--------------------------------------------------------------------------
% Syntax:       h = mySymEigHist(mat,binCenters);
%               h = mySymEigHist(mat,binCenters,'true');
%
% Inputs:       mat is a symmetric matrix
%
%               binCenters is a vector of length n containing the centers
%               of n bins, b(i), i = 1,...,n.  Bins b(2) through b(n-1) are
%               constructed to have edges at the midpoints of the
%               corresponding consecutive entries of binCenters, while b(1)
%               streches to -inf and b(n) stretches to +inf.
%
%               When 'true' is included as a 3rd argument, a bar graph
%               plotting the eigenvalue histogram of h is generated
%
% Outputs:      h is a vector of length n whose ith entry is the number of
%               eigenvalues of mat in the ith bin, as defined by binCenters
%
% Description:  This function efficiently computes the number of
%               eigenvalues of mat that lie in each of the n bins defined
%               by binCenters. To do so, the input matrix is first brought
%               to tridiagonal form, and then Sturm's sequences are used
%               to count the number of eigenvalues (i.e., sign changes of
%               the Sturm's sequence) that lie in each bin.
%
%               Note: Use the following code to compare the speed of
%               mySymEigHist() to eig():
%
%               n = 2000;
%               Nbins = 100;
%               A = randn(n); A = (A + A')/sqrt(2*n);
%               binCenters = linspace(-2,2,Nbins);
%               tic
%               h1 = mySymEigHist(A,binCenters);
%               toc
%               tic
%               h2 = hist(eig(A),binCenters);
%               toc
%               NumErrors = sum(abs(h1 - h2)) %#ok
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 18, 2012
%--------------------------------------------------------------------------

% Make sure input matrix is square
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Parse user input
if (nargin == 3)
    flag = strcmpi(plotFlag,'true');
else
    flag = 0;
end

% Obtain a symmetric tridiagonal matrix that is similar (i.e., shares the
% same eigenvalues) to mat
%T = myTriDiagHouseholder(mat);
T = hess(mat);

% Make sure binCenters are sorted
binCenters = sort(binCenters);

% Compute bin edges
edges = (binCenters(2:end) + binCenters(1:end-1)) / 2;

% Initialize histogram vector
Nbins = length(binCenters);
h = zeros(1,Nbins);

% Populate h
h(1) = numEigsBelow(T,n,edges(1));
totalEigs = h(1);
for i = 2:(Nbins - 1)
    h(i) = numEigsBelow(T,n,edges(i)) - totalEigs;
    totalEigs = totalEigs + h(i);
end
h(Nbins) = n - totalEigs;

if (flag == 1)
    figure;
    bar(binCenters,h);
    grid on;
    xlabel('Eigenvalues');
    ylabel('Count');
    title(['Eigenvalue Histogram of a ' num2str(n) ' x ' num2str(n) ' Symmetric Matrix']);
end

end

% Nested function
function num = numEigsBelow(T,n,mu)
% This function computes the number of eigenvalues of a symmetric
% tridiagonal matrix T that are less than mu

% Initialize modified Sturm sequence vector
q = zeros(n+1,1);

% Generate q
q(1) = 1;
q(2) = T(1,1) - mu;
for i = 2:n
    % Compute q recursively
    xk = T(i,i);
    yk = T(i-1,i);
    q(i+1) = (xk - mu) - (yk^2) / q(i);
    
    % Avoid division by zero
    if (abs(q(i+1)) < eps)
        if (q(i+1) == 0)
            q(i+1) = eps;
        else
            q(i+1) = sign(q) * eps;
        end
    end
    
    % Avoid division by zero
    %if (q(i+1) == 0)
    %    q(i+1) = 0.001;
    %end
end

% Compute num ( = # negative values in q)
num = nnz(q < 0);

end
