function opt = mlp2b_mcopt(opt);
% MLP2B_MCOPT  Default options for MLP2B_MC
%
%   Description
%   OPT = MLP2B_MCOPT(OPT) takes an options structure OPT and
%   returns an options structure identical to the input except that
%   nonexisting fields in input are set to default.
%
%   Default options are:
%   nsamples = 1
%   repeat   = 1
%   display  = 1
%   plot     = 1
%   gibbs    = 0
%   hmc_opt  = hmc2_opt
%     hmc_opt.stepsf  = 'mlp2b_steps'
%   persistence_reset = 0
%
%   The option values represent the following characteristics. 
%   nsamples         - the number of samples saved.
%   repeat           - how many times the HMC and Gibbs sampling
%                      is repeated between two saved samples. 
%   display          - information about the sampling process is printed
%                      on the screen with value 1 and not printed with 0. 
%   hmc2_opt         - is the name of the function used to initialize the
%                      hybrid Monte Carlo sampling options 
%   hmc_opt.stepsf   - a function to determine the heuristic step sizes
%                      for HMC. 
%  persistence_reset - resets the persistence after every
%                      repeat iteration. The persistence is reset when 
%                      the value is 1. This can be used to reduce
%                      the excess energy in the early phase of sampling.

% Copyright (c) 1999 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

if nargin < 1
  opt=[];
end

if ~isfield(opt,'nsamples') | opt.nsamples < 1
  opt.nsamples=1;
end
if ~isfield(opt,'repeat') | opt.repeat < 1
  opt.repeat=1;
end
if ~isfield(opt,'display')
  opt.display=1;
end
if ~isfield(opt,'plot')
  opt.plot=1;
end
if ~isfield(opt,'gibbs')
  opt.gibbs=0;
end
if ~isfield(opt,'hmc_opt')
  opt.hmc_opt=hmc2_opt;
  opt.hmc_opt.stepsf='mlp2b_steps';
end
if ~isfield(opt,'persistence_reset')
  opt.persistence_reset=0;
end
