%clear all
N=1024;
  simchmmconstr.chains{1}.K=2;
  simchmmconstr.chains{2}.K=3;
  simchmmconstr.chains{1}.Lags=1;
  simchmmconstr.chains{2}.Lags=3;
  simchmmconstr.chains{1}.Pi=[1/4 2/4 1/3];
  simchmmconstr.chains{2}.Pi=[1/2 1/2];
  simchmmconstr.chains{1}.P(:,:,1)=...
      [0.7 0.15 0.15 ; 0.15 0.7  0.15 ; 0.15 0.15 0.7];
  simchmmconstr.chains{1}.P(:,:,2)=...
      [0.7 0.15 0.15 ; 0.15 0.7  0.15 ; 0.15 0.15 0.7];
%  simchmmconstr.chains{1}.P(:,:,2)=...
%      [0.8  0.1  .1 ; 0.1   0.8 .1 ; 0.1 .1  .8];
%  simchmmconstr.chains{2}.P(:,:,1)=[0.7  0.6  0.55; 0.3 0.4  0.45];
%  simchmmconstr.chains{2}.P(:,:,2)=[0.3  0.4  0.45 ;0.7 0.6  0.55];
  simchmmconstr.chains{2}.P(:,:,1)=[0.7  0.7  0.7 ; 0.3 0.3  0.3 ];
  simchmmconstr.chains{2}.P(:,:,2)=[0.3  0.3  0.3 ; 0.7 0.7  0.7 ];
  simchmmconstr.chains{1}.obsmodel='Gauss'; 
  simchmmconstr.chains{1}.state(1).Mu=[-5;-5]; 
  simchmmconstr.chains{1}.state(2).Mu=[0;0];
  simchmmconstr.chains{1}.state(3).Mu=[5;5];
  simchmmconstr.chains{1}.state(1).Cov=diag([2 2]);
  simchmmconstr.chains{1}.state(2).Cov=diag([1 1]);
  simchmmconstr.chains{1}.state(3).Cov=diag([1.5 1.5]);
  simchmmconstr.chains{2}.obsmodel='Gauss'; 
  simchmmconstr.chains{2}.state(1).Mu=[0;0];
  simchmmconstr.chains{2}.state(2).Mu=[5;5];   
  simchmmconstr.chains{2}.state(1).Cov=diag([1 1]);
  simchmmconstr.chains{2}.state(2).Cov=diag([2 2]);
  [data_constr13] = chmmsim (simchmmconstr,N);

  save demlagtest