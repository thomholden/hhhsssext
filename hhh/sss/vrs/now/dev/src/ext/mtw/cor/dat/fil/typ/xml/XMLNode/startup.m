%Add XMLNode folder to path
folder = fileparts(mfilename('fullpath'));
addpath(fullfile(folder,'XMLNode'),'-end');
addpath(fullfile(folder,'example'),'-end');