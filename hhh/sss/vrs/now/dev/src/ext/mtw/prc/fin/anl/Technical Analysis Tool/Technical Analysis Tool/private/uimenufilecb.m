function uimenufilecb(obj,eventdata) %#ok
% tatool helper function for processing the file menu callbacks
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);
switch get(obj,'Tag')
    case 'uimenufileexportarray'
    case 'uimenufileexportstruct'
    case 'uimenufileexportfints'
    case 'uimenufileprint'
    case 'uimenufileclose'
        close(ad.handles.tatoolfig);
    otherwise
        str = [mfilename,' shouldn''t be called in this way,'];
        error(str);
end
