function [fn, varargout] = RescaleFn(fn, mask, style)
% rescale the approximating function Fn 
% when it doesn't cross zero anymore
% 
% [fn, DidRescale] = RescaleFn(fn, mask, STYLE)
%
% 2010.10.26    - added "smart" histogram STYLE

if nargin < 3, style = 'crude'; end
if nargin < 2, mask = []; end
if isempty(mask), mask = true(size(fn)); end

eps = 1e-18;    % avoid large 0-areas when fn is gated
maxf = max(fn(mask))-eps;
minf = min(fn(mask))+eps;
DidRescale = false;
if maxf*minf > 0 %
    DidRescale = true;
    
    switch style
        case 'crude'
            disp('RescaleFn > ... crude')
            fn(mask) = fn(mask) - (maxf+minf)/2;            
        case {'hist', 'hist50'}            
            disp('RescaleFn > ... HIST ')
            fn(mask) = ReBias(fn(mask)); 
    end    
elseif strcmp(style, 'hist_force')
    % 2x uint8 bins... some hand-waving Nyquist :-)
    fn(mask) = ReBias(fn(mask));
    disp('FORCE rescale Fn... HIST')
end

if nargout > 1
    varargout{1} = DidRescale;
end

end

function fn = ReBias(fn)
% use 2x uint8 bins... some hand-waving Nyquist :-)
[hfn, xbin] = hist(fn, 512);
DrawThreshWhen = length(fn)/2;
SmallerThanCurrent = hfn(1); i=1;
while SmallerThanCurrent < DrawThreshWhen
    SmallerThanCurrent = SmallerThanCurrent + ...
        hfn(i);
    i = i+1;
end
% adjust around new threshold
fn = fn - xbin(i-1);
end