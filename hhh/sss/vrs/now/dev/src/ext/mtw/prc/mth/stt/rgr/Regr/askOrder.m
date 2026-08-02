
function [N] = askorder(LAMBDA)

%   [N] = askorder(LAMBDA)
%
% Determine interactively the model order.
% This routine is to be called only by other functions
%
% Input parameters:
%  - LAMBDA: Vector of latent vector weights
% Return parameters:
%  - N: Selected order
%
% Heikki Hyotyniemi Dec.20, 2000


OK = 0;
N = 1;
n = length(LAMBDA);
fig = figure(10);
while OK == 0
   set(fig,'Name','Latent vector selection window');
   clf;
   hold on;
   plot(LAMBDA,'b');
   plot(LAMBDA,'b*');
   axis([1-0.1*n,n+0.1*n,0,max(LAMBDA)+0.1*max(LAMBDA)]);
   xlabel('Latent vector index');
   plot([N,N],[0,max(LAMBDA)+0.1*max(LAMBDA)],'r');
   text(N+0.02*n,LAMBDA(N),[num2str(round(1000*sum(LAMBDA(1:N))/(10*sum(LAMBDA)))),'% of maximun']);
   plot(LAMBDA(1:N),'m');
   plot(LAMBDA(1:N),'m*');
   plot(LAMBDA(1:N),'mo');
   title('Change the number of latent vectors using mouse (or press <return> if OK)');
   try
      [x,y] = ginput(1);
      if isempty(x) | x < 0.5 | x > n+0.5
         OK = 1;
      else
         N = round(x);
      end
   catch
      disp(['With ',num2str(N),' latent vectors ',num2str(sum(LAMBDA(1:N))/sum(LAMBDA)),'% of maximum captured']);
      OK = 1;
   end
end
