% $$$  clear classes
% $$$  load demgauss
% $$$  data=[arp];
% $$$  
% $$$  T=length(data);
% $$$  K=2;
% $$$  
% $$$  % Train up GMM on this data
% $$$  hmm=VarHMM(K,data,'Gauss',struct('inftype','meanfield'));
% $$$  
% $$$  hmm=set(hmm,'train','cyc',30);
% $$$  
% $$$  hmm=train(hmm,data,T);
% $$$  
% $$$  return
 
clear classes
load demlag
data=data_lag2;
method='meanfield';

% Generate two HMMs (one for each chain) for later initialisation

hmmx=VarHMM(3,data.Xseries,'Gauss');
hmmx=train(hmmx,data.Xseries);
hmmy=VarHMM(2,data.Yseries,'Gauss');
hmmy=train(hmmy,data.Yseries);

Lags=[1:3]; N=1:40;
for l=1:length(Lags),
  % reduce training sample
  Xtrain={data.Xseries([N 1:Lags(l)],:)+...
	  0*randn(size(data.Xseries([N 1:Lags(l)],:))), ....
	  data.Yseries([N 1:Lags(l)],:)+...
	  0*randn(size(data.Yseries([N 1:Lags(l)],:)))};


% 2 chains coupled symmetrically with selected delay
  LagOpSpec{1}=[-1     -Lags(l)     ;1 2];
  LagOpSpec{2}=[ -1    -Lags(l)     ;2 1];

  % setup CHMM , one for each lag
  chmm{l}=VarCHMM(LagOpSpec,{hmmx,hmmy},method);
  
  % reduce training time
  chmm{l}=set(chmm{l},'train','cyc',30);
  obsupdate=get(chmm{l},'train','obsupdate');
  chmm{l}=set(chmm{l},'train','obsupdate',1*obsupdate);
  txupdate=get(chmm{l},'train','txupdate');
  chmm{l}=set(chmm{l},'train','txupdate',1*txupdate);

  [chmm2{l},FrEntrain]=train(chmm{l},Xtrain);

end;

return

tv=round(fliplr(logspace(1,1.5,length(Lags)-1)));
for t=tv;
  NumMod=length(chmm);		% how many models left?
  FrEn=zeros(1,NumMod);
  for l=1:NumMod,
    % set reduced training time
    chmm{l}=set(chmm{l},'train','cyc',t);
    % train for a few steps
    chmm{l}=train(chmm{l},Xtrain);
    FrEn(l)=sum(get(chmm{l},'train','FrEn'));
  end
  [FrEn,model]=sort(FrEn);
  chmmold=chmm;
  chmm=chmm(model(1:end-1));
end
% finish training the last one
chmm=train(chmm{1},Xtrain);
