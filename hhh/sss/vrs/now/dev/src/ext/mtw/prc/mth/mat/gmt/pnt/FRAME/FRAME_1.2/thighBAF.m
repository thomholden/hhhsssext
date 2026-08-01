function [Rth, Tth] = thighBAF(HJC, ME, LE, side, varargin)
%THIGHBAF  Bone-embedded anatomical reference frame(s) of the thigh
%   This function features an ARRAYLAB (MULTIMATRIX) engine.
%
%   [Rth, Tth] = thighBAF(HJC, ME, LE, SIDE) is equivalent to
%   [Rth, Tth] = thighBAF(HJC, ME, LE, SIDE, DIM), where DIM is 
%   the first dimension of length 3 in arrays HJC, ME, LE.
%
%   [Rth, Tth] = thighBAF(HJC, ME, LE, SIDE, DIM) returns arrays
%   containing M 3-by-3 orientation matrices (Rth) and M 3-element position
%   vectors (Tth), representing the angular and linear 3-D position(s) of
%   the anatomical reference frame of a thigh. Each matrix and each vector
%   is computed using a "Non Optimal Pose Estimator", based on the position
%   of 3 anatomical landmarks. M = SIZE(HJC) / 3.
%
%   HJC, ME, LE:
%         Arrays with N dimensions and the same size (see function REFSYS)
%         containing, along dimension DIM, M 3-element vectors representing
%         the linear 3-D positions of 3 anatomical landmarks.
%   SIDE: Scalar indicating right (SIDE = 0) or left (SIDE = 1) thigh.
%   DIM:  Dimension along which the landmark position vectors are found.
%   Rth:  Array with N + 1 dimensions (see function REFSYS), containing 
%         the M reference frame orientation matrices along dimensions DIM
%         and DIM + 1.
%   Tth:  Array with the same size as HJC, ME, LE, containing
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

MidE = (LE + ME) / 2;
if side == 0 % Right thigh
    Rth = frame(-HJC+LE, -LE+ME, 'x', -MidE+HJC, 'y', varargin{:});
else % Left thigh
    Rth = frame(-HJC+ME, -ME+LE, 'x', -MidE+HJC, 'y', varargin{:});
end

Tth = MidE;
