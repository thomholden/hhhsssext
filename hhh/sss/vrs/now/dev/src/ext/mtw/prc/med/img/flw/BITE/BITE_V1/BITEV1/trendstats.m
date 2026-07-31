% Extract features from trajectory

function rstats = trendstats(ypoints)
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
    
    n = size(ypoints,1);
    slope = zeros(1,n-1);
    rangec = zeros(1,n-1);
    for i=1:n-1
        slope(i) = (ypoints(i+1,2)-ypoints(i,2))/(ypoints(i+1,1)-ypoints(i,1));
        rangec(i) = (ypoints(i+1,2)-ypoints(i,2));
    end
    % Min Slope, Max Slope, Min Range Change, Max Range Change Min, Max
    minslope = min(slope);
    maxslope = max(slope);
    minrangechange = min(rangec);
    maxrangechange = max(rangec);
    minv = min(ypoints(:,2));
    maxv = max(ypoints(:,2));
    rstats = [minslope maxslope minrangechange maxrangechange minv maxv];
    