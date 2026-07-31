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

function alfa = optimalAlpha(model,lnS,lnK,T,r,d,varargin)
% calculation of the optimal alpha
% This implementation is due to an algorithm of Kahl and Lord

%if strcmp(model,'BS') || strcmp(model,'BlackScholes') && lnK > lnS
%    alfa = BS_alfaOpt(lnS,lnK,T,r,d,varargin{:});
%elseif strcmp(model,'VG') || strcmp(model,'VarianceGamma') && lnK > lnS
%    alfa = VG_alfaOpt(lnS,lnK,T,r,d,varargin{:});
%else
    ME = MException('Iteration:Overflow','Divergence');
    TOL = 1e-7;
    h = 1e-6;
    xold = 0.01;%*ones(size(lnK));
    xnew = 0.02;
    alfa = zeros(size(lnK));
    for i = 1:length(lnK)

        %x = (0.01:0.01:200)';
        %y = feval(@Psi,x,lnK(31),model,lnS,T,r,d,varargin{:});
        %y1 = (feval(@Psi,x+0.00001,lnK(31),model,lnS,T,r,d,varargin{:})-y)/0.00001;

        %plot(x,y,x,y1)

        fh = feval(@Psi,xold+h,lnK(i),model,lnS,T,r,d,varargin{:});
        f = feval(@Psi,xold,lnK(i),model,lnS,T,r,d,varargin{:});
        fxold = (fh-f)/h;
        maxIter = 1000;
        iter = 0;
        dx = 0;
        while max(abs(xnew - xold)) > TOL && iter < maxIter && abs(fxold) > TOL
            iter = iter +1;
            fh = feval(@Psi,xnew+h,lnK(i),model,lnS,T,r,d,varargin{:});
            f = feval(@Psi,xnew,lnK(i),model,lnS,T,r,d,varargin{:});
            if imag(f) == 0 && imag(fh) == 0
                fxnew = (fh-f)/h;                
                dx = (xnew - xold)./(fxnew - fxold).*fxnew;
                xold = xnew;
                xnew = xnew - dx;
                fxold = fxnew;
            else
                a = dx;
                while imag(f) ~= 0 || imag(fh) ~= 0 && iter < maxIter
                    a = a/2;
                    fh = feval(@Psi,xold-a+h,lnK(i),model,lnS,T,r,d,varargin{:});
                    f = feval(@Psi,xold-a,lnK(i),model,lnS,T,r,d,varargin{:});
                    iter = iter +1;
                end
                dx = a;
                xnew = xold - dx;
                fxnew = (fh-f)/h;
            end
            while fxnew*fxold < 0 && iter < maxIter
                xmid = (xold+xnew)/2;
                fh = feval(@Psi,xmid+h,lnK(i),model,lnS,T,r,d,varargin{:});
                f = feval(@Psi,xmid,lnK(i),model,lnS,T,r,d,varargin{:});
                fmid = (fh-f)/h;
                if fmid*fxold < 0
                    xnew = xmid;
                    fxnew = xmid;
                else
                    xold = xmid;
                    fxold = fmid;
                end
                iter = iter +1;
            end
            %fxold = fxnew;
        end

        if iter == maxIter
            throw(ME)
        end
        alfa(i) = xnew;
        xnew = xnew*4/5;
        xold = xnew*3/5;
    end

%end

end


function y = Psi(alfa,k,model,varargin)
y = - alfa .* k + feval(@CharacteristicFunctionLib, model, - i * (alfa + 1), varargin{:}) - log(alfa.*(alfa+1));
end

function alfa = BS_alfaOpt(lnS,lnK,T,r,d,sigma)
d1 = (lnS - lnK + (r - d + 0.5 * sigma^2) * T) / sigma / sqrt(T);
alfa = -d1 / sigma / sqrt(T);
end

function alfa = VG_alfaOpt(lnS,lnK,T,r,d,sigma,VG_nu,VG_theta)
VG_omega = (1/VG_nu)*( log(1-VG_theta*VG_nu-sigma*sigma*VG_nu/2) );
mtilde = lnS+(r-d)*T-lnK+VG_omega*T;
alfa = VG_theta/sigma^2+1-T/(VG_nu*mtilde)+sign(mtilde)*sqrt((VG_theta/sigma^2)^2+2/VG_nu/sigma^2+(T/(VG_nu*mtilde))^2);
end
