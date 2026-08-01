function mycost = myCostFcn(x)
%% Extract suspension variables
kf = x(1);
cf = x(2);
kr = x(3);
cr = x(4);

%% Load configuration
configParams

%% Run black box model
sim('mldemo_suspnfast.mdl',[0 8], simset('SrcWorkspace', 'current', 'DstWorkspace', 'current'))

%% Compute cost
totalAccel = (Zdotdot + rf * thetadotdot).^2 + (Zdotdot - rr * thetadotdot).^2;

%% Return final value
mycost = sum(totalAccel);

%% [EOF]