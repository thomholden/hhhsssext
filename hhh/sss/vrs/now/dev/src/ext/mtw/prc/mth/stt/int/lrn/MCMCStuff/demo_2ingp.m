function demo_2ingp
%DEMO_2INGP    Regression problem demonstration for 2-input 
%              function with Gaussian process
%
%    Description
%    The problem consist of a data with two input variables
%    and one output variable with Gaussian noise. 
%

% Copyright (c) 2005 Jarno Vanhatalo, Aki Vehtari 

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.


% Load the data.
S = which('demo_2ingp');
L = strrep(S,'demo_2ingp.m','demos/dat.1');
data=load(L);
x = [data(:,1) data(:,2)];
y = data(:,3);

% Draw the data.
figure
title({'The noisy teaching data'});
[xi,yi,zi]=griddata(data(:,1),data(:,2),data(:,3),-1.8:0.01:1.8,[-1.8:0.01:1.8]');
mesh(xi,yi,zi)

% Create a Gaussian process for regression model. 
[n, nin] = size(x);
gp=gp2('gp2r',nin,'exp');
gp.jitterSigmas=0.01;
gp.expScale=0.2;
gp.expSigmas=repmat(0.1,1,gp.nin);
gp.noiseSigmas=0.2;
gp.f='norm';
                                                                                
gp.p.expSigmas=invgam_p({0.1 0.5 0.05 1});
gp.p.expScale=invgam_p({0.05 0.5});
gp.p.noiseSigmas=invgam_p({0.05 0.5});

opt=gp2_mcopt;
opt.repeat=20;
opt.nsamples=1;
opt.hmc_opt.steps=20;
opt.hmc_opt.stepadj=0.1;
opt.hmc_opt.nsamples=1;
hmc2('state', sum(100*clock));

[r,g,rstate1]=gp2r_mc(opt, gp, x, y);
                                                                                
opt.repeat=10;
opt.hmc_opt.steps=30;
opt.hmc_opt.stepadj=0.3;
[r,g,rstate2]=gp2r_mc(opt, g, x, y, [], [], r, rstate1);
                                                                                
opt.nsamples=350;
opt.hmc_opt.persistence=1;
opt.sample_variances=0;
opt.hmc_opt.window=5;
rstate=rstate2;
opt.hmc_opt.stepadj=0.75;
opt.hmc_opt.steps=10;
[r,g,rstate]=gp2r_mc(opt, g, x, y, [], [], r, rstate2);

% Create new data with the right scale checked above
figure
[p1,p2]=meshgrid(-1.8:0.05:1.8,-1.8:0.05:1.8);
p=[p1(:) p2(:)];
gp=thin(r,50,2);
out=gp2fwds(gp, x, y, p);
mout = mean(squeeze(out)');

%Plot the new data
gp=zeros(size(p1));
gp(:)=mout;
mesh(p1,p2,gp);
axis on;
