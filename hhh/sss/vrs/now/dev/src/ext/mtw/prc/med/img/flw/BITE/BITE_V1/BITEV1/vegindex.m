% Calculate spectral indices for an image.
% 
% The indices include:
% NDVI, NDSI, NDWI, NDMI, NBR, EVI, Brightness, Greenness, Wetness,
%
% the Landsat surface reflectance data is multiplied by 10000.
% masked values will be -10001.

function output = vegindex(fname, tgpath)

    [image,p,t,xystart,mapinfo,coodsys,index] = ...
        readenvi(fname, false);
    maskidx = (image(:,1) == -10001);
    image = image/10000;
    NDVI = (image(:,4)-image(:,3))./(image(:,4)+image(:,3));
    NDVI(NDVI > 1) = 1;
    NDVI(NDVI < -1) = -1;
    NDSI = (image(:,2)-image(:,5))./(image(:,2)+image(:,5));
    NDSI(NDSI > 1) = 1;
    NDSI(NDSI < -1) = -1;  
    NDMI = (image(:,4) - image(:,5))./(image(:,4)+image(:,5));
    NDMI(NDMI > 1) = 1;
    NDMI(NDMI < -1) = -1;
    NDWI = (image(:,2) - image(:,4))./(image(:,2)+image(:,4));
    NDWI(NDWI > 1) = 1;
    NDWI(NDWI < -1) = -1;
    NBR = (image(:,4) - image(:,6))./(image(:,4)+image(:,6));
    NBR(NBR > 1) = 1;
    NBR(NBR < -1) = -1;
    EVI = 2.5 * (image(:,4) - image(:,3))./(image(:,4)+6*image(:,3)-...
        7.5*image(:,1)+1);
    EVI(EVI > 1) = 1;
    EVI(EVI < -1) = -1;
    coeff = [0.3037 0.2793 0.4343 0.5585 0.5082 0.1863]';
    Brightness = image(:,:)* coeff;
    coeff = [-0.2848 -0.2435 -0.5436 0.7243 0.0840 -0.1800]';
    Greenness = image(:,:)* coeff;
    coeff = [0.1509 0.1793 0.3299 0.3406 -0.7112 -0.4572]';
    Wetness = image(:,:)* coeff;
    
    newimg=[image NDVI NDSI NDWI NDMI NBR EVI Brightness Greenness Wetness];
    newimg = int16(newimg * 10000);
    newimg(maskidx, :) = -10001;
    Bandnames = '{B1, B2, B3, B4, B5, B7, NDVI, NDSI, NDWI, NDMI, NBR, EVI, Brightness, Greenness, Wetness}';
    p(3) = 15;
    
    fname = strcat(tgpath,fname(end-7:end-1),'c');
    writeenvi(newimg,p,fname,xystart,mapinfo,coodsys, Bandnames);
    