function [Rsh, Tsh] = shankBAF(MM, LM, HF, TT, side, varargin)
%SHANKBAF  Bone-embedded anatomical reference frame(s) of the shank
%   This function features an ARRAYLAB (MULTIMATRIX) engine.
%
%   [Rsh, Tsh] = shankBAF(MM, LM, HF, TT, SIDE) is equivalent to
%   [Rsh, Tsh] = shankBAF(MM, LM, HF, TT, SIDE, DIM), where DIM is 
%   the first dimension of length 3 in arrays MM, LM, HF, TT.
%
%   [Rsh, Tsh] = shankBAF(MM, LM, HF, TT, SIDE, DIM) returns arrays
%   containing M 3-by-3 orientation matrices (Rsh) and M 3-element position
%   vectors (Tsh), representing the angular and linear 3-D position(s) of
%   the anatomical reference frame of a shank. Each matrix and each vector
%   is computed using a "Non Optimal Pose Estimator", based on the position
%   of 4 anatomical landmarks. M = SIZE(MM) / 3.
%
%   MM, LM, HF, TT:
%         Arrays with N dimensions and the same size (see function REFSYS)
%         containing, along dimension DIM, M 3-element vectors representing
%         the linear 3-D positions of 4 anatomical landmarks.
%   SIDE: Scalar indicating right (SIDE = 0) or left (SIDE = 1) shank.
%   DIM:  Dimension along which the landmark position vectors are found.
%   Rsh:  Array with N + 1 dimensions (see function REFSYS), containing 
%         the M reference frame orientation matrices along dimensions DIM
%         and DIM + 1.
%   Tsh:  Array with the same size as MM, LM, HF, TT, containing
%         the M origin position vectors along dimension DIM.
%
%   Reference:
%       Cappozzo et al. (1995). Position and orientation in space of bones 
%                       during movement: anatomical frame definition and
%                       determination. Clinical Biomechanics, 10, 171-178.
%
%   Examples:
%       See function FRAME
%
%   See also FRAME, PELVISBAF, THIGHBAF, SHANKBAF, FOOTBAF.

% $ Version: 1.0 $
% CODE      by:                 Paolo de Leva (IUSM, Rome, IT) 2005 Oct 1
% COMMENTS  by:                 Code author                    2006 Dec 4
% OUTPUT    tested by:          Code author                    2005 Oct 1
% -------------------------------------------------------------------------

MidM = (LM + MM) / 2;
if side == 0 % Right shank
    Rsh = frame(-HF+LM, -LM+MM, 'x', -MidM+TT, 'y', varargin{:});
else % Left shank
    Rsh = frame(-HF+MM, -MM+LM, 'x', -MidM+TT, 'y', varargin{:});
end

Tsh = MidM;
