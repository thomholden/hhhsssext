function [m,h]= MASH_plot(x, Ys, w, Y, datalab)
%
% function [m,h]= MASH_plot(x, Ys, w, Y, datalab) 
%
% Computes and displays the Moving Average over Shifting Horizon (MASH), 
% a tool to be applied in Exploratory Data Analysis for trend detection
% in seasonal data. 
% The MASH allows for simultaneously investigating the seasonality in the 
% data and filtering out the effects of interannual variability,
% thus making trend detection easier.
% Ref. "Trend detection in seasonal data: from hydrology to water
% resources", D. Anghileri, F. Pianosi, and R. Soncini-Sessa, Journal of 
% Hydrology, 2014 (http://dx.doi.org/10.1016/j.jhydrol.2014.01.022)
%
% The MASH is a collection of trajectories of the moving average over 'w' 
% consecutive days (or weeks, months, etc.), computed on a shifting horizon
% of 'Y' consecutive years.
%
% Input:
%    - x  = time series to be analyzed (*)                    - matrix(T,nY)
%    - Ys = starting year of the time series (format: 'yyyy') - scalar
%    - w  = half number of consecutive data to be averaged    - scalar
%          (i.e. moving average considers a window of 2*w+1 data)
%    - Y  = number of consecutive years to be averaged (**)   - scalar
% datalab = name and units of measure of 'x' (***)            - string
%
% Output:
%   - m  = averaged seasonal data                            - matrix(T,nY-Y+1)
%   - h  = handle of the lines in the plot                   - vector(nY-Y+1,1)
%
% REMARKS:
% (*) 'T' is the number of calendar units in one period (e.g. 365 for daily
%      data, 52 for weekly data, etc.) and 'nY' is the number of years in 
%      the time series. In case of daily data, data of leap years must be
%      resorted to a time series of 365 values by the user.
% (**) If Y = 1, w = 0 then the original data are plotted (without
%      averaging)
% (***) To be used for labeling axes in the plots
%
% EXAMPLE:
% % Generate synthetic time series
% % (cyclostationary signal + linear trend)
% T  = 365;
% t  = [1:30*T]' ;
% x_ = sin(2*pi/T*t+143)*15+rand(size(t))+0.001*t ;
% Ys = 1990 ;
% w  = 4  ;
% Y  = 20 ;
% y_label = 'Temperature';
% % Plot time series:
% figure; plot(x_); ylabel(y_label)
% % Compute and visualize MASH: 
% x  = reshape(x_,T,[]) ;
% [m,h] = MASH_plot(x, 1990, 4, 20, y_label) ;
%
% Created:     Daniela Anghileri, Francesca Pianosi 28/01/2014

% check on inputs
if ~isnumeric(x); error('x must be a double matrix of size (T,nY)'); end
[T,nY ] = size(x)        ;
if ~isnumeric(Ys); error('Ys must be a scalar integer number'); end
if ~isscalar(Ys); error('Ys must be a scalar'); end
if abs(Ys-round(Ys)); error('Ys must be an integer number'); end
%
if ~isnumeric(Y); error('Y must be a scalar integer number'); end
if ~isscalar(Y); error('Y must be a scalar'); end
if abs(Y-round(Y)); error('Y must be an integer number'); end
if Y>nY
    error('Y must be <= %d',nY)
elseif Y<1
    error('Y must be >=1')
end
%
if ~isnumeric(w); error('w must be a scalar integer number'); end
if ~isscalar(w); error('w must be a scalar'); end
if abs(w-round(w)); error('w must be an integer number'); end
if 2*w+1>T
    error('w must be such that 2*w+1 be <= %d (number of rows in x)',T)
elseif w<0
    error('w must be >=0')
end
%
if ~ischar(datalab); error('datalab must be a string'); end

% define useful variables
Hi   = [ Ys : Ys+nY-Y]   ;
H_if = [ Hi ; Hi+(Y-1) ] ; % initial and final year


% Compute the MASH:
m  = nan(T,nY-Y+1);
x_ = [ x(end-w+1:end,:) ; x ; x(1:w,:) ] ; % handling first and last w data
for j = 1:nY-Y+1
    for i = 1:T
        m(i,j) = nanmean(nanmean( x_( i:i+2*w , j:j+Y-1 ) )) ;
    end
end


% MASH against time
figure
h = plot(m);
c = colormap(jet(size(H_if,2)));
for i=1:length(h); set(h(i),'Color',c(i,:),'LineWidth',1); end
set(gca,'FontSize',15,'XLim',[0 T])
xlabel('Calendar unit')
ylabel(datalab)
legend(num2str(H_if'),'Location','NW')

% MASH in time and moving horizons
figure
imagesc(m)
cb = colorbar('peer',gca);
set(gca,'FontSize',15)
xlabel('Moving horizon'); ylabel('Calendar unit')
set(get(cb,'ylabel'),'String',datalab,'FontSize',15);
