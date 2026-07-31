function flag = subsetimgcl(fname, Etg, Ntg, sizex, sizey)
    % subset a image giving target coordinates (Etg, Ntg) and size
    [image,p,t,xystart,mapinfo,coodsys,index] = ...
        readenvi(fname, false);
    image=reshape(image,[p(1),p(2),p(3)]);
    
    % extract projection information (Easting and Northing)
    [token, remain] = strtok(mapinfo, ',');
    mappar = str2num(token);
    while length(remain)>0
        [token, remain] = strtok(remain, ',');
        mappar = [mappar str2num(token)];
    end
    Est = mappar(3);
    Nst = mappar(4);
    
    % calculate pixel location based on projection coordinates
    xst = (Etg - Est) / 30 + 1;
    yst = (Nst - Ntg) / 30 + 1;
    newimg = (image(xst:(xst+sizex-1), yst:(yst+sizey-1),:));
    p = [size(newimg) p(3)];
    newimg = convertdatatype(newimg, t);
    newimg = reshape(newimg,[p(1)*p(2), p(3)]);
    % rewrite the coordinates system string
    mapinfo = sprintf(' {UTM, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %d, North, WGS-84, units=Meters}',...
        mappar(1), mappar(2), Etg, Ntg, mappar(5), mappar(6), mappar(7));

    fname = strcat(fname,'s');
    writeenvi(newimg,p,fname,xystart,mapinfo,coodsys);