function [image,p,t,xystart,mapinfo,coodsys,index]=readenvi(fname, mask)

% This function reads envi standard file (a binary image file and a header
% file.
%
% INPUT 
% 
% fname is the filename including path. 
% 
% mask is true if [0, 0, ...., 0]. need to be masked or a certain value is
% to be masked.
% 
% OUTPUT
% 
% image is the output n * p matrix.
% 
% p is [col, row, bands].
% 
% t is data type.
% 
% xystart, mapinfo and coodsys are projection information and could be
% inserted back when writing an envi file.

% Example
% [image,p,t,xystart,mapinfo,coodsys,index] = readenvi(fname, false);


if nargin < 2
    mask = false;  
end

image = 0;
p = 0;
t = 0;

xystart = [1,1];
mapinfo = '';
coodsys = '';
index = 0;

keystrings={'samples' 'lines' 'bands' 'data type' 'x start' 'y start'...
    'map info' 'coordinate system string'};
d={'uint8' 'int16' 'int32' 'float32' 'float64' 'uint16' 'uint32' 'int64' 'uint64'};


% Open ENVI header file for metainformation
rfid = fopen(strcat(fname,'.hdr'),'r');

if rfid == -1
    return
end

% p(1) columns (samples) p(2) rows (lines) p(3) bands and t: data type
while 1
    tline = fgetl(rfid);
    if ~ischar(tline), break, end
    
    [first,second]=strtok(tline,'=');
    first = strtrim(first);
    
    switch first
        case keystrings(1)
            [~,s]=strtok(second);
            p(1)=str2num(s);
        case keystrings(2)
            [~,s]=strtok(second);
            p(2)=str2num(s);
        case keystrings(3)
            [~,s]=strtok(second);
            p(3)=str2num(s);
        case keystrings(4)
            [~,s]=strtok(second);
            t=str2num(s);
            switch t
                case 1
                    t=d(1);
                case 2
                    t=d(2);
                case 3
                    t=d(3);
                case 4
                    t=d(4);
                case 5
                    t=d(5);
                case 12
                    t=d(6);
                case 13
                    t=d(7);
                case 14
                    t=d(8);
                case 15
                    t=d(9);
                otherwise
                    return;
            end
        case keystrings(5)
            [~,s]=strtok(second);
            xystart(1) = str2num(s);
        case keystrings(6)
            [~,s]=strtok(second);
            xystart(2) = str2num(s);
        case keystrings(7)
            [~,s]=strtok(second);
            mapinfo = s;
        case keystrings(8)
            [~,s]=strtok(second);
            coodsys = s;
    end
end
fclose(rfid);

t=t{1,1};
% Open the ENVI image and store it in the 'image' array
disp(['Opening ',fname,' of ',num2str(p(1)),'cols x ',...
    num2str(p(2)),'rows x ',num2str(p(3)), 'bands of type ', t, '...']);
fid=fopen(fname);
image=fread(fid,t);
image=reshape(image,[p(1)*p(2),p(3)]);

% mask image with certain values or zero for default
if mask ~= false
    if mask == true
        index = (sum(abs(image),2)~=0);
        image = image(index,:);
    else
        index = (sum(abs(image-mask*ones(p(1)*p(2),p(3))),2)~=0); % all equal to mask
        image = image(index,:);
    end
end
fclose(fid);
disp(['Done Reading.']);