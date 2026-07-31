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



function [R,JacR] = residualExample1(x,Y_true)

%  example 1:
vecN = (1:length(Y_true))'-1;

R = Y_true - (x(1) + x(2)*exp(-x(4)*vecN) + x(3)*exp(-x(5)*vecN));

JacR = zeros(length(Y_true),5);
JacR(:,1) = -1;
JacR(:,2) = -exp(-x(4)*vecN);
JacR(:,3) = -exp(-x(5)*vecN);
JacR(:,4) = x(2)*vecN.*exp(-x(4)*vecN);
JacR(:,5) = x(3)*vecN.*exp(-x(5)*vecN);