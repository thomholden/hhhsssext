function delta=bsDelta(CallPutFlag, S,X,T,r,r_f, sigma) 
        T=T+1-1;
        d1=(log(S./X)+(r-r_f+(sigma.^2)./2)*T)./(sigma.*sqrt(T));
        if CallPutFlag == 'C' 
            delta=normcdf(d1).*exp(-r_f*T);
        else
            delta=(normcdf(d1)-1).*exp(-r_f.*T);
        end

end

          

% Delta(CallPutFlag, S, X, T, r, r_f, sigma) - Yazann Romahi, 2002
% 
% Returns Garman-Kohlhagen Delta for a European currency option

%   version: v1.0
%   author: Yazann Romahi [yazann@romahi.com]