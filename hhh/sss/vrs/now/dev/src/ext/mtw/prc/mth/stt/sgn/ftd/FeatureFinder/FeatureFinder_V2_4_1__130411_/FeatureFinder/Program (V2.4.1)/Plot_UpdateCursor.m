function Plot_UpdateCursor(hFig,cModifiers)

bShiftDown=any(strcmp(cModifiers,'shift'));
bDown=fLibrary('ButtonDown','no_warning');
if isempty(bDown),bDown=false;end

if bShiftDown&&~bDown
    set(hFig,'Pointer','crosshair');
elseif bShiftDown&&bDown
    set(hFig,'Pointer','fullcrosshair');
elseif bDown
    setptr(hFig,'closedhand');
else
    setptr(hFig,'hand');
end