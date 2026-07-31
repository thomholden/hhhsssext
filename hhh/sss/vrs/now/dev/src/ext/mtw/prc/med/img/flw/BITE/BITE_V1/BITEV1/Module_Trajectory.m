% This module extract trajectory
% Parralell works are allowed
% 
% INPUT
% 
% inputdir: input folder in which time-series images are named as NDVI_TS,
% NBR_TS, etc.
% 
% outputdir:  the folder to store the output trajectories. Files are Excel
% files with extension ‘.xlsx’.
% 
% yfile: the Excel file in which the first column stores the times of
% acquisition, for instance 2001179, 2002158, 2003207, etc.
% 
% lcfile: the forest mask file. 1 is forest, 0 is non-forest. This file
% must have the same size and coordinate system as the time-series images.
% 
% numparts: number of parts in the output. Increase this number to avoid
% big Excel files and save progressively into the hard drive.
% 
% par is the number of workers/threads for parallel CPU processing.
% 
% OUTPUT
% 
% Trajectory files in Excel format. For each index, the trajectories are
% stored in two files, a “nodx” and a “nody” file. They together define the
% breakpoints of the trajectory. Each line indicates a trajectory segments
% for an unmasked pixel.

% EXAMPLE
% Extract trajectory from time-series images for multiple indices
% We like to apply to NDMI, NBR and Wetness. Type the
% following commands to achieve the goal. We also like to use 4 cores
% combinelist = [10 11 15]; % NDMI NBR Wetness
% inputdir = 'F:\Data\TimeSeries\';
% outputdir = 'F:\Data\TrOutput\';
% yfile = 'F:\Data\stats.xlsx';
% lcfile = 'F:\Data\forestmask';
% numparts = 4;
% Module_Trajectory(inputdir, outputdir, yfile, lcfile, combinelist, numparts,4);
% %
function Module_Trajectory(inputdir, outputdir, yfile, lcfile, combinelist, numparts, par)

switch par
    case 2
        needNewWorkers = (matlabpool('size') == 0);
        if needNewWorkers
            % Open a new MATLAB pool with par workers.
            matlabpool open 2
        end
    case 3
        needNewWorkers = (matlabpool('size') == 0);
        if needNewWorkers
            % Open a new MATLAB pool with par workers.
            matlabpool open 3
        end
    case 4
        needNewWorkers = (matlabpool('size') == 0);
        if needNewWorkers
            % Open a new MATLAB pool with par workers.
            matlabpool open 4
        end
    case 6
        needNewWorkers = (matlabpool('size') == 0);
        if needNewWorkers
            % Open a new MATLAB pool with par workers.
            matlabpool open 6
        end
    case 8
        needNewWorkers = (matlabpool('size') == 0);
        if needNewWorkers
            % Open a new MATLAB pool with par workers.
            matlabpool open 8
        end
end

mp = 5; % maximum pieces

dnames = {'Persistent', 'Slow-onset', 'Rapid-onset'};

bands = {'B1', 'B2', 'B3', 'B4', 'B5', 'B7', 'NDVI', 'NDSI', 'NDWI', 'NDMI'...
    , 'NBR', 'EVI', 'Brightness', 'Greenness', 'Wetness'};

for listidx = 1:numel(combinelist)
    idx = combinelist(listidx);
    vegx = char(bands(idx));
    disp(['Processing Trajectory Extraction for ' vegx '...']);
    imgfile = strcat(inputdir, vegx,'_TS');
    
    [lcmask,p,t,xystart,mapinfo,coodsys,index] = ...
            readenvi(lcfile, true);
    [image,p,t,xystart,mapinfo,coodsys] = ...
            readenvi(imgfile, false);
    image = image(index,:);
    doy = xlsread(yfile);
    doy = doy(:,1);
    doyp = fix(doy/1000) + (doy/1000 - fix(doy/1000))/0.365;
    labels=cell(length(doy),1);
    for i = 1:length(doy)
        labels(i) = cellstr(num2str(doy(i)));
    end
    
    year = [min(fix(doy/1000)):max(fix(doy/1000))];
    n = length(year);
    m = size(image, 1);
    
    partsint = fix([1:m/numparts:m m+1]);
    lp = length(doyp);
    
    ct = 0;
    for parts = 1:numparts
        disp(['Processing part ' num2str(parts) '...']);
        tic;
        partn = partsint(parts+1)-partsint(parts);
        nodpoints = NaN(partn,6);
        nodvalues = NaN(partn,6);
        data = image(partsint(parts):partsint(parts+1)-1,:);
        parfor i = 1:partn;    
            vegidx = data(i,:);
            [x, y] = annuallify(doy, vegidx, 100);
            y = denoise(y, 1);
            tmp = NaN(6,2);
            [ypoints, ~, ~] = PLRtsfast(x, y, mp, 0.95, 0.9, 0.04);
            nyp = size(ypoints,1);
            tmp(1:nyp,:) = ypoints;
            nodpoints(i,:) = tmp(:,1)';
            nodvalues(i,:) = tmp(:,2)';        
        end
        disp(['writing...']);
        xlswrite([outputdir  vegx 'nodx' num2str(parts) '.xlsx'], nodpoints);
        xlswrite([outputdir  vegx 'nody' num2str(parts) '.xlsx'], nodvalues);
        toc
    end
    
end

if par > 1
    matlabpool close;
end