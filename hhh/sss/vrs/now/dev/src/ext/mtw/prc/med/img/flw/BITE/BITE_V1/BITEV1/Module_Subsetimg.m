% Subset images under the same coordinate systems
% INPUT
% 
% pathname is the directory for all images to be subset
% 
% Etg and Ntg specify the Easting and Northing start coordinates for the
% subset scene.
% 
% sizex and sizey specify the size for the subscene
% 
% OUTPUT
% 
% Subset scenes located in the same folder (pathname). They should be moved
% to another folder before proceeding.

% Examples
% Module_Subsetimg('F:\Data\RawImg\', 354375, 4485885, 3100, 3100);

function Module_Subsetimg(pathname, Etg, Ntg, sizex, sizey)

pathname = char(pathname);
Etg = 354375;
Ntg = 4485885;
sizex = 3100;
sizey = 3100;

filename=dir(pathname);
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
    subsetimgcl(temp,Etg,Ntg,sizex,sizey);
end