function ex2_bad

data = rand(4,4);
means = zeros(1,4);
parfor I = 1:4
    % The below usage of structures 
    % is flagged by Code Analyzer
    z.mean = mean(data(:,I));
    means(I) = z.mean;
end
disp(means)

% Copyright 2014 The MathWorks, Inc.
