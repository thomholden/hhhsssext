function [gOl gRl] = ARF(P, segname, side, varargin)
%ARF  Position(s) of the Anatomical Reference Frame of a segment.
%   This function features an ARRAYLAB (MULTIMATRIX) engine.
%
%   NOTE: This source code should be personalized by adjusting the list of
%         field (analtomical landmark) names (see below)
%
%   [gOl gRl] = ARF(P, SEGNAME) is equivalent to 
%   [gOl gRl] = ARF(P, SEGNAME, '', DIM), where DIM is the first dimension
%   of length 3 in the arrays contained in structure P.
%
%   [gOl gRl] = ARF(P, SEGNAME, SIDE) is equivalent to 
%   [gOl gRl] = ARF(P, SEGNAME, SIDE, DIM), where DIM is the first
%   dimension of length 3 in the arrays contained in structure P.
%
%   [gOl gRl] = ARF(P, SEGNAME, SIDE, DIM) returns block arrays containing
%   vectors (gOl) and matrices (gRl) representing the linear and angular
%   3-D positions of the anatomical reference frames of the specified body
%   segment. Each vector and each matrix is computed using a "Non Optimal
%   Pose Estimator" (FRAME), based on the position of 3 to 6 anatomical
%   landmarks.
%
%   INPUT:
%      P       (struct) Each field contains point position vectors along
%                       dimension DIM.
%      SEGNAME (char)   Name of a body segment.
%      SIDE    (char)   Indicates the side of the body (left or right). It
%                       can be omitted. Allowed values: 
%                           ''           No side (for head, trunk, ...)
%                           'l' or 'L'   Left side
%                           'r' or 'R'   Right side
%      DIM     1x1      Dimension along which the landmark position vectors 
%                       are found, in the fields of P.
%
%   OUTPUT:
%      gOl   Array of 3-element vectors representing positions of the
%            origin of the ARF. The format is specified in the table below.
%      gRl   Array of 3-by-3 matrices representing the orientations of the
%            ARF. The format is specified in the table below.
%
%   Array     Dimensions (*)     Containing              Along dimension(s)
%   -----------------------------------------------------------------------
%   P.XXXX        2-D            3-D position vectors             DIM
%   gOl           2-D            3-D position vectors             DIM
%   gRl           3-D         3-by-3 orient. matrices        DIM and DIM+1
%   -----------------------------------------------------------------------
%   (*) For instance, if P.XXXX is 120-by-3, gRl is 120-by-3-by-3, and
%                     if P.XXXX is   1-by-3, gRl is   1-by-3-by-3.
%
%   Reference:
%       Cappozzo et al. (1995). Position and orientation in space of bones 
%                       during movement: anatomical frame definition and
%                       determination. Clinical Biomechanics, 10, 171-178.
%       van der Helm et al. (2005). ISB Recommendation on Definitions of
%                       Joint Coordinate Systems ... - Part II: shoulder,
%                       elbow, wrist and hand. Journal of Biomechanics, 38,
%                       981-992.
%
%   Examples:
%       See function FRAME
%
%   See also FRAME.

% $ Version: 1.2 $
% CODE      by:            Paolo de Leva  (IUSM, Rome, IT)      2006 Nov 30
%                          Pietro Picerno (IUSM, Rome, IT)
% COMMENTS  by:            Paolo de Leva  (IUSM, Rome, IT)      2006 Dic 4
% OUTPUT    tested by:     Code authors & Andrea Cereatti (IUSM, Rome, IT)
% -------------------------------------------------------------------------

% Allow 2 to 4 input arguments (SIDE and DIM can be omitted)
error( nargchk(2, 4, nargin) );

if nargin == 2; side = ''; end
s = upper(side);
if ~isequal(s, '') & ~isequal(s, 'L') & ~isequal(s, 'R')
    error('ARF:NAsideSymbol', 'Invalid SIDE');
end
dim = varargin;


