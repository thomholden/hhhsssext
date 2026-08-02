function m = sdh_addframe(m, FRACT)
% SDH_ADDFRAME Add frame around matrix, frame has FRACTion values of boarder items
%
%  m = mdh_addframe(m, FRACT)
%  
%  m     (matrix)  is matrix which needs boarder.
%  FRACT (scalar)  fraction, default = 0.1
%
%  Function needed for shd_calculate and to compare visualization to other methods
%  such as U-Matrix.
%
%  see also SDH_CALCULATE

% elias 14/04/2002

if nargin < 2,
    FRACT = 0.1;
end

m2 = zeros(size(m,1)+2,size(m,2)+2);
c = min(min(m)); % don't set values smaller than this

% corners: FRACTion of old corner value
m2(1,1)     = max(c,FRACT*m(1,1));     % top left
m2(end,1)   = max(c,FRACT*m(end,1));   % bottom left
m2(1,end)   = max(c,FRACT*m(1,end));   % top right
m2(end,end) = max(c,FRACT*m(end,end)); % bottom right

% center: not changed
m2(2:end-1,2:end-1) = m;

% edges: 0.1 of old edges
m2(2:end-1,1)   = max(c,FRACT*m(1:end,1));   % left
m2(2:end-1,end) = max(c,FRACT*m(1:end,end)); % right
m2(1,2:end-1)   = max(c,FRACT*m(1,1:end));   % top
m2(end,2:end-1) = max(c,FRACT*m(end,1:end)); % bottom

m = m2;