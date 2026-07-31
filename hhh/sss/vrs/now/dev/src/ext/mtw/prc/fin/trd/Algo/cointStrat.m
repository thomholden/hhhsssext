function [sh,pnl,pos] = cointStrat(X,Y,N,M)
% cointegration routine
% use N days of history and rebalance every M days
lX=length(X);
I = ones(N,1);
pos = zeros(lX,2);
for i=1:lX-N-1
    xwind = X(i:N+i-1);
    ywind = Y(i:N+i-1);
    if rem(i,M)==1
        % do the regression
        beta = [I,xwind]\ywind;
        % test for cointegration
    end
    % form the residuals
    res = ywind - [I,xwind]*beta;
    % if the coint test is true, then use positions
    if 1
        stdres = std(res(1:end-1));
        % check the spread is large
        if res(end) > 1.5*stdres
            % Y is too high compared with X, sell Y, buy X
            pos(N+i,:)=[beta(2),-1];
        elseif res(end)<1.5*stdres
            % Y too low compared with X, buy Y, sell X
            pos(N+i,:)=[-beta(2),1];
        else
            pos(N+i,:)=[0 0];
            %pos(N+i,:)=pos(N+i-1,:);
        end
    end
end

% work out the P&L
dx=diff([X,Y],1,1);
pnl = (sum(dx.*pos(1:end-1,:),2));
sh = sqrt(250)*mean(pnl)/std(pnl);