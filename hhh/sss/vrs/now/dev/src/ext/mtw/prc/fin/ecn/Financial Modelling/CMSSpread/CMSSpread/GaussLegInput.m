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


function [points, weights] = GaussLegInput(lowerBound,upperBound,NumberPoints)
% Calculate the Gauss Legendre Points and Weights for evaluating the
% integral
% int_lowerBound^upperBound f(x) dx using NumberPoints evaluation points

n = floor(0.5*NumberPoints);
xm = 0.5*(lowerBound + upperBound);
xl = 0.5*(upperBound - lowerBound);

J = 0:n-1;

z = cos(pi*(J+0.75)/(NumberPoints+0.5));

err = false;

I = J+1;
t1=1; t2=0;

% despite the fact Matlab suggest to preallocate this significantly
% reduces the speed!!!!!
%p1 = ones(size(I)); p2 = zeros(size(I)); p3 = p1; pp = p1; z1 = p1; z = p1;

while(err ~= true)
    p1(I)= t1;
    p2(I)= t2;
    for k=0:NumberPoints-1
        p3(I)=p2(I);
        p2(I)=p1(I);
        p1(I)=((2.0*k+1.0).*z(I).*p2(I)-k*p3(I))/(k+1.0);
    end
    pp(I) = NumberPoints*(z(I).*p1(I)-p2(I))./(z(I).*z(I)-1.0);
    z1(I) = z(I);
    z(I) = z1(I)-p1(I)./pp(I);
    I = find(abs(z(I)-z1(I)) > sqrt(eps));
    if(isempty(I))
        err = true;
    end
end

points = xm-xl*z;
points = [points'; (xm-(points(end:-1:1)-xm))'];    % Gauss Legendre Points
weights = 2.0*xl./((1.0-z.*z).*pp.*pp); 
weights = [weights'; weights(end:-1:1)'];           % Gauss Legendre Weights
