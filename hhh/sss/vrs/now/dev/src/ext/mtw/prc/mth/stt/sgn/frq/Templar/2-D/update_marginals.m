%
% update the estimate for the parameters based on the most recent estimate of
% the most likely transformations for each training image.
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

second_moment=zeros(N1,N2);
  
template.high_mean=sum(wavelet_data,3)./T; % ML estimate.

second_moment = sum(wavelet_data.^2,3)./T;
template.high_var=second_moment - template.high_mean.^2;

