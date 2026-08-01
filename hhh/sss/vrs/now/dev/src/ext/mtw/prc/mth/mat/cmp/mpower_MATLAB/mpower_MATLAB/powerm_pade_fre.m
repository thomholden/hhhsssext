function [X,F,cond,nsq,m] = powerm_pade_fre(A,p,E)
%POWERM_PADE_FRE Matrix power, Frechet derivative and condition estimate.
%   X = POWERM_PADE_FRE(A,P) computes the P'th power X of the matrix A, 
%   for arbitrary real -1 < P < 1 and A with no nonpositive real
%   eigenvalues, by the Schur-Pade algorithm.
%
%   [X,F] = POWERM_PADE_FRE(A,P,E) computes the Frechet
%   derivative F at A in the direction E.
%
%   [X,F,COND] = POWERM_PADE_FRE(A,P,E) computes an estiamte COND of the
%   condition number.
%
%   [X,F,COND,NSQ,M] = POWERM_PADE_FRE(A,P,E) returns the number NSQ of matrix
%   square roots computed and the degree M of the Pade approximant used.
%   If A is singular or has any eigenvalues on the negative real axis,
%   a warning message is printed.
%
%   This code is intended for double precision.
%
%   See also LOGM, EXPM, FUNM.
%
%   Reference: N. J. Higham and L. Lin, An Improved Schur--Pade Algorithm 
%   for Fractional Powers of a Matrix and their Frechet Derivatives
%   MIMS Eprint 2013.1, January 2013.
%   Name of corresponding algorithm in that paper: Algorithm 4.2/SPade-Fre.
%
%   Nicholas J. Higham and Lijing Lin, May 3, 2013.

if ~isfloat(A) || ~ismatrix(A) || diff(size(A))
   error('MATLAB:powerm_pade_fre:InputDim',...
         'First input must be a floating point, square matrix.');
end
% See what user would like to calculate.
eval_fd = false;
eval_cond = false;
if nargout > 1
    eval_fd = true;
    if nargin < 3
        E = zeros(size(A));
    end
end
if nargout > 2
    eval_cond = true;
end

% Initialization.
n = length(A);
nsq = 0; m = 0;
maxsqrt = 64;
if eval_cond  % Save info that will be re-used
    isnormal = false;
    Troots = [];  % Troots used in powerm_frechet_only
    Xsqrs = [];   % Xsqrs used in powerm_frechet_only
end

% Trivial cases.
if p == 0, X = eye(n); F = zeros(n); cond = 0; return, end
if n == 1, X = A^p; F = p*A^(p-1)*E; cond = abs(A*F/X); return, end

% First form complex Schur form (if A not already upper triangular).
if isequal(A,triu(A))
   T = A; Q = eye(n); 
   if eval_fd, Es = E;   end
else
   [Q,T] = schur(A,'complex');
   if eval_fd, Es = Q'*E*Q; end
end

diagT = diag(T);
if ~all(diagT)
    warning('MATLAB:powerm_pade_fre:zeroEig', ...
            'Matrix power may not exist for singular matrix.')
end
if any( imag(diagT) == 0 & real(diagT) <= 0 )
    warning('MATLAB:powerm_pade_fre:nonPosRealEig', ...
           ['Principal matrix power is not defined for A with\n', ...
            '         nonpositive real eigenvalues. A non-principal matrix\n', ...
            '         power is returned.'])
end

if isequal(T,diag(diagT)) % Handle special case of diagonal T.
   isnormal = true;
   X = Q * diag(diagT.^p) * Q';
   if eval_fd
       K = zeros(n);
       for i = 1:n
           for j = i:n
               Tij = [T(i,i), 1; 0, T(j,j)];
               Kij = powerm2by2(Tij,p);   % divided difference
               K(i,j) = Kij(1,2);
               if i~=j, K(j,i)=K(i,j); end
           end
       end
       F = K .* Es;
       F = Q * F * Q';
   end
   if eval_cond
       %Get the condition number
       cond = norm(A, 1) * normest1(@powerm_frechet_only, 2, []) / norm(X, 1);
   end
   return
end

