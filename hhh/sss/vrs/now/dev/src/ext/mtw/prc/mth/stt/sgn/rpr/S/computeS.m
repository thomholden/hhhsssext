function S=computeS(TS,Idx,varargin)
% computeS   computes S estimator.
%
%    S=computeS(TS,Idx)  computes the synchronization estimator S (not embedded version) among the 
%    clusters of sites defined by Idx. The recorded time series of the sites 
%    are in TS, that have the recorded time samples on the rows (NaN separated experiments 
%    if several) for each site (columns). TS should have Inf values if an
%    experiment is bad (it must be a bad trials for all the sites).
%    Idx: m by n matrix, m being the length of the most numerous cluster and n
%    the number of clusters. Idx(:,j) is the set of indeces of cluster j.
%    Idx(i,j) can either be an index of a site (time series) or a NaN (bad site 
%    or just as filling entry of the Idx matrix to have m rows).
%    S is a matrix: n (number of clusters) are the columns and on the rows
%    are the values for each trials or experiment. S is NaN for a
%    corresponding bad trial.
%    
%    S=computeS(TS,Idx,ED) computes the synchronizations estimator S on
%    embedded time series. TS time series are embedded with parameters in ED,
%    first row the time lag, second row the embedding dimension. ED(:,j)
%    are the embedding prameters for TS(:,j).
%
%    Example
%    % fake data 
%    TS=repmat([randn(500,15) ; NaN(1,15)],[10 1]);
%    % two clusters
%    Idx=[1 12; 2 14 ; 5 NaN];
%    % S estimator
%    S=computeS(TS,Idx);
%
%    See also computeED, fileSelector, getClusters, getSpots.
%
%    Reference:
%    C. Carmeli, M. G. Knyazeva, G. M. Innocenti and O. De Feo
%    "Assessment of EEG synchronization based on state-space analysis",
%    NeuroImage 25 (2005) 339-354

% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology 
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.



% Check number of inputs
if nargin>3
    error('Too many input arguments');
elseif nargin<2
    error('Input argument missing, either Time series matrix or cluster indexes');
end

% Experiments separators
expbase=[0; find(isnan(TS(:,1)))];
explngt=expbase(2);
numexp=size(expbase,1)-1;

% unique sites (not NaN)
id=unique(Idx);
Idu=id(find(isfinite(id)));

% check on the number of available measurements and cluster index sites (weak)
if max(Idu)>size(TS,2),
   error('You are trying to compute S on sites where the measurement is missing. Please, check either the number of time series either the index of sites');
end

% number of clusters
numclu=size(Idx,2);

% init S
S=NaN(numexp,numclu);

% we want to compute S on embedded trajectories 
if nargin == 3,
    
    % parameters for delay embedding
    ED=varargin{1};
    
    % check its size
    if ~(size(ED,2) == size(TS,2))
        error('Third input does not correspond in size to first one');
    end
    
    % compute the embedded trajectories
    [TSnew,No]=Embed(TS(:,Idu),ED(:,Idu));
    
    % Experiments separators
    expbase=[0; find(isnan(TSnew(:,1)))];
    explngt=expbase(2);
    
    
    % loop over the cluster
    for nc=1:numclu,
        % In Idx(:,nc), which represents the sites index of the current clusters
        % (organized by columns), last values are filled with NaNs,
        % except if the cluster nc was the longest one when Idx was computed
         
        % get the sites belonging to the cluster nc
        clus=Idx(find(isfinite(Idx(:,nc))),nc);
        
        % if more than one site belongs to cluster nc
        if and(~isempty(clus),length(clus)>1), 
        
           % position of the sites in Idu
           idp=find(ismember(Idu,clus));
        
           % loop over the number of trials
           for ne=1:numexp,
            
               Y=[];
               % select the time series
               for ns=1:length(idp),
                   % select
                   Y1=TSnew((expbase(ne)+1):(expbase(ne+1)-1),No(idp(ns)):(No(idp(ns)+1)-1));
                
                   % Updates
                   Y=[Y Y1];
                   % end select 
               end
               %end for ns
           
               % for good trials
               if isfinite(Y)

                  % Correlation Matrix
                  C=corrcoef(Y);
                         
                  % Moment m0
                  m0=trace(C);

                  % Normalized eigenvalues
                  EI=eig(C)/m0;
                  EI(find(abs(EI)<eps))=eps;

                  % S estimator
                  S(ne,nc)=1+sum(EI.*log(EI))/log(size(Y,2));
               end
               % end if isfinite
                
           end
           % end over the number of experiments
        
        % else if isempty
        else
           % warning
           warning('You should compute S estimator at least on two sites!'); 
        end
        % end if isempty
      
    end
    % end over the number of clusters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  
% if we want to compute S on non-embedded signals
else

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
% loop over the clusters  
  for nc=1:numclu,
      % In Idx(:,nc), which represents the sites index of the current clusters
      % (organized by columns), last values are filled with NaNs,
      % except if the cluster nc was the longest one Idx was computed
           
      % get the sites belonging to the cluster nc
      clus=Idx(find(isfinite(Idx(:,nc))),nc);
      % number of sites
      nnsit=length(clus);
      
      % if more than one site belongs to cluster nc
      if and(~isempty(clus),nnsit>1),
      
         % loop over the number of trials    
         for ne=1:numexp,
          
             % select the time series
             Y=TS((expbase(ne)+1):(expbase(ne+1)-1),clus);  

             % for good trials
             if isfinite(Y)
              
                % Correlation Matrix
                C=corrcoef(Y);
                  
                % moment zero of the correlation matrix
                m0=trace(C);
 
                % Normalized eigenvalues
                EI=eig(C)/m0;
                EI(find(abs(EI)<eps))=eps;

                % S estimator
                S(ne,nc)=1+sum(EI.*log(EI))/log(nnsit);

             end
             % end if isfinite       

         end
         % end over the number of experiments  
         
        % else if isempty
        else
           % warning
           warning('You should compute S estimator at least on two sites!'); 
      end
      % end if isempty
          
  end
  % end over the number of clusters
  
end
% end if nargin==3
   
return,
% end computeS
