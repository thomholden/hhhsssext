function a = ex_serial(M, N)
% EX_SERIAL performs N trials of computing the largest 
% eigenvalue for an M-by-M random matrix
%
% Inputs:
% M     side length of matrix
% N     number of trials
%
% Output:
% a     vector of largest eigenvalues
%
% Example:
% >> a = ex_serial(50,4000);

a = zeros(N,1); 
for I = 1:N 
    a(I) = max(eig(rand(M)));
end

% Copyright 2010 - 2014 The MathWorks, Inc.