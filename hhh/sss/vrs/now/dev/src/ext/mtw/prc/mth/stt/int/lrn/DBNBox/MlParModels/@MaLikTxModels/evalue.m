function [avLL] = evalue (txmodel,Xi,Gamma,T,varargin);
% [avLL] = evalue (txmodel,Xi,Gamma,T);
%
% Evaluates the data and parameter log-likelihood prior for state transition
%  model
% 
% INPUT
%
% Xi           joint probability of past&future states conditioned on data 
% Gamma        probability of states conditioned on data 
% txmodel      data structure 
% T            lengths of individual blocks
%
% OUTPUT
%
% avLL         average log-likelihood
%

T=cumsum([0 T(1:end-1)])+1;			% indeces of block onset
K=[txmodel.K(1) prod(txmodel.K(2:end))]; % MD -> 2-D for loop
szXi=size(Xi);				% size of Xi
Xi=reshape(Xi,[szXi(1), K]); 		% assumes szXi(2:end) <-> K
Pi=txmodel.Pi(:);
P=reshape(txmodel.P,K);

avLL=0; 
lPri=[];
for l=1:K(1),
  % intial state avLL
  if Pi(l)~=0,
     avLL=avLL+sum(Gamma(T(:),l)*log(Pi(l)));
  end;

end

% now state transition part
for l=1:K(2),
  for k=1:K(1),
    if P(k,l)~=0
	avLL=avLL+sum(Xi(:,k,l),1)*log(P(k,l));
    end;
  end
end;

