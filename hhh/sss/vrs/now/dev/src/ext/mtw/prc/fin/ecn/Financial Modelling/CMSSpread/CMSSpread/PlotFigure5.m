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
% (C) Joerg Kienitz, Daniel Wetterau and Sven Glaser
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 


function [  ] = PlotFigure5( T,kappa,xi,V,titstr)
t=0:0.005:1;
y=0*t;
x=[.6,1.25,2.5,5];
for j=1:length(x)
a=1./x(j);
h=@(u)x(j)*u+imag(fHut(u*1i,kappa,xi,T,V))-pi/2;
if x(j)<10     % we use Newton iteration for larger values
    b=fzero(h,[0,10^16]);
else
    b=pi/8;
    for i=1:4   % we use 4 Newton steps
        b=b-h(b)*(1e-10)/(h(b+1e-10)-h(b));
    end
end
for i=1:length(t)
    y(i,j) = imag(exp(x(j) .* (a-3.*log(t(i)).*(b*1i-a))) .* fHut(a-3.*log(t(i)).*(b*1i-a),kappa,xi,T,V) .* (3./t(i)) .* (b*1i-a));
end
end
figure('Color', [1 1 1]);
hold on;
plot(t,y(:,1),'-','Color',[0 0 0]);
plot(t,y(:,2),'--','Color',[0 0 0]);
plot(t,y(:,3),':','Color',[0 0 0])
plot(t,y(:,4),'-.','Color',[0 0 0]);
%plot(t,y(:,5),'.-');
legend('x = 0.6','x = 1.25','x = 2.5','x = 5');
%legend('x = 0.6','x = 1.25','x = 2.5','x = 5','x = 15');
set(legend,'Position',[0.1658 0.6639 0.1893 0.2333]);
title(titstr);
end