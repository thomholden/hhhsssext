function demo_2classgp
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
disp(' matrices. A Gaussian process is used to find the decision')
disp(' line and predict the classes of new data points.')
disp(' ')
disp(' ')

% Load the data
S = which('demo_2classgp');
L = strrep(S,'demo_2classgp.m','demos/synth.tr');
x=load(L);
y=x(:,end);
x(:,end)=[];

disp(' ')
disp(' First we create a Gaussian process for classification problem. ')
disp(' A Gaussian multivariate hierarchical prior with ARD is created')
disp(' for GP. ')
disp(' ')

[n, nin] = size(x);
gp=gp2('gp2b',nin,'exp', 'jitter');
gp.jitterSigmas=10;
gp.expScale=0.2;
gp.expSigmas=repmat(0.1,1,gp.nin);
gp.noiseSigmas = 0.2;
gp.f='norm';

gp.p.expSigmas=invgam_p({0.1 0.5 0.05 1});
gp.p.expScale=invgam_p({0.05 0.5});

disp(' ')
disp(' The starting values for sampling the parameters are found with early ')
disp(' stop method. This is a quick way to get better starting point ')
disp(' for the Markov chain.') 
disp(' ')
% See Vehtari et al (2000). On MCMC sampling in Bayesian MLP neural networks.
% In Proc. IJCNN'2000.
%
% <http://www.lce.hut.fi/publications/pdf/VehtariEtAl_ijcnn2000.pdf>

% Intialize weights to zero and set the optimization parameters...
w=randn(size(gp2pak(gp)))*0.01;

fe=str2fun('gp2r_e');
fg=str2fun('gp2r_g');
n=length(y);
itr=1:floor(0.5*n);     % training set of data for early stop
its=floor(0.5*n)+1:n;   % test set of data for early stop
optes=scges_opt;
optes.display=1;
optes.tolfun=1e-1;
optes.tolx=1e-1;

% do scaled conjugate gradient optimization with early stopping.
[w,fs,vs]=scges(fe, w, optes, fg, gp, x(itr,:),y(itr,:), gp,x(its,:),y(its,:));
gp=gp2unpak(gp,w);

disp(' ')
disp(' Now that the starting values are found we set the main sampling ')
disp(' options and define the latent values. ')
disp(' ')

% set the options for sampling
opt=gp2_mcopt;
opt.repeat=20;
opt.nsamples=1;
opt.hmc_opt.steps=20;
opt.hmc_opt.stepadj=0.1;
opt.hmc_opt.nsamples=1;

opt.sample_latent = 20;
opt.sample_latent_scale = 0.5;
gp.latentValues = randn(size(y));
hmc2('state', sum(100*clock))

[r1,g1,rstate1]=gp2b_mc(opt, gp, x, y);

opt.repeat=10;
opt.nsamples = 1000;
opt.hmc_opt.persistence=1;
opt.sample_variances=0;
opt.hmc_opt.window=2;
opt.hmc_opt.stepadj=0.75;
opt.hmc_opt.steps=10;

% Here we would do the main sampling. In order to save time we have
% saved one GP record structure in the software. The record (and though 
% the samples) are loaded and used in the demo. In order to do your own 
% sampling uncomment the line below.
%
% [r,g,rstate]=gp2b_mc(opt, g1, x, y, [], [], r1, rstate1);

% Load a saved record structure
L = strrep(S,'demo_2classgp.m','demos/2classgprecord');
load(L)

% Thin the sample chain.
r=thin(r,50,8);

disp(' ')
disp(' For last the decision line and the training points are ')
disp(' drawn in the same plot. ')
disp(' ')

% Draw the decision line and training points in the same plot
[p1,p2]=meshgrid(-1.3:0.05:1.1,-1.3:0.05:1.1);
p=[p1(:) p2(:)];

tms2=mean((logsig2(gp2fwds(r, x, r.latentValues', p))),3);

%Plot the decision line
gp=zeros(size(p1));
gp(:)=tms2;
contour(p1,p2,gp,[0.5 0.5],'k');

hold on;
% plot the train data o=0, x=1
plot(x(y==0,1),x(y==0,2),'o');
plot(x(y==1,1),x(y==1,2),'x');
hold off;

% test how well the network works for the test data. 
L = strrep(S,'demo_2classgp.m','demos/synth.ts');
tx=load(L);
ty=tx(:,end);
tx(:,end)=[];

tga=mean(logsig2(gp2fwds(r, x, r.latentValues', tx)),3);

% calculate the percentage of misclassified points
missed = sum(abs(round(tga)-ty))/size(ty,1)*100;