% Extract year of disturbances from the deepest slope in the trajectory

function dist = trendlabel(ypoints, vegidx)
    % cut head or tails if segment only last one year
    lb = min(ypoints(:,1));
    ub = max(ypoints(:,1));
    n = size(ypoints,1);
    if ypoints(2,1) == lb + 1
        ypoints = ypoints(2:n,:);
    end
    n = size(ypoints,1);
    if ypoints(n-1,1) == ub - 1
        ypoints = ypoints(1:n-1,:);
    end
           
% trend flag disturbance changing direction
% -1 is decreasing 1 is increasing
% bands = {'B1', 'B2', 'B3', 'B4', 'B5', 'B7', 'NDVI', 'NDSI', 'NDWI', 'NDMI'...
%     , 'NBR', 'EVI', 'Brightness', 'Greenness', 'Wetness'};
    flagdist = [1 1 1 1 1 1 -1 -1 1 -1 -1 -1 1 -1 -1];
    dist = 0;
    n = size(ypoints,1);
    slope = 0;
    for i=1:n-1
        slopet = ((ypoints(i+1,2)-ypoints(i,2))/(ypoints(i+1,1)-ypoints(i,1)));
        if slopet * flagdist(vegidx) > slope
            slope = slopet * flagdist(vegidx);
            dist = ypoints(i,1);
        end
    end
    
%     