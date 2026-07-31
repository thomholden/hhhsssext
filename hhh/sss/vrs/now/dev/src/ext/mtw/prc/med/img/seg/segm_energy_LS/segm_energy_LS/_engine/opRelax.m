function fn = opRelax(fn, Residue, dirac, Mu, nIt, dT)
% fn = opRelax(fn, Residue, dirac, Mu, nIt, dT)
% 
% does 1 iteration Fn->Fn+1 when F is approximating G
% G shows up as the residual SQerr (F-to-G)
% Dirac is regularized using atan
% 
% 27.06.2011    - slimdown of v.23.03.2011	


WorkingClass = class(fn); % single... 
if nargin < 7, dT = 1; end
if nargin < 6, nIt = 8; end
if nargin < 5, Mu = 1; end
if nargin < 4,
    dirac = [];
    disp('opRelax: no regularization passed, assuming 1')
end % reinit later as 1 everywhere... shitty nR x nC
if ~isempty(dirac)
    dirac = single(dirac * dT); % faster calculation later
else % some shitty regularization :-)
    dirac = ones(size(fn), WorkingClass)* dT; 
end

if nargin < 3, error('opRelax : insuff. args !'); end

[nR,nC] = size(fn);

% calculate Thetas, dir X/Y as 1/2 or 0/1 (forget R/C here)

Th_R = uTheta_RC(fn, 1); % later move *Mu inside alpha, beta calculations
Th_R = Mu * Th_R; % save the *0 later :-)
Th_C = uTheta_RC(fn, 2); % empty gIx defaults to FullMask
Th_C = Mu * Th_C;

% the ONLY method  so far: 'JACOBI'
% here alpha is the quantity to * by dirac and to + to coeff
% of f_n+1 being updated, beta is the Th_R,Th_C already * by
% f_n+1 around the same point, beta is to add to Residue, then * by dirac
% then add to f_n in point being updated
alpha = zeros(nR,nC, WorkingClass); % init alpha
% ----------------------------------------------
% use Dx on rows 2:nR-1, exceptions: rows 1, nR
% use Dy on cols 2:nC-1, exceptions: col 1 & nC
% ---------------------------------------------
% keep adding terms to alpha

alpha(2:nR-1,:) = ...
    Th_R(1:nR-2,:) + Th_R(2:nR-1,:);    % dX
alpha(:,2:nC-1) = alpha(:,2:nC-1) + ...
    Th_C(:,1:nC-2) + Th_C(:,2:nC-1);    % dY


for i = 1:nIt
    % init beta
    beta = zeros(nR,nC, WorkingClass);
    %delta_Fn = zeros(nR,nC, WorkingClass);
    
    beta(2:nR-1,:)  = ...
        Th_R(1:nR-2,:).*fn(1:nR-2,:) + ...
        Th_R(2:nR-1,:).*fn(3:nR,:);      % dX
    % add Y terms to beta
    beta(:,2:nC-1)  = beta(:,2:nC-1) + ...
        Th_C(:,1:nC-2).*fn(:,1:nC-2) + ...
        Th_C(:,2:nC-1).*fn(:,3:nC);      % dY
    % --- do fn, less borders ---
    fn = (fn + dirac .*(beta + Residue)) ./ (1 + dirac .* alpha);
    % --- borders and corners --- copy one line --- brute, but it works :-)
    fn(:,1) = fn(:,2);
    fn(:,nC) = fn(:,nC-1);
    fn(1,:) = fn(2,:);
    fn(nR,:) = fn(nR-1,:);
end



end

function Theta = uTheta_RC(fn, dim) % old uDenominatorXY

% dim 1/2 -> R/C, in paper X/Y
if ~islogical(dim), dim = logical(dim-1); end

dirP = dim+1;
dirC = ~dim+1; % centered
df1p = opFD(fn, dirP, 1);
df2c = opFD(fn, dirC, 0);

Theta = df1p.^2 + df2c.^2/4;        % protection against division by 0
ix0 = (Theta==0);                   % crude: replace all 0's with
replacementVal = min(Theta(~ix0));  % the next minimum found in the
Theta(ix0) = replacementVal;        % denominator; smarter later
Theta = 1./sqrt(Theta);

end

