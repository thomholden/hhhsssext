function ED=computeED(TS,varargin)
% computeED   estimates the embedding parameters for a multivariate time
%             series.
%
%    ED=computeED(TS) computes the parameters ED for standard embedding
%    reconstruction of the time series in TS. For each time series in TS 
%    (NaN separated if several experiments),
%    ED has the estimated time lag on the first row, the minimum embedding
%    dimension on the second row. ED has NaN if the time series is constant.
%    It computes the parameters with the following methods:
%    1) time lag: first minimum of auto mutual information
%    2) embedding dimension: false nearest neighbors criterion (Rtol has 10
%    as default value). Another parameter of ffn method, the Theiler window, has been
%    set to 0. The threshold on the percentage of false nearest neighbors
%    has been set to 0.5 . Finally, a 10-dimensional state-space is
%    constructed as default for dimension estimation.
%    This function uses functions that need another toolbox,
%    TSTool, that is freely available @
%    http://www.physik3.gwdg.de/tstool/indexde.html
%
%    ED=computeED(TS,Rtol) where Rtol is the tolerance parameter for determining 
%    false nearest neighbors. As suggested in the H. Kantz and T. Schreiber' book (see Reference), 
%    it is advisable to study the ffnn statistic wrt the paramater Rtol.
%
%    See also false_neighbor, timedelay_am, DelReconstructor, Embed.
%
%    References:
%    H. Kantz and T. Schreiber, 
%    "Nonlinear Time Series Analysis", 
%    Cambridge University Press, Cambridge (2004). 
%

% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology 
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

if nargin==2
    Rtol=varargin{1};
else
% default value
    Rtol=10;
end

% check input
if nargin>2
    error('Too many inputs');
elseif nargin<1
    error('Missing input TS');
end

% number of sites 
nsite=size(TS,2);

% Initialisation
ED=zeros(2,nsite);

% Experiments separators
expbase=[0 ; find(isnan(TS(:,1)))];
numexp=size(expbase,1)-1;
explngt=expbase(2)-1;
    
% Time vector
T=repmat([linspace(0,1,explngt)' ; NaN],[numexp 1]);

% zero vector for check: check that not reference(s) site(s) is(are) included
% loop over the sites
for s = 1:nsite,
    % idx of good trials
    idx=find(isfinite(TS(:,s)));
    % if signal is constant (e.g. all zeros, it is a reference site)      
    if  isequalwithequalnans(diff(TS(idx,s)),zeros(length(idx)-1,1)),
        % embedding parameters = NaN
        ED(:,s)=NaN(2,1);
    end
    % end if isequal
end
% end for

% update nsite where compute embedding parameters
ids=find(~isnan(ED(1,:)));
nsite=length(ids);

% Loop over sites
for ns = 1:nsite,
    
    % update index
    s=ids(ns);
    
    % First parameter: time lag by first minimum of auto mutual information
    ED(1,s)=timedelay_am(TS(:,s));
    
    % second parameter: embedding dimension computed with false nearest
    % neighbors method
    [Tn,Xn]=DelReconstructor(T,TS(:,s),ED(1,s),10);
    % run false neighbor (Theiler window is zero here)
    [ffnn]=false_neighbor(Xn,Rtol,0);
    
    % threshold
    th=0.5;
    
    % Find values in ffnn superior to threshold
    ED(2,s)=length(find(ffnn>th))+1;
   
end
% end

return,
% end ComputeED