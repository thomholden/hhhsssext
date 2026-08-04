function gp = gp2unpak(gp, w)
%GP2UNPAK Separate GP hyper-parameter vector into components. 
%
%	Description
%	GP = GP2UNPAK(GP, HP) takes an Gaussian Process data structure GP
%	and  a hyper-parameter vector HP, and returns a Gaussian Process data
%	structure  identical to the input model, except that the covariance
%	hyper-parameters has been set to the of HP.
%
%	See also
%	GP2, GP2PAK
%

% Copyright (c) 2000-2001 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

nin = gp.nin;
nout = gp.nout;

w(w<-10)=-10;
w(w>10)=10;
w=exp(w);

gpp=gp.p;
i1=0;i2=1;
i1=i1+1;
gp.expScale=w(i1);
if ~isempty(gpp.expSigmas.p)
  i1=i1+1;
  gp.p.expSigmas.a.s=w(i1);
  if any(strcmp(fieldnames(gpp.expSigmas.p),'nu'))
    i1=i1+1;
    gp.p.expSigmas.a.nu=w(i1);
  end
end
i2=i1+length(gp.expSigmas);
i1=i1+1;
gp.expSigmas=w(i1:i2);
i1=i2;

if ~isempty(gp.noiseSigmas) & ~isempty(gpp.noiseSigmas)
  if ~isempty(gpp.noiseSigmas.p)
    if ~isempty(gpp.noiseSigmas.p.s.p)
      i1=i1+1;
      gp.p.noiseSigmas.p.s.a.s=w(i1);
    end
    i2=i1+length(gpp.noiseSigmas.a.s);
    i1=i1+1;
    gp.p.noiseSigmas.a.s=w(i1:i2);
    i1=i2;
    if any(strcmp(fieldnames(gpp.noiseSigmas.p),'nu'))
      if ~isempty(gpp.noiseSigmas.p.nu.p)
	i1=i1+1;
	gp.p.noiseSigmas.p.nu.a.s=w(i1);
      end
      i2=i1+length(gpp.noiseSigmas.a.nu);
      i1=i1+1;
      gp.p.noiseSigmas.a.nu=w(i1:i2);
      i1=i2;
    end
  end
  if isempty(gp.noiseVariances)
    i2=i1+length(gp.noiseSigmas);
    i1=i1+1;
    gp.noiseSigmas=w(i1:i2);
  end
end
