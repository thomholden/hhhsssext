function [e, g] = sdh_visualize(S, varargin)

% SDH_VISUALIZE Visualize Smoothened Data-Histogram
%
%  sdh_visualize(S, [argID, value, ...])
% 
%   S = sdh_calculate(sData, sMap);
%   sdh_visualize(S);
%   sdh_visualize(S,'type','contour');
%   sdh_visualize(S,'grid','on');
%   e = sdh_visualize(S,'labels',sMap.labels,'subplot',s,'fontsize',10); 
%
%   Input and output arguments ([]'s are optional): 
%     S       (struct) Smoothened Data Histogram structure, see sdh_calculate
%    [argID,  (string) See below.  The values which are unambiguous can 
%     value]  (scalar) be given without the preceeding argID.
%     e       (matrix) map units x 4, 'extent' property of text (labels) plotted
%     g       (matrix) units x 4: grid edge points
%
%   Here are the valid argument IDs and corresponding values. The values 
%   which are unambiguous (marked with '*') can be given without the
%   preceeding argID.
%     'type'      *(string) 'continuous' (default), 'contour', 'contourinous' (mix), 'image' (pixel), 'imagesc'.
%     'grid'      *(string) 'on', 'nodes', or 'off' (default). Depicts 
%                         relationship between underlining map and visualization.
%     'gridcolor'  (string) 'k' (default) or 'w' etc.
%     'levels'     (scalar) contour levels, default = 4.
%     'subplot'    (scalar) plot image into this subplot (handle)
%     'labels'     (cell)   labels (see sMap.labels)
%     'fontsize'   (double) default = 7 (size of labels)
%     'fontcolor'  (string) default = 'w' (white)
%     'shadow'     (scalar) default = 1 (on) 
%     'shadowcolor'(string) default = 'k' (black)
%     'sof'        (double) shadow offset factor (default = 1)
%     'sofn'       (double) number of shadows shadow offsets (default = 3)
%     'showpixel'  (scalar) default = '', e.g. 'r' plots red pixel
%     'pixel_pos'  (scalar) map unit of pixel to show (high light kind of)
%
%  See also SDH_CACULATE.

% elias 25/04/2002
% elias 13/02/2003 fixed the shadow offset problem (partly)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% defaults
fontsize = 7;
s = [];
type = 'continuous';
grid = 'off';
labels = {};
levels = 4;
titel = ['n = ',num2str(S.spread)];
fontcolor='w';
shadow = 1;
shadowcolor='k';
sof=1;
sofn=3;
showpixel = '';
pixel_pos = 0;
trace = [];
contourvalues = [];
gridcolor = 'k';

if ~isstruct(S) |  ~isfield(S,'type') | ~strcmp(S.type,'sdh'),
    error('(sdh_visualize) first argument is not SDH structure.');
end

% varargin
i=1; 
while i<=length(varargin), 
    argok = 1; 
    if ischar(varargin{i}), 
        switch varargin{i}, 
            % argument IDs
        case 'title',         i=i+1; titel = varargin{i}; 
        case 'type',          i=i+1; type = varargin{i}; 
        case 'grid',          i=i+1; grid = varargin{i}; 
        case 'levels',        i=i+1; levels = varargin{i}; 
        case 'subplot',       i=i+1; s = varargin{i}; 
        case 'labels',        i=i+1; labels = varargin{i}; 
        case 'fontsize',      i=i+1; fontsize = varargin{i}; 
        case 'fontcolor',     i=i+1; fontcolor = varargin{i}; 
        case 'shadow',        i=i+1; shadow = varargin{i}; 
        case 'shadowcolor',   i=i+1; shadowcolor = varargin{i}; 
        case 'sof',           i=i+1; sof = varargin{i}; 
        case 'sofn',          i=i+1; sofn = varargin{i}; 
        case 'showpixel',     i=i+1; showpixel = varargin{i}; 
        case 'pixel_pos',     i=i+1; pixel_pos = varargin{i}; 
        case 'trace',         i=i+1; trace = varargin{i}; 
        case 'contourvalues', i=i+1; contourvalues = varargin{i}; 
        case 'gridcolor',     i=i+1; gridcolor = varargin{i}; 
            % unambiguous values
        case {'on','nodes','off'}, grid = varargin{i};
        case {'continuous','contour','contourinous','image','imagesc','none'}, type = varargin{i}; 
        otherwise argok=0; 
        end
    elseif isnumeric(varargin{i}),
        level = varargin{i};
    else
        argok = 0; 
    end
    if ~argok, 
        disp(['(sdh_visualize) Ignoring invalid argument #' num2str(i+1)]); 
    end
    i = i+1; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START

if isempty(s),
    f = figure;
    s = subplot(1,1,1);
    set(f,'name',titel);
else
    subplot(s);
end
title(titel);

% visualize SDH
switch type, 
case 'image', 
    image(S.matrix);
    set(s,'ydir','normal')
    sdh_colormap('islands');
case 'imagesc', 
    imagesc(S.matrix);
    set(s,'ydir','normal')
    sdh_colormap('islands',1/3);
case 'continuous', 
    pcolor(S.matrix); shading interp;
    sdh_colormap('islands');
case 'contour',
    if ~isempty(contourvalues),
        contourf(S.matrix,contourvalues);
    else
        contourf(S.matrix,levels);
    end
    colormap(flipud(1-gray/2));
case 'contourinous',
    pcolor(S.matrix); shading interp; hold on
    contour(S.matrix,levels,'k');
    colormap(flipud(1-gray/2));
case 'none',
    % dont add anything to the plot except for labels maybe, or a pixel
otherwise, 
    error('(sdh_visualize) unsupported type!');
end

g = [];
if strcmp(grid,'on'), % use grid so that cells correspond to map units
    hold on; 
    
    x = S.msize(2);
    y = S.msize(1);
    c = 2^S.interp.ntimes;
    
    if strcmp(S.frame,'on'), fr = 1;
    else fr = 0;
    end
    
    o=fr*c-c/2+1;
    
    g = zeros(x*y,4);
    k=1;
    for j=1:x,
        for i=1:y,
            g(k,:) = [o+(j-1)*c, o+(i-1)*c, c, c];
            k = k + 1;
        end
    end

    for i=1:x+1, 
        plot([o+(i-1)*c, o+(i-1)*c],[o, o+c*y],'-','color',gridcolor);
    end
    for i=1:y+1, 
        plot([o, o+c*x],[o+(i-1)*c, o+(i-1)*c],'-','color',gridcolor);
    end
elseif strcmp(grid,'nodes'), % use grid so that grid nodes correspond to map units
    hold on; 
    
    x = S.msize(2);
    y = S.msize(1);
    c = 2^S.interp.ntimes;

    g = zeros(x*y,2);    
    
    if strcmp(S.frame,'on'), fr = 1;
    else fr = 0;
    end
    
    o=fr*c+1;
    
    for i=1:x, 
        plot([o+(i-1)*c, o+(i-1)*c],[o, o+c*(y-1)],'-','color',gridcolor);
    end
    for i=1:y, 
        plot([o, o+c*(x-1)],[o+(i-1)*c, o+(i-1)*c],'-','color',gridcolor);
    end
    
    k = 1;
    for i=1:x,
        for j=1:y,
            g(k,:) = [o+(i-1)*c, o+(j-1)*c]; k=k+1;
            plot(o+(i-1)*c, o+(j-1)*c,'.','color',gridcolor);
        end
    end
end

e = [];
if ~isempty(labels),
    hold on; 
    
    x = S.msize(2);
    y = S.msize(1);
    c = 2^S.interp.ntimes;
    
    if strcmp(S.frame,'on'), fr = 1;
    else fr = 0;
    end
    
    o=fr*c+1;
    
    OFFSET = (1:sofn)*sof;
    
    e = zeros(x*y,4);
    k=1;
    for j=1:x,
        for i=1:y,
            
            if 0,
                str = labels{k};
            else
                str = labels(k,find(strcmp(labels(k,:),'')==0));
            end
            
            if shadow,
                for offis=1:length(OFFSET),
                    hsh(1) = text(o+(j-1)*c-OFFSET(offis),o+(i-1)*c-OFFSET(offis),str);
                    hsh(2) = text(o+(j-1)*c+OFFSET(offis),o+(i-1)*c-OFFSET(offis),str);
                    hsh(3) = text(o+(j-1)*c-OFFSET(offis),o+(i-1)*c+OFFSET(offis),str);
                    hsh(4) = text(o+(j-1)*c+OFFSET(offis),o+(i-1)*c+OFFSET(offis),str);
                    
                    hsh(5) = text(o+(j-1)*c              ,o+(i-1)*c-OFFSET(offis),str);
                    hsh(6) = text(o+(j-1)*c+OFFSET(offis),o+(i-1)*c              ,str);
                    hsh(7) = text(o+(j-1)*c-OFFSET(offis),o+(i-1)*c              ,str);
                    hsh(8) = text(o+(j-1)*c              ,o+(i-1)*c+OFFSET(offis),str);

                    set(hsh,'fontsize',fontsize,'horizontalalignment','center','color',shadowcolor,'interpret','none');
                end            
            end
            h=text(o+(j-1)*c, o+(i-1)*c, ...
                str,'fontsize',fontsize,'horizontalalignment','center','color',fontcolor,'interpret','none'); 
            h2=text(o+(j-1)*c, o+(i-1)*c, ...
                str,'fontsize',fontsize,'horizontalalignment','center','color','r','interpret','none','visible','off'); 
            set(h2,'units','normalized');
            e(k,:) = get(h2,'extent');
            set(h2,'units','data');
            
            if 0
                lt='r';
                lux = e(k,1);
                luy = e(k,2)+(j-1)*e(i,4)/k;
                
                rox = lux + e(k,3);
                roy = luy + e(k,4)/k;
                
                max_x = 900;
                max_y = round(800*(6+1)/(9+1));
                
                lux=lux*max_x;
                luy=luy*max_y;
                rox=rox*max_x;
                roy=roy*max_y;
                
                plot([lux rox], [luy luy],lt); hold on
                plot([lux lux], [luy roy],lt)
                plot([rox lux], [roy roy],lt)
                plot([rox rox], [luy roy],lt)
            end
            k=k+1;
        end
    end
end

if ~isempty(showpixel) & (~isempty(strfind(type,'image')) | strcmp(type,'none')),
    hold on; 
    
    x = S.msize(2);
    y = S.msize(1);
    c = 2^S.interp.ntimes;
    
    if strcmp(S.frame,'on'), fr = 1;
    else fr = 0;
    end
    
    o=fr*c+1;

    if ~isempty(trace),
        trace_points=zeros(length(trace),2);
        for t = 1:length(trace);
            k=1;
            for j=1:x,
                for i=1:y,
                    if k == trace(t),
                        trace_points(t,:) = [o+(j-1)*c,o+(i-1)*c];
                    end
                    k=k+1;
                end
            end
        end
        plot(trace_points(:,1),trace_points(:,2),'b-');
    end
    
    k=1;
    for j=1:x,
        for i=1:y,
            if k == pixel_pos,
                plot(o+(j-1)*c,o+(i-1)*c,'b.','markersize',15);
                plot(o+(j-1)*c,o+(i-1)*c,'.','color',showpixel,'markersize',6);
            end
            k=k+1;
        end
    end
end

set(s,'ydir','reverse');
set(s,'xtick',[-realmax realmax]);
set(s,'ytick',[-realmax realmax]);

set(gcf,'renderer','painter')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%