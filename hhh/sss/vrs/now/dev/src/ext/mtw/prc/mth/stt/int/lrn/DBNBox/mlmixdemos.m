function [mix,block]=mlmixdemos(varargin)
% Maximum Likelihood Mixture Model demos

plotflag=0;				% verbose flag/set to 0 if testing
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
    load demgauss
    [mix,block]=mlgaussdemo(arp,plotflag);
  end
  disp(' ');
  disp(' ');
  disp('Press a key to continue');
  pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d]=requestdemo
% prompt user for demo number

disp('Maximum Likelihood Mixture Model Demos with  ');
disp('Gaussian Mixture Model                                   [1]');
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix,block]=mlgaussdemo(data,plt)
% A demonstration of the MIX software using a Gaussian observation
% model on AR features 

T=length(data);
K=2;

% X   original time series
% data AR(4) features

if plt
  plot(data);
  title('Training Data');
  disp('The data consists of AR-4 features. They were extracted');
  disp('from the original data which had ad middle section with');
  disp('mainly 10Hz activity wheras the beginning and end');
  disp('sections were just noise.');
  disp(' ');
  disp('We will train a  Gaussian Mixture Model on the AR-4 features');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Train up GMM on this data
mix=MaLikMixM(K,data,'Gauss');

if plt
  disp('Means of MIX initialisation');
  getobspar(mix,1,'Mu');
  getobspar(mix,2,'Mu');

  % Train up Mixture model on observation sequence data using EM
  disp('We will now train the Mixture Model using EM');
  disp(' ');
  disp('Press a key to continue');
  pause
  disp('Estimated Model');
end

mix=set(mix,'train','cyc',30);

mix=train(mix,data,T);

if plt
  disp('Means');
  getobspar(mix,1,'Mu')
  getobspar(mix,2,'Mu')
  disp('Component Probabilities, Pi');
  gettxpar(mix,'Pi')
end

[block]=decode(mix,data,T);

if plt
  % Find most likely hidden state 
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
end
% ml gauss demo

