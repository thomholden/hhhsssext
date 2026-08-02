function pv=MultiTest(S1,S2)
%  MultiTest   performs a non-parametric permutation version 
%              of the Hotelling's T^2 test. 
%
%     pv=MultiTest(S1,S2) performs a non-parametric test to detect similarities 
%     between two multivariate data populations S1 and S2. A non-parametric 
%     permutation version of the Hotelling's T^2 test. The null
%     hypothesis Ho is: mean(S1) = mean(S2).
%     S1 and S2 are organized as number of trials (row) x number of
%     variables (columns).
%     pv is the computed p-value to which the hypothesis is tenable. 
%     As default, 2000 permutations are performed.
%     The two populations can contain NaN values to indicate bad trials. If 
%     all the population samples for a certain variable are NaNs, that
%     variable is not considered in the test.
%
%     Example
%     % two 5-variate populations with approximately same mean
%     x=rand(100,5);
%     y=rand(100,5);
%     % test diversity
%     pv=MultiTest(x,y+2)
%     % test equality
%     pv=MultiTest(x,y)
%
%     See also MBF.

% Copyright (c) 2005
% Cristian Carmeli, Swiss Federal Institute of Technology 
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


% Check inputs
if nargin < 2
    error('Input missing, two matrix are required');
elseif nargin > 2
    error('Too many inputs, only two matrix are required');
end

% number of variables
  k=size(S1,2);

% check on the number of variables
if k ~= size(S2,2),
   error('The two multivariate populations must have the same number of variables!');
end
  
% number of trials of the 2 populations
  idx1=find(~isnan(S1(:,1))); 
  idx2=find(~isnan(S2(:,1))); 
  NP1=length(idx1);
  NP2=length(idx2);  
  
% check if there are bad variables (NaN values for all the trials)
for s=1:k,
   track(1,s)=isequalwithequalnans(S1(:,s),NaN(NP1,1));
   track(2,s)=isequalwithequalnans(S2(:,s),NaN(NP2,1));
end
% find variables to keep
idv=union(find(track(1,s)),find(track(2,s)));
goodv=setdiff([1:k],idv);
% new population matrices
% take only not-NaN values (good trials) and good variables 
Y1=S1(idx1,goodv);
Y2=S2(idx2,goodv);      
% new number of variables
k=length(goodv);
% disp how many variables you're working on
disp([num2str(k,'%i') ' variables']);

% error
if (k>NP1 || k>NP2),
    error('The test has not meaning. You should have more trials than variables.');
end

% number of permutations
  NR=2000;
  disp([num2str(NR,'%i') ' permutations']);

% init F-distribution values
  F=zeros(NR,1);  

% Reference F-value
  ref=MBF(mean(Y1,1),mean(Y2,1),cov(Y1),cov(Y2),NP1,NP2);
  
% total data matrix for permutation  
  C=[Y1 ; Y2];
  
% NR permutations  
  for i=1:NR,
      
      % permuting vector 
        perm=repmat(2.*binornd(1,.5,NP1+NP2,1)-1,1,k);
        Xp=perm.*C;
        
      % estimated mean of the two new populations  
        Mu1=mean(Xp(1:NP1,:),1);
        Mu2=mean(Xp(NP1+1:end,:),1);
        
      % estimated covariance matrix  
        Co1=Xp(1:NP1,:)'*Xp(1:NP1,:)/(NP1-1);
        Co2=Xp(NP1+1:end,:)'*Xp(NP1+1:end,:)/(NP2-1);
        
      % F-values  
        F(i)=MBF(Mu1,Mu2,Co1,Co2,NP1,NP2);
       
  end
  % end for
  
% p-value
%   pv=length(find(F>=ref))/NR;
  pv=(length(find(F>=ref))+1)/(NR+1);  

  return,
  % end