function [hEdit] = editbox(fig,x,y,w,h,defstr,label)
% editbox
% ----------------------------------------------------
% Purpose:
% 	Open edit window with label
%
% Input:
%   fig     - figure object;
%   x,y     - location of left-bottom corner;
%   w,h     - width and height of edit window;
%   label   - text label;
%   defstr  - default string. 	
%
% All coordinates are in figure measurement units.
% (c) by A.Ivanov

pxLabelWid = 6*size(label,2);

hEdit = uicontrol(fig,'Style','edit','Position',[x+pxLabelWid y w h], ...
	'String',defstr);
txtlabel = uicontrol(fig,'Style','text', ...
	'Position',[x  y-2 pxLabelWid h],'Horiz','left', ...
	'String',label);
