function dF = opFD(f, dim, sense)
% dF = opFD(F, DIM, SENSE)
%
% the 2-D function's F 1st order finite differences on dimension DIM 
% 
%   DIM       - 1/2 == i/j, y/x :-)
%   SENSE     - +/0/-, +1/0/-1 == fwd, centered, bacward, except on 1st/last 
%               Row & Col, where fwd/bck differences are always used
% 
% (scale outside by h/2h/h -- or h^2 for 2nd order, later...) 
% 
% 27.06.2011    - slimdown v. of 09.03.2011


if nargin < 3, sense = 1;
    if nargin < 2, dim = 1; % x
        if nargin < 1, error('opFD : no input 2D function !'); end
    end;
end

sense = sign(sense);

[nR,nC] = size(f);
WorkingClass = class(f);
dF = zeros(nR,nC, WorkingClass); % 'X' := 'Y', indices are i,j=1,2 :-)

% ------------------------------------------------

if dim == 1 % --- i ---
    v_slide = (1:nR-1);
    if sense == 1
        % subtract from  lower
        dF(v_slide,:) = f(v_slide+1,:) - f(v_slide,:);
        dF(nR,:) = f(nR,:) - f(nR-1,:);
    elseif sense == -1 % subtract the upper
        dF(v_slide+1,:) = f(v_slide+1,:) - f(v_slide,:);
        dF(1,:) = f(2,:) - f(1,:);
    else % centered
        dF(1,:) = 2*(f(2,:) - f(1,:));
        dF(nR,:) = 2*(f(nR,:) - f(nR-1,:));
        dF(2:nR-1,:) = f(3:nR,:) - f(1:nR-2,:);
    end;
    
else % --- j ---
    v_slide = (1:nC-1);
    if sense == 1
        % subtract from left
        dF(:,v_slide) = f(:,v_slide+1) - f(:,v_slide);
        dF(:,nC) = f(:,nC) - f(:,nC-1);
    elseif sense == -1 % subtract the one on the right
        dF(:,v_slide+1) = f(:,v_slide+1) - f(:,v_slide);
        dF(:,1) = f(:,2) - f(:,1);
    else % centered
        dF(:,1) = 2*(f(:,2) - f(:,1));
        dF(:,nC) = 2*(f(:,nC) - f(:,nC-1));
        dF(:,2:end-1) = f(:,3:end) - f(:,1:end-2);
    end
end