% FIELD NAMES (this list must be personalized)
% -------------------------------------------------------------------------
% Warning: Each field name refers to an anatomical landmark. The order of 
%          the landmarks should not be changed, because in the ANATAMICAL
%          REFERENCE FRAMES section that order is assumed to be known. Only
%          the field (landmark) names can be customized.

    thorax = {'C7', 'T8', 'IJ', 'PX'};

    scapula.L = {'LAA', 'LAI', 'LTS'};
    scapula.R = {'RAA', 'RAI', 'RTS'};

    upperarm.L = {'LGH', 'LEM', 'LEL'};
    upperarm.R = {'RGH', 'REM', 'REL'};

    forearm.L = {'LEM', 'LEL', 'LRS', 'LUS'};
    forearm.R = {'REM', 'REL', 'RRS', 'RUS'};

    hand.L = {'LRS', 'LUS', 'LFIN'};
    hand.R = {'RRS', 'RUS', 'RFIN'};

    pelvis = {'LASI' 'RASI' 'LPSI' 'RPSI'};

    thigh.L = {'LHJC' 'LLE' 'LME'};
    thigh.R = {'RHJC' 'RLE' 'RME'};

    shank.L = {'LHF' 'LTT' 'LLM' 'LMM'};
    shank.R = {'RHF' 'RTT' 'RLM' 'RMM'};

    foot.L = {'LCA' 'LFM' 'LSM' 'LVM'};
    foot.R = {'RCA' 'RFM' 'RSM' 'RVM'};

    foot95.L = {'LCA' 'LFM' 'LSM' 'LVM'};
    foot95.R = {'RCA' 'RFM' 'RSM' 'RVM'};

    pointer = {'PTR1' 'PTR2' 'PTR3'};


% ANATOMICAL REFERENCE FRAMES
% -------------------------------------------------------------------------
switch segname


% case 'head'

case 'thorax'
    
    [C7 T8 IJ PX] = thorax{:}; % Converting to standard symbols
    gOl     = P.(IJ);
    MidUP   = (P.(IJ) + P.(C7)) / 2;
    MidDOWN = (P.(PX) + P.(T8)) / 2;
    gRl    = frame(-MidDOWN+P.(C7), -MidDOWN+P.(IJ), 'z', ...
                                     -MidDOWN+MidUP, 'y', dim{:});
    
case 'scapula'
    
    [AA AI TS] = scapula.(s){:}; % Converting to standard symbols
    gOl = P.(AA);
    if isequal(s, 'R')% Right scapula
        gRl = frame(-P.(TS)+P.(AA), -P.(TS)+P.(AI),'x', ...
                                   -P.(TS)+P.(AA), 'z', dim{:});
    elseif isequal(s, 'L') % Left scapula
        gRl = frame(-P.(TS)+P.(AI), -P.(TS)+P.(AA), 'x', ...
                                    -P.(TS)+P.(AA), 'y', dim{:});
    end

case 'upperarm'
    
    [GH EM EL] = upperarm.(s){:}; % Converting to standard symbols
    MidE = (P.(EL) + P.(EM)) / 2;
    gOl = P.(GH);
    if isequal(s, 'R') % Right upperarm
        gRl = frame(-P.(GH)+P.(EL), -P.(EL)+P.(EM), 'x', ...
                                      -MidE+P.(GH), 'y', dim{:});
    elseif isequal(s, 'L') % Left upperarm
        gRl = frame(-P.(GH)+P.(EM), -P.(EM)+P.(EL), 'x', ...
                                      -MidE+P.(GH), 'y', dim{:});
    end
    
case 'forearm'
    
    [EM EL RS US] = forearm.(s){:}; % Converting to standard symbols
    MidE = (P.(EL) + P.(EM)) / 2;  % mid point epycondiles
    MidS = (P.(RS) + P.(US)) / 2;  % mid point styloides
    gOl = MidS;
    if isequal(s, 'R') % Right forearm
        gRl = frame(-MidE+P.(RS), -P.(RS)+P.(US), 'x', ...
                                      -MidS+MidE, 'y', dim{:});
    elseif isequal(s, 'L') % Left forearm
        gRl = frame(-MidE+P.(US), -P.(US)+P.(RS), 'x', ...
                                      -MidS+MidE, 'y', dim{:});
    end