T_old = T;
q = 0;
xvals = [ % Max norm(X) for degree m Pade approximant to (I-X)^p.
          1.512666672122460e-005    % m = 1
          2.236550782529778e-003    % m = 2
          1.882832775783885e-002    % m = 3 being used
          6.036100693089764e-002    % m = 4 being used
          1.239372725584911e-001    % m = 5 being used
          1.998030690604271e-001    % m = 6 being used
          2.787629930862099e-001    % m = 7 being used
          3.547373395551596e-001    % m = 8
          4.245558801949280e-001    % m = 9
          4.870185637611313e-001    % m = 10
          5.420549053918690e-001    % m = 11
          5.901583155235642e-001    % m = 12
          6.320530128774397e-001    % m = 13
          6.685149002867240e-001    % m = 14
          7.002836650662422e-001    % m = 15
          7.280253837034645e-001    % m = 16
          9.152924199170567e-001    % m = 32
          9.764341682154458e-001 ]; % m = 64

% % new way of choosing m and s, based on the quantities alpha_p
foundm = false;
s0 = opt_cost(diagT); 
nsq = s0;
for s = 1:min(nsq,maxsqrt)
    T = sqrtm_tri(T);
    if eval_fd
        Es = sylv_tri(T,T,Es);
    end
    if eval_cond
        Troots(:,:,s) = T;
    end
end

d2 = normAm(T-eye(n),2)^(1/2); d3 = normAm(T-eye(n),3)^(1/3);
alpha2 = max(d2,d3);
if alpha2 <= xvals(2)
   m = find(alpha2 <= xvals(1:2),1); foundm = true;
end

while ~foundm
    more = 0; % more square roots
    if nsq > s0, d3 = normAm(T-eye(n),3)^(1/3); end
    d4 = normAm(T-eye(n),4)^(1/4);
    alpha3 = max(d3,d4);
    if alpha3 <= xvals(7)
        j = find( alpha3 <= xvals(3:7),1) + 2;
        if j <= 6
           m = j; break
        else
           if alpha3/2 <= xvals(5) && q < 2
               more = 1; q = q+1;
           end
        end
    end
    if ~more
        d5 = normAm(T-eye(n),5)^(1/5);
        alpha4 = max(d4,d5);
        eta = min(alpha3,alpha4);
        if eta <= xvals(7)
            m = find(eta <= xvals(6:7),1) + 5;
            break
        end
    end
    if nsq == maxsqrt, m = 13; break, end
    T = sqrtm_tri(T);
    if eval_fd
        Es = sylv_tri(T,T,Es);
    end
    nsq = nsq + 1;
    if eval_cond
        Troots(:,:,nsq) = T;
    end
    
end

% Compute accurate superdiagonal of T^(1/2^s).
for i = 1:n-1
    T(i:i+1,i:i+1) = powerm2by2(T_old(i:i+1,i:i+1),1/2^nsq);
end

% Compute accurate diagonal of I - T^(1/2^s). 
R = eye(n) - T;
d = sqrt_power_1(diag(T_old),nsq); % sqrt_power_1(a,n) for a^(1/2^n)-1.
R(1:n+1:end) = - d;    % we need 1- a^(1/2^n)

% Computes the [m/m] Pade approximant of the matrix power T^p = (I-R)^p and 
% its derivative by evaluating a continued fraction representation 
% and differentiating it in bottom-up fashion. 
j = 2*m;
cj = coeff(p,j);
Sj = cj*R;
if eval_fd 
    Es = -Es;  %  L_x^p(T,Es) = L_rm(I-T,-Es)
    F = cj*Es;
end
if eval_cond
    S(:,:,j) = Sj;   % saved for cond est.
end
for j = 2*m-1:-1:1  % bottom-up
    cj = coeff(p,j);
    Sjp1 = Sj;
    Sj = cj * ( (eye(n) + Sjp1)\R );
    if eval_fd
        F = (eye(n) + Sjp1)\(cj * Es - F*Sj);
    end
    if eval_cond
        S(:,:,j) = Sj;   % saved for cond est.
    end
end
X = eye(n) + Sj;

