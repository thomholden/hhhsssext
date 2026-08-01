%% loadresults.m

%% Load configuration
configParams

%% Initial design
x0 = [kf0 cf0 kr0 cr0];
cost0 = myCostFcn(x0);

%% Traditional design
load Tdesign

%% Reliability and Robust design
load RRdesign

%% Clear unneeded variables
clear Iyy Iyyempty Lf Lf0 Lr Lr0 Mb Mempty 
clear Z0 Zdot0 cf cf0 cr cr0 g kf kf0 kr kr0
clear rf0 rf rr0 rr rt0 rt theta0 thetadot0

%% Plot results
% Plot suspension design parameters
figure
    % Plot front spring constants
    subplot(2,2,1)
    bar([x0(1),x1(1),x2(1)])
    ylabel('k_f (N/m)')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
    % Plot front damping coefficients
    subplot(2,2,2)
    bar([x0(2),x1(2),x2(2)])
    ylabel('c_f (N/(m/s))')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
    % Plot rear spring constants
    subplot(2,2,3)
    bar([x0(3),x1(3),x2(3)])
    ylabel('k_r (N/m)')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
    % Plot front damping coefficients
    subplot(2,2,4)
    bar([x0(4),x1(4),x2(4)])
    ylabel('c_r (N/(m/s))')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
% Plot the cost function    
figure
    bar([cost0 cost1 cost2])
    ylabel('Cost Function')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