case 'hand'
    
    [RS US FIN] = hand.(s){:}; % Converting to standard symbols
    MidS = (P.(RS) + P.(US)) / 2;  % mid point styloides
    gOl = MidS;
    if isequal(s, 'R') % Right hand
        gRl = frame(-P.(FIN)+P.(RS), -P.(RS)+P.(US), 'x', ...
                                      -P.(FIN)+MidS, 'y', dim{:});
    elseif isequal(s, 'L') % Left hand
        gRl = frame(-P.(FIN)+P.(US), -P.(US)+P.(RS), 'x', ...
                                      -P.(FIN)+MidS, 'y', dim{:});
    end

%case 'UPT' % Upper part of trunk

%case 'MPT' % Middle part of trunk

case 'pelvis' % Lower part of trunk
    
    [LASI RASI LPSI RPSI] = pelvis{:}; % Converting to standard symbols
    gOl    = ( P.(LASI) + P.(RASI) ) / 2;
    MidPSI = ( P.(LPSI) + P.(RPSI) ) / 2;
    gRl    = frame(-P.(LASI)+MidPSI, -P.(LASI)+P.(RASI), 'y', ...
                                     -P.(LASI)+P.(RASI), 'z', dim{:});

case 'thigh'
    
    [HJC LE ME] = thigh.(s){:}; % Converting to standard symbols
    MidE = ( P.(LE) + P.(ME) ) / 2;
    gOl = MidE;
    if isequal(s, 'R') % Right foot
        gRl = frame(-P.(HJC)+P.(LE), -P.(LE)+P.(ME),  'x', ...
                                       -MidE+P.(HJC), 'y', dim{:});
    elseif isequal(s, 'L') % Left foot
        gRl = frame(-P.(HJC)+P.(ME), -P.(ME)+P.(LE),  'x', ...
                                       -MidE+P.(HJC), 'y', dim{:});
    end

case 'shank'
    
    [HF TT LM MM] = shank.(s){:}; % Converting to standard symbols
    MidM = ( P.(LM) + P.(MM) ) / 2;
    gOl = MidM;
    if isequal(s, 'R') % Right foot
        gRl = frame(-P.(HF)+P.(LM), -P.(LM)+P.(MM), 'x', ...
                                      -MidM+P.(TT), 'y', dim{:});
    elseif isequal(s, 'L') % Left foot
        gRl = frame(-P.(HF)+P.(MM), -P.(MM)+P.(LM), 'x', ...
                                      -MidM+P.(TT), 'y', dim{:});
    end

case 'foot' % (x axis from heel to tip)
    
    [HEEL MET1 MET2 MET5] = foot.(s){:}; % Converting to standard symbols
    gOl = P.(HEEL);
    if isequal(s, 'R') % Right foot
        gRl = frame(-P.(HEEL)+P.(MET5), -P.(MET5)+P.(MET1), 'y', ...
                                        -P.(HEEL)+P.(MET2), 'x', dim{:});
    elseif isequal(s, 'L') % Left foot
        gRl = frame(-P.(HEEL)+P.(MET1), -P.(MET1)+P.(MET5), 'y', ...
                                        -P.(HEEL)+P.(MET2), 'x', dim{:});
    end

case 'foot95' % Definition by Cappozzo (1995)
    
    [HEEL MET1 MET2 MET5] = foot95.(s){:}; % Converting to standard symbols
    gOl = P.(HEEL);
    if isequal(s, 'R') % Right foot
        gRl = frame(-P.(HEEL)+P.(MET5), -P.(MET5)+P.(MET1), 'x', ...
                                        -P.(MET2)+P.(HEEL), 'y', dim{:});
    elseif isequal(s, 'L') % Left foot
        gRl = frame(-P.(HEEL)+P.(MET1), -P.(MET1)+P.(MET5), 'x', ...
                                        -P.(MET2)+P.(HEEL), 'y', dim{:});
    end

case 'pointer'
    
    % Local reference frame used by Vicon IQ (based on sequence P1,P2,P3)
    [P1 P2 P3] = pointer{:}; % Converting to standard symbols
    gOl = P.(P1);
    gRl = frame(-P.(P1)+P.(P2), -P.(P2)+P.(P3), 'z', ...
                                -P.(P1)+P.(P2), 'x', dim{:});

otherwise
        error('TRS:NAsegment', ...
              ['''' segname ''' is not a valid segment name']);

end