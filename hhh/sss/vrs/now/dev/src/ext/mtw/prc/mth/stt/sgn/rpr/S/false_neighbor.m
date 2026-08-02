function ffnn=false_neighbor(Xn,Rtol,nn)
% false_neighbor   estimates the false nearest neighbors statistic for a
%                  multi-dimensional state-space.
% 
%    ffnn=false_neighbor(Xn,Rtol,nn) computes the false nearest neighbors
%    statistic (percentage) ffnn for a state space Xn with the tolerance parameter Rtol. nn
%    represents the number of samples of a Theiler window. 
%    Xn is a M x p matrix, where M are the samples (NaN separated experiments)
%    and p the dimension of the state-space.
%    This functions detrends to zero mean and normalizes to unit variance the
%    state-space. This function uses routines from TSTool, you can freely download @
%    http://www.physik3.gwdg.de/tstool/indexde.html .
%    Remark: the method implemented here is a minor modification by H. Kantz (see the book) 
%    of the original Kennel's method. It is convenient to study ffnn as function of Rtol.
%    Because the statistics ffnn depends on the time lag tau, a surrogate test is needed
%    for distinguishing nonlinearities from noise.
%
%    Example
%    [t,x]=sim('vdp',1000);
%    % noisy observation
%    y=x(:,1)+0.01*randn(size(x(:,1)))*std(x(:,1),0,1);
%    % reconstruct a high dimensional state-space
%    [Tn,Xn]=DelReconstructor([t ; NaN],[y ; NaN],6,10);
%    % ffnn statistic
%    ffnn=false_neighbor(Xn,100,0);
%
%    See also timedelay_am, DelReconstructor, computeED.
%
%    References:
%    H. Kantz and T. Schreiber, 
%    "Nonlinear Time Series Analysis", 
%    Cambridge University Press, Cambridge (2004). 
%
%    M. B. Kennel, R. Brown, and H. D. I. Abarbanel, 
%    "Determining embedding dimension for phase-space reconstruction using a geometrical construction", 
%    Physical Review A 45, 3403 (1992).     

% Copyright (c) 2005
% Cristian Carmeli, Swiss Federal Institute of Technology Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


% number of points and maximal dimension
[NP,D]=size(Xn);

% index of NaN elements (separators)
numexp=length(find(isnan(Xn(:,1))));
% base index
expbase=[0 ; find(isnan(Xn(:,1)))];

% detrend and normalize 
for nt=1:numexp,
    % indexes
    idx=expbase(nt)+1:expbase(nt+1)-1;
    % only for good trials (non Inf values)
    if isfinite(Xn(idx,:))
        
       Xn(idx,:)=Xn(idx,:)-repmat(nanmean(Xn(idx,:)),[NP/numexp-1 1]);
       Xn(idx,:)=Xn(idx,:)./repmat(nanstd(Xn(idx,:)),[NP/numexp-1 1]);
       
    end
    % end if
end
% end for

% new matrix of values, with NaN 
Yn=reshape(Xn,NP/numexp,numexp,D);

% loop over the dimension
for m=1:D-1,
    
    % init 
    count=zeros(numexp,2);
     
    % loop over the experiments
    for nt=1:numexp,
        
        Data=squeeze(Yn(1:end-1,nt,1:m+1));
          
        % only for good trials
        if isfinite(Data)
            
           % prepare structure for fast neighbours searching
           atria=nn_prepare(Data(:,1:m));
    
           % indeces of nearest neighbour for every point of dimension m, and
           % euclidean distance value (implement the decorrelation window due to Theiler)
           [idx,R]=nn_search(Data(:,1:m),atria,(1:(NP/numexp-1)),2*nn+1,0);
    
           % auxiliary variable
           aux=abs(idx-repmat((1:(NP/numexp-1))',[1 2*nn+1]))-nn;
    
           for i=1:(NP/numexp-1),
               % version 7.0 Matlab
               id_th(i)=idx(i,find(aux(i,:)>0,1,'first'));
           end
    
           % distance (maximum norm) in m-dimension
           distm=max(abs(Data(:,1:m)-Data(id_th,1:m)),[],2);
           % if some elements have distm=0
           distm(find(~distm))=eps;
        
           % false neighbors
           idx1=find((max(abs(Data(id_th,:)-Data),[],2)./distm)>Rtol);
           % sigma=1 because of normalization
           idx2=find((1/Rtol-distm)>0);
           % and
           idx3=intersect(idx1,idx2);
        
           % counting
           count(nt,:)=[length(idx3) length(idx2)];
    
        end
        % end if isfinite
    
    end
    % end over the number of experiments
    
    % sum of false neighbors over all the experiments 
    tot=sum(count,1);
    
    % false nearest neighbors percentage
    if tot(2)
       ffnn(m)=tot(1)/tot(2)*100;
    else
       ffnn(m)=0;
    end
       
end
% end for dimension

return,
% end function
