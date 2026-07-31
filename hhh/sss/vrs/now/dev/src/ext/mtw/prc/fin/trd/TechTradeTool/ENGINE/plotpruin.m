function [plRuin]=plotpruin(NT,MT,XWO,XPL,XRF,NR);

if (MT>=2)
for j=1:MT
   k(j)=round(NT/j);
   [lb1(j), p1(j)]=pruin(k(j),XWO,XPL,0.50,XRF,NR);
   [lb2(j), p2(j)]=pruin(k(j),XWO,XPL,0.40,XRF,NR);
   [lb3(j), p3(j)]=pruin(k(j),XWO,XPL,0.30,XRF,NR);
end 
  p=[p1', p2', p3'];

plRuin=plot(k, p);
grid on;
h = legend('50% Ruin','40% Ruin','30% Ruin',2); 
ylabel('Probability of Ruin')
xlabel('Number of Trades')
title('Prob. of Ruin by following the System')

else 
t='Number of trades should be at least double than the number of points plotted'
end
