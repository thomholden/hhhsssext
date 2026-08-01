function tweakmymass(Iyyempty,Mempty,Lf0,Lr0,rf0,rr0,rt0)
%% tweakmymass.m  Computes the perturbed values for the vehicle mass,
% moment of inertia and the geometry for the Monte Carlo simulation.  

%% Global definitions
global Iyy Mb Lf Lr rf rr rt

%% Define distributions
front = raylrnd(80,1,1);  % additional mass for front passengers (kg)
back = raylrnd(40,1,1);   % additional mass for rear passengers (kg)
trunk = raylrnd(10,1,1);  % additional mass for luggage (kg)

%% Compute new vehicle mass
Mb = Mempty + front + back + trunk;

%% Compute new center of mass
% Computed as a perburtation from the existing center of mass
cm = (front*rf0 - back*rr0 - trunk*rt0)/Mb;
% a positive cm indicates the CM moved forward
% a negative cm indicates the CM moved backwards

%% Adjust the moment of inertia about the old center of mass
Iyy1 = Iyyempty + front*rf0^2 + back*rr0^2 + trunk*rt0^2;

%% Use parallel axis theorem to move moment of inertia to the new CM
Iyy = Iyy1 - Mb*cm^2;

%% Adjust the distance measurements to the new CG
Lf = Lf0 - cm;
Lr = Lr0 + cm;

rf = rf0 - cm;
rr = rr0 + cm;
rt = rt0 + cm;