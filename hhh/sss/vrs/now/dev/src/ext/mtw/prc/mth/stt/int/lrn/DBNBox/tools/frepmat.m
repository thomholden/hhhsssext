function B = frepmat(A,K)
%FREPMAT Replicate and tile an array with filling
%   B = rfepmat(A,K) creates a large matrix B consisting of an 
%   tiling of copies of A along dimensions indicate in K with ones. 
%   
%   Example:
%       B=frepmat(magic(2),[1 3 1 ,4])
%       size(B)  % is  2-by-3-by-2-by-4.
%       for i=1:3, for j=1:4, 
%          A=squeeze(B(:,i,:,j)); % produces the same A matrix
%       end; end;
%        
if nargin < 2
   error('Requires at least 2 inputs.')
end

ndx1=find(K==1); 
ndx2=find(K~=1);
pvec=[find(K==1); find(K~=1)];
B=repmat(A,K(pvec));
B=ipermute(B,pvec);
