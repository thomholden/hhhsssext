%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Spectral indices
% INPUT
% 
% pathname is the folder for the surface reflectance images with 6 spectral
% bands Band 1, 2, 3, 4, 5, 7 for Landsat TM. Files end with ‘s’.
% 
% tgpath is the output folder.
% 
% OUTPUT
% 
% Output images with additional spectral bands including NDVI, NDSI, NDWI,
% NDMI, NBR, EVI, Brightness, Greenness and Wetness as spectral indices are
% generated in tgpath. Files end with ‘c’.
%
% EXAMPLE
% Module_SpectralIndex('F:\Data\RefImgFil\','F:\Data\IdxImg\');
% the output folder should be created in advance.

function Module_SpectralIndex(pathname, tgpath)

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
for i = 1:n
    temp=char(fileList(i,:));
    disp(['Processing ', num2str(i), ' of the ', num2str(n),' files...']);
    vegindex(temp, tgpath);
end

