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

function y = svol_2(a, b, r, n, f, k, t)
% implied vol for the SABR model

    y= ones(1,length(k));
    
	Term1 = a/f.^(1-b);
	Term2 = ((1-b)^2/24*a^2/f^(2-2*b) + r*b*a*n/4/f^(1-b) + (2-3*r^2)*n^2/24);
	y(abs(f-k)<= 0.00001) = Term1*(1 + Term2*t);

	z = n/a*(f*k).^((1-b)/2).*log(f./k);
	x = log((sqrt(1 - 2*r*z + z.^2) + z - r)/(1-r));
	Term1 = a ./ (f*k).^((1-b)/2) ./ (1 + (1-b)^2/24*log(f./k).^2 + (1-b)^4/1920*log(f./k).^4);
	if abs(x-z) < 1e-10
		Term2 = 1;
	else
		Term2 = z ./ x;
	end
	Term3 = 1 + ((1-b)^2/24*a^2./(f*k).^(1-b) + r*b*n*a/4./(f*k).^((1-b)/2) + (2-3*r^2)/24*n^2)*t;
	y(abs(f-k)>0.00001) = Term1(abs(f-k)>0.00001).*Term2(abs(f-k)>0.00001).*Term3(abs(f-k)>0.00001);
end