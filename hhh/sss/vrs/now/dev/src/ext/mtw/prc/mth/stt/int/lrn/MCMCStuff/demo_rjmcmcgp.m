function demo_rjmcmcgp
%DEMO_RJMCMCGP    Demonstration program for input variable 
%                 sampling in Gaussian process
%                 
%
%      Description
%      The demonstration program is based on synthetic two 
%      class data used by B.D. Ripley (Pattern Regocnition and
%      Neural Networks, 1996}. The data consists of 2-dimensional
%      vectors that are divided into to classes, labeled 0 or 1.
%      Each class has a bimodal distribution generated from equal
%      mixtures of Gaussian distributions with identical covariance
%      matrices. After the classification is done based on the two 
%      input component three irrelevant inputs are added to the input
%      vector. A Bayesian aprouch is used to find the decision
%      line and predict the classes of new data points and a Reversible 
%      Jump MCMC method is used to sample for the inputs. 
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
disp(' matrices. After the classification is done based on the two ')
disp(' input component three irrelevant inputs are added to the input')
disp(' vector.A Gaussian process is used to find the decision')
disp(' line and predict the classes of new data points and a Reversible ')
disp(' Jump MCMC method is used to sample for the inputs. ')
disp(' ')
disp(' ')

% Load the data
S = which('demo_rjmcmcgp');
L = strrep(S,'demo_rjmcmcgp.m','demos/synth2.mat');
x=load(L);
x = x.x;
L = strrep(L,'synth2.mat','synth.tr');
y=load(L);
y=y(:,end);

disp(' ')
disp(' First we create a Gaussian process for classification problem (gp2b) ')
disp(' A Gaussian multivariate hierarchical prior with ARD is created ')
disp(' for GP parameters. ')
disp(' ')

[n, nin] = size(x);
gp=gp2('gp2b',nin,'exp', 'jitter');
gp.jitterSigmas=10;
gp.expScale=0.2;
gp.expSigmas=repmat(0.1,1,gp.nin);
gp.noiseSigmas = 0.3;
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

% ... Start scaled conjugate gradient optimization with early stopping.
[w,fs,vs]=scges(fe, w, optes, fg, gp, x(itr,:),y(itr,:), gp,x(its,:),y(its,:));
gp=gp2unpak(gp,w);

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
hmc2('state', sum(100*clock));

[r,gp,rstate]=gp2b_mc(opt, gp, x, y);

disp(' ')
disp(' Now that the starting values are found we set the main sampling ')
disp(' options and define the latent values. We define also the options ')
disp(' for input variable sampling. ')
disp(' ')

% Set the main sampling options
opt.repeat=10;
opt.nsamples = 1000;
opt.hmc_opt.persistence=1;
opt.sample_variances=0;
opt.hmc_opt.window=5;
opt.hmc_opt.stepadj=0.75;
opt.hmc_opt.steps=10;

% Set the sampling options for RJMCMC
opt.sample_inputs=1;
opt.rj_opt.pswitch = 1/3;
opt.rj_opt.pdeath = 0.5;
opt.rj_opt.lpk = log(ones(1,gp.nin)/gp.nin); % log of uniform prior for k:s
gp.inputii = logical(ones(1,gp.nin))

% Here we would do the main sampling. In order to save time we have
% saved one GP record structure in the software. The record (and though 
% the samples) are loaded and used in the demo. In order to do your own 
% sampling uncomment the line below.
%
%[r,g,rstate]=gp2b_mc(opt, gp, x, y, [], [], r, rstate);

S = which('demo_rjmcmcgp');
L = strrep(S,'demo_rjmcmcgp.m','demos/rec_rjmcmcgp.mat');
load(L);


% Thin the sample chain.
r=thin(r,50,6);

% Lets test how well the network works for test data. 
S = which('demo_rjmcmcgp');
L = strrep(S,'demo_rjmcmcgp.m','demos/synth.ts');
tx=load(L);
ty=tx(:,end);
L = strrep(S,'demo_rjmcmcgp.m','demos/synth2.ts');
tx=load(L);

tga=mean(logsig2(gp2fwds(r, x, r.latentValues', tx)),3);

% lets calculate the percentage of misclassified points
missed = sum(abs(round(tga)-ty))/size(ty,1)*100;

importance = sum(r.inputii)/size(r.inputii,1)
