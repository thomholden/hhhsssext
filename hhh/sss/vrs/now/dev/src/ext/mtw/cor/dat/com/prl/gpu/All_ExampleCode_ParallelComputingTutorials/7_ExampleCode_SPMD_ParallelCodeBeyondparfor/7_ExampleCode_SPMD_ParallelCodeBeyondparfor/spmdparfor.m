
spmd
    % myfile.mat needs to be available on workers
    data = load('myfile.mat');
end

parfor I = 1:N
    % loop using data
end

% Copyright 2014 The MathWorks, Inc.