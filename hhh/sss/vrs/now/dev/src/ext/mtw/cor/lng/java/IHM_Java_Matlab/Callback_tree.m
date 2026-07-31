function Callback_tree(varargin)


tree=varargin{3};
text1=varargin{4};
string=text1.getText;
figname=char(get(string,'Bytes'))';

if ~isempty(figname)
    curb=findobj('Tag','mycurbe');
    path=tree.getSelectionPath;
    strpath=path.toString;
    pathtab=char(get(strpath,'Bytes'))';
    
   if ~isempty(strfind(pathtab,'rectangle'))
       set(curb,'Marker','s');
   elseif ~isempty(strfind(pathtab,'triangle'))    
       set(curb,'Marker','^');
   elseif ~isempty(strfind(pathtab,'rond'))    
       set(curb,'Marker','O');
   elseif ~isempty(strfind(pathtab,'bleu'))    
       set(curb,'Color','b');
   elseif ~isempty(strfind(pathtab,'rouge'))    
       set(curb,'Color','r');
   elseif ~isempty(strfind(pathtab,'vert'))    
       set(curb,'Color','g');
   else
   end
   
    
else
    warndlg('no data or figure displayed');
end
