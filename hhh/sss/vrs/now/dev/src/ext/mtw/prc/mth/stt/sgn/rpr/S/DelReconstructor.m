function [Tn,Xn]=DelReconstructor(t,y,stp,n)
% DelReconstructor   State space reconstruction of a scalar time series using the 
%                    delay embedding principle.
%
%   [Tn,Xn]=DelReconstructor(t,y,stp,n) takes a scalar time series y
%   and reconstructs a state space Xn by using the delay embedding technique 
%   with parameters: time lag stp and embedding dimension n. t is the vector of the times.
%   Correspondingly, Tn is the vector of the reference time.
%   The time series y is detrended to zero mean and normalized to unit variance. 
%   t and y may consist of several experiments which must be NaN separated.
%
%   Example
%   % we use a Van der Pol oscillator, using the vdp model that comes with
%   % Simulink.
%   [t,x]=sim('vdp',1000);
%   % noisy observation
%   y=x(:,1)+0.01*randn(size(x(:,1)))*std(x(:,1),0,1);
%   % embed
%   [Tn,Xn]=DelReconstructor([t ; NaN],[y(:,1) ; NaN],6,2);
%   % plot the real and the embedded state space
%   plot(x(:,1),x(:,2),'b'); figure;
%   plot(Xn(:,1),Xn(:,2),'r');
%
%   See also Embed, computeED.
%
%   Reference: H. Kantz and T. Schreiber, ``Nonlinear Time Series
%   Analysis'', Cambridge University Press, Cambridge (2004). 

% Copyright (c) 2005
% Oscar De Feo / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.



% Force column vector
  y=y(:);

% Experiments separators
  expbase=[0; find(isnan(t))];
  numexp=size(expbase,1)-1;
  explngt=diff(expbase,1,1);
  
% detrend and normalize 
for nt=1:numexp,
    % indexes
    idx=expbase(nt)+1:expbase(nt+1)-1;
    % for good trials
    if isfinite(y(idx))
    
       y(idx)=y(idx)-mean(y(idx));
       y(idx,:)=y(idx)/std(y(idx));
    
    end
end

% length of the toeplitz matrices
  mi=explngt-(n-1)*stp-1;
  bi=cumsum([0; mi+1]);
  cidx=(1:stp:n*stp);
  
% Allocate the result
  Xn=zeros(sum(mi)+numexp,n);
  Tn=zeros(sum(mi)+numexp,1);

% Easier with a for loop over the experiments
  for i=1:numexp,
      % Constructing the toeplitz shift matrix of the measuremnt
        ridx=expbase(i)+(0:mi(i)-1)';
      % Shifted measures matrix (the state space)
        Xn(((bi(i)+1):(bi(i+1)-1)),1:n)=y(cidx(ones(size(ridx,1),1),:)+ridx(:,ones(size(cidx,2),1)));
      % Reference Time  
        Tn(((bi(i)+1):(bi(i+1)-1)))=t(expbase(i)+(1:mi(i)));
      % Nan separator
        Xn(bi(i+1),:)=NaN;
        Tn(bi(i+1))=NaN;
  end;

% End
return;
 