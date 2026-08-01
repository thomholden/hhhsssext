%% countcycles.m  Counts the number of cycles the strut is subjected to. 

%% Initialize variables
global cycles

years = 5;                      % desired lifetime of strut
bumps = 50000;                  % # of bumps encountered per year
cycles_time = 0;

%% Compute the Number of Cycles Per Bump
% Find index where acceleration amplitude falls below some percent of the 
% initial value from the step input
Ih = find(h~=0);
Ih = Ih(1);

Zhilbert = hilbert(Zdotdot/abs(Zdotdot(Ih)));
I = find(abs(Zhilbert(1:end-100)) > 0.3);
I = I(end)+1;

% Count zero crossing in acceleration up to index I
for jj = Ih:I
    if Zdotdot(jj)*Zdotdot(jj+1) < 0
        cycles_time = cycles_time + 1;
    end
end

%% Compute the Lifetime Number of Cycles
cycles_time = cycles_time/2;              % 2 zero crossings for every cycle
cycles_mean = mean(cycles_time);          % average # of cycles per bump

cycles = years*bumps*cycles_mean;    % total lifetime cycles for shock absorber
