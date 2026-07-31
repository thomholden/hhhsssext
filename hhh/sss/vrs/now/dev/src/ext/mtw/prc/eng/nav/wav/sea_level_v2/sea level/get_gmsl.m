function [gmsl,year_vec] = get_gmsl
%GET_GMSL retrieves global mean sea level data from 1992 to present (with
%an approximately 2 month delay for the most recent data). Seasonal signals 
% are preserved using this function. Chad A. Greene, 2012.
% 
% For global mean sea levels with seasonal signals removed, use get_gmsl_ns.m.  
% 
% INPUTS: none
% 
% OUTPUTS: 
% gmsl = global mean sea level array
% year_vec = corresponding years
% 
% Data are retrieved from the University of Colorado Sea Level Research Group. 
% If you use this data, please cite the following:
% Nerem, R. S., D. Chambers, C. Choe, and G. T. Mitchum. "Estimating Mean
% Sea Level Change from the TOPEX and Jason Altimeter Missions." Marine 
% Geodesy 33, no. 1 supp 1 (2010): 435.
%
% See also get_gmsl_ns, global_mean_sea_level_plotter.

cu_slr = urlread('http://sealevel.colorado.edu/files/2012_rel4/sl_global.txt');
slr = textscan(cu_slr,'%n %n','headerlines',1); 
year_vec = slr{1}; 
gmsl = slr{2};



