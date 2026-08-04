function w = gp2pak(gp)
%GP2PAK	Combine GP hyper-parameters into one vector.
%
%	Description
%	HP = GP2PAK(GP) takes a Gaussian Process data structure GP and
%	combines the hyper-parameters into a single row vector HP.
%
%	The ordering of the parameters in HP is defined by
%	  hp = [gp.expScale gp.expSigmas gp.noiseSigmas];
%
%	See also
%	GP2, GP2UNPAK
%

% Copyright (c) 2000-2001 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

w=[];
gpp=gp.p;
i1=0;i2=1;
i1=i1+1;
w(i1)=gp.expScale;
if ~isempty(gpp.expSigmas.p)
  i1=i1+1;
  w(i1)=gpp.expSigmas.a.s;
  if any(strcmp(fieldnames(gpp.expSigmas.p),'nu'))
    i1=i1+1;
    w(i1)=gpp.expSigmas.a.nu;
  end
end
i2=i1+length(gp.expSigmas);
i1=i1+1;
w(i1:i2)=gp.expSigmas;
i1=i2;

if ~isempty(gp.noiseSigmas) & ~isempty(gpp.noiseSigmas)
  if ~isempty(gpp.noiseSigmas.p)
    if ~isempty(gpp.noiseSigmas.p.s.p)
      i1=i1+1;
      w(i1)=gpp.noiseSigmas.p.s.a.s;
    end
    i2=i1+length(gpp.noiseSigmas.a.s);
    i1=i1+1;
    w(i1:i2)=gpp.noiseSigmas.a.s;
    i1=i2;
    if any(strcmp(fieldnames(gpp.noiseSigmas.p),'nu'))
      if ~isempty(gpp.noiseSigmas.p.nu.p)
	i1=i1+1;
	w(i1)=gpp.noiseSigmas.p.nu.a.s;
      end
      i2=i1+length(gpp.noiseSigmas.a.nu);
      i1=i1+1;
      w(i1:i2)=gpp.noiseSigmas.a.nu;
      i1=i2;
    end
  end
  if isempty(gp.noiseVariances)
    i2=i1+length(gp.noiseSigmas);
    i1=i1+1;
    w(i1:i2)=gp.noiseSigmas;
  end
end
w = log(w);
