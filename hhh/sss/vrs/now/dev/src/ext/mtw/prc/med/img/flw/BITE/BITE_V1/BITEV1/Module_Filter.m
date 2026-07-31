% This module applies a 3 by 3 low filter and mask to the image.
% the mask should be processed using FMask algorithm
% or the unmasked pixels with a value of 5
% 
% INPUT
% 
% pathname is the folder for the surface reflectance images. Files end with
% ‘s’.
% 
% tgpathname is the output folder.
% 
% maskpath is the folder where mask images store.  Files end with ‘mask’.
% 
% OUTPUT
% 
% Filtered and masked images are derived from this function and stored in
% tgpathname. The files end with ‘s’.
% 
% EXAMPLE
% Module_Filter('F:\Data\RefImg\','F:\Data\RefImgFil\','F:\Data\MaskImg\',true);
% Make all paths exist already. If not, create the folder.

function Module_Filter(pathname, tgpathname, maskpath, filtering)
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
    
    for i = 1:n
        temp=char(fileList(i,:));
        [image,p,t,xystart,mapinfo,coodsys,index] = ...
            readenvi(temp, false);
        if ~isempty(maskpath)
            maskname = strcat(maskpath, temp(end-7:end-1), 'mask');
            % read cloud mask files
            mask = readenvi(maskname, false);  
            % only class 5 (land) is retained
            image(mask ~= 5,:) = -10001;
        end
        image=reshape(image,[p(1),p(2),p(3)]);
        if filtering
            disp(['Implementing the 3 by 3 low pass filter. Processing...']);
            newimg = lowpassfilter(image, -10001);
        else
            newimg = image;
        end
        tgfilename = strcat(tgpathname, temp(end-7:end-1), 's');
        newimg = convertdatatype(newimg, t);            
        writeenvi(newimg,p,tgfilename,xystart,mapinfo,coodsys);

    end