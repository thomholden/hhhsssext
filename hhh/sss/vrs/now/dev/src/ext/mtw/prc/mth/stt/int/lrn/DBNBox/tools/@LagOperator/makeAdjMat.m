function [AdjMat,Labels]=makeAdjMat(LagOp,T);
% [AdjMat,Labels]=makeAdjMat(LagOp,T)
%
%  Generates Adjacency Matrix from a given LagOp, for LagOp.MaxCha
%  Chains of length T. LagOp is an object of class <LagOperator>.
%  The matrix encoded the specification of the lags with the
%  corresponding chain number to which the lag refers. Labels contains
%  generically generated string labels for each vertex in the
%  graph. 
%
%  e.g.
%  [AdjMat,Labels]= makeAdjMat(LagOp,5);
  
  if nargin<2
    T=LagOp.MaxLag+1;	% need one for current time
  end
  Nchains=LagOp.MaxCha;

  AdjMat=zeros(T*Nchains,T*Nchains);	% Adjacency Matrix
  AdjMatsv=[T*Nchains,T*Nchains];

  for nL=1:Nchains,

    lags=LagOp.Lag{nL};			% get Lag list
    lags=lags(:);
    lags(find(isinf(lags(:))))=-T;	% if inf -> Lag=chain length
    lagsl=length(lags);
    
    chanid=LagOp.Cha{nL}+nL;		% get chain id of lags
    chanid=chanid(:);
    tMa=(chanid-1)*T;			% 1st node id of each chain
    tMad=(nL-1)*T*ones(size(tMa));	% 1st node id of current chain (nL)
    for t=1:T, 
      ndx=find((lags+t>0) & (lags+t<=T));	% check for 0< time index<=T
      if ~isempty(ndx)
	AdjMat(sub2ind(AdjMatsv,tMa(ndx)+lags(ndx)+t,tMad(ndx)+t))=-1;
      end
    end
  end;

  %  making Labels
  Labels=cellstr([char(65:64+Nchains)' repmat(num2str(1),Nchains,1)])';
  for t=2:T, 
    Labels=cat(1,Labels,cellstr([char(65:64+Nchains)' ...
		    repmat(num2str(t),Nchains,1)])');
  end
