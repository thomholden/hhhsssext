function c = GKprice(CallPutFlag, S, X, T, r, r_f, sigma)
    sigma=sigma+0.0000001; % To avoid 0 sigma divide by zero error
    T=T+0.0000001; % To avoid 0 T divide by zero error
    d1=(log(S./X)+(r-r_f+(sigma.^2)./2)*T)./(sigma.*sqrt(T));
    d2=d1-(sigma.*sqrt(T));
    
    if CallPutFlag == 'C' 
        c=S.*normcdf(d1).*exp(-r_f*T) - X.*normcdf(d2).*exp(-r*T);
    else
        c=X.*normcdf(-d2).*exp(-r*T) - S.*normcdf(-d1).*exp(-r_f*T);
    end
end

% GKprice(CallPutFlag, S, X, T, r, r_f, sigma) 
% 
% Returns Garman-Kohlhagen (1983) modified Black-Scholes price for a
% European currency option

%   version: v1.0
%   author: Yazann Romahi [yazann@romahi.com]