function h = plot(varargin)
%% wrapper for the original plot function
currentFolder = pwd; % save current folder
cd([matlabroot '\toolbox\matlab\graph2d']) %go to matlab folder
h = plot(varargin{:}); % call original function
akZoom();
cd(currentFolder) % go back to current folder