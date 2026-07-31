function lambda=bsElasticity(CallPutFlag, S,X,T,r,r_f, sigma) 
    % Sensitivity in percent to a percent movement in the underlying asset
    % price
    
    lambda=bsDelta(CallPutFlag, S,X,T,r,r_f, sigma)*S./GKprice(CallPutFlag, S,X,T,r,r_f, sigma);
    
end

%   version: v1.0
%   author: Yazann Romahi [yazann@romahi.com]