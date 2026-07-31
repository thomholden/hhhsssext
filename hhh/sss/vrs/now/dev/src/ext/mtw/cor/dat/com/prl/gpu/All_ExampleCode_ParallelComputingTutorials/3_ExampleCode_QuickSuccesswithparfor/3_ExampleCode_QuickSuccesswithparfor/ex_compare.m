% Running in serial 
tic; a1 = ex_serial(50,10000); t1 = toc;

% Running in parallel
gcp; % open parallel pool if none is open
tic; a2 = ex_parallel(50,10000); t2 = toc;

% Compare processing times
disp(['Serial processing time:   ' num2str(t1)])
disp(['Parallel processing time: ' num2str(t2)])

% Comparing results
subplot(1,2,1)
hist(a1, 23:0.2:27), xlim([23 27]), title('serial')
subplot(1,2,2)
hist(a2, 23:0.2:27), xlim([23 27]), title('parallel')

% Copyright 2010 - 2014 The MathWorks, Inc.