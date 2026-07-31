function h = image(varargin)
%% wrapper for the original image function
currentFolder = pwd; % save current folder
cd([matlabroot '\toolbox\matlab\specgraph']) %go to matlab folder
h = image(varargin{:}); % call original function
akZoom();
cd(currentFolder) % go back to current folder