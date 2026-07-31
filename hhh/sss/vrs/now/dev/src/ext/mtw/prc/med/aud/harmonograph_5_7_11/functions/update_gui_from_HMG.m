%update_gui_from_HMG
% Updates GUI following a change to structured array HMG, contained within
% structure handles.
%
% LAST UPDATED by Andy French 18th March 2011

function handles = update_gui_from_HMG(handles)

%Update edit boxes
set(handles.EDITA,'string',num2str( handles.HMG.A ));
set(handles.EDITD,'string',num2str( handles.HMG.D ));
set(handles.EDITF,'string',num2str( handles.HMG.F ));
set(handles.EDITphi,'string',num2str( handles.HMG.phi ));
set(handles.EDITN,'string',num2str( handles.HMG.N ));
set(handles.EDITM,'string',num2str( handles.HMG.M ));

%Update sliders
v = ( handles.HMG.F - handles.HMG.Flimits(1) ) ...
    / ( handles.HMG.Flimits(2) - handles.HMG.Flimits(1) );
set(handles.SLIDERF,'value',v);
v = ( handles.HMG.A - handles.HMG.Alimits(1) ) ...
    / ( handles.HMG.Alimits(2) - handles.HMG.Alimits(1) );
set(handles.SLIDERA,'value',v);
v = ( handles.HMG.D - handles.HMG.Dlimits(1) ) ...
    / ( handles.HMG.Dlimits(2) - handles.HMG.Dlimits(1) );
set(handles.SLIDERD,'value',v);
v = ( handles.HMG.phi - handles.HMG.philimits(1) ) ...
    / ( handles.HMG.philimits(2) - handles.HMG.philimits(1) );
set(handles.SLIDERphi,'value',v);

%Update Harmonograph type
set( handles.POPUPMENUhmgtype,'string',handles.HMG.types );
set( handles.POPUPMENUhmgtype,'value',...
    strmatch( handles.HMG.type, handles.HMG.types,'exact') );

%End of code