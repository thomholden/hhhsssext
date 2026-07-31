%% Submit batch job
clust = parcluster('local');
N = 4; % for a quad-core computer
% To utilize all available workers on a cluster 
% of multiple computers, use the following instead:
% N = clust.NumIdleWorkers;
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
% (after job has reached 'finished' state)
results = fetchOutputs(job);
a = results{1};
hist(a)

%% Delete job
delete(job)

% Copyright 2014 The MathWorks, Inc.