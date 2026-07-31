function h = imshow(varargin)
%% wrapper for the original image function
currentFolder = pwd; % save current folder
cd([matlabroot '\toolbox\images\imuitools']) %go to matlab folder
h = imshow(varargin{:}); % call original function
akZoom();
cd(currentFolder) % go back to current folder