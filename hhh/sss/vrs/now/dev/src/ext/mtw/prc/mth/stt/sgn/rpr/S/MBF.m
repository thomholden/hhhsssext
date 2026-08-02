function F=MBF(m1,m2,C1,C2,NP1,NP2)
% MBF   computes F-distribution value for a multivariate Behrens-Fisher test.
%
%    F=MBF(m1,m2,C1,C2,NP1,NP2) computes the F-distribution value F of a modified 
%    Nel and Van der Merwe test for the multivariate Behrens–Fisher problem
%    with the following parameters values for the two populations: m1 and m2 the
%    estimated mean vectors, C1 and C2 the estimated covariance matrix, NP1 and
%    NP2 the number of trials for the two multivariate populations respectively. 
%          
%    See also MultiTest.
%
%    Reference:
%    K. Krishnamoorthy and J. Yu  
%    "Modified Nel and Van der Merwe test for the multivariate
%     Behrens–Fisher problem",
%    Statistics & Probability Letters 66 (2004), 161-169.

% Copyright (c) 2005
% Cristian Carmeli, Swiss Federal Institute of Technology 
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


% force to row vector
  m1=m1(:);
  m2=m2(:);
 
% number of variables
  p=length(m1);
% inverted mixed variance matrix
  S_tinv=inv(C1/NP1+C2/NP2);
% helping variables
  a1=trace(((C1/NP1)*S_tinv).^2);
  b1=trace((C1/NP1)*S_tinv)^2;
  a2=trace(((C2/NP2)*S_tinv).^2);
  b2=trace((C2/NP2)*S_tinv)^2;
% estimated degrees of freedom (modified Nel and Van der Merwe's solution)
  df=(p+p^2)/((a1+b1)/(NP1-1)+(a2+b2)/(NP2-1));

% T square
  T_sq=(m1-m2)'*S_tinv*(m1-m2);
% F distribution value
% T_f=((df*p)/(df-p+1))*finv(alfa,p,df-p+1);
  F=((df-p+1)/(df*p))*T_sq;

return;
%end
