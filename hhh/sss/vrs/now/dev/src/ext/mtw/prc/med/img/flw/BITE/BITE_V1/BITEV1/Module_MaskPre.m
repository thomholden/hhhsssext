%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mask Cloud layers with the study area and manual masks (stripemask)

% INPUT 
% 
% pathname is the target output folder, the study area mask is also
% in this directory and should be named as 'studyarea'. For the study area
% mask and the supplemental mask, 1 is on and 0 is off and masked.
%
% scpath is the folder that stores the Fmask classified results and files
% must end with 'fmasks'. fmask images will retain the pixel values.
%
% smpath is the folder stores the manual masks and must end with 'sm'. 1 is
% on and 0 is off and will be masked.
% 
% OUTPUT
% The combined mask files that end with ‘mask’ are derived and put into pathname.


% EXAMPLE
% Module_MaskPre('F:\Data\MaskImg\','F:\Data\CloudFmasks\','F:\Data\StripeMask\')
% an excel file named 'stats.xlsx' will be output into the pathname folder.

function Module_MaskPre(pathname, scpath, smpath)

smfiles = dir(smpath);
smfiles = {smfiles.name}';

mask = readenvi(strcat(pathname,'studyarea'));

filename = dir(scpath);
fileList = getAllFiles(scpath);
isnotidx = zeros(size(fileList,1),1);
for i = 1:size(fileList,1)
    temp=lower(char(fileList(i,:)));
    if strcmp(temp(end-5:end),'fmasks')
        isnotidx(i)=1;
    end
end
fileList=fileList(isnotidx~=0,:);
n = size(fileList,1);
stats=zeros(n,6); % Count pixel numbers for different classes
for i = 1:n
    temp=char(fileList(i,:));
    disp(['Processing ', num2str(i), ' of the ', num2str(n),' files...']);
    [image,p,t,xystart,mapinfo,coodsys,index] = ...
        readenvi(temp, false);
    image(mask == 0,:) = 0;
    stats(i,2:6) = accumarray(image(image~=0),1)';
    stats(i,1) = str2num(temp(end-12:end-6));
    smname = strcat(temp(end-12:end-6),'sm');
    if ismember(smname, smfiles)    % read stripe mask files if existing
        smmask = readenvi(strcat(smpath,smname), false);
        image(smmask == 0,:) = 0;
    end
    image = uint8(image);
    outfname = strcat(pathname, temp(end-12:end-6), 'mask');
    writeenvi(image,p,outfname,xystart,mapinfo,coodsys);
end
xlswrite(strcat(pathname,'stats.xlsx'), stats);