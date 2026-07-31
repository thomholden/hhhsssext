function dialog_gg(varargin)

title='Dialog_GG';

text={'Error dialog box by GG';'Please press Yes or No';...
    'This is a test line written to confirm size changes due to variable length string'};

for i=1:2:nargin
    switch lower(varargin{i})
        case 'title'
            title=varargin{i+1};
        case 'text'
            text=varargin{i+1};
        otherwise
            disp('Wrong method of Input');
    end
end

sz = size(text, 1);
l = 0;
for i=1:sz
    len = length(text{i});
    l = max(l, len);
end

LF = 50;
HF = 5.5;
if l>22,LF = 50 + (l-22);end
if sz>2,HF = 5.5 + sz-2;end
if ~isempty(gcbf)
    GcbfOLdUnits=get(gcbf,'Units');
    set(gcbf,'Units','characters');
    scrsz=get(gcbf,'pos');
    set(gcbf,'Units',GcbfOLdUnits);
else
    set(0,'Units','characters');
    scrsz=get(0,'Screensize');
    set(0,'Units','pixels');
end
scr = get(0,'Screensize');
pos=[scrsz(1) + (scrsz(3)-LF)/2, scrsz(2) + (scrsz(4)-HF)*2/3, LF,HF];
hfig=figure('menubar','none','resize','off','Name',title,'numbertitle',...
    'off','color',[.9,.9,.9],'Units','character','pos',pos,'DeleteFcn'...
    ,@dispose_fig,'WindowStyle','modal');
pos = [(LF-34-l+22)/2,2.7,34+l-22,2.7+sz-2];
if l>22, pos(3) = 34+l-22;end
if sz>2, pos(4) = 2.7+sz-2;end
txt = uicontrol('style','text','Units','characters','Backgroundcolor',[.9,.9,.9],'pos',pos,'FontUnits','normalized','String',text);
g = get(txt, 'FontSize');
set(txt, 'FontSize', g*1.5/1080*scr(4));
h=uicontrol('Units','characters','pos',[(LF-15)/2,.5,15,1.5],'String','OK','FontUnits', 'normalized','callback',@OK_cb);
g = get(h, 'FontSize');
set(h, 'FontSize', g*1.5/1080*scr(4));

uiwait(hfig);

    function OK_cb(src,evnt)

    dispose_fig;
    end

    function dispose_fig(src,evnt)
    uiresume(hfig);
    closereq;
    end
end