% Squaring phase, with directly computed diagonal and superdiagonal.
for s = 0:nsq
    if s ~= 0, 
        if eval_fd
            F = X*F + F*X;
        end
        X = X*X; % squaring
    end  
    for i = 1:n-1
        Tii = T_old(i:i+1,i:i+1);
        X(i:i+1,i:i+1) = powerm2by2(Tii,p/(2^(nsq-s)));
    end
    if eval_cond
        if s ~= nsq
            Xsqrs(:,:,s+1) = X;   % reuse X, X^2,..., X^{2^{s-1}} for cond
        end
    end
end
X = Q*X*Q';
if isreal(A) && norm(imag(X),1) <= 10*n*eps*norm(X,1)
   X = real(X);
end

if eval_fd
    F = Q*F*Q';
end

% Get the condition number.
if eval_cond
    cond = norm(A, 1) * normest1(@powerm_frechet_only, 2, []) / norm(X, 1);
end

%%%%%% Nested functions %%%%%
    function ss = opt_cost(d)
        % for i = 0:double(intmax)
        %     if max( abs(d-1)) <= xvals(mmax), s = i; return, end
        %     d = sqrt(d);
        % end
        ss = 0;
        while norm(d-1,inf) > xvals(7)
            d = sqrt(d); ss = ss+1;
        end
    end


    function [ vecD ] = powerm_frechet_only(flag, vecE)
    %Compute the derivative in a given direction without recomputing the
    %actual matrix power. Called by normest1 to get the conditioning of the
    %problem.
        t = size(vecE, 2);
        %When called by normest1 need to use flags
        skip = false;
        if strcmp(flag, 'real')
            vecD = isreal(A);  % && isreal (E); 
            %I don't think there is anything to do with the original E
            %here. --Lijing
            skip = true;
        elseif strcmp(flag, 'dim')
            vecD = n^2; skip = true;
        elseif strcmp(flag ,'transp')
            D = zeros(n,n,t);  % the derivatives
            Es = zeros(n,n,t);
            for k = 1:t
                Es(:,:,k) = unvec(vecE(:,k));
                Es(:,:,k) = Es(:,:,k)'; %Transpose
                Es(:,:,k) = findEs(Q' * Es(:,:,k) * Q, Troots);  
                % Do not need to separate the normal A case here since 
                % Troots = [] in that case and findEs will return E
            end
        elseif strcmp(flag, 'notransp')
            D = zeros(n,n,t); % the derivatives
            Es = zeros(n,n,t);
            for k = 1:t
                Es(:,:,k) = unvec(vecE(:,k));
                Es(:,:,k) = findEs(Q' * Es(:,:,k) * Q, Troots);
            end
        end
        %If we only need to return some data from the flags then skip
        if ~skip
            for k = 1:t
                if isnormal 
                    D(:,:,k) = K.* Es(:,:,k);
                    D(:,:,k) = Q * D(:,:,k) * Q';
                else  % Evaluate the Frechet deriv of the Pade approx.
                    Es = -Es;  % L_x^p(Ts,Es) = L_rm(I-Ts,-Es)
                    D(:,:,k) = coeff(p,2*m)*Es(:,:,k);
                    for jj = 2*m-1:-1:1  % bottom-up
                        cj = coeff(p,jj);
                        D(:,:,k) = (eye(n) + S(:,:,jj+1))\ ...
                            (cj * Es(:,:,k) - D(:,:,k)*S(:,:,jj));
                    end
                    D(:,:,k) = findLs(D(:,:,k),Xsqrs);
                    D(:,:,k) = Q * D(:,:,k) * Q';
                end
            end
            if strcmp(flag, 'transp')
                for k = 1:t
                    D(:,:,k) = D(:,:,k)';
                end
            end
            vecD = zeros(n^2, t);
            for k = 1:t
                vecD(:,k) = vec(D(:,:,k));
            end
        end
    end

	function c = coeff(p,i)
    %COEFF The ith coefficient in the continued fraction represtation 
    %of the [m/m] Pade approximation for (1-x)^p.
        if i == 1, c = -p; return, end
        jj = i/2;
        if jj == round(jj)
           c = (-jj + p) / (2*(2*jj-1));
        else
           jj = floor(jj);
           c = (-jj - p) / (2*(2*jj+1));
        end
    end

    function Es = findEs(E, Troots)
    %FINDES Finds the matrix Es that satisfies E = L_x^(2^s)(Ts,Es)
        ss = size(Troots, 3);
        %Fix for Troots = []
        if isempty(Troots)
            ss = 0;
        end
        Es = E;
        for b = 1:ss
            Es = sylv_tri(Troots(:,:,b),Troots(:,:,b),Es);
        end 
    end

    function Ls = findLs(L, Xsqrs)
    %FINDLS Finds the matrix Ls = L_{x^(2^s)}(X^{t/2^s},L) given X^{t/2^i}
        ss = size(Xsqrs, 3);
        %Fix for Troots = []
        if isempty(Xsqrs)
            ss = 0;
        end
        Ls = L;
        for b = 1:ss
            Ls = Ls*Xsqrs(:,:,b) + Xsqrs(:,:,b)*Ls;
        end 
    end

    function V = unvec(vec)
    %UNVEC Unvectorizes the column vector vec
    V = zeros(n);
        for b = 0:n-1
            V(:,b+1) = vec(1+b*n:(b+1)*n);
        end
    end

    function v = vec(mat)
    v = mat(:);
    end
end

%%%%%%%%%%%%%%  subfunctions  %%%%%%%%%%%%%%%%%%%%
function r = sqrt_power_1(a,n)
%SQRT_POWER_1    Accurate computation of a^(1/2^n)-1.
%  SQRT_POWER_1(A,N) computes a^(1/2^n)-1 accurately.
%
% A. H. Al-Mohy.  A more accurate Briggs method for the logarithm.
% Numer. Algorithms, DOI: 10.1007/s11075-011-9496-z.

if n == 0, r = a-1; return, end
n0 = n;
if angle(a) >= pi/2
    a = sqrt(a); n0 = n-1;
end
z0 = a - 1;
a = sqrt(a);
r = 1 + a;
for i=1:n0-1
    a = sqrt(a);
    r = r.*(1+a);
end
r = z0./r;
end


function R = sqrtm_tri(T)
%SQRTM_TRI   Upper triangular square root of upper triangular matrix.

n = length(T);
R = zeros(n);
for j=1:n
    R(j,j) = sqrt(T(j,j));
    for i=j-1:-1:1
        R(i,j) = (T(i,j) - R(i,i+1:j-1)*R(i+1:j-1,j))/(R(i,i) + R(j,j));
    end
end
end

function X = sylv_tri(T,U,B)
%SYLV_TRI    Solve triangular Sylvester equation.
%   X = SYLV_TRI(T,U,B) solves the Sylvester equation
%   T*X + X*U = B, where T and U are square upper triangular matrices.
m = length(T);
n = length(U);
X = zeros(m,n);
opts.UT = true;

% Forward substitution.
for i = 1:n
    X(:,i) = linsolve(T + U(i,i)*eye(m), B(:,i) - X(:,1:i-1)*U(1:i-1,i), opts);
end
end

function X = powerm2by2(A,p)
%POWERM2BY2    Power of 2-by-2 upper triangular matrix.
%   POWERM2BY2(A,p) is the pth power of the 2-by-2 upper
%   triangular matrix A, where p is an arbitrary real number.

a1 = A(1,1);
a2 = A(2,2);

a1p = a1^p;
a2p = a2^p;

loga1 = log(a1);
loga2 = log(a2);

X = diag([a1p a2p]);

if a1 == a2
   X(1,2) = p*A(1,2)*a1^(p-1);

elseif abs(a1) < 0.5*abs(a2) || abs(a2) < 0.5*abs(a1)
   X(1,2) =  A(1,2) * (a2p - a1p) / (a2 - a1);
   
else % Close eigenvalues.
   w = atanh((a2-a1)/(a2+a1)) + 1i*pi*unwinding(loga2-loga1);
   dd = 2 * exp(p*(loga1+loga2)/2) * sinh(p*w) / (a2-a1);
   X(1,2) = A(1,2)*dd;

end
	function u = unwinding(z,k)
	%UNWINDING    Unwinding number.
	%   UNWINDING(Z,K) is the K'th derivative of the
	%   unwinding number of the complex number Z.
	%   Default: k = 0.

	if nargin == 1 || k == 0
	   u = ceil( (imag(z) - pi)/(2*pi) );
	else
	   u = 0;
	end
	end

end