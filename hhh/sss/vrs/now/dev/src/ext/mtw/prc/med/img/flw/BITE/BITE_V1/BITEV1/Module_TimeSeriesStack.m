%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stack layers of a certain spectral band for all images across the time
% INPUT
% 
% pathname is the folder where there are all images with spectral indices
% calculated. Files end with ‘s’
% 
% tgpath is the output folder.
% 
% vegidx is the index for the bands:
% 1 - B1   2 - B2   3 - B3   4 - B4   5 - B5   6 - B7   7 – NDVI   8 – NDSI
% 9 – NDWI   10 – NDMI   11 – NBR   12 – EVI   13 – Brightness   14 –
% Greenness   15 - Wetness
% 
% OUTPUT
% 
% An image to store time-series are generated for the spectral index vegidx
% listed above. The filename consists of index name and ‘_TS’ and is output
% in tgpath.
%
% EXAMPLE
% Module_TimeSeriesStack('F:\Data\IdxImg\','F:\Data\TimeSeries\',7);
% This builds a time-series image for NDVI.

function Module_TimeSeriesStack(pathname, tgpath, vegidx)

% maskpath = char('C:\Users\Yanlei\Desktop\PineBeetle\MaskImg\');

idxnames = {'B1', 'B2', 'B3', 'B4', 'B5', 'B7', 'NDVI', 'NDSI', 'NDWI',... 
    'NDMI', 'NBR', 'EVI','Brightness', 'Greenness', 'Wetness'};
filename = dir(pathname);
fileList = getAllFiles(pathname);
isnotidx = zeros(size(fileList,1),1);
for i = 1:size(fileList,1)
    temp=lower(char(fileList(i,:)));
    if strcmp(temp(end-3:end),'.hdr')
        isnotidx(i)=1;
    end
end
fileList=fileList(isnotidx==0,:);
n = size(fileList,1);
data = int16(zeros(9610000, n));
for i = 1:n
    temp=char(fileList(i,:));
    disp(['Processing ', num2str(i), ' of the ', num2str(n),' files...']);
    [image,p,t,xystart,mapinfo,coodsys,index] = ...
        readenvi(temp, false);
    image = image(:, vegidx); 
    % B1, B2, B3, B4, B5, B7, NDVI, NDSI, NDWI, NDMI, NBR, EVI
%     maskname = strcat(maskpath, temp(end-7:end-1), 'mask');
%     mask = freadenvi(maskname, false);  % read cloud mask files
%     image(mask ~= 5,:) = -10001;
    data(:, i) = image;
end

temp=char(fileList(1,:));
bandnames=strcat('{', temp(end-7:end-1));
for i=2:n
    temp=char(fileList(i,:));
    bandnames=strcat(bandnames, ', ', temp(end-7:end-1));
end
bandnames = strcat(bandnames,'}');
outfname = strcat(tgpath, char(idxnames(vegidx)),'_TS');
p(3) = n;
writeenvi(data,p,outfname,xystart,mapinfo,coodsys,bandnames);
