function prjData = ShowData(prjData, figNo)
% show levelset evolution on original image
% 
% 08.02.2011    - migrate to new membrane detection and display
%                 (membraneAct.m)
% 10.06.2011    - fix SHOW at init (a _prev plot would fail)

optShowLight = true; %false; %  temporary, in debug
if nargin < 2, figNo = 500; end 

ShowPanel = [2 2];
doMembranes = true; % false; % 

PicNames = {'evolution', 'moving', 'Fn', 'orig'};
DoPrev = true;
if size(prjData.m,2) < 2
    DoPrev = false;
    PicNames{1} = '';
    PicNames{2} = '';
end
WantedPics = [1 1 1 1]; % later set from menu, will look in plot.*
WantedMembrane_curr = doMembranes*[0 1 1 1]; % to check what windows, etc
WantedMembrane_prev = doMembranes*[0 0 1 1]*DoPrev; 

fn = prjData.fn;
sphi_prev = prjData.sphi_prev;
sphi = prjData.sphi;

if any(WantedMembrane_prev)
    if prjData.m(2).Stale           % store current as prev       
        prjData.m(2) = prjData.m(1);% next detect new membrane
    end
end
if (any(WantedMembrane_curr) && prjData.m(1).Stale)
    prjData.m(1) = membraneAct('mask2vertices', sphi);
    prjData.m(1).Stale = false;
end
% --- removed from here the sign change check! ---

% actual plotting
strSubplotBase = ['subplot(' num2str(ShowPanel(1)) num2str(ShowPanel(2)) ];
FigureNumbers = figNo + 1:size(WantedPics,2);
if prod(ShowPanel) >1   % overwrite, show them all in the same figure
    FigureNumbers = figNo*ones(1,size(WantedPics,2));
end

% test existence of figure, only replace when new
ReplaceFigWhenNew(FigureNumbers(1), [250 10 560 420]);
set(FigureNumbers(1), 'menubar', 'none', 'numbertitle', 'off', ...
    'name', 'seg:: result');

for i = 1:size(WantedPics,2) % show the selected plots only
    % if WantedPics(i)... later
    eval([strSubplotBase num2str(i) ')'])
    
    switch PicNames{i}
        case {'Fn', 'fn', 'approx'} % --- show the approximating function, Fn
            figure(FigureNumbers(i))
            imagesc(fn), colormap gray%, axis equal tight
            title(['Fn, ' num2str(prjData.count.It) ' it.'])      
            
        case {'orig', 'g'}
            titleStr = ['orig, ' num2str(prjData.count.It) ' it.'];
            imagesc(prjData.gTile(:,:,1))%, axis equal tight
            title(titleStr), colormap gray
            
            
        case 'evolution' % draw evolution picture
            titleStr = ['evolution, ' num2str(prjData.count.Steps) ' steps.'];
            Inside2Outside = 0.3;
            Outside2Inside = 0.2;
            MovingMask = zeros(size(sphi));
            MovingMask(sphi & sphi_prev) = 1;
            MovingMask(sphi & ~sphi_prev) = 1-Outside2Inside;
            MovingMask(~sphi & sphi_prev) = Inside2Outside;
            MovingMask = round(MovingMask*255);
            figure(FigureNumbers(i))
            imagesc(MovingMask), title(titleStr), colormap gray
            %axis equal tight, zoom on

        case 'moving'
            move_up = fn > prjData.fn_prev;
            are_up = fn > 0;
            evolving_points = ~xor(move_up,are_up);
            figure(FigureNumbers(i))
            imagesc(evolving_points), colormap gray% , axis equal tight
            title('evolution (dark points evolving)')            
    end
    
    axis equal tight, zoom on
    if WantedMembrane_prev(i) % 2, previous
        membraneAct('plot', prjData.m(2), 'fig', FigureNumbers(i),...
            'color', 'b', 'width', 2);
    end
    if WantedMembrane_curr(i) % --- current membrane ---        
        membraneAct('plot', prjData.m(1), 'fig', FigureNumbers(i),...
            'color', 'r', 'width', 2);
    end
    
    
end

if ~optShowLight
    % automatically show the error, later configurable
    ShowError(prjData.err, prjData.it.nSteps, FigureNumbers(end)+1)
end
end
