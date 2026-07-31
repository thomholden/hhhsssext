%plot_in_new_window
% Function to clone plot in a particular axes
%
% LAST UPDATED by Andy French. 17-Jan-2010
%
% Syntax: [new_fig,new_ax] = plot_in_new_window(fig,ax,cax,norm_position,...
%                            name,savepics)
%
% fig            - Handle of current figure
% ax             - Handle of axes to copy to a new figure
% cax            - Colour limits returned by caxis. If empty, don't plot
%                   colorbar.
% norm_position  - Four element vector defining normalised position of new
%                  figure. e.g. [0.13 0.11 0.675 0.815]
% name           - Name of new figure
% savepics       - If == 1 save PNG file of name given in name above
%                - If == 2 save PNG file and then close new figure
%
% new_fig        - Handle of new figure
% new_ax         - Handle of new axes

function  [new_fig,new_ax] = plot_in_new_window(fig,ax,cax,norm_position,...
    name,savepics)

%Set picture save method. 1 is using 'saveas', otherwise use 'getframe'
picsave_method = 1;

%Plot in new window, filling window with axes
new_fig = figure('color',[1 1 1],'name',name);
new_ax = copyobj(ax,new_fig);
if ~isempty(cax)
    colorbar
    caxis(cax)
end
set(new_ax,'units','normalized')
set(new_ax,'position',[0 0 1 1])
set(new_fig,'units','normalized','Position',norm_position);

%Save figure, if required
if savepics==1
    picsave(new_fig,name,picsave_method);
elseif savepics==2
    picsave(new_fig,name,picsave_method);
    close(new_fig)
end

%%

function picsave(new_fig,name,picsave_method)
if picsave_method == 1
    saveas(new_fig,name,'png');
else
    F = getframe(new_fig);
    imwrite(F.cdata,name,'png');
end

%End of code

