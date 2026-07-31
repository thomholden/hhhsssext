function r=CalcRet(asset,T,wts)
% Calculate single asset or portfolio of assets geometric return
% Input:
%   asset - matrix of assets historical prices
%   T - period for return calculation
%   wts - assets weight in portfolio
% (c) by A. Ivanov
[N M]=size(asset);
if M > 1 
   % portfolio
   if size(wts,2)~=M
      error('Error: Assets matrix row length and weights length must be equal')
   end   
   %if sum(wts)~=1
   %  error('Error: Assets weights must sum to unity')
   %end   
   r=zeros(N-1,M);
   r=log(asset(1+T:N,:)./asset(1:N-T,:));   
   r=r*wts';       % wts is a row
else 
   %if T > 1
   % [shortma,longma] = movavg(asset,T,T,1);
   % r=log(longma(1+2*T:N)./longma(1+T:N-T));
   %else
   r=log(asset(1+T:N)./asset(1:N-T));
   %end
end
