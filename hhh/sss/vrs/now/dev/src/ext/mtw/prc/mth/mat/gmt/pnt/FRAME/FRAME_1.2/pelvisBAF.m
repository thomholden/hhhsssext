function [Rpv, Tpv] = pelvisBAF(LASI, RASI, LPSI, RPSI, varargin)
%PELVISBAF  Bone-embedded anatomical reference frame(s) of the pelvis
%   This function features an ARRAYLAB (MULTIMATRIX) engine.
%
%   [Rpv, Tpv] = pelvisBAF(LASI, RASI, LPSI, RPSI) is equivalent to
%   [Rpv, Tpv] = pelvisBAF(LASI, RASI, LPSI, RPSI, DIM), where DIM is 
%   the first dimension of length 3 in arrays LASI, RASI, LPSI, RPSI.
%
%   [Rpv, Tpv] = pelvisBAF(LASI, RASI, LPSI, RPSI, DIM) returns arrays
%   containing M 3-by-3 orientation matrices (Rpv) and M 3-element position
%   vectors (Tpv), representing the angular and linear 3-D position(s) of
%   the anatomical reference frame of a pelvis. Each matrix and each vector
%   is computed using a "Non Optimal Pose Estimator", based on the position
%   of 4 anatomical landmarks. M = SIZE(LASI) / 3.
%
%   LASI, RASI, LPSI, RPSI:
%         Arrays with N dimensions and the same size (see function REFSYS)
%         containing, along dimension DIM, M 3-element vectors representing
%         the linear 3-D positions of 4 anatomical landmarks.
%   DIM:  Dimension along which the landmark position vectors are found.
%   Rpv:  Array with N + 1 dimensions (see function REFSYS), containing 
%         the M reference frame orientation matrices along dimensions DIM
%         and DIM + 1.
%   Tpv:  Array with the same size as LASI, RASI, LPSI, RPSI, containing
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

Tpv    = (LASI + RASI) / 2;
MidPSI = (LPSI + RPSI) / 2;
Rpv    = frame(-LASI+MidPSI, -LASI+RASI, 'y', ...
                             -LASI+RASI, 'z', varargin{:});