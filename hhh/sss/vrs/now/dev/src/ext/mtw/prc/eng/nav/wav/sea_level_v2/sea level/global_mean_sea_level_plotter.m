% This example looks up global mean sea level data using get_gmsl.m and
% get_gmsl_ns.m, plots the data, and computes the linear regression from
% the year 1992 to present. Produces the plot shown in sea_level_example.pdf. 
% Chad A. Greene, 2012. 
% 
% Data are retrieved from the University of Colorado Sea Level Research Group. 
% If you use this data, please cite the following:
% Nerem, R. S., D. Chambers, C. Choe, and G. T. Mitchum. "Estimating Mean
% Sea Level Change from the TOPEX and Jason Altimeter Missions." Marine 
% Geodesy 33, no. 1 supp 1 (2010): 435.
% 
% See also get_gmsl and get_gmsl_ns.
% 

[gmsl,yr] = get_gmsl; % Import data with seasonal signals retained
sltrend = [ones(length(gmsl),1) yr]\gmsl; % computes linear least squares fit

figure
subplot(2,1,1)
plot(yr,gmsl,'b'); hold on
plot(yr,yr*sltrend(2)+sltrend(1),'k')
xlim([yr(1) yr(end)])
text(yr(1)+.5*(yr(end)-yr(1)),min(gmsl)+.2*(max(gmsl)-min(gmsl)),['linear trend ',sprintf('%0.2f',sltrend(2)),' mm/yr sea level rise'])
text(yr(1)+.1*(yr(end)-yr(1)),min(gmsl)+.8*(max(gmsl)-min(gmsl)),'seasonal signals retained')
title('global mean sea level rise')
ylabel('{\Delta} mean sea level (mm)')
box off


% Repeat the above with seasonal signals removed: 
[gmsl_ns,yr_ns] = get_gmsl_ns; 
sltrend_ns = [ones(length(gmsl_ns),1) yr_ns]\gmsl_ns; 

subplot(2,1,2)
plot(yr_ns,gmsl_ns,'b'); hold on
plot(yr_ns,yr_ns*sltrend_ns(2)+sltrend_ns(1),'k')
xlim([yr_ns(1) yr_ns(end)])
text(yr_ns(1)+.5*(yr_ns(end)-yr_ns(1)),min(gmsl_ns)+.2*(max(gmsl_ns)-min(gmsl_ns)),['linear trend ',sprintf('%0.2f',sltrend_ns(2)),' mm/yr sea level rise'])
text(yr(1)+.1*(yr(end)-yr(1)),min(gmsl)+.8*(max(gmsl)-min(gmsl)),'seasonal signals removed')
ylabel('{\Delta} mean sea level (mm)')
xlabel('year')
box off

