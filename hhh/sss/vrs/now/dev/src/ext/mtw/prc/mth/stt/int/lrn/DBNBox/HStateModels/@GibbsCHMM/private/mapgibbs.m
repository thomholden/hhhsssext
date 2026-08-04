function [S]=mapgibbs(chschain,B,S)
% The actual sampling of the chains using indiscrimant map gibbs sampler
%
% B     Data likelihood
% S     Draw from State space chain
%
% Output
% S     MAP Draw from State space chain
% Output

C=chschain.NChains;
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
Pi=chschain.Pi;

T=length(B);				% size(B,1); State Chain length
Topo=[T,C];				% topology

M=10;                        % number of draws per iteration;


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
        [Ppast,subpndx]=submdsel(P,pndxvec,pndxvalvec);
        Pfut=L;			% P(obs|S)
        
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
            Pfut=Pfut.*reshape(submdsel(P,cndxvec,cndxvalvec),K(t.ch),1);
        end
        condP=Ppast.*Pfut;
        condP=condP./sum(condP);		
        % draw a set of rand samples
        Ssampl=multinomrnd(condP,M,1);
        % in each draw find the state==1
        [Ssamplndx,Junk]=ind2sub(size(Ssampl),find(Ssampl==1));
        % which draw increased the prob
        Ssamplndx=find(condP(Ssamplndx)>condP(S(t.tc)));
        if ~isempty(Ssamplndx)
            S(t.tc)=Ssamplndx(1);	% store state space variable if increased prob
        end 
        t=next(t);				% who's next?
    end
end
disp('Warning: Maximum Number of iterations exceeded in MAPGIBBS');
