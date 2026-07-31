function Callback_trace(varargin)

%varargin{1} 
%varargin{2} est le mouse event exemple: MOUSE_CLICKED
%varargin{3} a partir d'ici commence les handles Java et les paramètres 

panel3=varargin{4};
vp=panel3.getViewport;
try
    
jtab=vp.getComponent(0);
col=jtab.getSelectedColumns;
row=jtab.getSelectedRows;
if (length(col)~=1)&&(length(col)>0)
    warndlg('select only one column');
    col=[];
    row=[];
    return;
else
col=col+1;
row=row+1;
end
% extraction des données
data=varargin{11}(row,col);
gridx=varargin{9};
gridy=varargin{10};
%verification si une figure avec 
%le meme nom existe deja
text1=varargin{6};
string=text1.getText;
    if (~isempty(findobj('Name',char(get(string,'Bytes'))')))
        h=findobj('Name',char(get(string,'Bytes'))');
        childfig=get(h,'Children');
        
        warndlg('a figure with the same name already exist!!');
        return;
        %cla(childfig);
        %close(h);
        
    else
        h=figure;
    end

set(h,'Name',char(get(string,'Bytes'))');
ax=axes('HandleVisibility','on');
try 
    plot(data,'Tag','mycurbe');
    drawnow
    xlab=get(ax,'XLabel');
    ylab=get(ax,'YLabel');
    text2=varargin{7};
    string2=text2.getText;
    set(xlab,'String',char(get(string2,'Bytes'))');
    text3=varargin{8};
    string3=text3.getText;
    set(ylab,'String',char(get(string3,'Bytes'))');
    childfig=get(h,'Children');
        if gridx.isSelected 
            set(childfig,'XGrid','on');
        end
        if gridy.isSelected
            set(childfig,'YGrid','on');
        end
            
catch
    warndlg('no data selected');
    close(h);
    clear lasterr;
end

catch
errordlg('no data yet')
end