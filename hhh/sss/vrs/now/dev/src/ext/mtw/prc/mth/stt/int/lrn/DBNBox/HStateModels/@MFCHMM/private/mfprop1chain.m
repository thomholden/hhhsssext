function [Gamma,Xi]=mfprop1chain(chschain,Gamma,Xi,B)
% The actual sampling of the chains using indiscrimant mean field assumption
%
% B     Data likelihood
% Gamma    Marginal of hidden states from previous iterations
% Xi       Pairwise marginal of states from previous iterations
%
% Output
%
% Gamma    Marginal of hidden states
% Xi       Pairwise marginal of states

C=chschain.NChains;
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
Pi=chschain.Pi;

T=length(B);				% size(B,1); State Chain length
Topo=[T,C];				% topology


%for ns=1:chschain.NSweep,		% number of sweeps
for ns=1:1
%  Gammat(:,1)=Gamma{1};
%  Gammat(:,T)=Gamma{T};
 for t=1:T,
   P=TxP{1};
   L=reshape(B{t},K(1),1);

   P2=mdvecprod(P,L,1,0);
   P3=zeros(K,K,K);
   P3(:,1,:)=P(:,1)*P2(1,:);
   P3(:,2,:)=P(:,2)*P2(2,:);
   P4=log(P3);
   if t==1,
     P4=mdvecprod(P4,((Gamma{T})),3,1);
   else
     P4=mdvecprod(P4,Gamma{t-1},3,1);
   end
   if t==T,
     P4=mdvecprod(P4,((Gamma{1})),1,1);
   else
     P4=mdvecprod(P4,Gamma{t+1},1,1);
   end
   Pjjj=exp(P4)./sum(exp(P4));
   Pjjj=Pjjj(:);
   
    P=log(TxP{1});
    
    L=reshape(B{t},K(1),1);	% likelihood;
    L=log(L);
    
    if t==1,
      Ppast=mdvecprod(P,((Gamma{T})),2,1);
%      Ppast=P*ones(size(Gamma{T}));
    else
      Ppast=mdvecprod(P,Gamma{t-1},2,1);
%      Ppast=P*Gamma{t-1};
    end
    Ppast=reshape(Ppast,K(1),1);

    if t==T,
      cP=mdvecprod(P,Gamma{1},1,1);
%      cP=ones(size(Gamma{1}))'*P;
    else
      cP=mdvecprod(P,Gamma{t+1},1,1);
%      cP=Gamma{t+1}'*P;
    end

    Pfut=reshape(cP,K(1),1);

    Pj=exp(Ppast+Pfut+L);		% combine past with future
    Pj=Pj./sum(Pj);			% renormalise
 
     Pv=(Ppast+Pfut+L);
     Pjj=1./sum(exp(genkron(Pv,Pv','-')),1)';

    Gammat(:,t)=Pjj;
    
    Gamma{t}=Pjj;			% mean field marginal
 end
 Entr(ns)=Gammat(:)'*log(Gammat(:));
% disp(sprintf('Entr=%f',Entr(ns)))
 if ns>2
   if Entr(ns)-Entr(ns-1)>0
     disp('+')
   else
     disp('-');
   end
 end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P]=mdvecprod(P,Pi,Dim,mflag);
% [P]=mdvecprod(P,Pi,Dim,mflag);
%
% multiply a MD array by a vector along dimension Dim  
% with optional marginalisation over dimension Dim


sv=size(P);
p=reshape(1:prod(size(P)),size(P));

pv1=setdiff(1:ndims(P),Dim);
pv2=Dim;
pv=[pv1 pv2];
pp=permute(p,pv);
ppp=reshape(pp,prod(sv(pv1)),prod(sv(pv2)));
P(ppp)=P(ppp).*repmat(Pi(:)',size(ppp,1),1);

%and if marginal
if nargin<4 | mflag,
  P=squeeze(sum(P,Dim));
end

