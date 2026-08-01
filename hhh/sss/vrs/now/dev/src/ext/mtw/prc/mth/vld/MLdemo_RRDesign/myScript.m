%% Load configuration
configParams

%% Run black box model
sim('mldemo_suspn.mdl',[0 10]);

%% Compute cost
totalAccel = (Zdotdot + rf * thetadotdot).^2 + (Zdotdot - rr * thetadotdot).^2;
sumAccel= cumsum(totalAccel);

%% Visualize data
createfigure(t, thetadotdot, Zdotdot, totalAccel, sumAccel)

%% Return final value
mycost = sum(totalAccel);