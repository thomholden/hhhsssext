function plSegment(m_segm, xoyo, FigNo, color, LineWidth)
% show one membrane segment(or sequence)
%
% 01.07.2008    - new, for v.04i, from older v 0.2, 
%                 27.04.2008, (even older plMembrane
% 11.02.2011    - add LineWidth... since it is STILL called in 
%                 membraneAct.m| uDrawSegment ... to phase out...

% definition of increment signs  
%   direction (0,1) <=> (V,H), (y,x) a.k.a (1,2) in matrix indexes
%   sense (0,1) <=> intuitive, (-1,1)
%
%          ^  (0,1)     %          ^  1  
%          |            %          |        
% (1,0) <--+-->  (1,1)  %    2  <--+-->  3
%          |            %          |
%          V  (0,0)     %          V  0

if nargin < 5, LineWidth = 2; end;
if nargin < 4, color = 'b'; end;
if nargin < 3, FigNo = 1;
    if nargin < 3
        error('plSegment : no xo, yo passed')
    end;
end;

% --- draw first arrow ---
figure(FigNo);
hold on;

nPoints = size(m_segm,1); % 
% --- draw next arrows (2:nPoints)
for i = 1:nPoints
    delta = (m_segm(i,2)-0.5)*2; % dezindex apoi
    position = ~m_segm(i,1)+1; % H,x/V,y -> 2nd/1st index
    xvyv = xoyo;
    xvyv(position) = xvyv(position) + delta;
    % was :
    %if membr(i,1) % H, x, 2nd index
    %    y2 = xoyo(2);
    %    x2 = xoyo(1) + delta;
    %else % V, y, 1st index
    %    x2 = xoyo(1);
    %    y2 = xoyo(2) + delta;
    %end;
    plot([xoyo(1) xvyv(1)], [xoyo(2) xvyv(2)], ...
        color, 'LineWidth', LineWidth);
    xoyo = xvyv;
end

hold off

