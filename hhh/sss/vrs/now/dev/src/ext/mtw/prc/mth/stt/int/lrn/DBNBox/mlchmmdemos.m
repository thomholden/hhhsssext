function [chmm,block]=mlchmmdemos(varargin)
% Maximum Likelihood CHMM demos

plotflag=1;				% verbose flag/set to 0 if testing
justonce=0;				% if args then only 1 demo
while ~justonce
  noarg=isempty(varargin);
  if noarg
    [d]=requestdemo;
    justonce=0;				% loop forever
  else
    d=varargin{1};
    justonce=1;				% argument given - just once
  end
  if isempty(d)
    return;
  end
  switch d
   case 1
    disp('MaLikCHMM Demo with Gaussian Observations and Mean Field');
    load chmmsim
    [chmm,block]=mfchmm(data,plotflag);
  end
  disp(' ');
  disp(' ');
  disp('Press a key to continue');
  pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d]=requestdemo
% prompt user for demo number

disp('Maximum Likelihood CHMM Demos with  ');
disp('Gaussian Observation model and Hidden States Mean Field          [1]');
disp(' ');
disp('Quit                                         [q/x]');
disp(' ');
d=[];
while isempty(d)
  d=input('Enter Demo number:     ','s');
end
d=str2num(d);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [chmm,block]=mfchmm(data,plt)


% Generate two HMMs (one for each chain) for later initialisation

hmmx=MaLikHMM(2,data.Xseries,'Gauss');
hmmy=MaLikHMM(2,data.Yseries,'Gauss');

% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 -1;1 2];
LagOpSpec{2}=[-1 -1; 1 2];

% setup CHMM 
chmm=MaLikCHMM(LagOpSpec,{hmmx,hmmy},'meanfield');

% reduce training time
chmm=set(chmm,'train','cyc',10);

% reduce training sample
Xtrain={data.Xseries(1:128,:), data.Yseries(1:128,:)};

chmm=train(chmm,Xtrain);

% now find MAP distribution of State variables
[block]=decode(chmm,Xtrain);


