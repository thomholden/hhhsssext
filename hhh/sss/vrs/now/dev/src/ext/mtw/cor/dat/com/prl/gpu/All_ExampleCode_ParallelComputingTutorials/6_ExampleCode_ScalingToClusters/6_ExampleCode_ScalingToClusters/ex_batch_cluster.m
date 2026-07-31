%% Submit batch job
clust = parcluster('MyCluster');
% N = 4; % for a quad-core computer
% To utilize all available workers on an MJS cluster 
% of multiple computers, use the following instead:
if strcmp(clust.Type, 'MJS')
    N = clust.NumIdleWorkers;
else
    % Need to specify number of desired workers
    % Use the following to utilize all workers of the cluster
    % (job will be queued until all workers are available)
    % N = clust.NumWorkers;
    N = 4;
end
job = batch(clust, @ex_parallel, 1, {50, 4000}, 'Pool', N-1);

%% Query state of job
get(job, 'State')

%% Wait for job to be finished
% If you run the script using the "Run" button or from the command line,
% the above section may return a state different from 'finished' and resume
% with the next section, thus making fetchOutputs throw an error.
% The following line is inserted to ensure that the job is really finished 
% before proceeding to fetch the outputs from it:
wait(job, 'finished')

%% Retrieve and process results
% (after job has reached the 'finished' state)
results = fetchOutputs(job);
a = results{1};
hist(a)

%% Delete job
delete(job)

% Copyright 2014 The MathWorks, Inc.