function [class] = knn (class0, class1, pattern)

% function [class] = knn (class0, class1, pattern)
% k-nearest-neighbour classifier for two-class problems
% k is set to ceil(sqrt(N)) where N is the number of patterns
% See Duda and Hart p.95 to 98.
% k=sqrt(N) ensures that as N goes to infinity the volume enclosed
% by the k-nearest neighbours infinitely small yet contains an infinite
% number of points. Hence the estimated posterior probabilites from a 
% kNN density estimator
% class0	matrix
% class1	matrix
% pattern	vector to be classified

dp=size(pattern,2);
if ~(size(class0,2)==size(class1,2)) | ~(dp==size(class0,2))
	disp('Error in nn: patterns are unequal dimension');
	return
end


n=size(class0,1);
mpattern=ones(n,1)*pattern;
dzero=dmeuclid(class0,mpattern);

n=size(class1,1);
mpattern=ones(n,1)*pattern;
done=dmeuclid(class1,mpattern);

k=ceil(sqrt(2*n));

[y,i]=sort([dzero;done]);
labels=[zeros(n,1);ones(n,1)];
closest=labels(i);
p=mean(closest(1:k));
if p > 0.5
	class=1;
elseif p < 0.5
	class=0;
else
	if randn(1,1)<0
		class=0;
	else
		class=1;
	end
end

