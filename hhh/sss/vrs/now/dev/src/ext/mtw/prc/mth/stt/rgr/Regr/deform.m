
function [X,W] = deform(DATA,defmatrix)

%   [X,W] = deform(DATA,defmatrix)
%
% Function for equalizing data distributions.
%
% Input parameter:
%  - DATA: Data to be manipulated
%  - defmatrix: Matrix containing deformation information (see 'form.m')
% Return parameters:
%  - X: Data with (approximately) deformed distribution
%  - W: Validity vector containing '1' for all data within assumed distribution
%
% Heikki Hyotyniemi Feb.20, 2001


[k,ndata] = size(DATA);
[bins2,nmodel] = size(defmatrix);
if nmodel ~= ndata
   disp('Incompatible model and data!'); return;
end
n = ndata;
bins = (bins2-1)/2;
beginbin = defmatrix(2*[1:bins]-1,:);
equalize = defmatrix(2*[1:bins],:);  
minX = defmatrix(1,:);
maxX = defmatrix(2*bins+1,:);

X = zeros(k,n);
W = zeros(k,n);
for i = 1:k
   x = DATA(i,:)';
   binx = sum(ones(bins,1)*x'>beginbin);
   Wbelow = binx < 1;
   Wabove = binx > bins;
   W(i,:) = Wbelow + Wabove;
   binx(find(Wbelow)) = 1;
   binx(find(Wabove)) = bins;
   for j = 1:n
      X(i,j) = minX(j) + (binx(j)-1)*(maxX(j)-minX(j))/bins + ...
         equalize(binx(j))*(x(j)-beginbin(binx(j)));
   end
end

