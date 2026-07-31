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


InitVariables;              % example setting

T = [0.25 5 10];            % maturities
xi = [0.5 1.5 3];           % volatility of variance values
kappa = [0.05 0.1 0.5];     % reversion speed values
x = [1 5 10];               % xvalues
u=(0.01:0.01:10);           % values where we calculate the density
y = zeros(length(u),3);     % init the output variable

for k=1:length(T);
    y(:,k)=real(exp(x(2)*u*1i).*fHut(1i*u,kappa(3),xi(3),T(k),V));
end

% output
figure('Color', [1 1 1]); hold on;  % create figure and lock hold
plot(u,y(:,1),'Color', [0 0 0], 'LineStyle','-');
plot(u,y(:,2),'Color', [0 0 0], 'LineStyle','-.');
plot(u,y(:,3),'Color', [0 0 0], 'LineStyle',':');
legend('T=0.25', 'T=5', 'T=10');
title('Real part of Integrand for different values of T');
xlabel('u'); ylabel('R(f(u))');

hold off;                   % unlock hold 

for k=1:length(xi);
    y(:,k)=real(exp(x(2)*u*1i).*fHut(1i*u,kappa(3),xi(k),T(2),V));
end
% output
figure('Color', [1 1 1]); hold on;  % create figure and lock hold
plot(u,y(:,1),'Color', [0 0 0], 'LineStyle','-');
plot(u,y(:,2),'Color', [0 0 0], 'LineStyle','-.');
plot(u,y(:,3),'Color', [0 0 0], 'LineStyle',':');
legend('\nu=0.5', '\nu=1', '\nu=1.5', '\nu=2');
title('Real part of Integrand for different values of \nu');
xlabel('u'); ylabel('R(f(u))');

hold off;                           % unlock hold

for k=1:length(kappa);
    y(:,k)=real(exp(x(2)*u*1i).*fHut(1i*u,kappa(k),xi(3),T(2),V));
end
% output
figure('Color', [1 1 1]); hold on;      % create figure and lock hold
plot(u,y(:,1),'Color', [0 0 0], 'LineStyle','-');
plot(u,y(:,2),'Color', [0 0 0], 'LineStyle','-.');
plot(u,y(:,3),'Color', [0 0 0], 'LineStyle',':');
legend('\kappa=0.05', '\kappa=0.1', '\kappa=0.5');
title('Real part of Integrand for different values of \kappa');
xlabel('u'); ylabel('R(f(u))');
hold off;                               % unlock hold

for k=1:length(x);
    y(:,k)=real(exp(x(k)*u*1i).*fHut(1i*u,kappa(3),xi(3),T(2),V));
end
% output
figure('Color', [1 1 1]); hold on;      % create figure and lock hold
plot(u,y(:,1),'Color', [0 0 0], 'LineStyle','-');
plot(u,y(:,2),'Color', [0 0 0], 'LineStyle','-.');
plot(u,y(:,3),'Color', [0 0 0], 'LineStyle',':');
legend('x=1', 'x=5', 'x=10');
title('Real part of Integrand for different values of x');
xlabel('u'); ylabel('R(f(u))');
hold off;                               % unlock hold


clear; clc;