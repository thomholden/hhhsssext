function [Gamma,Xi]=splitnodes(chschain,cartGamma,cartXi)
% Split the marginals resuting form the clusterd forward backward routine into 
% those corresponding to the marginals of each chain
%
% Output
% Gamma    cell array with marginal of hidden states, one cell element/chain
% Xi       cell array with Joint marginals of states, one cell element/chain




LagOp=chschain.LagOp;
K=chschain.K;
T=chschain.T;		% size(Gamam,1)= State Chain length


% now split the marginals for each chain
[Gamma,Xi]=splitmarginal(cartXi,cartGamma,LagOp,T,K);

%%%%%%%%%%%%%%%%%%%%%%%%%%  SPLITMARGINAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Gamma,Xi]=splitmarginal(cartXi,cartGamma,LagOp,T,K);
% splits the single marginals of the clustered time step into marginals 
% for each time step and chain of the original unclusterd model.

Txi=size(cartXi,1);
Tga=size(cartGamma,1);
L=get(LagOp,'MaxLag');
C=get(LagOp,'MaxCha');


Gamma=cell(T,C);
Xi=cell(T-1,C);
%if C==1,
%  cartXi=permute(cartXi,[2 3 1]);	% time -> last dimension
%  [Xi(1:T-1)]=num2cell(cartXi,[1 2]);	% put dim 1&2 in one cell
%  [Gamma(1:T)]=num2cell(cartGamma',1);	% put dim 1 in one cell
%  return
%end

cartXi=reshape(cartXi,[Txi,repmat(K(:)',1,2*L)]);
cartGamma=reshape(cartGamma,[size(cartGamma,1),repmat(K(:)',1,L)]);

for c=1:C, 
  npar=LagOp.*[0 c];
  parK=K(npar(2,:));
%  Xi{c}=zeros([T-1,K(c),parK]);
%  Gamma{c}=zeros([T,K(c)]);
  [Xi{:,c}]=deal(zeros([K(c),parK]));
  [Gamma{:,c}]=deal(zeros(K(c),1));

  tmpXi=[];
  tmpGam=[];
  
  for l=1:L,
    % compute time indeces which are valid (ie. smaller than T)
    tnx=L+1-l:L:Tga*L;
    vtnx=find(tnx<=T);
    %
    % first Gammas
    dims=setdiff(1:L*C,sub2ind([C,L],c,l));
    tmpGam=mdsum(cartGamma,1+dims);
%    Gamma{c}(tnx(vtnx),:)=tmpGam(vtnx,:);
    tmpGam=num2cell(tmpGam',1);
    Gamma(tnx(vtnx),c)=tmpGam(vtnx);
    %
    % now Xi; re compute time indeces which are valid (ie. smaller than T)
    tnx=L+1-l:L:Txi*L;
    vtnx=find(tnx<T);
    % need to find parents which are not marginalised out
    parents=inv(LagOp).*[l;c];
    dims=setdiff(1:2*L*C,sub2ind([C,L*2],c,l));
    for p=1:size(parents,2),
      dims=setdiff(dims,sub2ind([C,L*2],parents(2,p),parents(1,p)));
    end
    tmpXi=mdsum(cartXi,1+dims);
%    Xi{c}(tnx(vtnx),:)=tmpXi(vtnx,:);
    tmpXi=permute(tmpXi,[2:ndims(tmpXi) 1]);
    tmpXi=num2cell(tmpXi,[1:(ndims(tmpXi)-1)]);
    Xi(tnx(vtnx),c)=tmpXi(vtnx);
  end;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%  MDSUM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Z=mdsum(X,conddim)
% function Z=mdsum(X,conddim)
%
% integrating out dimensions <conddim> of multidimensional arrays
%
% e.g. P(A,B,C) is of size 3x2x4
%
% to obtain P(A,C)
% mdsum(P,2) as B varies along dimension 2
%
% example:
% X=round(10*rand(2,2,2));
% dim=3;
% Y=mdsum(X,dim);
% Z=mddiv(X,Y,dim);
% results in every other element X in dimensions 1 and 2
% is multiplied by every value of Y


svx=size(X);				% need old demensions of X
conddim=reshape(conddim,1,length(conddim));

freedim=setdiff(1:length(svx),conddim);	% get free dimensions

if isempty(freedim),
  Z=sum(X(:));
  return;
end;

X=permute(X,[freedim,conddim]);		% move freedims to front

X=reshape(X,[prod(svx(freedim)),prod(svx(conddim))]);% vectorise the 2 dim sets

Z=sum(X,2);

rshv=svx(freedim);

if length(rshv)==1, rshv=cat(2,rshv,1); end
Z=reshape(Z,rshv);
