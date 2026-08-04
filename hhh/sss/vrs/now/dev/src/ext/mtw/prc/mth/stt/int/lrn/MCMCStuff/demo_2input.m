function demo_2input
%DEMO_2INPUTS    Regression problem demonstration for 2-input 
%                function
%
%      Description
%      The demonstration program is based on the data used in work
%      by C.J. Paciorek and M.J. Scherwish (2204). The data is from
%      a two input one output function with Gaussian noise with
%      mean zero and standard deviation 0.25, (N(0,0.25^2).
%      Data is in a matrix so that first two columns corresponds 
%      input vectors and last column is an outcome with noise.
%

% Copyright (c) 2004 Jarno Vanhatalo, Aki Vehtari 

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

disp(' ')
disp(' The problem consist of a noisy function with two input variables')
disp(' and one output variable. We use  MLP network with multivariate ')
disp(' hierarchical prior to solve the regression problem.')
disp(' ')

% Load the data.
S = which('demo_2input');
L = strrep(S,'demo_2input.m','demos/dat.1');
data=load(L);
x = [data(:,1) data(:,2)];
y = data(:,3);

disp(' ')
disp(' In order to be able to compare the starting data and result, we')
disp(' draw the starting data')
disp(' ')

% Draw the data. The data is not sorted.
figure
title({'The noisy training data'});
[xi,yi,zi]=griddata(data(:,1),data(:,2),data(:,3),-1.8:0.01:1.8,[-1.8:0.01:1.8]');
mesh(xi,yi,zi)

disp(' ')
disp(' We create an MLP network and priors for network weights and residual. ')
disp(' Prior of network is Gaussian multivariate hierarchical with ARD. ')
disp(' ')

% Create an MLP network for regression model. function mlp 
% initializes weights to zero.
nin=size(x,2);
nhid=10;
nout=1;
net = mlp2('mlp2r', nin, nhid, nout);

% Create a Gaussian multivariate hierarchical prior with ARD 
% for network...
net=mlp2normp(net, {{repmat(0.1,1,net.nin) 0.05 1 -0.05 2} ...
                    {0.1 0.05 1} ...
                    {0.1 -0.05 1} ...
                    {1}})

% ...and the same for residual.
net.p.r = norm_p({0.05 0.05 0.5});

disp(' ')
disp(' The starting values for sampling are found by first sampling ')
disp(' only the weights with HMC. In this phase the hyperparameter')
disp(' values are fixed to certain values in order to prevent them ')
disp(' from taking strange values before the weights have reached ')
disp(' reasonable values. ')
disp(' ')


% Set the options for Monte Carlo sampling
opt=mlp2r_mcopt;
opt.repeat=50;
opt.plot=0;
opt.hmc_opt.steps=40;
opt.hmc_opt.stepadj=0.1;
hmc2('state', sum(100*clock));

% Initialize weights to zero and sample for the first time.
% The opt.gibbs = 0 for this round of MC-sampling, so the 
% sampling is done only for weigths. This way we can reach the 
% equilibrium distribution more quickly.
net = mlp2unpak(net, mlp2pak(net)*0);
[r1,net1]=mlp2r_mc(opt, net, x, y);

disp(' ')
disp(' After the first iteration round we start also the Gibbs sampling for ')
disp(' hyper-parameters. At first the persistence is not used for ')
disp(' weights sampling. This way we get the starting points for ')
disp(' hyperparameters also. ')
disp(' ')

% Now sample also for hyper-priors with Gibbs sampling.
opt.hmc_opt.stepadj=0.2;
opt.hmc_opt.steps=60;
opt.repeat=70;
opt.gibbs=1;
[r2,net2]=mlp2r_mc(opt, net1, x, y, [], [], r1);

% The sampling parameters are fixed a bit and the sampling with
% windowing and persistence is started. After this the starting
% values for main sampling are reached.
opt.hmc_opt.stepadj=0.3;
opt.hmc_opt.steps=100;
opt.hmc_opt.window=5;
opt.hmc_opt.persistence=1;
[r3,net3]=mlp2r_mc(opt, net2, x, y, [], [], r2);

disp(' ')
disp(' Here we would do the main sampling. The main sampling is skipped')
disp(' and an old network record structure is loaded in order to save')
disp(' time. To do the main sampling, uncomment mlp2r_mc line from ')
disp(' program and comment out the load lines.')
disp(' ')

% Sample for the posterior 2500 samples .
opt.repeat=60;
opt.hmc_opt.steps=100;
opt.hmc_opt.stepadj=0.5;
opt.nsamples=2500;

% Here we would do the main sampling. In order to save time we have
% saved one GP record structure in the software. The record (and though 
% the samples) are loaded and used in the demo. In order to do your own 
% sampling uncomment the line below.
%
%[r,net]=mlp2r_mc(opt, net3, x, y, [], [], r3);

S = which('demo_2input');
L = strrep(S,'demo_2input.m','demos/2inputrecord');
load(L)
L = strrep(S,'demo_2input.m','demos/2inputnet');
load(L)

% Thin the network
mlp=thin(r,150,25);

disp(' ')
disp(' Finally we are ready to forward propagate new input data and plot')
disp(' the outcome. ')
disp(' ')

% Create new data with the right scale checked above
figure
[p1,p2]=meshgrid(-1.8:0.05:1.8,-1.8:0.05:1.8);
p=[p1(:) p2(:)];
tms=squeeze(mlp2fwds(mlp,p))';
g=mean(tms);

%Plot the new data
gp=zeros(size(p1));
gp(:)=g;
mesh(p1,p2,gp);
axis on;
