function demo_tmlp
%    DEMO_TMLP    A regression problem demo for MLP. Uses Students 
%                 t-distribution for residual.
%
%
%       Description
%       The synthetic data used here  is the same used by Radford M. Neal 
%       in his regression problem with outliers example in Software for
%       Flexible Bayesian Modeling (http://www.cs.toronto.edu/~radford/fbm.software.html).
%       The problem consist of one dimensional input and target variables. The
%       input data, x, is sampled from standard Gaussian distribution and
%       the corresponding target values come from a distribution with mean
%       given by 
%
%       y = 0.3 + 0.4x + 0.5sin(2.7x) + 1.1/(1+x^2).
%
%       For most of the cases the distribution about this mean is Gaussian
%       with standard deviation of 0.1, but with probability 0.05 a case is an
%       outlier for wchich the standard deviation is 1.0. There are total 200
%       cases from which the first 100 are used for training and the last 100
%       for testing. 


% Copyright (c) 2005 Jarno Vanhatalo, Aki Vehtari 

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

disp(' ')
disp(' The synthetic data used here  is the same used by Radford M. Neal ')
disp(' in his regression problem with outliers example in Software for ')
disp(' Flexible Bayesian Modeling (http://www.cs.toronto.edu/~radford/fbm.software.html).')
disp(' The problem consist of one dimensional input and target variables. The ')
disp(' input data, x, is sampled from standard Gaussian distribution and ')
disp(' the corresponding target values come from a distribution with mean ')
disp(' given by ')
disp(' ')
disp(' y = 0.3 + 0.4x + 0.5sin(2.7x) + 1.1/(1+x^2).')
disp(' ')
disp(' For most of the cases the distribution about this mean is Gaussian ')
disp(' with standard deviation of 0.1, but with probability 0.05 a case is an ')
disp(' outlier for wchich the standard deviation is 1.0. There are total 200 ')
disp(' cases from which the first 100 are used for training and the last 100 ')
disp(' for testing. ')
disp(' ')

% load the data. First 100 variables are for training
% and last 100 for test
S = which('demo_tmlp');
L = strrep(S,'demo_tmlp.m','demos/odata');
x=load(L);
xt = x(101:end,1);
yt = x(101:end,2);
y = x(1:100,2);
x = x(1:100,1);

% plot the training data in dots and the underlying 
% mean of it as a line
xx = [-2.7:0.1:2.7];
yy = 0.3+0.4*xx+0.5*sin(2.7*xx)+1.1./(1+xx.^2);
figure
plot(x,y,'.')
hold on
plot(xx,yy)
title('training data')

disp(' ')
disp(' We create an MLP network and priors for network weights and residual. ')
disp(' Prior of network is Gaussian multivariate hierarchical. The prior model ')
disp(' residual is hierarchical Students t-distribution.')
disp(' ')

% create the network
nin=size(x,2);
nhid=8;
nout=1;
net = mlp2('mlp2r', nin, nhid, nout);

% Create a Gaussian multivariate hierarchical prior for network...
net=mlp2normp(net, {{0.1 0.05 0.5 -0.05 1} ...
                    {0.1 0.05 0.5} ...
                    {0.1 -0.05 0.5} ...
                    {1}});

% Create students t-distribution prior for residual.
% first the prior is created wiht fixed number of degrees of freedom.
% After which the sampling is done forone round
net.p.r = t_p({0.1 4 0.05 0.5})

disp(' ')
disp(' The starting values for sampling are found by first sampling ')
disp(' only the weights with HMC. In this phase the hyperparameter')
disp(' values are fixed to certain values in order to prevent them ')
disp(' from taking strange values before the weights have reached ')
disp(' reasonable values. Also the number of degrees of freedom for')
disp(' residual model is fixed. ')
disp(' ')

% Set the sampling options
opt=mlp2r_mcopt;
opt.repeat=50;
opt.plot=0;
opt.hmc_opt.steps=40;
opt.hmc_opt.stepadj=0.1;
hmc2('state', sum(100*clock));

% Sample for one round with fixed nu
net = mlp2unpak(net, mlp2pak(net)*0);
[r1,net1]=mlp2r_mc(opt, net, x, y);

disp(' ')
disp(' After the first iteration round we start also the Gibbs sampling for ')
disp(' hyper-parameters. At first the persistence is not used for ')
disp(' weights sampling. This way we get the starting points for ')
disp(' hyperparameters also. ')
disp(' ')
disp(' We set also a hierarchical prior for residual model. In this case ')
disp(' the number of degrees of freedom is sampled from discretized values. ')
disp(' ')

% create the prior structure for the final sampling
% Here nu (number of freedom) is sampled from discrete 
% set of values.
net1.p.r = t_p({net.p.r.a.s net.p.r.a.nu 0.05 0.5 ...
                  [2 2.3 2.6 3 3.5 4 4.5 5 6 7 8 9 10 12 14 16 18 20 25 30 35 40 45 50]});

opt.hmc_opt.stepadj=0.2;
opt.hmc_opt.steps=60;
opt.repeat=70;
opt.gibbs=1;
[r2,net2]=mlp2r_mc(opt, net1, x, y, [], [], r1);

% The sampling parameters are tuned and the sampling with
% windowing and persistence is started. After this the starting
% values for main sampling are found and main sampling is started.
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

% Sample for the posterior 2000 samples .
opt.repeat=60;
opt.hmc_opt.steps=100;
opt.hmc_opt.stepadj=0.5;
opt.nsamples=2000;

% Here we would do the main sampling. In order to save time we have
% saved one GP record structure in the software. The record (and though 
% the samples) are loaded and used in the demo. In order to do your own 
% sampling uncomment the line below.
%
% In order to sample for real uncomment the lines.
%[r,net]=mlp2r_mc(opt, net3, x, y, [], [], r3);

L = strrep(S,'demo_tmlp.m','demos/tmlprecord.mat');
load(L);

disp(' ')
disp(' Finally we are ready to forward propagate new input data and plot')
disp(' the outcome. The test data and network predictions are plotted ')
disp(' together with the underlying mean. ')
disp(' ')

% thin the record
rr = thin(r,50,20)

% make predictions for test set
tga = mean(mlp2fwds(r,xt),3);

% Plot the network outputs as '.', and underlying mean with '--'
figure
plot(xt,tga,'.')
hold on
plot(xx,yy,'--')
legend('prediction', 'mean')
title('prediction from MLP')

% plot the test data set as '.', and underlying mean with '--'
figure
plot(xt,yt,'.')
hold on
plot(xx,yy,'--')
legend('data', 'mean')
title('test data')

% evaluate the RMSE to the mean
yyt = 0.3+0.4*xt+0.5*sin(2.7*xt)+1.1./(1+xt.^2);
er = sqrt((yyt-tga)'*(yyt-tga)/length(yyt));
