function demo_2class
%DEMO_2CLASS    Classification problem demonstration for 2
%               classes. 
%
%      Description
%      The demonstration program is based on synthetic two 
%      class data used by B.D. Ripley (Pattern Regocnition and
%      Neural Networks, 1996}. The data consists of 2-dimensional
%      vectors that are divided into to classes, labeled 0 or 1.
%      Each class has a bimodal distribution generated from equal
%      mixtures of Gaussian distributions with identical covariance
%      matrices. A Bayesian aprouch is used to find the decision
%      line and predict the classes of new data points.
%
%      The demonstration program does not sample for real, because
%      it would require so much time. The main sampling state is
%      commented out from the program and instead a saved network
%      structure is loaded and used to make predictions (see lines
%      143-146).
%

% Copyright (c) 2005 Jarno Vanhatalo, Aki Vehtari 

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

% This demonstration is based on the dataset used in the book Pattern Recognition and
% Neural Networks by B.D. Ripley (1996) Cambridge University Press ISBN 0 521
% 46986 7

disp(' ')
disp(' The demonstration program is based on synthetic two ')
disp(' class data used by B.D. Ripley (Pattern Regocnition and')
disp(' Neural Networks, 1996}. The data consists of 2-dimensional')
disp(' vectors that are divided into to classes, labeled 0 or 1.')
disp(' Each class has a bimodal distribution generated from equal')
disp(' mixtures of Gaussian distributions with identical covariance')
disp(' matrices. A Bayesian aprouch is used to find the decision')
disp(' line and predict the classes of new data points.')
disp(' ')
disp(' ')

% Load the data
S = which('demo_2class');
L = strrep(S,'demo_2class.m','demos/synth.tr');
x=load(L);
y=x(:,end);
x(:,end)=[];

disp(' ')
disp(' First we create an MLP network for classification model with logistic')
disp(' output function (mlp2b). Function mlp initializes weights to zero.')
disp(' A Gaussian multivariate hierarchical prior with ARD is created ')
disp(' for network. ')
disp(' ')

nin=size(x,2);
nhid=10;   
nout=size(y,2);
% create MLP with logistic output function ('mlp2b')
net = mlp2('mlp2b', nin, nhid, nout);

%Create a Gaussian multivariate hierarchical prior with ARD 
% for network...
net=mlp2normp(net, {{repmat(10,1,net.nin) 0.05 1 -0.05 2}... % input-hidden weigth
                    {10 0.05 1} ...                          % bias-hidden
                    {10 -0.05 1} ...                         % hidden-output weigth
                    {1}})                                      % bias-output

% To create prior for the weights without ARD, comment out the above
% lines and remove the comment marks below.
%net=mlp2normp(net, {{10 0.05 1}...                             % input-hidden weight
%                    {10 0.05 0.5} ...                          % bias-hidden
%                    {10 -0.05 0.5} ...                         % hidden-output
%                    {1}});                                     % bias-output

disp(' ')
disp(' The starting values for sampling the weights are found with early ')
disp(' stop method. This is a quick way to get better starting point ')
disp(' for the Markov chain.') 
disp(' ')
% See Vehtari et al (2000). On MCMC sampling in Bayesian MLP neural networks.
% In Proc. IJCNN'2000.
%
% <http://www.lce.hut.fi/publications/pdf/VehtariEtAl_ijcnn2000.pdf>

% Intialize weights to zero and set the optimization parameters...
w=randn(size(mlp2pak(net)))*0.01;

fe=str2fun('mlp2b_e');
fg=str2fun('mlp2b_g');
n=length(y);
itr=1:floor(0.5*n);     % training set of data for early stop
its=floor(0.5*n)+1:n;   % test set of data for early stop
optes=scges_opt;
optes.display=1;
optes.tolfun=1e-1;
optes.tolx=1e-1;

% scaled conjugate gradient optimization with early stopping.
[w,fs,vs]=scges(fe, w, optes, fg, net, x(itr,:),y(itr,:), net,x(its,:),y(its,:));
net=mlp2unpak(net,w);

disp(' ')
disp(' Now that the initial values for weigths are found we can set the ')
disp(' starting values for weights hyperparameters (variance of weight). ')
disp(' The variance of each weight can be aproximated from the early stop ')
disp(' values of the weight. The starting values for other hyperparameters ')
disp(' are found by sampling one sample of each parameter without ') 
disp(' persistence for weights. ')
disp(' ')

% Set the starting values for weights hyperparameter to be the
% variance of the early stopped weight.
shypw1 = std(net.w1,0,2)';
shypb1 = std(net.b1);
shypw2 = std(net.w2(:));

net=mlp2normp(net, {{shypw1  0.05 1 -0.05 2}...      % input-hidden weigth
                    {shypb1  0.05 1} ...             % bias-hidden
                    {shypw2 -0.05 1} ...             % hidden-output weigth
                    {1}})                              % bias-output

% First initialize random seed for Monte 
% Carlo sampling and set the sampling options to default.
hmc2('state', sum(100*clock));
opt=mlp2b_mcopt;
opt.sample_inputs=0; % do not use RJMCMC for input variables

% sample without persistence.
opt.repeat=70;           
opt.hmc_opt.steps=10;    
opt.hmc_opt.stepadj=0.2; 
opt.gibbs=1;
opt.nsamples=1;
[r,net,rstate]=mlp2b_mc(opt, net, x, y);

disp(' ')
disp(' Here we would do the main sampling. The main sampling is skipped')
disp(' and an old network record structure is loaded in order to save')
disp(' time. To do the main sampling, uncomment mlp2b_mc line from ')
disp(' program and comment out the load lines.')
disp(' ')

% starting values are found. start the main sampling.
opt.hmc_opt.stepadj=0.5;
opt.hmc_opt.persistence=1;
opt.hmc_opt.steps=40;    
opt.hmc_opt.decay=0.95;  
opt.repeat=50;           
opt.nsamples= 650;
opt.hmc_opt.window=5;     

% Here we would do the main sampling. In order to save time we have
% saved one GP record structure in the software. The record (and though 
% the samples) are loaded and used in the demo. In order to do your own 
% sampling uncomment the line below.
%
%[r,net,rstate]=mlp2b_mc(opt, net, x, y, [], [], r, rstate);

L = strrep(S,'demo_2class.m','demos/2classrecord');
load(L)   % This line loads an old record structure.

% Thin the sample chain.
r=thin(r,50,6);

disp(' ')
disp(' For last the decision line and the training points are ')
disp(' drawn in the same plot. ')
disp(' ')

% Draw the decision line and training points in the same plot
[p1,p2]=meshgrid(-1.3:0.05:1.1,-1.3:0.05:1.1);
p=[p1(:) p2(:)];
tms=mean((logsig2(mlp2fwds(r,p))),3);

%Plot the decision line
gp=zeros(size(p1));
gp(:)=tms;
contour(p1,p2,gp,[0.5 0.5],'k');

hold on;
% plot the train data o=0, x=1
plot(x(y==0,1),x(y==0,2),'o');
plot(x(y==1,1),x(y==1,2),'x');
hold off;

% test how well the network works for test data. 
L = strrep(S,'demo_2class.m','demos/synth.ts');
tx=load(L);
ty=tx(:,end);
tx(:,end)=[];

tga=mean(logsig2(mlp2fwds(r,tx)),3);

% calculate the percentage of misclassified points
missed = sum(abs(round(tga)-ty))/size(ty,1)*100;

