
function [W] = outl(X,W)

%   [W] = outl(X,W)
%   [W] = outl(X)
%
% Function eliminates outliers interactively.
% Feedback is given on the graphical screen -
% mouse clicks toggle the status of the nearest point 
%
% Input parameters:
%  - X: Data to be modeled (size k x n)
%  - W: Old vector containing 1 for valid data (optional)
% Return parameter:
%  - W: New vector containing 1 for valid data (size k x 1)
%
% Heikki Hyotyniemi Dec.21, 2000


[k,n] = size(X);
if nargin<2
   W = ones(k,1);
end

[V,L] = eig(X'*X/k);
[LL,order] = sort(diag(L));
LL = flipud(LL);
order = flipud(order);
V = V(:,order);

if n > 1
   pc = [1,2];
else
   pc = [1];
end

while length(pc) ~= 0 
   axes = V(:,pc);
   Z = X*axes;
   figure(1);
   clf;
   hold on;
   for i = 1:k
      if W(i) ~= 1
         if length(pc) == 1
            plot(i,Z(i,1),'bx');
         end
         if length(pc) == 2
            plot(Z(i,1),Z(i,2),'bx');
         end
         if length(pc) == 3
            plot3(Z(i,1),Z(i,2),Z(i,3),'bx');
            view([30,30]);
         end           
      else
         if length(pc) == 1
            plot(i,Z(i,1),'rx');
         end
         if length(pc) == 2
            plot(Z(i,1),Z(i,2),'rx');
         end
         if length(pc) == 3
            plot3(Z(i,1),Z(i,2),Z(i,3),'rx');
            view([30,30]);
         end           
      end
   end   
   if length(pc)==3
      xlabel(['Principal component ',num2str(pc(1))]);
      ylabel(['Principal component ',num2str(pc(2))]);
      zlabel(['Principal component ',num2str(pc(3))]);
      title('Three-dimensional view');
   else
      title('Select outliers using mouse (right button to end)');
      if length(pc) == 1
         xlabel(['Data index']);   
         ylabel(['Principal component ',num2str(pc(1))]);
      end
      if length(pc) == 2
         xlabel(['Principal component ',num2str(pc(1))]);   
         ylabel(['Principal component ',num2str(pc(2))]);
      end
   
      while 1==1
         [x,y,button] = ginput(1);
         if isempty(x) | button~=1, break; end;
         distance = inf;
         nearest = 0;
         if length(pc) == 1
            scalex = k;
            scaley = max(Z(:,1)) - min(Z(:,1));
            for i = 1:k
               newstance = ((x-i)/scalex)^2 + ((y-Z(i,1))/scaley)^2;
               if newstance<distance
                  nearest = i;
                  distance = newstance;
               end
            end
         end
         if length(pc) == 2
            scalex = max(Z(:,1)) - min(Z(:,1));
            scaley = max(Z(:,2)) - min(Z(:,2));
            for i = 1:k
               newstance = ((x-Z(i,1))/scalex)^2 + ((y-Z(i,2))/scaley)^2;
               if newstance<distance
                  nearest = i;
                  distance = newstance;
               end
            end
         end
         if length(pc) == 1
            if W(nearest) ~= 1
               W(nearest) = 1;
               plot(nearest,Z(nearest,1),'rx');
            else
               W(nearest) = 0;
               plot(nearest,Z(nearest,1),'bx');
               text(x,y,int2str(nearest));
            end
         end
         if length(pc) == 2
            if W(nearest) ~= 1
               W(nearest) = 1;
               plot(Z(nearest,1),Z(nearest,2),'rx');
            else
               W(nearest) = 0;
               plot(Z(nearest,1),Z(nearest,2),'bx');
               text(x,y,int2str(nearest));
            end
         end
      end   
   end
   pc = input('Give pc''s to project the data onto (1, 2, or 3 in list form, or <cr>)  ');
end
