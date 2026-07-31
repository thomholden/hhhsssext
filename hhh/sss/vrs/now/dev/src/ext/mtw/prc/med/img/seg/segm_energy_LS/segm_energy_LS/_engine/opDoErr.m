function [err, dSQerr, dirac, hvi_out] = opDoErr(f, g, par, mask, doExactError) 
% [ERR, dSQ_err, Dirac, HVI] = opErr(F, G, PAR, MASK, doExactError)
%
% ERR   - PHI is sign(f), Cp/Cm are the averages inside/outside PHI
%       - FSQp/m > the err.func. integrals G-Cp / G-Cm in/outside PHI
%       - dSQerr lambda-weighted sum of p,m errors
%       - Perimeter (raw and corrected by MIU)
% 
% dSQ_err   - 2D error function, to use next in iterating f
% Dirac     - 2D regularization term, use in fn->f_n+1 as well
% HVI       - Heaviside function, derivative of Dirac
%
% F     - aproximating function
% G     - target function (a.k.a. image to segment)
% PAR   - contains MIU, NIU, LP, LM   - evolving curve parameters
% MASK  - 2D domain where err is to be calculated (boolean)
% doExactError  - false usually (use dirac, heaviside), true only in debug
%  
% 09.06.2009    - new, structure output (for GUI-based segmentation & more), uses 
%               - err.calc bits from older opPhiNext, opErr(v.062, 15.07.2008)
% 22.07.2009    - fixed huge bug in error total
%               - add "exact" RMS error
% 01.02.2010    - heaviside output now optional
% 08.02.2010    - use MASK
% 06.07.2010    - corrected /2 bug in perimeter calculation, which was 
%                 caused by using the centered differences without
%                 normalization
%
% later add edges to Perimeter... use alpha ?

%optGatePerimComp = true; fprintf(1, '%s', 'opDoErr.comp.')
optGatePerimComp = false; %fprintf(1, '%s', '.NO comp.')

if nargin < 5, doExactError = false; end;
if nargin < 4, mask = true(size(f)); end % default full mask
if nargin < 3, par = uConstruct('par'); end     % Miu (smoothness) and lambdaP, lambdaM 
if isempty(par), par = uConstruct('par'); end   % SQ_err coeff  ('p'/'m', inside/outside)
if nargin < 2, error('opErr : no 2-D G input function !'); end

[nR, nC] = size(f);
err = uConstruct('err');

% regularization of Heaviside & Dirac functions using 'atan', eps = 2
[hvi, dirac] = uReg(f, mask, 1, 'atan'); % or 'none' :-(
if optGatePerimComp
    % test removal of mask perim, use +/- 1 pix, equiv. to eps = 2... NAH
    mskOut = nGrowRegion(mask, 1); % inflate
    mskIn = nGrowRegion(mask, 0); % deflate
    dirac(mskOut & ~mskIn) = 0;
end
% calculate averages, in- out-
% -----------------------------
ix_inside = false(nR, nC);
ix_inside(mask) = f(mask)>0;
ix_outside = false(nR, nC);
ix_outside(mask) = f(mask)<0; %false outside MASK

nPixels = sum(mask(:));
if doExactError     % exact averages    
    Region_P = sum(ix_inside(:));
    Cp = sum(g(ix_inside))/Region_P;
    Cm = sum(g(~ix_inside))/(nPixels - Region_P);
else    % use H(phi), delta
    Region_P = sum(hvi(mask));       % regularized area : "almost inside"
    rS = sum(double(g(mask)).*hvi(mask));  % sum pixel values "almost inside"
    Cp = rS/Region_P;                % average "almost inside"
    Cm = (sum(g(mask)) - rS)/(nPixels-Region_P); % remaining sum by area "almost outside"
end

% calc 2-D error functions (of size nR x nC)
dSQerr = zeros(nR, nC); % 2-D err, will use as + on the R-hand side in opIt
dFSQp = zeros(nR, nC);  %
dFSQm = zeros(nR, nC);

if 1 % good old safe style
    Sp = 0; Sm = 0;
    % P/M delta RMS energies, weighted by Lambda P/M
    dFSQp(mask) = (g(mask) - Cp).^2 *par.Lp;
    dFSQm(mask) = (g(mask) - Cm).^2 *par.Lm;

else % sigma, test 0.2 :-)
    optSigma = 0.01;
    Sp = std(g(ix_inside));
    Sm = std(g(ix_outside));
    So = mean([Sp Sm]); dSpm = Sm-Sp;
    dFp = zeros(nR, nC); % signed deltas
    dFm = zeros(nR, nC);
    dFp(mask) = g(mask) - Cp;
    dFm(mask) = g(mask) - Cm;

    Dp = zeros(nR, nC);
    Dp(mask) = 2*((dFp(mask)-So)/dSpm);
    %Dp = min(1,max(0,Dp));

    Dm = zeros(nR, nC);
    Dm(mask) = 2*((-dFm(mask) +So)*dSpm);
    %Dm = min(1,max(0,Dm));

    dFSQp(mask) = dFp(mask).^2 * par.Lp .* (1+optSigma*Dp(mask));
    dFSQm(mask) = dFm(mask).^2 * par.Lm .* (1+optSigma*Dm(mask));

end
dSQerr(mask)  = -dFSQp(mask) + dFSQm(mask) - par.Niu;

% find scalar the weighted energy error terms Fp, Fm 
% (to later use in stop criteria)
FSQp = sum(dFSQp(ix_inside));
FSQm = sum(dFSQm(ix_outside));
%FSQ_scaled = ( FSQp + FSQm)/nPixels; % total RMS error, weighted and scaled

% --- perimeter --- find gradient modulus
dX = opFD(hvi, 1, 0);
dY = opFD(hvi, 2, 0);
gHvi = zeros(nR,nC);
gHvi(mask) = sqrt(dX(mask).^2 + dY(mask).^2);
Interface_raw = sum(gHvi(mask))/2;% /2 due to centered differences, un-normalized

% plug numbers into err. structure
err.Cp = Cp;
err.Cm = Cm;
err.Ep = sqrt(FSQp/par.Lp/Region_P);
err.Em = sqrt(FSQm/par.Lm/(nPixels-Region_P));
err.E_pix = (FSQp + FSQm)/nPixels;
err.Interface_raw = Interface_raw;
err.Interface_adj = Interface_raw * par.Miu;
err.Region_P = Region_P;
err.Region_ratio = Region_P/(nPixels-Region_P);
err.Sp = Sp;
err.Sm = Sm;
% all, a bit redundant but oh, so handy
err.total = FSQp + FSQm + err.Interface_corr + par.Niu*Region_P;
err.total_corr = err.total/nPixels;

if nargout >= 4, hvi_out = hvi; end



    