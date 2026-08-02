function tau=timedelay_am(s)
% timedelay_am   computes time lag by means of the first minimum of auto mutual
%                information function.
%
%    tau=timedelay_am(s)  computes time lag tau given the scalar time
%    series s (NaN separated if several experiments). The applied method
%    is to look for the first minimum of the auto mutual information
%    function. 256 bins are used to estimate the mutual information, and a
%    maximum lag approximately of ten times less the total length of the 
%    time series is used.
%    It detrends to zero mean and normalizes to unit variance the time
%    series.
%    This function uses routines from TSTool, you can freely download @
%    http://www.physik3.gwdg.de/tstool/indexde.html
%
%    Example
%    % time lag for a random (normal) vector
%    tau=timedelay_am([randn(500,1); NaN]);
%    
%    See also false_neighbor, Embed, DelReconstructor, computeED.
%
%    Reference: H. Kantz and T. Schreiber, ``Nonlinear Time Series
%    Analysis'', Cambridge University Press, Cambridge (2004). 

% Copyright (c) 2005
% Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


% Check number of inputs
if nargin>1
    error('Too many inputs, 1 input required');
elseif nargin==0,
    error('Input missing, 1 input required');
end

% check it is a univariate time series
if size(s,2)>1,
    error('Input must be a univariate time series!');
end

% line vector 
s=s(:);

% Experiments separators
expbase=[0; find(isnan(s))];
numexp=size(expbase,1)-1;
explngt=expbase(2)-1;

% detrend and normalize the signal
for nt=1:numexp,
    idx=expbase(nt)+1:expbase(nt+1)-1;
    s(idx)=s(idx)-mean(s(idx));
    s(idx)=s(idx)/std(s(idx),0,1);
end

% take only the not-NaN values
y=s(find(~isnan(s))); 

% create signal struct
x=signal(y);

% compute auto-mutual information
st_am=amutual(x,ceil(explngt/10),256);

% find first minimum
am=data(st_am);
forw=am(2:end-1)-am(1:end-2);
back=am(2:end-1)-am(3:end);
i=find((forw<=0)&(back<=0));
% check if a minimum exists
if isempty(i),
    error('A minimum of auto mutual information has not been found. Please, consider another approach.');
else
   tau=i(1)+1;
end
  
return
% end