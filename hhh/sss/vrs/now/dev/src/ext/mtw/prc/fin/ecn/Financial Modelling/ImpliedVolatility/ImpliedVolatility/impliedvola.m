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

function [impvol, iterations] = impliedvola(Fwd, Strike, T, ...
        OptionValue, CallOrPut)
% determines the dimension of Fwd, Strike, T and OptionValue provided
% equality
% this is a way to derive implied vol due to Peter Jaeckel
N = length(Fwd);
M = length(Strike);

if length(CallOrPut)==1
    CallOrPut=CallOrPut*ones(N,M);
end

impvol = zeros(N,M);
iterations = zeros(N,M);

for i = 1:N
    for k = 1:M
        if CallOrPut(i,k)==1 %in this case we have a call
            theta = 1;
        elseif CallOrPut(i,k)==0 %in this case we hava a put
            theta = -1;
        end

        %declaring and setting required variables
            %normalised moneyness
            x = log(Fwd(i)/Strike(k));
            absx = abs(x);

            %represents the normalised option price that is to be matched
            beta = OptionValue(i,k)/sqrt(Fwd(i)*Strike(k));
            
            if((Fwd(i) / Strike(k)) ^ theta > 1)
                iota = heaviside(theta * x) * theta * (exp(1 / 2 * x) - exp(-1 / 2 * x));
                theta = 1 - 2 * heaviside(x);
                beta = beta - iota;
            end
    
            %point where normalised_optionprice(sigma) (=b) changes from convex to concave behaviour
            sigma_c = sqrt(2*abs(x));

            %normalised optionprice at sigma_c

            %special case ATM: setting b_c=0 instead of computed value (would
            %be division by zero -> NaN)
            if x==0
                b_c=0;
            else
                b_c = normalised_optionprice(sigma_c, x, theta);
            end

            iota = heaviside(theta*x)*theta*(exp(0.5*x)-exp(-0.5*x));

            %tolerance of newton iteration
            TOL = 1e-6;
            maxIter = 2000;

            %sigma(1)=old value in iteration, sigma(2)=new value in iteration
            sigma = zeros(2,1);

            %absolute value of relative error
            absrelerr = 1;

        %for choice of objective function and start values compare beta with b_c
        %now compute start values and begin newton iteration
        if beta<b_c
            %preparation for start values
                sigma_star     = -2*norminv((exp(0.5*theta*x))/(exp(0.5*theta*x)-b_c)*normcdf(-sqrt(0.5*absx)));
                b_star = normalised_optionprice(sigma_star, x, theta);

                sigma_highstar = -2*norminv((exp(0.5*theta*x)-b_star)/(exp(0.5*theta*x)-b_c)*normcdf(-sqrt(0.5*absx)));

                frac  = (b_star-iota)/(b_c-iota);
                sigma_lowstar  = sqrt((2*x*x)/(absx-4*log(frac)));

                frac  = (beta-iota)/(b_c-iota);
                sigma_low  = sqrt((2*x*x)/(absx-4*log(frac)));

                sigma_high = -2*norminv((exp(0.5*theta*x)-beta)/(exp(0.5*theta*x)-b_c)*normcdf(-sqrt(0.5*absx)));

                gamma = log((sigma_star-sigma_lowstar)/(sigma_highstar-sigma_lowstar))/log(b_star/b_c);
                w = min((beta/b_c)^gamma,1);

            sigma(1) = (1-w)*sigma_low + w*sigma_high;
            while(absrelerr>=TOL && iterations(i,k)<=maxIter)
                b_prime = exp(0.5*(x/sigma(1))*(x/sigma(1))-0.5*(sigma(1)/2)*(sigma(1)/2))/sqrt(2*pi);
                b = normalised_optionprice(sigma(1),x,theta);
                frac = (beta-iota)/(b-iota);
                nu = log(frac)*(log(b-iota)/log(beta-iota))*((b-iota)/b_prime);

                nu_hat = max(nu, -0.5*sigma(1));
                tmp = (x*x)/(sigma(1)*sigma(1)*sigma(1))-0.25*sigma(1);
                tmp2 = tmp - (2+log(b-iota))/log(b-iota)*(b_prime/(b-iota))*(beta<b_c);
                eta_hat = max(0.5*nu_hat*tmp2, -0.75);

                sigma(2) = sigma(1) + max(nu_hat/(1+eta_hat),-0.5*sigma(1));
                absrelerr=abs((sigma(2)-sigma(1))/sigma(1));
                sigma(1) = sigma(2);
                iterations(i,k) = iterations(i,k)+1;
            end
        else
            sigma(1) = -2*norminv((exp(0.5*theta*x)-beta)/(exp(0.5*theta*x)-b_c)*normcdf(-sqrt(0.5*absx)));
            while(absrelerr>=TOL && iterations(i,k)<=maxIter)
                b_prime = exp(0.5*(x/sigma(1))*(x/sigma(1))-0.5*(sigma(1)/2)*(sigma(1)/2))/sqrt(2*pi);
                b = normalised_optionprice(sigma(1),x,theta);
                nu = (beta-b)/b_prime;

                nu_hat = max(nu, -0.5*sigma(1));
                tmp = (x*x)/(sigma(1)*sigma(1)*sigma(1))-0.25*sigma(1);
                tmp2 = tmp - (2+log(b-iota))/log(b-iota)*(b_prime/(b-iota))*(beta<b_c);
                eta_hat = max(0.5*nu_hat*tmp2, -0.75);

                sigma(2) = sigma(1) + max(nu_hat/(1+eta_hat),-0.5*sigma(1));
                absrelerr=abs((sigma(2)-sigma(1))/sigma(1));
                sigma(1) = sigma(2);
                iterations(i,k)=iterations(i,k)+1;
            end
        end
    %    disp([num2str(iterations),'  ' ,num2str(absrelerr)])
        impvol(i,k) = sigma(2)/sqrt(T(i));
    end
end