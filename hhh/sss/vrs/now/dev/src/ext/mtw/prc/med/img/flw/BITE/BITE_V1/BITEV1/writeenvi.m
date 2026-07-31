%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write ENVI image 
% 			
% image is the array to be written into the file.
% 
% p is the size in [col, row, bands] format.
% 
% fname is filename to write.
% 
% xystart, mapinfo and coodsys indicate coordinate system, if readenvi is
% used the three variables are in the same format as the outputs of the
% readenvi function.
% 
% Bandnames specifies names of bands.
% 
% index is used when mask was applied in readenvi to expand the masked
% image array to the full image size.
%
% EXAMPLE
% enviwrite(newimg,p,fname,xystart,mapinfo,coodsys);

function output = writeenvi(image,p,fname,xystart,mapinfo,coodsys,Bandnames,index)

if nargin<4
    xystart=[1 1];
end
if nargin<5
    mapinfo='';
end
if nargin<6
    coodsys='';
end
if nargin<7
    Bandnames='';
end
if nargin<8
    index=0;
else
    image2 = zeros(length(index),p(3),class(image));
    for i = 1:p(3)
        image2(index,i) = image(:,i);
    end
    image = image2;
    clear image2;
    clear index;
end

im_size=p;
keystrings={'samples =' 'lines =' 'bands =' 'data type =' 'x start ='...
    'y start =' 'map info =' 'coordinate system string =' 'band names ='};
d=[4 1 2 3 1 12 13];

cl1=class(image);
if strcmp(cl1,'double')
    img=reshape(single(image),p(1),p(2),p(3));
else
    img=reshape(image,p(1),p(2),p(3));
end
cl=class(img);
switch cl
    case 'single'
        t = d(1);
    case 'int8'
        t = d(2);
    case 'int16'
        t = d(3);
    case 'int32'
        t = d(4);
    case 'uint8'
        t = d(5);
    case 'uint16'
        t = d(6);
    case 'uint32'
        t = d(7);
    otherwise
        error('Data type not recognized');
end
wfid = fopen(fname,'w');
if wfid == -1
    output=-1;
end
disp(['Writing ' fname '. Processing ...']);
fwrite(wfid,img,cl);
fclose(wfid);

% Write header file

fid = fopen(strcat(fname,'.hdr'),'w');
if fid == -1
    output=-1;
end

fprintf(fid,'%s \n','ENVI');
fprintf(fid,'%s \n','description = {');
fprintf(fid,'%s \n','ENVI standard image file}');
fprintf(fid,'%s %i \n',keystrings{1,1},im_size(1));
fprintf(fid,'%s %i \n',keystrings{1,2},im_size(2));
fprintf(fid,'%s %i \n',keystrings{1,3},im_size(3));
fprintf(fid,'%s %i \n',keystrings{1,4},t);
fprintf(fid,'%s %i \n',keystrings{1,5},xystart(1));
fprintf(fid,'%s %i \n',keystrings{1,6},xystart(2));
fprintf(fid,'%s%s \n',keystrings{1,7},mapinfo);
fprintf(fid,'%s%s \n',keystrings{1,8},coodsys);
if length(Bandnames)~=0
    fprintf(fid,'%s%s \n',keystrings{1,9},Bandnames);
end
fprintf(fid,'%s \n','interleave = bsq');
fclose(fid);
disp(['Done Writing.']);