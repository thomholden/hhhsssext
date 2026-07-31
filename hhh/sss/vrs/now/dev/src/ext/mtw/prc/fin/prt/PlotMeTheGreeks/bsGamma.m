function gamma=bsGamma(CallPutFlag, S,X,T,r,r_f, sigma) 
    %sigma=sigma+0.0000000001;
    %T=T+0.0000000001;
    d1=(log(S./X)+(r-r_f+(sigma.^2)./2).*T)./(sigma.*sqrt(T));
    nd1=(1./(sqrt(2.*pi)) .* exp(-d1.^2/2));
    gamma=(nd1.*exp(-r_f.*T))./(S.*sigma.*sqrt(T));
    
    
end

% bsGamma(CallPutFlag, S, X, T, r, r_f, sigma)
% 
% Returns Garman-Kohlhagen Gamma for a European currency option

%   version: v1.0
%   author: Yazann Romahi [yazann@romahi.com]