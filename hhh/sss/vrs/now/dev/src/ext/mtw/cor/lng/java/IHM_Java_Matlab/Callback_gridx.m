function Callback_gridx(varargin)

text1=varargin{4};
string=text1.getText;
figname=char(get(string,'Bytes'))';

try
    fig=findobj('Name',figname);
    childfig=get(fig,'Children');
    v=get(childfig,'XGrid');
    switch v
        case 'off'
        set(childfig,'XGrid','on');
        case 'on'
        set(childfig,'XGrid','off');
        otherwise
    end
catch
    clear lasterr;
end