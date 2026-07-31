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


function [  ] = PlotFigure3( x,kappa,xi,T,V )
% This plot illustrates the optimal integration path used
% in chapter 4 of 
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% to calculate CMS Caplet prices

a=1/x;                              % for keeping values small for large x
slow = -4; shigh = 2; sstep=0.25;   
tlow = 0; thigh = 10; tstep = 0.5;
s=slow:sstep:shigh;                 % step values
t=tlow:tstep:thigh;                 % step value

RePlot=zeros(length(s),length(t));  % init output real part
ImPlot=RePlot;                      % init output imag part
for i=1:length(s)
    z=s(i)+1i*t;
    RePlot(i,:)=max(min(real(exp(x*z).*fHut(z,kappa,xi,T,V)),3),-3);
    ImPlot(i,:)=max(min(imag(exp(x*z).*fHut(z,kappa,xi,T,V)),3),-3);
end
% output
figure('Color', [1 1 1]); colormap('bone');grid('on');
subplot(1,2,1); surf(t,s,RePlot);
set(gca,'XDir','reverse')
hold on

% different integration paths
b=.09;                              % path I
r=a+(0:0.05:min(shigh/a+1,thigh/b))*(b*1i-a);
darkgrayLine=min(max(real(exp(x*r).*fHut(r,kappa,xi,T,V)),-3),3);
subplot(1,2,1);  plot3(imag(r),real(r),darkgrayLine, ...
    'Color',[0.8 0.8 0.8],'Marker','o','MarkerSize',2);

b=15;                               % path II
r=a+(0:0.05:min(shigh/a+1,thigh/b))*(b*1i-a);
whiteLine=min(max(real(exp(x*r).*fHut(r,kappa,xi,T,V)),-3),3);
subplot(1,2,1); plot3(imag(r),real(r),whiteLine, ...
    'Color',[1 1 1],'Marker','o','MarkerSize',4);

% b=.768 do calculations for optimal path path III
h=@(u)x*u+imag(fHut(u*1i,kappa,xi,T,V))-pi/2;
if x<10     % for larger values of x we use Newton iteration
    b=fzero(h,[0,10^16]);
else
    b=pi/8;
    for i=1:4   % we use 4 Newton iteration steps
        b=b-h(b)*(1e-10)/(h(b+1e-10)-h(b));
    end
end

r=a+(0:0.05:min(shigh/a+1,thigh/b))*(b*1i-a);
blackLine=min(max(real(exp(x*r).*fHut(r,kappa,xi,T,V)),-3),3);
subplot(1,2,1); plot3(imag(r),real(r),blackLine, ...
    'Color',[0 0 0],'Marker','o','MarkerSize',4);
box('on');
title(['Real Part of Integrand T=', num2str(T)]);
zlabel('Value of Integrand');
xlabel('Real part of argument');
ylabel('Imag part of argument');
hold off                        % unlock hold


% new plot
subplot(1,2,2); surf(t,s,ImPlot); set(gca,'XDir','reverse')
hold on                         % lock hold

b=.09;                         % path I
r=a+(0:0.05:min(shigh/a+1,thigh/b))*(b*1i-a);
darkgrayLine=min(max(imag(exp(x*r).*fHut(r,kappa,xi,T,V)),-3),3);
subplot(1,2,2);  plot3(imag(r),real(r),darkgrayLine, ...
    'Color',[0.8 0.8 0.8],'Marker','o','MarkerSize',4);

b=15;                           % path II
r=a+(0:0.05:min(shigh/a+1,thigh/b))*(b*1i-a);
whiteLine=min(max(imag(exp(x*r).*fHut(r,kappa,xi,T,V)),-3),3);
subplot(1,2,2); plot3(imag(r),real(r),whiteLine, ...
    'Color',[1 1 1],'Marker','o','MarkerSize',4);

% b=.768; caluclate optimal path path III
h=@(u)x*u+imag(fHut(u*1i,kappa,xi,T,V))-pi/2;
if x<10     % for larger value we need Newton iteration
    b=fzero(h,[0,10^16]);
else
    b=pi/8;
    for i=1:4   % we use 4 Newton steps here
        b=b-h(b)*(1e-10)/(h(b+1e-10)-h(b));
    end
end

r=a+(0:0.05:min(shigh/a+1,thigh/b))*(b*1i-a);
blackLine=min(max(imag(exp(x*r).*fHut(r,kappa,xi,T,V)),-3),3);
subplot(1,2,2); plot3(imag(r),real(r),blackLine, ...
    'Color',[0 0 0],'Marker','o','MarkerSize',4);
title(['Imaginary Part of Integrand T=', num2str(T)]);
zlabel('Value of Integrand');
xlabel('Real part of argument');
ylabel('Imag part of argument');
hold off                        % unlock hold

box('on');

end

