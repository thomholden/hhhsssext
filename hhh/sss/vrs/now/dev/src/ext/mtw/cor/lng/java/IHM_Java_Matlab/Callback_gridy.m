function Callback_gridy(varargin)

text1=varargin{4};
string=text1.getText;
figname=char(get(string,'Bytes'))';

try 
    fig=findobj('Name',figname);
    get(fig,'Children');
    childfig=get(fig,'Children');
    v=get(childfig,'YGrid');
    switch v
        case 'off'
        set(childfig,'YGrid','on');
        case 'on'
        set(childfig,'YGrid','off');
        otherwise
    end
catch
    clear lasterr;
end