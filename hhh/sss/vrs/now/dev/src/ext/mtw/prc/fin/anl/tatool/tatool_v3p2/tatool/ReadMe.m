% Technical Analysis Tool (TATOOL) is designed to allow the user to
% quickly calculate, display and compare various financial technical
% analysis indicators.
%
% Help for TATOOL is currently quite limited.   What follows is a brief
% description of loading, manipulating and exporting data.  A list of
% known issues is also given at the end.
%
% DIRECTORIES
% TATOOL requires both the .../tatool and .../tatool/analysisfcns
% directories to be on the MATLAB path.
%
% IMPORTING DATA
% The first thing that needs to be done is for time series data
% to be loaded.  Other functionality is disabled until this is done.
% There are potentially 5 options for importing data (under the File->Import menu).
% The options are:
% 1. A ticker symbol from http://finance.yahoo.com (Only works if you have
%    an internet connection.)
% 2. A 2 column numeric array of the form [dates_column data_column]
% 3. A structure with a field called dates and another called
%    close or price.
% 4. A MATLAB timeseries object. (Only works in version 7.2 or above.)
% 5. A Financial Time Series Object with a field called close or
%    price. (Pre ver 7.2: For those licenced to use the FTS Toolbox.
%    Post ver 7.2: For those licensed to use the Financial Toolbox.)
% Note that the current version of TATOOL only looks for time series data called
% close or price.  A later version will handle open, high, low and
% close series'.
%
% CORE FUNCTIONALITY
% Once data has been loaded you can view different time ranges,
% add/delete various indicators (some of which appear overlaid
% on the main price plot and others in their own axes), and re-order
% the axes (if multiple indicators are plotted).  The figure may also
% be resized, in which case appropriate scroll bars become active.
% Various printing options are available under the File menu.
%
% EXPORTING DATA
% You can also export back to the MATLAB workspace.  Any indicators
% currently plotted on all axes are exported along with the original
% time series data.
% There are 3 options for exporting data (under the File->Export menu).
% The options are:
% 1. A structure with a field for each axis, then subfields for each
%    of the indicators currently calculated.
% 2. A MATLAB timeseries collection containing a time series object
%    for each of the indicators. (Only works in version 7.2 or above.)
% 3. A Financial Time Series Object with fields for each of the
%    indicators currently calculated. (Pre ver 7.2: For those licenced
%    to use the FTS Toolbox.  Post ver 7.2: For those licensed to use
%    the Financial Toolbox.)
% 
% LIMITATIONS AND KNOWN PROBLEMS:
% 1. TATOOL has only been tested for daily data.  Data with other time
%    periods may or may not work correctly.
% 2. If the legend on an axis is manually dragged away from its
%    default (top right) position then it will not move with the axis
%    if the figure is subsequently resized or the scroll bars are used.
%    This is due to the inbuilt functionality of the MATLAB legend
%    command.
% 3. Sometimes the dates displayed across the bottom of the axes do not
%    show what year of data is currently shown.  This is due to the
%    default functionality of the MATLAB datetick command.
% 4. When printing, the scroll bars are shown in the printed image.
% 5. Indicators requiring more than one input series (i.e. those requiring'
%    Open, High, Low and Close data) aren't implemented in this
%    version.