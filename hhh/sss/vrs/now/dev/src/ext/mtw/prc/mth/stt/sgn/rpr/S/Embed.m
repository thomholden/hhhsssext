function [TSnew,No]=Embed(TS,ED)
% Embed   embeds multivariate time series by delay embedding.
%
%   [TSnew,No] = Embed(TS,ED) embeds all the time series in TS by the delay
%   embedding with parameters in ED (first row the time lag, second row the
%   embedding dimension). TS must be a matrix with the recorded samples
%   on the rows (NaN separated if several experiments) and the recording
%   sites on the columns. ED contains the parameters values for embedding 
%   for the corresponding variables.
%   Embed returns a matrix TSnew, the delay embedded time series; and a vector No.
%   No allows to keep track of the number of colums used to represent
%   (embed) each site. 
% 
%   Example:
%   % fake data  
%   TS=[randn(500,3) ; NaN(1,3)];
%   % prameters
%   ED=[1 1 1 ; 2 1 2];
%   % embedding
%   [TSnew,No]=Embed(TS,ED);
%
% See also DelReconstructor, timedelay_am, false_neighbor, computeED.

% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


% check input
if nargin > 2
    error('Too many input arguments');
elseif nargin < 2
    error('Missing input');
end

% Check input consistency
if ~(size(ED,2)==size(TS,2))
    error('InputError:Input', ...
          'TS and ED should have the same number of columns \n which is the number sites in the considered cluster');
end

% Experiments separators
  expbase=[0 ; find(isnan(TS(:,1)))];
  numexp=size(expbase,1)-1;
  explngt=expbase(2)-1;
  
% base index  
  No=cumsum([1 ED(2,:)]);

% Compute products
  mi=explngt-(ED(2,:)-1).*ED(1,:);
% minimum value
  win=unique(min(mi));  

% base index
  BI=cumsum([1 (win+1)*ones(1,numexp)]);
  
% Allocate space for delay embedded values
  TSnew=NaN((win+1)*numexp,No(end)-1);

% Creating NaN separated vector of time
  t=[linspace(0,1,explngt(1))' ; NaN];
      
for ns=1:size(ED,2),
        
    % Easier with a for loop over the experiments
    for ne=1:numexp,
        
        % Bad trials are not considered
        if isinf(TS(expbase(ne)+1:expbase(ne+1)-1,ns))==ones(explngt,1),
             
           % Fill bad trials with Inf
             TSnew(BI(ne):BI(ne+1)-2,No(ns):No(ns+1)-1)=Inf(win,ED(2,ns));
            
        else

        % Compute delay embedded series for each trial
          [Tn,Xn]=DelReconstructor(t,TS(expbase(ne)+1:expbase(ne+1),ns),ED(1,ns),ED(2,ns));
          
        % Fill new time series
          TSnew(BI(ne):BI(ne+1)-2,No(ns):No(ns+1)-1)=Xn(1:win,:);

        end
    end
end  

return,
% end computeED

