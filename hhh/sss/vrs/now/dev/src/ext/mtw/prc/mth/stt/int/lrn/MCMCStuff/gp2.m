function gp = gp2(type, nin, varargin)
%GP2	Create a Gaussian Process.
%
%	Description
%
%	GP = GP2(TYPE, NIN, COVARFN...) takes the type and number of inputs NIN
%       for a  Gaussian Process model with a single output, together with a 
%	strings COVARFN which specifies the elements of the covariance 
%       function, and returns a data structure GP. 
%
%	The fields and initial values in GP are:
%	  type           = 'gp2r' or 'gp2b'
%	  nin            = number of inputs
%	  nout           = number of outputs: always 1
%	  jitterSigmas   = jitter term in covariance function
%                          0.1, if given a string 'jitter' in COVARFN
%	  expScale       = general scale for exponential part
%                          0.1, if given a string 'exp' in COVARFN
%	  expSigmas      = length scale for each input 
%                          0.1, if given a string 'exp' in COVARFN
%	  noiseSigmas    = scale of residual distribution
%                          standard deviation for normal distribution 
%                          Degrees of freedom for t-distribution
%         noiseVariances = variance of standard deviation in covariable 
%                          dependent groupped noise model
%         p              = prior structure containing the above fields for prior
%                          also.
%
%	See also
%	GPINIT, GP2PAK, GP2UNPAK
%
%

% Copyright (c) 1996,1997 Christopher M Bishop, Ian T Nabney
% Copyright (c) 1998,1999 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

gp.type = type;
gp.nin = nin;
gp.nout = 1;

gp.constSigmas=[];
gp.linearSigmas=[];
gp.jitterSigmas=[];
gp.expSigmas=[];
gp.expScale=[];
gp.noiseSigmas=[];
gp.noiseVariances=[];
for i = 1:length(varargin)
  switch varargin{i}
   case 'jitter'
    gp.jitterSigmas=0.1;
   case 'exp'
    gp.expScale=0.1;
    gp.expSigmas=0.1;
  end
end

gp.p=[];
gp.p.constSigmas=[];
gp.p.linearSigmas=[];
gp.p.linearSigmas=[];
gp.p.jitterSigmas=[];
gp.p.expSigmas=[];
gp.p.expScale=[];
gp.p.noiseSigmas=[];
gp.p.noiseVariances=[];
gp.p.r=[];
