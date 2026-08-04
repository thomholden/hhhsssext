function [chmm,block]=varchmmdemos(varargin)
% Variational CHMM demos

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
    disp('VarCHMM Demo with Gaussian Observations and Gibbs Sampling');
    load chmmsim
    [chmm,block]=gibbschmm(data,plotflag);
   case 2
    disp('VarCHMM Demo with Gaussian Observations and Mean Field');
    load chmmsim
    [chmm,block]=mfchmm(data,plotflag);
   case 3
    disp('VarCHMM Demo with Gaussian Observations and Mean Field Chains');
    load chmmsim
    [chmm,block]=mfchainchmm(data,plotflag);
   case 4
    disp('VarCHMM Demo with Gaussian Observations and Forw/Back Inference');
    load chmmsim
    [chmm,block]=fwbwchmm(data,plotflag);
   case 5
    disp('Lagged VarCHMM Demo with Gaussian Observations and Gibbs Sampling');
    load demlag    % use the lag2 set
    [chmm]=lagchmm(data_constr13,'gibbs',plotflag);
   case 6
    disp('Lagged VarCHMM Demo with Gaussian Observations and Mean Field');
    load demlag    % use the lag2 set
    [chmm]=lagchmm(data_lag2,'meanfield',plotflag);
   case 7
    disp('Lagged VarCHMM Demo with Gaussian Observations and MeanF. Chains');
    load demlag    % use the lag2 set
    [chmm]=lagchmm(data_lag2,'meanfieldchains',plotflag);
% $$$    case 8
% $$$     disp('Lagged VarCHMM Demo with Gaussian Observations and ForwBack');
% $$$     load demlag    % use the lag2 set
% $$$     [chmm]=lagchmm(data_lag1,'forwback',plotflag);
  end
  disp(' ');
  disp(' ');
  disp('Press a key to continue');
  pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d]=requestdemo
% prompt user for demo number

disp('Variational CHMM Demos with  ');
disp('Gaussian Observation model and Hidden States Gibbs Sampling      [1]');
disp('Gaussian Observation model and Hidden States Mean Field          [2]');
disp('Gaussian Observation model and Mean Field of State Chain         [3]');
disp('Gaussian Observation model and Forward Backward on State Chain   [4]');
disp('Test for Optimal Lag using');
disp('  Gaussian Observation model and Hidden States Gibbs Sampling    [5]');
disp('  Gaussian Observation model and Hidden States Mean Field        [6]');
disp('  Gaussian Observation model and Mean Field of State Chain       [7]');
%disp('  Gaussian Observation model and Forward Backward on State Chain [8]');
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
function [chmm,block]=gibbschmm(data,plt)


% Generate two HMMs (one for each chain) for later initialisation

hmmx=VarHMM(2,data.Xseries,'Gauss');
hmmy=VarHMM(2,data.Yseries,'Gauss');

% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 -1;1 2];
LagOpSpec{2}=[-1 -1; 1 2];

% setup CHMM 
chmm=VarCHMM(LagOpSpec,{hmmx,hmmy});

% reduce training time
chmm=set(chmm,'train','cyc',10);

% reduce training sample
Xtrain={data.Xseries(1:128,:), data.Yseries(1:128,:)};

chmm=train(chmm,Xtrain);

% now find MAP distribution of State variables
[block]=decode(chmm,Xtrain);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [chmm,block]=mfchmm(data,plt)


% Generate two HMMs (one for each chain) for later initialisation

hmmx=VarHMM(2,data.Xseries,'Gauss');
hmmy=VarHMM(2,data.Yseries,'Gauss');

% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 -1;1 2];
LagOpSpec{2}=[-1 -1; 1 2];

% setup CHMM 
chmm=VarCHMM(LagOpSpec,{hmmx,hmmy},'meanfield');

% reduce training time
chmm=set(chmm,'train','cyc',10);

% reduce training sample
Xtrain={data.Xseries(1:128,:), data.Yseries(1:128,:)};

chmm=train(chmm,Xtrain);

% now find MAP distribution of State variables
[block]=decode(chmm,Xtrain);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [chmm,block]=mfchainchmm(data,plt)


% Generate two HMMs (one for each chain) for later initialisation

hmmx=VarHMM(2,data.Xseries,'Gauss');
hmmy=VarHMM(2,data.Yseries,'Gauss');

% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 -1;1 2];
LagOpSpec{2}=[-1 -1; 1 2];

% setup CHMM 
chmm=VarCHMM(LagOpSpec,{hmmx,hmmy},'meanfieldchains');

% reduce training time
chmm=set(chmm,'train','cyc',10);

% reduce training sample
Xtrain={data.Xseries(1:128,:), data.Yseries(1:128,:)};

chmm=train(chmm,Xtrain);

% now find MAP distribution of State variables
[block]=decode(chmm,Xtrain);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [chmm,block]=fwbwchmm(data,plt)


% Generate two HMMs (one for each chain) for later initialisation

hmmx=VarHMM(2,data.Xseries,'Gauss');
hmmy=VarHMM(2,data.Yseries,'Gauss');

% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 -1;1 2];
LagOpSpec{2}=[-1 -1; 1 2];

% setup CHMM 
chmm=VarCHMM(LagOpSpec,{hmmx,hmmy},'forwback');

% reduce training time
chmm=set(chmm,'train','cyc',10);

% reduce training sample
Xtrain={data.Xseries(1:128,:), data.Yseries(1:128,:)};

chmm=train(chmm,Xtrain);

% now find MAP distribution of State variables
[block]=decode(chmm,Xtrain);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [FrEn,chmmset]=lagchmm(data,method,plt)


% reduce training sample
Xtrain={data.Xseries(1:400,:), data.Yseries(1:400,:)};
% Generate two HMMs (one for each chain) for later initialisation

hmmx=VarHMM(3,Xtrain{1},'Gauss');
hmmy=VarHMM(2,Xtrain{2},'Gauss');
Xtrain={data.Xseries(1:40,:), data.Yseries(1:40,:)};
LagOpSpec{1}=[-1;1];  
LagOpSpec{2}=[-1;2];

% setup new CHMM 
chmm=VarCHMM(LagOpSpec,{hmmx,hmmy},method);

Lags=[0:4];
for l1=1:length(Lags),
    for l2=1:length(Lags),
        % 2 chains coupled symmetrically with selected delay
        if Lags(l1)==0
            LagOpSpec{1}=[-1;1];
        else
            LagOpSpec{1}=[-1 -Lags(l1);1 2];
        end
        if Lags(l2)==0,
            LagOpSpec{2}=[-1;2];
        else
            LagOpSpec{2}=[-Lags(l2) -1; 1 2];
        end
 	if chkcompat(chmm,LagOpSpec)
 	   chmm=chngtopo(chmm,LagOpSpec);
 	else
 	  % setup new CHMM as topology has changed significantly
 	  chmm=VarCHMM(LagOpSpec,{hmmx,hmmy},method);
 	end
	
	% reduce training time
	chmm=set(chmm,'train','cyc',30);
        chmm=set(chmm,'train','obsupdate',[0 0]);
        
        chmmset{l1,l2}=train(chmm,Xtrain);
        FrEn(l1,l2)=sum(get(chmmset{l1,l2},'train','FrEn'));
    end
end




