function [mTxP,L]=marginchain(LagOp,TxP,K,Gamma,pXi,t)
% integrate out parent and children influcences of neighbouring chains 
% and return effective 2-D state transition probability and likelihoods 
% for chain in question
%
% INPUT
% LagOp    LagOperator for topological calucations
% TxP      transition prob of each chain
% K        state space dimensions of chains
% Gamma    Marginal of hidden states
% t        time and chain index of current state
%
% OUTPUT
% mTxP     transition prob. after integarting out neighbouring chains
% L        likelihood messages from neighbouring chains
        
% current transition prob
curP=log(TxP{t.ch});		

% for this inference LagOp should be sorted with earliers lag to latest lag
% also need to ensure only 1 parent from same chain 
mbel=cell(get(LagOp,'MaxCha'),3);
parents=LagOp*t;	
for p=1:length(parents)
  % parent time/chain index
  pndx=parents{p};
  if pndx~=prevt(t);,			% parent of other chain?
    if isempty(mbel{pndx.ch,1})
      mbel{pndx.ch,1}=Gamma{pndx.tc};
    else
      tmpt=mbel{pndx.ch,3};
      tmpbel=eye(K(pndx.ch));
      while tmpt~=pndx
	tmpbel=cdiv(pXi{tmpt.tc},csum(pXi{tmpt.tc}))*tmpbel;
	tmpt=nextt(tmpt);
      end
      rv=[1,1,K(pndx.ch)*ones(1,myndims(mbel{pndx.ch,1})-1)];
      tmpbel=repmat(tmpbel,rv);
      mbel{pndx.ch,1}=mdvecprod(tmpbel,mbel{pndx.ch,1},[2:ndims(tmpbel)],0);
    end
    mbel{pndx.ch,3}=pndx;
    mbel{pndx.ch,2}=cat(2,mbel{pndx.ch,2},p+1);
  end
end


mbel=mbel(:,1:2);
pndxvec=[];
for bc=1:size(mbel,1),
  if ~isempty(mbel{bc,2}),
    tmpbel=mbel{bc,1};
    tmpbel=permute(tmpbel,ndims(tmpbel):-1:1);
    curP=mdvecprod(curP,mbel{bc,1},mbel{bc,2},0); 
    pndxvec=cat(2,pndxvec,mbel{bc,2});
  end
end					% parent loop
% now integrate out 
mTxP=exp(mdsum(curP,pndxvec));			



L=zeros(K(t.ch),1);			% Likelihoods of neighbours
children=inv(LagOp)*t;
for c=1:length(children),
    cndx=children{c};
    mbel=cell(get(LagOp,'MaxCha'),3);
    if cndx~=nextt(t);			% child of annother chain?
      cP=log(TxP{cndx.ch});		% transition prob to child
      childparents=LagOp*cndx;		% childrens' parents
      childparents{end+1}=cndx;		% add this child for processing
      for cp=1:length(childparents),
	  cpndx=childparents{cp};	% childrens' parents  time/chain index
	  if ~(cpndx.ch==t.ch),		% parent is current state chain
	    if isempty(mbel{cpndx.ch,1})
	      mbel{cpndx.ch,1}=Gamma{cpndx.tc};
	    else
	      tmpt=mbel{cpndx.ch,3};
	      tmpbel=eye(K(cpndx.ch));
	      while tmpt~=cpndx
		tmpbel=cdiv(pXi{tmpt.tc},csum(pXi{tmpt.tc}))*tmpbel;
		tmpt=nextt(tmpt);
	      end
	      rv=[1,1,K(cpndx.ch)*ones(1,myndims(mbel{cpndx.ch,1})-1)];
	      tmpbel=repmat(tmpbel,rv);
	      mbel{cpndx.ch,1}=mdvecprod(tmpbel,mbel{cpndx.ch,1},[2:ndims(tmpbel)],0);
	    end
	    mbel{cpndx.ch,3}=cpndx;
	    mbel{cpndx.ch,2}=cat(2,mbel{cpndx.ch,2},cp+1);
	  end				% end cpndx==t
      end				% end child-parent loop
      mbel{cpndx.ch,2}(end)=1;		% correct the very last assingment 
      mbel=mbel(:,1:2);
      cpndxvec=[];
      for bc=1:size(mbel,1),
	if ~isempty(mbel{bc,2}),
	  tmpbel=mbel{bc,1};
	  tmpbel=permute(tmpbel,ndims(tmpbel):-1:1);
	  cP=mdvecprod(cP,mbel{bc,1},mbel{bc,2},0); 
	  cpndxvec=cat(2,cpndxvec,mbel{bc,2});
	end
      end
      cP=mdsum(cP,cpndxvec);		% now integrate out
      L=L+reshape(cP,K(t.ch),1);
    end					% end cndx~=nextt(t)      
end					% end children loop
L=exp(L);

