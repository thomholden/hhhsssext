function R = frame(a, b, axis1, c, axis2, dim)
%FRAME  Buildung a 3-D Cartesian reference frame based on three vectors
%   This function features an ARRAYLAB (MULTIMATRIX) engine.
%
%   R = FRAME(A, B, AXIS1, C, AXIS2) is equivalent to  
%   R = FRAME(A, B, AXIS1, C, AXIS2, DIM), where DIM is the first
%   dimension of length 3 in arrays A, B and C.
%
%   R = FRAME(A, B, AXIS1, C, AXIS2, DIM) returns an array with N + 1 
%   dimensions (*), containing M 3-by-3 orientation matrices along its
%   dimensions DIM and DIM + 1. Each matrix contains, in its columns, 
%   the unit vectors of the axes of a right handed 3-D Cartesian reference
%   frame (see below). The size of R, if the length of its dimension
%   DIM + 1 is ignored, is equal to that of A, B, and C.
%       A, B, C:    Arrays with N dimensions (*) containing M 3-element 
%                   vectors along dimension DIM. Each vector represents a
%                   directed 3-D distance (i.e., the position of a point
%                   relative to another). A, B, C must have the same size.
%                   C is allowed to be equal to A or B. 
%   AXIS1, AXIS2:   The names (1x1 char) of two Cartesian axes (see below).
%                   Allowed names: 'x' or 'X', 'y' or 'Y', 'z' or 'Z'.
%            DIM:   The dimension of A, B, and C along which the position
%                   vectors are stored. DIM can be omitted (short syntax).
%
%   Defining the Cartesian axes:
%       If Ai, Bi, Ci are vectors identified, in A, B, and C, by the same
%       indexes, and Ri is the respective orientation matrix contained in
%       R, the three unit vectors in its columns are defined as follows:
%       U1i:   Representing axis AXIS1, aligned with V1i = Ai x Bi.
%       U2i:   Representing axis AXIS2, aligned with the projection
%              of vector Ci on the plane defined by Ai and Bi (ABi).
%       U3i:   Representing the third axis, orthogonal to U1i and U2i, 
%              and forming with them a right handed reference frame.
%       Notice that U1i, U2i and U3i are not needs arranged in that order
%       inside Ri (see example 1). Ai and Bi cannot be parallel. Ci cannot
%       be orthogonal to plane ABi, but it can coincide with Ai or Bi. 
%
%   Note:
%   (*) N is the number of dimensions in A, B, and C. If A, B, and C are
%       3-by-1 arrays, they are treated as 1-D arrays (N = 1 is assumed, 
%       DIM = 1 is required), and R is a single 3-by-3 orientation matrix. 
%
%   Examples:
%       In the following examples, the 1st, 2nd and 4th arguments passed to
%       FRAME are supposed to be 3-by-M arrays containing M 3-D distances. 
%
%    1) R = FRAME(A, B, 'z', A, 'x', 1) is a 3-by-3-by-M array 
%       containing M 3-by-3 matrices. Notice that, in this case, C = A.
%       Each matrix Ri contained in R (for i = 1 : M) is so constructed:
%           Column     Unit vector of    Aligned with
%           ------------------------------------------------------------
%           R(:,1,i)    Axis x (AXIS2)   A(:,i) (°)
%           R(:,2,i)    Axis y           Cross prod. of column 3 by 1
%           R(:,3,i)    Axis z (AXIS1)   Cross prod. of A(:,i) by B(:,i)
%           ------------------------------------------------------------
%           (°) Since A(:,i) is on plane xy, it coincides with its
%               projection on that plane.
%
%    2) A simple method (implemented in the Vicon IQ software) to define
%       orientation matrices based on the positions of 3 points:
%           R = FRAME(-P1+P2, -P2+P3, 'z', -P1+P2 'x', 1) 
%
%    3) Anatomical bone-embedded reference frames for the pelvis, right
%       thigh, right shank and right foot, as defined by
%       Cappozzo et al. (1995). Position and orientation in space of 
%                    bones during movement: anatomical frame definition and
%                    determination. Clinical Biomechanics, 10, 171-178.
%       The directed distances are obtained from anatomical landmark 
%       positions.
%           MidPSIS = (LPSIS + RPSIS) / 2;
%           MidE    = (LE + ME) / 2;
%           MidM    = (LM + MM) / 2;
%           Rpelvis = FRAME(-LASIS+MidPSIS, -LASIS+RASIS, 'y', ...
%                                            -LASIS+RASIS, 'z', 1);
%           RRthigh = FRAME(-HJC+LE,   -LE+ME,   'x', -MidE+HJC, 'y', 1);
%           RRshank = FRAME(-HF+LM,    -LM+MM,   'x', -MidM+TT,  'y', 1);
%           RRfoot  = FRAME(-HEEL+MT5, -MT5+MT1, 'x', -MT2+HEEL, 'y', 1);
%
%    See also MAKEHGTFORM, CROSS, UNIT.

