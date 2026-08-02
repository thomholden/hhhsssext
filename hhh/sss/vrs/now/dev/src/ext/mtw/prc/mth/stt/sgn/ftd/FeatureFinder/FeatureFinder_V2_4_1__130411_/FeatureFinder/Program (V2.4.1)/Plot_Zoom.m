function Plot_Zoom(hAxes,hWFOs,cAxes,nNewLim,bAnimate)

% Check input arguments
if nargin~=5
    fprintf('ERROR:  Bad number of input arguments to Plot_Zoom.\n\n');
    return
elseif ~ishandle(hAxes)
    fprintf('ERROR:  Bad axes handle sent to Plot_Zoom.\n\n');
    return
elseif any(~ishandle(hWFOs))
    fprintf(['ERROR:  One or more bad window-fixed-object \n',...
        'handles input to Plot_Zoom.\n\n']);
    return
elseif ~isfield(nNewLim,'X')||numel(nNewLim.X)~=2||...
        ~isfield(nNewLim,'Y')||numel(nNewLim.Y)~=2
    fprintf('ERROR:  Bad limits specified to Plot_Zoom.\n\n');
    return
elseif ~isempty(cAxes)&&(~iscell(cAxes)||length(cAxes)~=length(hWFOs))
    fprintf(['ERROR:  Third argument must be a cell containing elements\n',...
        ' ''X'',''Y'', or ''XY''.  The second and third arguments must\n',...
        ' be of the same length.\n\n']);
    return
elseif (~islogical(bAnimate))
    fprintf('ERROR:  Bad animation value sent to Plot_Zoom.\n\n');
    return
end

% Determine current limits
nOldLim.X=get(hAxes,'xlim');
nOldLim.Y=get(hAxes,'ylim');

% Animate to new limits
if bAnimate
    % Temporarily hide text that's pinned to a specific coordinate
    for i=1:length(hWFOs)
        switch get(hWFOs(i),'type')
            case 'text'
                if strcmp(get(hWFOs(i),'String'),'Baseline')||...
                    strcmp(get(hWFOs(i),'String'),'Target')
                    continue
                end
                set(hWFOs(i),'Visible','off');
        end
    end
    
    nSteps=7;
    nInterLim.X=repmat(nOldLim.X,nSteps,1)+[1:nSteps]'*((nNewLim.X-nOldLim.X)/nSteps);
    nInterLim.Y=repmat(nOldLim.Y,nSteps,1)+[1:nSteps]'*((nNewLim.Y-nOldLim.Y)/nSteps);
    for i=1:nSteps
        set(hAxes,'xlim',nInterLim.X(i,:));
        set(hAxes,'ylim',nInterLim.Y(i,:));  
        drawnow
        pause(0.02);
    end
    
    % Update cursor
    hFig=get(get(hAxes,'Parent'),'Parent');
    cModifiers=get(hFig,'currentModifier');
    Plot_UpdateCursor(hFig,cModifiers);
end

% For each window-fixed-object (WFO), determine new position/extent and
% update position/extent of each WFO
for i=1:length(hWFOs)
    switch get(hWFOs(i),'type')
        case 'text'
            if strcmp(get(hWFOs(i),'String'),'Baseline')||...
                    strcmp(get(hWFOs(i),'String'),'Target')
                continue
            end
            nExtent=get(hWFOs(i),'Position');
            nNewExtent=fTransformCoords(nExtent,nOldLim,nNewLim,cAxes{i});
            set(hWFOs(i),'Position',nNewExtent,'Visible','on');
            
        case 'rectangle'
            nPosition=get(hWFOs(i),'Position');
            nCorner1=nPosition(1:2);
            nCorner2(1)=nPosition(1)+nPosition(3);
            nCorner2(2)=nPosition(2)+nPosition(4);
            nNewCorner1=fTransformCoords(nCorner1,nOldLim,nNewLim,cAxes{i});
            nNewCorner2=fTransformCoords(nCorner2,nOldLim,nNewLim,cAxes{i});
            nNewPosition(1:2)=nNewCorner1;
            nNewPosition(3)=nNewCorner2(1)-nNewCorner1(1);
            nNewPosition(4)=nNewCorner2(2)-nNewCorner1(2);
            set(hWFOs(i),'Position',nNewPosition);  
                    
        otherwise
            fprintf(['ERROR:  Unexpected window-fixed object type ',...
                '(Plot_Zoom).\n\n']);
    end
end

% Change x and y limits of plot
set(hAxes,'xlim',nNewLim.X);
set(hAxes,'ylim',nNewLim.Y);


% This function transforms the coordinates C from axes with limits O to
% axes with limits N, such that their position in the plot window appears
% unchanged.
function nNewCoords=fTransformCoords(nCoords,nOldLim,nNewLim,sAxes)

X=nCoords(1);
Y=nCoords(2);

O=nOldLim;
N=nNewLim;

switch sAxes    
    case 'X'
        A=(X-O.X(1))/(O.X(2)-O.X(1))*(N.X(2)-N.X(1))+N.X(1);
        B=Y;
    case 'Y'
        A=X;
        B=(Y-O.Y(1))/(O.Y(2)-O.Y(1))*(N.Y(2)-N.Y(1))+N.Y(1);
    case 'XY'
        A=(X-O.X(1))/(O.X(2)-O.X(1))*(N.X(2)-N.X(1))+N.X(1);
        B=(Y-O.Y(1))/(O.Y(2)-O.Y(1))*(N.Y(2)-N.Y(1))+N.Y(1);
end

nNewCoords=[A,B];
