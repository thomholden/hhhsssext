clear classes

load demlagtest
% Generate two HMMs (one for each chain) for later initialisation

Xtrain={data_constr13.Xseries(1:end,:);data_constr13.Yseries(1:end,:)};

hmmx=VarHMM(3,Xtrain{1},'Gauss');
hmmy=VarHMM(2,Xtrain{2},'Gauss');

Xtrain={data_constr13.Xseries(901:980,:);data_constr13.Yseries(901:980,:)};

% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 -1;1 2];
LagOpSpec{2}=[-1 -3;2 1];

% setup CHMM 
chmm1=VarCHMM(LagOpSpec,{hmmx,hmmy},'meanfield');

% reduce training time
chmm1=set(chmm1,'train','cyc',40);
chmm1=set(chmm1,'train','obsupdate',[0 0]);

chmm1=train(chmm1,Xtrain);


% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 -3;1 2];
LagOpSpec{2}=[-1 -1;2 1];

% setup CHMM 
chmm2=VarCHMM(LagOpSpec,{hmmx,hmmy},'meanfield');

% reduce training time
chmm2=set(chmm2,'train','cyc',40);
chmm2=set(chmm2,'train','obsupdate',[0 0]);

chmm2=train(chmm2,Xtrain);

% 2 chains coupled symmetrically with 1 sample delay
LagOpSpec{1}=[-1 ;1];
LagOpSpec{2}=[-1 ;2];

% setup CHMM 
chmm3=VarCHMM(LagOpSpec,{hmmx,hmmy},'meanfield');

% reduce training time
chmm3=set(chmm3,'train','cyc',40);
chmm3=set(chmm3,'train','obsupdate',[0 0]);

chmm3=train(chmm3,Xtrain);

