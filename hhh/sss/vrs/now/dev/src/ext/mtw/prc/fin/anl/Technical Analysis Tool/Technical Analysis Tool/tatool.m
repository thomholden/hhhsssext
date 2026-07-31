function tatool(flag)
% This is the entry point function to create a tatool, technical analysis
% tool.
%
% Example:
% tatool
%

if nargin == 0
    flag = 'init';
end

switch flag
    case 'init'
        hfig = findall(0,'Name','Technical Analysis Tool');
        if ~isempty(hfig) % figure already exists
            figure(hfig);
        else
            % Create widgets
            hfig = figure('Visible','off','Units','pixels',...
                'Name','Technical Analysis Tool','NumberTitle','off',...
                'MenuBar','none','Renderer','zbuffer',...
                'IntegerHandle','off','Resize','off','Tag','tatoolfig',...
                'PaperPositionMode','auto','DockControls','off');
            figpos = get(hfig,'Position');
            % will need default axes positioning info later, so create a temporary
            % axis and store position info
            ha = axes('Parent',hfig,...
                'Units','Pixels',...
                'Visible','off');
            apos = get(ha,'Position');
            ad.defaultleftmargin = apos(1);
            ad.defaultrightmargin = figpos(3)-apos(1)-apos(3);
            ad.defaultaxesheight = apos(4);
            
            ad.sliderwidth = 16;
            % will need to know the default distance that the xlabel and
            % the title appear below/above their axes so create these, get
            % the values, then delete them
            
            hxl = xlabel('This is temporary',...
                'Parent',ha,...
                'Visible','off',...
                'Units','pixels');
            xlpos = get(hxl,'Extent');
            ad.defaultxlabelspacing = -xlpos(2); % value is -'ve so this is like abs()
            ht = title('This is temporary',...
                'Parent',ha,...
                'Visible','off',...
                'Units','pixels');
            htpos = get(ht,'Extent');
            ad.defaulttitlespacing = (htpos(2)-apos(4))+htpos(4);
            ad.defaultaxesspacing = htpos(4);
            
            % delete the temporary axis (which will also remove the title
            % and xlabel)
            delete(ha);
            
            % make figure slightly larger to account for sliders
            figpos = figpos + [-ad.sliderwidth/2 -ad.sliderwidth/2 ad.sliderwidth ad.sliderwidth];
            set(hfig,'Position',figpos);
            ad.defaultfigureposition = figpos;
            
            % Need relative height of indicator plots to main plot
            ad.defaultrelativeheight = 1/3;
            
            uicontrol('Parent',hfig,...
                'Style','text','Units','pixels',...
                'Position',[figpos(3)/2-10*18 (2/3*figpos(4)) 20*18 18],...
                'String','Start by importing a data set using the File menu.',...
                'Backgroundcolor',get(hfig,'Color'),...
                'Tag','welcomeinfo');
            
            % create the menubar
            createmenubar(hfig);
            
            % create the sliders, including a blank text box to hide
            % the bottom right corner where the scroll bars meet
            uicontrol('Parent',hfig,...
                'Style','slider','Units','pixels',...
                'Position',[0 0 figpos(3)-ad.sliderwidth+1 ad.sliderwidth],'Enable','on',...
                'Min',0,'Max',1,'Value',0,'SliderStep',[0.1 10000],...
                'Callback',@scrollcb,'Tag','hscroll');
            uicontrol('Parent',hfig,...
                'Style','slider','Units','pixels',...
                'Position',...
                [figpos(3)-ad.sliderwidth+1 ad.sliderwidth ad.sliderwidth figpos(4)-ad.sliderwidth],...
                'Enable','on',...
                'Min',0,'Max',1,'Value',1,'SliderStep',[0.1 10000],...
                'Callback',@scrollcb,'Tag','vscroll');
            uicontrol('Parent',hfig,...
                'Style','Text','String','','Units','pixels',...
                'Position',[figpos(3)-ad.sliderwidth+1 1 ad.sliderwidth ad.sliderwidth-1],...
                'Tag','cornerscrollmask');
            
            set(hfig,'Visible','on','HandleVisibility','callback');
            
            % Create and save a handles structure
            ad.handles = guihandles(hfig);
            guidata(hfig,ad);
        end
end






