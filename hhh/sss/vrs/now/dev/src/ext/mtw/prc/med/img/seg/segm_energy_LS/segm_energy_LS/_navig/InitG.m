function [g, gOffset] = InitG(g0, kMax)
% [g, gOffset] = InitG(G0, kMax)
% 
% scale down the image G0 kMax octaves

% g0 is 2D, gray-level ! force g0(:,:,:) to BW outside !
%
% 10.07.2011    - downsample using spline interpolation, more accurate

gOffset = []; % dummy out

g{1} = g0; clear g0;

if kMax>0
    g{kMax+1} = [];
    gOffset = zeros(kMax,2);
    for ik = 2:kMax+1
        thisSlice = squeeze(g{ik-1});
        [nR, nC] = size(thisSlice);
        gOffset(ik-1,:) = mod([nR nC],2); % offsets used in Fn Multi-Scale
        ixR = 1:2:nR; ixC = 1:2:nC;
        nextSmSlice = interp2(thisSlice, ixC, ixR', 'spline');
        g{ik} = nextSmSlice; %#ok<AGROW>
    end
end
% store offset to obtain g{ik-1} := opUp(g{ik}) @ index ik in gOffset

