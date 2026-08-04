function Y = gp2fwds(gp, TX, TY, X)
%GP2FWDS	Forward propagation through Gaussian Processes.
%
%	Description
%	Y = GP2FWDS(GP, TX, TY, X) takes a Gaussian processes data structure GP
%       together with a matrix X of input vectors, matrix TX of training inputs 
%       and vector TY of training targets, and forward propagates the inputs 
%       through the Gaussian processes to generate a vector Y of outputs.
%       TX is of size MxN and TY is size Mx1. Each row of X corresponds to one
%       input vector and each row of Y corresponds to one output vector. 
%       
%       LATENT VALUES
%       TY can be also matrix of latent values in which case it is of size MxNMC. 
%       In this case TY is handled as all the other sampled parameters.
%
%       BUGS: - only exp2 covariance function is supported
%             - only 1 output allowed
%             - only mean values
%
%	See also
%	GP2, GP2PAK, GP2UNPAK

% Copyright (c) 1999 Simo Särkkä
% Copyright (c) 2000-2003 Aki Vehtari

% The original code of fbmgppred in fbmtools was modified 2004 by 
% Jarno Vanhatalo to be compatible with mcmcstuff toolbox.

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.


if nargin < 4
  error('Requires at least 4 arguments');
end

nin  = gp.numInputs;
nout = gp.numOutputs;

Gp=gp2('gp2r',nin);
nmc=size(gp.rejects,1);
if isfield(gp,'constSigmas');
  constSigmas=gp.constSigmas;else;constSigmas=[];
end
if isfield(gp,'linearSigmas');
  linearSigmas=gp.linearSigmas;else;linearSigmas=[];
end
if isfield(gp,'linearii');
  linearii=gp.linearii;else;linearii=[];
end
if isfield(gp,'expScale');
  expScale=gp.expScale;else;expScale=[];
end
if isfield(gp,'expSigmas');
  expSigmas=gp.expSigmas;else;expSigmas=[];
end
if isfield(gp,'expii');
  expii=gp.expii;else;expii=[];
end
if isfield(gp,'jitterSigmas');
  jitterSigmas=gp.jitterSigmas;else;jitterSigmas=[];
end
if isfield(gp,'noiseSigmas');
  noiseSigmas=gp.noiseSigmas;else;noiseSigmas=[];
end
if isfield(gp,'noiseVariances');
  noiseVariances=gp.noiseVariances;else;noiseVariances=[];
end
n=size(TX,1);
n2=size(X,1);
Y = zeros(size(X,1),nout,nmc);
count = 1;
Gp.constSigmas=[];
Gp.linearSigmas=[];
Gp.expScale=[];
Gp.expSigmas=[];

% loop over all samples
for i1=1:nmc
  
  if ~isempty(constSigmas); Gp.constSigmas=constSigmas(i1); end
  if ~isempty(linearSigmas); Gp.linearSigmas=linearSigmas(i1,:); end
  if ~isempty(expScale); Gp.expScale=expScale(i1); end
  if ~isempty(expSigmas); Gp.expSigmas=expSigmas(i1,:); end
  if ~isempty(expii); Gp.expii=expii(i1,:); end
  if ~isempty(jitterSigmas); Gp.jitterSigmas=jitterSigmas(i1,:); end
  if ~isempty(noiseSigmas); Gp.noiseSigmas=noiseSigmas(i1,:); end
  if ~isempty(noiseVariances); Gp.noiseVariances=noiseVariances(i1,:); end
  C=gptrcov(Gp, TX);
  
  K=gpcov(Gp, TX, X);
  
  % This is used only in the case of latent values. 
  if size(TY,2)>1
    y=K'*(C\TY(:,i1));
  else    % Here latent values are not present
    y=K'*(C\TY);
  end
  
  Y(:,:,count) = y;
  count = count+1;
end
