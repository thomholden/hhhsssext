
% the training data in the transform dmain.

wavelet_data=zeros(N1,N2,T);

for t=1:T
  h=transforms(1,t);
  v=transforms(2,t);
  r=transforms(3,t);

  wavelet_data(:,:,t)= ...
	atomic_rep(inv_transform(training_data{t},h,v,r));
end


