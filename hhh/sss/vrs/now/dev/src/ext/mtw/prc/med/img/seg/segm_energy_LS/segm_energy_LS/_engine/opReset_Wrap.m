function [thisErr, ResidueSQ, Dirac, Hvi, gHvi] = opReset_Wrap(f, g, par, RegStyle) 
% [thisErr, ResidueSQ, Dirac, Hvi, gHvi] = opReset_Wrap(f, g, par, RegStyle) 
% 
% 27.06.2011    - slimdown from opReset_Wrap, v.13.06.2011


if nargin < 5, RegStyle = 'atan'; end % 'atan', 'sine' or 'none' :-(

% init working vars, shortwrites:
nVox = numel(g);
[Hvi, Dirac] = uReg(f, [], par.eps, RegStyle);

[Cp, Cm, Vp, Vm] = uRecalcMean(g, Hvi);

Dp_sq = (g - Cp).^2; % can be 1-D
Dm_sq = (g - Cm).^2;
% partial P/M energy  calculations Dp_sq, Dm_sq are 2D
FSQp =  Dp_sq.*Hvi;
FSQp = sum(FSQp(:));
FSQm =  Dm_sq.*(1-Hvi);
FSQm = sum(FSQm(:));
% will weight by Dirac, ADD to Fn, true sign
ResidueSQ = - par.Lp *Dp_sq + par.Lm *Dm_sq - par.Niu;

clear Dp_sq Dm_sq

% --- perimeter --- find gradient modulus, TO DO save work outside GATE
dX = opFD(Hvi, 1, 0);
dY = opFD(Hvi, 2, 0);
gHvi = sqrt(dX.^2 + dY.^2);
Area_raw = sum(gHvi(:))/2;% /2 due to centered differences, un-normalized
Area_adj = Area_raw * par.Miu;

% plug numbers into err. structure
thisErr = uConstruct('err');
thisErr.Cp = Cp;
thisErr.Cm = Cm;
thisErr.Ep = sqrt(FSQp/Vp);
thisErr.Em = sqrt(FSQm/(nVox-Vp));
thisErr.E_pix = sqrt((FSQp + FSQm)/nVox); %, scaled...
thisErr.Interface_raw = Area_raw; % in 2D this is Perimeter!
thisErr.Interface_adj = Area_raw * par.Miu;
thisErr.Region_P = Vp; % in 2D these are Areas!
thisErr.Region_M = Vm;
thisErr.Region_ratio = Vm/Vp; % make it < 0.5 ?
% all, a bit redundant but oh, so handy
thisErr.total = FSQp + FSQm + Area_adj + par.Niu*Vp;
thisErr.total_corr = thisErr.total/nVox;
end

function [Cp, Cm, Vp, Vm] = uRecalcMean(g, Hvi)
V_all = numel(g);
Sum_all = sum(g(:));

% *_p := "almost inside"
Vp = sum(Hvi(:));        % regularized area/vol
Vm = V_all-Vp;
Sum_p = sum(single(g(:)).* Hvi(:));  % sum pixel values "almost inside"
Sum_m = Sum_all - Sum_p;
Cp = Sum_p/Vp; % average "almost inside"
Cm = Sum_m/Vm; % remaining sum by area "almost outside"
end
