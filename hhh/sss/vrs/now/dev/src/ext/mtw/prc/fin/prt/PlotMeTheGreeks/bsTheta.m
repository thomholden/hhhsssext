function theta=bsTheta(CallPutFlag, S,X,T,r,r_f, sigma) 

    
    d1=(log(S./X)+(r-r_f+(sigma.^2)./2).*T)./(sigma.*sqrt(T));
    d2=d1-sigma.*sqrt(T);
    nd1=(1/sqrt(2.*pi)).*exp(-d1.^2/2);
    
    if CallPutFlag=='C'
        part1= -(S.*exp(-r_f.*T).*nd1.*sigma)./(2.*sqrt(T));
        part2= r_f.*S.*exp(-r_f.*T).*normcdf(d1);
        part3= r .* X .* exp(-r .* T) .* normcdf(d2);
        theta= part1 + part2 - part3;
    else
        theta=-(S.*exp(-r_f.*T).*nd1.*sigma)./(2.*sqrt(T)) -r_f.*S.*exp(-r_f.*T).*normcdf(-d1)+ r .* X .* exp(-r .* T) .* normcdf(-d2);
    end
    TimeDecayPeriodInDays=1;
    theta=theta.*TimeDecayPeriodInDays/260;
end

% bsTheta(CallPutFlag, S, X, T, r, r_f, sigma)
% 
% Returns Garman-Kohlhagen Theta for a European currency option

%   version: v1.0
%   author: Yazann Romahi [yazann@romahi.com]