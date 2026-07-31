% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



%   Ensures that the points that SIMULANNEAL  move forward with
%   are always feasible.  It does so by checking to see if the given point
%   is outside of the bounds, and then if it is, creating a point called
%   which is on the bound that was being violated and then generating a new
%   point on the line between the previous point and the new projxk. It is
%   assumed that x0 is within bounds.

lb = [0;0];
ub = [3;3];

x0 = lb + (ub-lb).*rand(2,1);
dk = lb + (ub-lb).*rand(2,1);

xk = x0 + dk;

lbound = xk < lb;
ubound = xk > ub;
alpha = rand;
% Project xk to the feasible region; get a random point as a convex
% combination of proj(xk) and x0 (already feasible)
if any(lbound) || any(ubound)
    projxk = xk;
    projxk(lbound) = lb(lbound);
    projxk(ubound) = ub(ubound);
    newx = alpha*projxk + (1-alpha)*x0;
    
    % Create figure
    figure1 = figure('Color',[1 1 1]);
    colormap('gray');

    % Create axes
    axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Helvecia');
    box(axes1,'on');
    hold(axes1,'all');
    
    
    plot([x0(1);xk(1);projxk(1);newx(1)],[x0(2);xk(2);projxk(2);newx(2)],...
            'Marker','o','MarkerSize',12,'Color',[0 0 0],'LineStyle','none')
    
    plot([x0(1);projxk(1)],[x0(2);projxk(2)],...
        'Color',[0 0 0])
   
    stem([lb(1); ub(1)],ub,'r--o')
    plot([lb(1) ub(1)], ub,'r--o',[lb(2) ub(2)], lb,'r--o')
    
    
    
else
    newx = xk;
end