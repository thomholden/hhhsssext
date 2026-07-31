function h = imagesc(varargin)
%% wrapper for the original imagesc function
currentFolder = pwd; % save current folder
cd([matlabroot '\toolbox\matlab\specgraph']) %go to matlab folder
h = imagesc(varargin{:}); % call original function
akZoom();
cd(currentFolder) % go back to current folder