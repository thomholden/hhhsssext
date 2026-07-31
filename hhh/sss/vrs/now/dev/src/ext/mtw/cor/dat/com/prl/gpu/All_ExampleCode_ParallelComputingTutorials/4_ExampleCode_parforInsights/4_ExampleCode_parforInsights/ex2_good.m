function ex2_good

data = rand(4,4);
means = zeros(1,4);
parfor I = 1:4
    % Call a function instead
    means(I) = computeMeans(data,I);
end
disp(means)


% This function now contains the body
% of the parfor-loop
function meansI = computeMeans(data,I)
z.mean = mean(data(:,I));
meansI = z.mean;

% Copyright 2014 The MathWorks, Inc.