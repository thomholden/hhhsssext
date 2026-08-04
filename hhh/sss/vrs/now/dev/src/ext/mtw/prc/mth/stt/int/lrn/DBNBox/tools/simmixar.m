function [X,J,A,C]=simmixar(T,multidim,mix)
% [X,J,A,C]=simmixar(T,multidim,mix)
%
% generate T samples X from (predefined) autoregressive models with 
% coefficients A, noise variance C. If the multidim flag is set, a bivariate AR processes is 
% sampled, otherwise data is generated from a univariaate AR model.
% The mixture generates a sequence of interleaved samples from 2 AR models
% with labels <J> indicating from which of the 2 AR models the data was drawn.
%

if nargin<3 | isempty(mix)
   mix=0;                  % default: no mixture
   disp('Using default single AR model');
end
if nargin<2 | isempty(multidim)
   multidim=0;                  % default: univariate
   disp('Using default univarite AR');
end
if nargin<1 | isempty(T)
   T=100;
   disp(sprintf('Using default %d samples',T));
end   
 
if ~multidim
   if mix      
      w=0;
      % Coeffs at lag 1
      A(:,:,1)=[.4 .35];           % AR of first mixture component
      A(:,:,2)=[1.2 -.7];          % AR of second mixture component
      C = [ 1.00];
      % generate mixture of 2 AR processes: process 1 - process 2 - process 1
      % We use the module ARSIM to simulate T observations of each AR
      % process:
      X = [arsim(w, A(:,:,1) , C, T); ...
            arsim(w, A(:,:,2), C, T); ...
            arsim(w, A(:,:,1), C, T)]; 
      J=[ones(T,1) 2*ones(T,1) ones(T,1)];                   % Class labels
   else
      w=0;
      % Coeffs at lag 1
      A=[.4 .35];           % AR of first mixture component
      %A=[1.2 -.7];          % AR of second mixture component
      C = [ 1.00];
      % generate mixture of 2 AR processes: process 1 - process 2 - process 1
      % We use the module ARSIM to simulate T observations of each AR
      % process:
      X = arsim(w, A(:,:) , C, T);
      J=  ones(T,1);                   % Class labels
   end
else
   if mix
      w=[0;0];
      % Coeffs at lag 1 of first AR mixture component 
      Al1(:,:,1) = [ 0.4   1.2;   0.3   0.7 ];
      % Coeffs at lag 2
      Al2(:,:,1) = [ 0.35 -0.3;  -0.4  -0.5 ];
      % Coeffs at lag 1 of second AR mixture component 
      Al1(:,:,2) = [ 0.4   0;   0   0.7 ];
      % Coeffs at lag 2
      Al2(:,:,2) = [ 0.35 0;  0  -0.5 ];
      A(:,:,1) = [ Al1(:,:,1) Al2(:,:,1) ];
      A(:,:,2) = [ Al1(:,:,2) Al2(:,:,2) ];
      C = [ 1.00  0.50;   0.50  1.50 ];
      % generate mixture of 2 AR processes: process 1 - process 2 - process 1
      % We use the module ARSIM to simulate T observations of each AR
      % process:
      X = [arsim(w, A(:,:,1) , C, T); ...
            arsim(w, A(:,:,2), C, T); ...
            arsim(w, A(:,:,1), C, T)]; 
      J=[ones(T,1) 2*ones(T,1) ones(T,1)];                   % Class labels

   else
      w=[0;0];
      % Coeffs at lag 1
      Al1 = [ 0.4   1.2;   0.3   0.7 ];
      %Al1 = [ 0.4   0;   0   0.7 ];
      % Coeffs at lag 2
      Al2 = [ 0.35 -0.3;  -0.4  -0.5 ];
      %Al2 = [ 0.35 0;  0  -0.5 ];
      A = [ Al1 Al2 ];
      C = [ 1.00  0.50;   0.50  1.50 ];
      %  We use the module ARSIM to simulate T observations of this AR
      %  process:
      X = arsim(w, A, C, T);
      J=  ones(T,1);                   % Class labels

   end
end

