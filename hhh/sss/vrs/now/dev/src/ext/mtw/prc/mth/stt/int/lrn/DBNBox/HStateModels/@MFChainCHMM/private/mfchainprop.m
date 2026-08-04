function [Gamma,Xi,pXi]=mfchainprop(chschain,Gamma,Xi,pXi,B)
% The actual sampling of the chains using indiscrimant mean field assumption
%
% B     Data likelihood
% Gamma    Marginal of hidden states
% Xi       clique-wise marginal of states
% pXi      pair-wise marginal of states
%
% Output
%
% Gamma    Marginal of hidden states
% Xi       clique-wise marginal of states
% pXi      Pairwise marginal of states

C=chschain.NChains;
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
Pi=chschain.Pi;

T=length(B);				% size(B,1); State Chain length
Topo=[T,C];				% topology

%%%%% Now the propagation
% Description: t is a cyclic index, i.e. it implements cyclic boundary
% conditions , so that a neg. time index t are mapped to postitive T-t 
% LagOp is used to calculate indeces of markov blanket (MB)
% the values of the MB state space variables are used to construct an
% evaluation string to pick the right array elements.
% The  state transition probabability is computed by integrating out all
% parent influences resulting from neighbouring chains. All children to 
% current state, apart from its native child (ie same chain, next time step), 
% are integrated out and effectively act like additional likelihoods. These
% are then combined with the observation likelhood. After integrating out 
% only one step of the forward iteration is performed as new integrating out
% needs to be done at the next step.


% generic curcluar index which increments chains first
t=SpaceTime(T,C,'Ccyclic');
% number of sweeps


for ns=1:chschain.NSweep,		
    % reset to beginning;
    t=reset(t);				
    % loop until 1 complete sweep over T-by-C
    while ~ending(t),
        
        % integrate out neighbouring chains first
        [curP,curL]=marginchain(LagOp,TxP,K,Gamma,pXi,t);
        % combine with last piece of evidence
        curL=curL.*reshape(B{t.tc},K(t.ch),1);	% give total likelihood;
        
        %  Forward itertions
        if t.ti==1,
            alpha{t.tc}=reshape(Pi{t.ch},K(t.ch),1).*curL;
            scale(t.tc)=sum(alpha{t.tc});
        else
            pt=prevt(t);		% previous time step/same chain
            tmpalpha=curL.*(curP*alpha{pt.tc});
            scale(t.tc)=sum(tmpalpha(:));% P(X_i | X_1 ... X_{i-1})
            alpha{t.tc}=tmpalpha(:)/scale(t.tc);
        end
        if scale(t.tc)==0,
	  estr='Normalisation constant at iteration %d/%d is zero';
            error(sprintf(estr',t.ti,t.ch));
        end
        P{t.tc}=curP;			% keep for backward iterations
        L{t.tc}=curL;           	% keep likelihoods 
        t=next(t);			% who's next?
    end					% while ~ending(t)

    % 
    t=reset(t);
    t=max(t);				% start at end
    
    % loop until 1 complete sweep over T-by-C
    while ~ending(t),	
        % current transition prob
        curP=P{t.tc};		
        % next time step/same chain
        nt=nextt(t);			
        % likelihood
        curL=L{nt.tc};
        %  Back itertions
        if t.ti==t.T
            beta{t.tc}=ones(K(t.ch),1)/scale(t.tc);
            tmpgam=alpha{t.tc}.*beta{t.tc};
            Gamma{t.tc}=tmpgam(:)./sum(tmpgam(:));
        else
            % next time step/same chain
            nt=nextt(t);	
            % compute beta/ backward variable
            beta{t.tc}=(curP'*(curL.*beta{nt.tc}))/scale(t.tc); 
            % compute temporary Xi/ joint marginals, vectorised for later kronecker
            xi=((beta{nt.tc}.*curL) *alpha{t.tc}').* curP;
            xi=xi./sum(xi(:));
            % vectorise for later use of approximate marginal for TxProb update
            xi=xi(:); 
            % compute Gamma/ single marginals
            tmpgam=alpha{t.tc}.*beta{t.tc};
            Gamma{t.tc}=tmpgam(:)./sum(tmpgam(:));
            
            % compute approximation Xi
            % get parents
            parents=LagOp*t;
            % vector of dimension for later reshape
            Kv=[K(t.ch) K(t.ch)];
	    % keep the pairwise marginals
	    pXi{t.tc}=reshape(xi,Kv);
	    % find all non-native parents
            for p=1:length(parents),
                % parent time/chain index
                pndx=parents{p};
                if pndx~=prevt(t),		% parent of other chain?
                    xi=kron(Gamma{pndx.tc},xi);	% outer product
                    Kv=cat(2,Kv,K(pndx.ch));	% keep K of current chain
                else				
                    scp=p;  %loop index of same chain parent
                end
            end
            
            xi=xi./sum(xi(:));			% re-normalise
            xi=reshape(xi,Kv);			% reshape into MD array
            
            % now permute: 1st permuation vec. of all but native parent
            pvec=(1:length(parents)-1)+2;
            % insert native parent at index found in above parent loop
            pvec=cat(2,1,pvec(1:scp-1),2,pvec(scp:end));
            % permute and store 
            Xi{t.tc}=permute(xi,pvec);
        end
        t=prev(t);				% next backward
    end  					% while ~ending(t)
end

