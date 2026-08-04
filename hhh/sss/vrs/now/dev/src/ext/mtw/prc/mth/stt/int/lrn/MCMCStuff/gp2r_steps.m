function ss = gp2r_steps(gp, x, y)
%GP2R_STEPS Calculate heuristic stepsizes for Gaussian Process
%
%	Description
%	S = GP2R_STEPS(GP, X, Y) takes a gp data structure GP
%	together with a matrix X of input vectors and a matrix T of
%       target vectors and calculates heuristic stepsizes S.
%
%	See also
%	GP2
%

% Copyright (c) 1999-2000 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

N=length(x);
nin=gp.nin;
nout=gp.nout;

% Basic stepsize
gp=gp2unpak(gp,repmat(0.1,size(gp2pak(gp))));

gpp=gp.p;
% Scale down some stepsizes (see Neal:1997a pp. 15-16)
if ~isempty(gp.linearSigmas) & ~isempty(gpp.linearSigmas) ...
      & ~isempty(gpp.linearSigmas.p)
  if isfield(gp,'linearii')
    gp.p.linearSigmas.a.s=exp(0.1/sqrt(length(gp.linearSigmas(gp.linearii))));
  else
    gp.p.linearSigmas.a.s=exp(0.1/sqrt(length(gp.linearSigmas)));
  end
end

if ~isempty(gp.jitterSigmas) & ~isempty(gpp.jitterSigmas)
  gp.jitterSigmas=exp(0.5/sqrt(N*nout+1));
  w(1)=[];
end

if ~isempty(gp.expSigmas) & ~isempty(gpp.expSigmas) & ~isempty(gpp.expSigmas.p)
    gp.p.expSigmas.a.s=exp(0.1/sqrt(length(gp.expSigmas)));
end

if ~isempty(gp.noiseSigmas) & ~isempty(gpp.noiseSigmas)
  if isempty(gp.noiseVariances)
    gp.noiseSigmas=exp(0.5/sqrt(N+1));
  else
    if ~isempty(gpp.noiseSigmas.p)
      if ~isempty(gpp.noiseSigmas.p.s.p)
	gp.p.noiseSigmas.p.s.a.s=exp(0.1/sqrt(length(gp.p.noiseSigmas.a.s)));
      end
      if length(gp.p.noiseSigmas.a.s) == 1
	gp.p.noiseSigmas.a.s=exp(0.5/sqrt(N+1));
      elseif any(strcmp(fieldnames(gpp.noiseSigmas.a),'ii'))
	ii=gp.p.noiseSigmas.a.ii;
	for i=1:length(ii)
	  gp.p.noiseSigmas.a.s(i)=exp(0.3/sqrt(length(ii{i})+1));
	end
      else
	gp.p.noiseSigmas.a.s(:)=exp(0.1/sqrt(N+1));
      end
      if any(strcmp(fieldnames(gpp.noiseSigmas.p),'nu'))
	if ~isempty(gpp.noiseSigmas.p.nu.p)
	  gp.p.noiseSigmas.p.nu.a.s=...
	      exp(0.1/sqrt(length(gp.p.noiseSigmas.a.nu)));
	end
	if length(gp.p.noiseSigmas.a.s) == 1
	  gp.p.noiseSigmas.a.nu=exp(0.1);
	elseif any(strcmp(fieldnames(gp.p.noiseSigmas.a),'ii'))
	  ii=gp.p.noiseSigmas.a.ii;
	  for i=1:length(ii)
	    gp.p.noiseSigmas.a.nu(i)=exp(0.1);
	  end
	else
	  gp.p.noiseSigmas.a.nu(:)=exp(0.1);
	end
      end
    end
  end
end

ss=gp2pak(gp);
