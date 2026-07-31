% This function integrate multiple disturbance maps of a variety of
% spectral indices into one map that can potentially yield a better overall
% accuracy.
% 
% INPUT
% 
% datadir: The folder that disturbance maps are stored.
% 
% lcfile: the complete filename for the forest mask.
% 
% combinelist: the array list of spectral indices to integrate.
% 
% algorithm: 1 – CART, 2 – SVM.
% 
% OUTPUT
% 
% The output disturbance map is named either “SVMdistmap” or “CARTdistmap”
% based on whether algorithm is used. The file is stored in datadir. For
% the pixel values, 0 is masked, 1 is persistent forest, while other values
% are the onset years of disturbances. For rapid-onset disturbances, the
% values are onset year + 1000.

% EXAMPLE
% combinelist = [10 11 15];
% Module_CombineMaps('F:\Data\DistMap\', 'F:\Data\forestmask', combinelist, 2);

function Module_CombineMaps(datadir, lcfile, combinelist, algorithm)

dnames = {'Persistent', 'Slow-onset', 'Rapid-onset'};
bands = {'B1', 'B2', 'B3', 'B4', 'B5', 'B7', 'NDVI', 'NDSI', 'NDWI', 'NDMI'...
    , 'NBR', 'EVI', 'Brightness', 'Greenness', 'Wetness'};


numc = numel(dnames);

[lcmask,p,t,xystart,mapinfo,coodsys,index] = ...
            readenvi(lcfile, true);
np = size(lcmask,1);
dtypecomb = zeros(np,numel(combinelist));
ycdcomb = zeros(np,numel(combinelist));
yadcomb = zeros(np,numel(combinelist));
algonames = {'CART', 'SVM'};

algon = char(algonames(algorithm));
for listidx = 1:numel(combinelist)
    idx = combinelist(listidx);
    vegx = char(bands(idx));
    dtype = readenvi([datadir algon vegx 'typemap'], false);
    dtypecomb(:,listidx) = dtype(index,:);
    ycd = readenvi([datadir algon vegx 'slowmap'], false);
    ycdcomb(:,listidx) = ycd(index,:);
    yad = readenvi([datadir algon vegx 'rapidmap'], false);
    yadcomb(:,listidx) = yad(index,:);
end

dtypecomb = 4 - dtypecomb;      % prioritize 3, 2, 1
[dtype, ~]  = mode(dtypecomb,2);
dtype = 4 - dtype;
for i = 1:np
    if dtype(i) == 2
        dtype(i) = median(ycdcomb(i,ycdcomb(i,:)~=0));
    elseif dtype(i) == 3
        dtype(i) = median(yadcomb(i,yadcomb(i,:)~=0)) + 1000;
    end
end
bandnames = '{CoverType}';
writeenvi([int16(dtype)],p,[datadir algon 'distmap'],xystart,mapinfo,coodsys,bandnames,index);

