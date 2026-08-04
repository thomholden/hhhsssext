function [chschain,Bcart]=nodemerge(chschain,B)
% Merge the hidden state nodes into a single chain to allow 
% running of forward backward routine 
% 
% Input
% B     Data likelihood
% Output
% P         merged transition probability
% Pi        merged initial state probability
% B         merged observation likelihoods
% K         merged state space dimension


C=chschain.NChains;
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
Pi=chschain.Pi;

T=length(B);				% size(B,1); State Chain length

% get MaxLag and MaxChain
MaxLag=get(LagOp,'MaxLag');
MaxCha=get(LagOp,'MaxCha');

% check for need to cluster
if C==1 & MaxLag==1,			% this is a standard HMM
  Bcart=cat(1,B{:});
  P=TxP{1};			% use to double
  Pi=Pi{1};
else					
  % cluster evidence nodes, ie likelihoods
  [Bcart]=joinlike(B,K,MaxLag,C);
  % cluster state transition probabilties : 
  % 1st augment to have same set of parents
  P=augtxp(TxP,K,LagOp);
  % 2nd merge current state nodes
  P=jointxp(P,K,MaxLag);	
  % 3rd make trans.prob square`
  P=reptxp(P);			
  % now merge initial state
  Pi=joininst(Pi,K,MaxLag);		
end


chschain.P=P';				% fwbw needs it this way
chschain.Pi=Pi(:)';			% fwbw needs it this way
chschain.LagOp=LagOperator;		% default is HMM
chschain.K=size(chschain.Pi,2);

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JOINLIKE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Bcart]=joinlike(B,K,MaxLag,C,lflag)
% combine likelihoods of the form P(X|S) and P(Y|R) to
% P(X,Y|S,R) for all time steps 

if nargin<5 | lfag==0,
    
  Bcart1=cat(1,B{:,1});
  sv=size(Bcart1);
  Bcart1=cat(1,Bcart1,repmat(Bcart1(end,:),MaxLag-rem(size(Bcart1,1),MaxLag),1));
  for rc=2:C,
    tmpB=cat(1,B{:,rc});
    tmpB=cat(1,tmpB,repmat(tmpB(end,:),MaxLag-rem(size(tmpB,1),MaxLag),1));
    tmpBcart=[];
    for k=1:K(rc)
      tmpBcart=cat(2,tmpBcart,repmat(tmpB(:,k),1,size(Bcart1,2)).*Bcart1);
    end
    Bcart1=tmpBcart;
  end
  
  
  Kcart=size(Bcart1,2);
  Bcart=Bcart1(MaxLag:MaxLag:end,:);
  for l=MaxLag-2:-1:0,
    tmpB=Bcart1(1+l:MaxLag:end,:);
    tmpBcart=[];
    for k=1:Kcart
      tmpBcart=cat(2,tmpBcart,repmat(tmpB(:,k),1,size(Bcart,2)).*Bcart);
    end
    Bcart=tmpBcart;
  end
  
  
else
  disp('Using Log');
  Bcart1=cat(1,B{:,1});
  sv=size(Bcart1);
  Bcart1=cat(1,Bcart1,repmat(Bcart1(end,:),MaxLag-rem(size(Bcart1,1),MaxLag),1));
  for rc=2:C,
    tmpB=cat(1,B{:,rc});
    tmpB=cat(1,tmpB,repmat(tmpB(end,:),MaxLag-rem(size(tmpB,1),MaxLag),1));
    tmpBcart=[];
    for k=1:K(rc)
      tmpBcart=cat(2,tmpBcart,repmat(tmpB(:,k),1,size(Bcart1,2))+Bcart1);
    end
    Bcart1=tmpBcart;
  end
  
  
  Kcart=size(Bcart1,2);
  Bcart=Bcart1(MaxLag:MaxLag:end,:);
  for l=MaxLag-2:-1:0,
    tmpB=Bcart1(1+l:MaxLag:end,:);
    tmpBcart=[];
    for k=1:Kcart
      tmpBcart=cat(2,tmpBcart,repmat(tmpB(:,k),1,size(Bcart,2))+Bcart);
    end
    Bcart=tmpBcart;
  end
  
end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AUGTXP  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P2]=augtxp(TxP,K,LagOp)
% augment the conditioning variables to include all variables upto MaxLag

% from somewhere I get MaxLag and MaxChain
MaxLag=get(LagOp,'MaxLag');
MaxCha=get(LagOp,'MaxCha');

rt=[MaxLag+1;1];
for rc=1:MaxCha,
  rt(2)=rc;
  % this K is the final K of clustered K
  repK=repmat(K(:),1,MaxLag);
  % get parents
  parents=LagOp.*rt;
  % reverse such that indeces begin @ t-1 and end @ t-MaxLag
  parents(1,:)=MaxLag-parents(1,:)+1;
  % flip such that chains increase first, then time
  tmp=num2cell(flipud(parents),2);
  % index of K which need not be repeated
  ndx= sub2ind([MaxCha,MaxLag],tmp{:});
  % mark as not to be repeated
  repK(ndx)=1;
  % first index is state of current time and chain
  repK=[1;repK(:)];
  % replicat and insert old transition P where K==1
  P2{rc}=frepmat(TxP{rc},repK);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JOINTXP  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Pcart]=jointxp(Parr,K,MaxLag)
% combine transition probabilities of the form P(A|C,D) and P(B|C,D) to
% P(A,B|C,D) 

C=length(Parr);

Pcart=Parr{1};
Pcart=reshape(Pcart,K(1),prod(K)^MaxLag);
for rc=2:C,
  P=reshape(Parr{rc},K(rc),prod(K)^MaxLag);
  tmpPcart=[];
  for k=1:K(rc),
    tmpPcart=cat(1,tmpPcart,repmat(P(k,:),size(Pcart,1),1).*Pcart);
  end
  Pcart=tmpPcart;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REPTXP  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Psq]=reptxp(P);
% repeatedly applies products of the from 
%     P(A|B,C,D) * P(B|C,D,E) 
% to give
%     P(A,B|C,D,E)
% until the transition probability is square

Psq=P;
while size(Psq,1)~=size(Psq,2),
 Psq=repmat(Psq,[1,1,size(P,1)]);
 sv=size(Psq);
 Psq=reshape(Psq,[sv(1), sv(3), sv(2)]);
 sv=size(Psq);
 for k=1:sv(2)
   Psq(:,k,:)=squeeze(Psq(:,k,:)).*repmat(P(k,:),sv(1),1);
 end
 Psq=reshape(Psq,sv(1)*sv(2),sv(3));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JOINPI  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Picart]=joininst(Piarr,K,MaxLag)
% combine intial state probabilities of the form P(A) and P(B) to
% P(A,B) 

C=length(Piarr);

tmpPicart=reshape(Piarr{1},K(1),1);
for rc=2:C,
  Pi=reshape(Piarr{rc},K(rc),1);
  tmpPicart=kron(Pi,tmpPicart);
end

Picart=tmpPicart;
for l=1:MaxLag-1
  Picart=kron(tmpPicart,Picart);
end


