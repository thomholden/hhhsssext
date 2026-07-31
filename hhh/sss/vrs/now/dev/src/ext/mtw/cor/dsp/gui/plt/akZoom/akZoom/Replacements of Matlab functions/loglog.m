function h = loglog(varargin)
%% wrapper for the original loglog function
currentFolder = pwd; % save current folder
cd([matlabroot '\toolbox\matlab\graph2d']) %go to matlab folder
h = loglog(varargin{:}); % call original function
akZoom();
cd(currentFolder) % go back to current folder