function VarVega=bsVarVega(CallPutFlag, S,X,T,r,r_f, sigma) 
    %sigma=sigma+0.0000000001;
    %T=T+0.0000000001;
    d1=(log(S./X)+(r-r_f+(sigma.^2)./2).*T)./(sigma.*sqrt(T));
    nd1=(1./sqrt(2.*pi))*exp(-d1.^2/2);
    %vega=S.*exp(-r_f.*T).*nd1.*sqrt(T)
    VarVega=(S.*sqrt(T)./(2*sigma)) .* nd1;
end

% bsVarVega(CallPutFlag, S, X, T, r, r_f, sigma)
% Returns Garman-Kohlhagen Variance-Vega for a European currency option

%   version: v1.0
%   author: Yazann Romahi [yazann@romahi.com]