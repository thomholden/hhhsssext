function h = semilogy(varargin)
%% wrapper for the original semilogy function
currentFolder = pwd; % save current folder
cd([matlabroot '\toolbox\matlab\graph2d']) %go to matlab folder
h = semilogy(varargin{:}); % call original function
akZoom();
cd(currentFolder) % go back to current folder