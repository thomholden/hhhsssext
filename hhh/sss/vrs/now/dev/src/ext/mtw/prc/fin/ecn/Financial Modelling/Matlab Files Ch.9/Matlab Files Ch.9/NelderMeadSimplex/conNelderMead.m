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



function [xMin,fMin,iter] = conNelderMead(objF,conF,x0,alfa,beta,gamma)
% Nelder-Mead Downhill simplex for constrained problems

%problem dimension
N = length(x0);
% reflection coefficient
if nargin < 4 || isempty(alfa)
   alfa = 0.95; 
end
% contraction coefficient
if nargin < 5 || isempty(beta)
   beta = 0.5; 
end
% expansion coefficient
if nargin < 5 || isempty(gamma)
   gamma = 2.0; 
end

% shrinkage coefficient
delta = 0.5;
% termination tolerance
TOL = sqrt(eps);
% maximum iteration steps
iterMax = 5000*N;

% setup a feasible simplex with vertices v0,...,vn
Sk = repmat(x0,1,N+1);

% auxiliary variables
I0 = x0 == 0.0;
x = delta*x0;
x(I0) = delta;

% vertex v0
Sk(:,1) = Sk(:,1)-x;
% vertices v1,...,vN
Sk(:,2:end) = Sk(:,2:end) + diag(x);

I1 = conF(Sk(:,1)) > 0; %checks if vertex v0 is admissible
deltaTmp = delta;
while sum(I1) > 0 && deltaTmp > TOL
    deltaTmp = .5*deltaTmp;
    Sk(:,1) = (1-deltaTmp)*x0;
    Sk(I0,1) = -deltaTmp;
    I1 = conF(Sk(:,1)) > 0;
end

%identity matrix
iMat = eye(N);
for i=2:N+1
    I1 = conF(Sk(:,i)) > 0; %checks if vertex vi, i=1,...,n is admissible
    deltaTmp = delta;
    while sum(I1) > 0 && deltaTmp > TOL
        deltaTmp = .5*deltaTmp;
        x = deltaTmp*x0;
        x(I0) = deltaTmp;
        Sk(:,i) = x0 + iMat(:,i-1).*x;
        I1 = conF(Sk(:,i)) > 0;
    end
end

% sort function values in ascending order
[fval,I2] = sort(objF(Sk));
% ordered simplex
Sk = Sk(:,I2);

v0 = Sk(:,1);
f0 = fval(1);

vn = Sk(:,N+1);
fn = fval(N+1);

% calculate centroid of v0,...,vn-1
vhat = mean(Sk(:,1:N),2);
% compute reflection point xr
xr = (1+alfa)*vhat - alfa*vn;
fr = objF(xr);

vk = xr;
fk = fr;

if fr < fval(N)
    if fr < f0
        % compute expansion point xe
        xe = (1-gamma)*vhat + gamma*xr;
        fe = objF(xe);
        if sum(conF(xe) > 0) == 0 && fe < f0
            vk = xe;
            fk = fe;
        end
    end
else
    if sum(conF(xr) > 0) == 0
        vtmp = vn;
        if fr < fn
            vtmp = xr;
        end

        % compute partial contraction point xc
        xc = (1-beta)*vhat + beta*vtmp;
        fc = objF(xc);
        if fc < fn
            vk = xc;
            fk = fc;
        end

        % compute total contration / shrinkage
        if fc >= fn
            Sk(:,2:N+1) = 0.5*(repmat(v0,1,N)+Sk(:,2:N+1));
            fval(2:N+1) = objF(Sk(:,2:N));
            vk = Sk(:,N+1);
            fk = fval(N+1);
        end

    end
    
end

%update simplex
Sk = [Sk(:,1:N),vk];
% sort function values in ascending order
[fval,I2] = sort([fval(1:N),fk]);
% ordered simplex
Sk = Sk(:,I2);

        

iter = 1;
while (max(max(abs(repmat(Sk(:,1),1,N)-Sk(:,2:end)))) > TOL ...
        || std(fval) > TOL) ... 
        && iter < iterMax
            
    % if vk infeasible / assign large positive function value to vertex vk
    if sum(conF(vk) > 0) > 0
        fval(fval == fk) = 1e+100;
    end
    
    v0 = Sk(:,1);
    f0 = fval(1);

    vn = Sk(:,N+1);
    fn = fval(N+1);
 
    
    % calculate centroid of v0,...,vn-1
    vhat = mean(Sk(:,1:N),2);
    % compute reflection point xr
    xr = (1+alfa)*vhat - alfa*vn;
    fxr = objF(xr);
    
    vk = xr;
    fk = fxr;

    if fxr < fval(N)
        if fxr < f0
            % compute expansion point xe
            xe = (1-gamma)*vhat + gamma*xr;
            fe = objF(xe);
            if sum(conF(xe) > 0) == 0 && fe < f0
                vk = xe;
                fk = fe;
            end
        end
    else
        if sum(conF(xr) > 0) == 0 && sum(conF(vn) > 0) == 0 && fn <= 1e+99
            vtmp = vn;
            if fxr < fn
                vtmp = xr;
            end

            % compute partial contraction point xc
            xc = (1-beta)*vhat + beta*vtmp;
            fc = objF(xc);
            if fc < fn
                vk = xc;
                fk = fc;
            end
            % compute total contration / shrinkage
            if fc > fn
                Sk(:,2:N+1) = 0.5*(repmat(v0,1,N)+Sk(:,2:N+1));
                fval(2:N+1) = max([objF(Sk(:,2:N+1));fval(2:N+1)]);
                vk = Sk(:,N+1);
                fk = fval(N+1);
            end
        end
    end
    
    %update simplex
    Sk = [Sk(:,1:N),vk];
    % sort function values in ascending order
    [fval,I2] = sort([fval(1:N),fk]);
    % ordered simplex
    Sk = Sk(:,I2);
    
    % counts number of iterations
    iter = iter + 1;
    
end


xMin = Sk(:,1);
fMin = fval(1);


end

