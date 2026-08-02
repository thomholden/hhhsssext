
function [defmatrix] = form(DATA,normdist)

%   [defmatrix] = form(DATA,normdist)
%   [defmatrix] = form(DATA,bins)
%   [defmatrix] = form(DATA)
%
% Function for finding mapping between distributions.
%
% Input parameter:
%  - DATA: Data to be manipulated
%  - normdist: If vector, intended distribution form (default Gaussian)
%    (default sigma=3, bins=10)
%    If scalar given, interpreted as the number of bins in Gaussian
% Return parameters:
%  - defmatrix: Matrix containing deformation information.
%    For each column of DATA, there is the starting point of the data bin,
%    after that the 'steepness' of the distribution;
%    there are this kind of pairs as many as there are bins
%
% Heikki Hyotyniemi Feb.20, 2001


[k,n] = size(DATA);
minX = min(DATA);
maxX = max(DATA);

if nargin<2 | length(normdist)==1 
   if nargin>1
      bins = normdist;
   else
      bins = 10;  % How many equalization intervals
   end
   width = 3;  %2.5;  % How wide is the intended distribution (in sigmas)
   t = ([0:bins-1]-(bins-1)/2)/((bins-1)/2)*width;
   normdist = 1/sqrt(2*pi)*exp(-t.*t/2);
else
   [mustbe1,bins] = size(normdist);
   if mustbe1 ~= 1
      normdist = normdist';
      bins = length(normdist);
   end
end
fix = -1;
binsums = round(k*normdist/sum(normdist));
if binsums(1) == 0
   binsums(1) = 1;
   fix = fix - 1;
end
if binsums(bins) == 0
   binsums(bins) = 1;
   fix = fix - 1;
end
fix = fix - (sum(binsums)-k);
for i = 1:abs(fix)
   index = floor((bins-2)*rand(1)) + 2;
   binsums(index) = binsums(index) + sign(fix);
end
if any(binsums<0)
   disp('Failure!'); return;
end

[sortDATA,index] = sort(DATA);

cumubin = cumsum(binsums);
defmatrix = zeros(2*bins+1,n);
defmatrix(1,:) = min(DATA);
defmatrix(3:2:2*bins-1,:) = sortDATA(cumubin(1:bins-1)+1,:);
defmatrix(2*bins+1,:) = max(DATA);

defmatrix(2:2:2*bins,:) = ...
   (ones(bins,1)*(max(DATA)-min(DATA))/bins) ./ ...
   (defmatrix(3:2:2*bins+1,:)-defmatrix(1:2:2*bins-1,:)+10*eps);

