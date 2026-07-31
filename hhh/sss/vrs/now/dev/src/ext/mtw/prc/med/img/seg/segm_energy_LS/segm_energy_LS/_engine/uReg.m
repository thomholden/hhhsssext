function [h, d] = uReg(fn, mask, eps, style)
% Regularize the evolution function Fn.
% 
% [Heaviside, Dirac] = uReg(Fn, MASK, EPS, STYLE)
% 
% calculate and regularize Heaviside/Dirac inside MASK
% 
% STYLE     - default 'atan'
% EPS       - default 1
% MASK      - when empty defaults to full


if nargin < 4, style = 'atan'; end % default add mode
if nargin < 3, eps = 1; end % default minimum step, h=1 mode
if nargin < 1, error('uReg > no Fn passed'), end
if nargin < 2, mask = []; end % default full mask
FnSize = size(fn);
if isempty(mask), mask = true(FnSize); end

h = zeros(FnSize, 'single');  % heaviside
DoDirac = nargout > 1;
if DoDirac
    d = zeros(FnSize, 'single');  % dirac
end

switch style
    case 'atan'
        h(mask) = 0.5*(1+2/pi*(atan(fn(mask)/eps)));
        if DoDirac
            d(mask) = eps./(pi*(eps^2+fn(mask).^2));
        end
    case 'sine' % only act between -eps and eps
        msk_M = fn(mask) < -eps;
        msk_P = fn(mask) > eps;
        mask_Eps = mask;
        mask_Eps(msk_M) = false;
        mask_Eps(msk_P) = false;
        
        %fn_nrm = zeros(FnSize, 'single');
        fn_nrm = 1/eps * fn(mask_Eps); % 1D ref
        h1D = 0.5*(1 + fn_nrm + 1/pi*sin(pi*fn_nrm));
        h(msk_M) = 0; % not needed :-)
        h(msk_P) = 1;
        h(mask_Eps) = h1D;
        if DoDirac
            d1D = 0.5/eps * (1 + cos(pi*fn_nrm));
            % reshape
            d(mask_Eps) = d1D;
        end
        % rebuild 2D if needed
        
    case 'none'     % older, crude, 0/1
        h(mask) = sign(fn(mask));
        if DoDirac
            %d(mask) = zeros(size(fn(mask)));
            ix_d = (fn(mask) < eps);
            d(ix_d) = 1;
        end
    case 'safe' % will make default !
        if eps ~= 1
            fn(mask) = 1/eps * fn(mask); % normalize f
        end
        h(mask) = 0.5 + 1/pi *atan(fn(mask));
        if DoDirac
            d(mask) = 1/pi *1./(1+fn(mask).^2);
        end

    otherwise
        disp('uReg > unrecognized regularization ... exiting')
end
