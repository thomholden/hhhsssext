%FIGCENTER 
% Calculates position vector of current figure 
% in pixels that centers the figure.
% 
% Andy French. 14th March 2012.
%
% Syntax: position_vector=figcenter('figure_tag')
%
%  position_vector is a four component row vector.
%  position_vector(1)=number of PIXELS of figure bottom left hand corner
%                     from screen bottom left hand corner, horizontally.
%  position_vector(2)=number of PIXELS of figure bottom left hand corner
%                     from screen bottom left hand corner, vertically.
%  position_vector(3)=number of PIXELS of figure width.
%  position_vector(4)=number of PIXELS of figure height.
%
% 'figure_tag' is a string giving the tag of the figure in question.
% Make sure the figure's 'HandleVisibility' option is set to 'on' for the
% figure to be accessible.
%
% If the figure's tag is unknown, 'current' as the argument of figcentre
% will use the gcf command instead of the specific figure handle.
% Be warned, it is sometimes not clear which is the current figure when multiple
% figures are activated!

function output=figcenter(figtag)

%Get screen dimensions in pixels.
set(0,'units','pixels') ;
screen_size=get(0,'Screensize');
display_size=get(0,'MonitorPositions');

%Get position vector for figure using gcf or specific handle address.
if strcmp(figtag,'current')==1 
    set(gcf,'units','pixels'); 
    fig_position=get(gcf,'position') ; 
else 
    fig_handle=findobj('tag',figtag); 
    set(fig_handle,'units','pixels');  
    fig_position=get(fig_handle,'position');  
end

%Define coordinates or figure bottom hand corner from screen bottom hand corner
%that will place the figure window in the center of the screen.
center_x=0.5*( display_size(3)-fig_position(3) ) - screen_size(1);
center_y=0.5*( display_size(4)-fig_position(4) ) - screen_size(2);

%Define output of figcenter function.
output=[center_x,center_y,fig_position(3),fig_position(4)];

%End of code


