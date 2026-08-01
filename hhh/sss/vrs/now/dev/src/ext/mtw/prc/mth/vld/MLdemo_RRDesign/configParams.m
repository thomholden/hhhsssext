%% configParams.m  Initializes parameters needed for the model.  

%% Constants
g = 9.81;                   % gravity (m/s^2)

%% Car Geometry 
Lf0 = 0.9;                   % front hub displacement from body CG (m)
Lr0 = 1.2;                   % rear hub displacement from body CG (m)

rf0 = 0.5*Lf0;                % location of front passengers (m)
rr0 = 0.9*Lr0;                % location of rear passengers (m)
rt0 = 1.1*Lr0;                % location of trunk (m)

Mempty = 1200;              % empty car mass (kg)
Iyyempty = 2100;            % body moment of inertia about y-axis (kgm^2)

%% Initial suspension design
kf0 = 19600;                % front suspension stiffness (N/m)
cf0 = 2200;                 % front suspension damping (N/(m/s))

kr0 = kf0*Lf0/Lr0;            % rear suspension stiffness (N/m) required value for level car
cr0 = 2000;                 % rear suspension damping (N/(m/s))

%% Use defaults if not exlicitly defined
if ~exist('kf','var')
    kf = kf0;
end
if ~exist('kr','var')
    kr = kr0;
end
if ~exist('cf','var')
    cf = cf0;
end
if ~exist('cr','var')
    cr = cr0;
end
if ~exist('Mb','var')
    Mb = Mempty;
end
if ~exist('Iyy','var')
    Iyy = Iyyempty;
end
if ~exist('Lf','var')
    Lf = Lf0;
end
if ~exist('Lr','var')
    Lr = Lr0;
end
if ~exist('rf','var')
    rf = rf0;
end
if ~exist('rr','var')
    rr = rr0;
end
if ~exist('rt','var')
    rt = rt0;
end

%% Initial Conditions for Simulink Model
theta0 = 0;                 % initial pitch (rad)
thetadot0 = 0;              % initial pitch rate (rad/s)
Z0 = -0.5*Mb*g/(kf+kr);     % initial equilibrium position, assumes full car (m)
Zdot0 = 0;                  % initial bounce rate (m/s)

%% [EOF]