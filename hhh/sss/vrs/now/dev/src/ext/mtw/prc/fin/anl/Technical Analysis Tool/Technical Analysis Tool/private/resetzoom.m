function resetzoom(obj)
% tatool helper function
% When manipulating axes MATLAB automatically turns the zoom off, so need
% to check where tatool thinks it should be and put it back on in needed
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);
switch get(ad.handles.uimenueditzoomon,'Checked')
    case 'on' % put zoom back on
        uimenueditcb(ad.handles.uimenueditzoomon);
    case 'off' % make sure check mark indicates off
        uimenueditcb(ad.handles.uimenueditzoomoff);
end