% Version: 1.2 (old name: REFSYS)
% CODE      by:  Paolo de Leva (Univ. "Foro Italico", Rome, IT) 2013 Feb 23
% COMMENTS  by:  Code author                                    2013 Jul 22
% OUTPUT    tested by: Code author                              2005 Oct 1
% -------------------------------------------------------------------------

% Allow 5 to 6 input arguments
error( nargchk(5, 6, nargin) );    

% Setting DIM if not supplied.
if nargin == 5
   first3 = find(size(b)==3, 1, 'first'); % First dimension of length 3
   dim = max([first3, 1]);            % If FIRST3 is empty, then DIM=1 and
end                                   % function CROSS will issue an error

% Lowercase axis names (A1 and A2)
a1 = lower(axis1);
a2 = lower(axis2);
% Checking axis names
if isequal (a1, a2)
    error ('FRAME:NAaxisname', 'The two axis names must be different');
elseif ~ (isequal (a1, 'x') || isequal (a1, 'y') || isequal (a1, 'z') )
    error ('FRAME:NAaxisname', ['''' a1 ''' ' ...
           'is not allowed as a name for a cartesian axis'] );
elseif ~ (isequal (a2, 'x') || isequal (a2, 'y') || isequal (a2, 'z') )
    error ('FRAME:NAaxisname', ['''' a2 ''' ' ...
           'is not allowed as a name for a cartesian axis'] );
end

% Determining name of third axis (A3)
switch a1
    case 'x'
        if     a2 == 'y',   a3 =  'z';
        else   a3  = 'y'; % a2 == 'z';
        end
    case 'y'
        if     a2 == 'z',   a3 =  'x';
        else   a3  = 'z'; % a2 == 'x';
        end
    case 'z'
        if     a2 == 'x',   a3 =  'y';
        else   a3  = 'x'; % a2 == 'y';
        end
end

% NOTE: To make the variable names more easily understandable, 
% the first three steps of the algorithm were written assuming that
% AXIS1 == 'x' and AXIS2 == 'y'.

% 1 - Normalizing input vectors for magnitude
unitA = unit(a, dim); % On plane TZ
unitB = unit(b, dim); % On plane TZ
unitC = unit(c, dim); % Not necessarily on plane TZ

% 2 - Unit vectors of the Cartesian axes
x = unit( cross(unitA, unitB, dim), dim ); % AXIS1
z = unit( cross(    x, unitC, dim), dim ); % the third axis
y =       cross(    z,     x, dim);        % AXIS2

% 3 - Selecting the verse of the third Cartesian axis
%        Step 1 is valid only if the sequence [A1 A2] is equal to
%        'xy', 'yz' or 'zx'. Otherwise, the reference frame obtained
%        above is left handed.
switch [a1 a2]
    case {'xz' 'yx' 'zy'}, z = -z; % Enough to make it right handed
end

% 4 - Adding a singleton dimension to arrays X, Y, and Z
x = addsingleton(x, dim+1);
y = addsingleton(y, dim+1);
z = addsingleton(z, dim+1);

% 5 - R is built by concatenating arrays x, y, and z in the correct order,
%     based on their true names (a1, a2, a3).
%     Example:
%        If X, Y, Z are 5x3x1x9 arrays and DIM==2,
%        R is ....... a 5x3x3x9 array,
colnumbers = int8([a1 a2 a3]) - 119; % Converting axis names into indexes
columns{colnumbers(1)} = x;
columns{colnumbers(2)} = y;
columns{colnumbers(3)} = z;
R = cat(dim+1, columns{:});



%--------------------------------------------------------------------------
function b = addsingleton(a, newdim)
%ADDSINGLETON   Adding a singleton dimension to an array.
%   Example:
%      If A is ................. a 5x9x3   array,
%      B = ADDSINGLETON(A, 3) is a 5x9x1x3 array,

if newdim <= ndims(a)
    sizA = size(a);
    sizB = [sizA(1:newdim-1), 1, sizA(newdim:end)];
    b = reshape(a, sizB);
else 
    b = a;
end
