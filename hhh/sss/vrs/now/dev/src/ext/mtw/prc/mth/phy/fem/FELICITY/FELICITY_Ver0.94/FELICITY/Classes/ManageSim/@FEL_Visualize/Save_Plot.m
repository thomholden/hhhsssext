function Full_FN = Save_Plot(obj, FigHandle, FileName, Cmd)
%Save_Plot
%
%   Save a figure to a file.
%
%   Full_FN   = obj.Save_Plot(FigHandle, FileName, Cmd);
%
%   FigHandle = handle to figure window.
%   FileName  = local filename to use when saving the figure.
%   Cmd       = any of the commands available to the MATLAB "print" command.
%               if empty, then default = '-depsc' (save as color eps file)
%
%   Full_FN   = the full filename that the figure was saved to.

% Copyright (c) 05-05-2014,  Shawn W. Walker

if isempty(Cmd)
    Cmd = '-depsc'; % default to color eps plot
    % note: '-deps' is black and white eps
end

% file stuff
Full_FN = fullfile(obj.Plot_Dir,FileName);
%export_fig(FN, '-pdf', '-eps', '-transparent');
%export_fig(FN, '-pdf', '-transparent');

%print(FigHandle,'-deps',FN); % black and white
print(FigHandle, Cmd, Full_FN); % color

end