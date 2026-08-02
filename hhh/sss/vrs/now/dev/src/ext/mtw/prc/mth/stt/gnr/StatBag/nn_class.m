function [yclass] = nn_class (x,y,xtest)

% function [yclass] = nn_class (x,y,xtest)
% For two-class problems only

if max(y) > 1
  disp('Error in nn_class: this routine for two-class classification only');
  return
end
  
c0=find(y(:,1)==0);
c1=find(y(:,1)==1);
class0=x(c0,:);
class1=x(c1,:);
Ntest=size(xtest,1);
for i=1:Ntest,
    yclass(i,:) = nn (class0, class1, xtest(i,:), 0.5, 0.5);
end    
  
  
  