function [Gamma,Xi,S]=gibbs(chschain,B,S)
% The actual sampling of the chains using indiscrimant gibbs sampler
%
% B     Data likelihood
% S     Draw from State space chain
%
% Output
% Gamma    Marginal of hidden states
% Xi       Pairwise marginal of states
% S     Draw from State space chain

C=chschain.NChains;
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
Pi=chschain.Pi;

T=length(B);				% size(B,1); State Chain length
Topo=[T,C];				% topology


Gamma=cell(Topo);			% marginals
Xi=cell(Topo);				% joint marginals

for c=1:C,				% initialise
  zeroarray=zeros(K(c),1);
  Gamma(:,c)=repmat({zeroarray},T,1);
  zeroarray=zeros([K(c),K(chschain.LagOpSpec{c}(2,:))]);
  Xi(:,c)=repmat({zeroarray},T,1);
end

%%%%% Now the sampler
% Description: t is a cyclic index, i.e. it implements cyclic boundary
% conditions , so that a neg. time index t are mapped to postitive T-t 
% LagOp is used to calculate indeces of markov blanket (MB)
% the values of the MB state space variables are used to construct an
% evaluation string to pick the right array elements.
% The  probabability conditional on the MB is calcuated, samples drawn 
% and added to state space marginals and joint marginals

% Note, the sampler assumes  transition probabilites which don't change
% dimensionality, so TxP below is only selected for each chain. Allowing for
% separate initial state probabilites needs SpaceTime indeces to be linear 
% and more changes to core

t=SpaceTime(T,C,'Tcyclic');		% generic cycular index
for ns=1:chschain.NSamp,		% number of sampling sweeps
    t=reset(t);				% reset to beginning;
    while ~ending(t),			% loop until 1 sweep over T&C completed
        P=TxP{t.ch};
        L=reshape(B{t.tc},K(t.ch),1);	% likelihood;
        parents=LagOp*t;			% get parents

        pndxvec=[];                         % parent indeces 
        pndxvalvec=[];                      % value of indeces which to select
        for p=1:length(parents),
            pndx=parents{p};			% parent time/chain index
            pndxvec=cat(2,pndxvec,p+1);
            pndxvalvec=cat(2,pndxvalvec,S(pndx.tc));
        end
        [condPpast,subpndx]=submdsel(P,pndxvec,pndxvalvec);
        condPfut=L;			              % P(obs|S)
        
        % now the children and children's pare
        children=inv(LagOp)*t;
        for c=1:length(children),
            cndx=children{c};
            P=TxP{cndx.ch};			% transition prob to child
            childparents=LagOp*cndx;		% childrens' parents
            
            cndxvec=[1];                         % child indeces 
            cndxvalvec=[S(cndx.tc)];		% value of indeces which to select
            for cp=1:length(childparents),
                cpndx=childparents{cp};		% childrens' parents  time/chain index
                if cpndx~=t,			% parent is current state
                    cndxvec=cat(2,cndxvec,cp+1);
                    cndxvalvec=cat(2,cndxvalvec,S(cpndx.tc));
                end
            end
            condPfut=condPfut.*reshape(submdsel(P,cndxvec,cndxvalvec),K(t.ch),1);
        end
        condP=condPpast.*condPfut;    % combine past with future to give present
        condP=condP./sum(condP);		% renormalise
        Ssampl=multinomrnd(condP,1,1);	% draw a rand sample
        if all(Ssampl==0) | all(Ssampl==1)
            warning('Ambigous draw for Hidden State variable');
        end
        Ssamplndx=find(Ssampl==1);		% get its index
        S(t.tc)=Ssamplndx;			% store state space variable
        if  chschain.NSamp>chschain.NSampBurnin
            Gamma{t.tc}=Gamma{t.tc}+Ssampl./chschain.NSamp; % add one count
            xi=Xi{t.tc};			% for clearer eval str use temp
            xi(subpndx)=xi(subpndx)+Ssampl/chschain.NSamp;
            Xi{t.tc}=xi;			% restore temp
        end;
        t=next(t);				% who's next?
    end
end

