function [varargout]=pre_processing(varargin)
% Introduction
% =========================================================================
% When you have a found an image to turn into a LEGO mosaic, it is best to
% run it through this pre_processing function. The most important thing
% when dealing with LEGO mosaics is understanding that there are
% limitations. LEGO mosaics are generally not very good at real-life
% pictures, if you think about it, trying to turn your kids face or your
% wedding picture into something represented by a 64x64 pixel image is not
% going to work out, while it may be possible to recognize them, the result
% is typically disappointing. To fix this, specify a larger mosaic size.
% 
% This function is very basic and does not do any crazy image processing
% things, its purpose is to merely take your image and make sure it is in
% the right format and matching a color map. 
%
% Inputs and Outputs
% ========================================================================
% varargout==2, indexed img and color map are output
% varargout==1, rgb img is output
% varargin==1, it is the color map
% varargin==2, it is the name and path of the file to get and the new file
% name (Do NOT include Extension!)
% varargin==5 (everything), it is the color map, name and path of the
% file to get, name and path of the file to save, width, height
% 
% I am almost positive I have tested everything, but I can not seem to find
% it in my command history
% 
% Examples:
% [indexed_img map]=pre_processing(map,source_file,new_file,width,height)
% [rgb_img]=pre_processing(map)
% pre_processing(source_file,new_file)
%
% Suggestions / Getting Started
% =========================================================================
% 1) Pick your company logo or favorite cartoon charachter as your image
% 2) Run the generate_colormap function, look at your image and pick the
% most commonly used colors, and ones that make the image, well the image.
% Do NOT include any colors that are not in the image and try to pick
% fairly unique colors (i.e. do not pick Black, Brown, and Dark Gray as
% possible colors)
% 3) Specify a size between 64x64 and 128x128 for your mosaic. Pay
% attention to the aspect ratio of your image and match it with your mosaic
% dimensions. A 64x64 mosaic will have about 800 pieces and have an
% estimated total cost of $100, everything scales from that. 
% 4) Do not just be done with your image and go straight to the
% post_processing function. 9 times out of 10, there will be a few pixels
% that show up where they probably shouldn't and a line that has a random
% colored pixel in the middle of it. While I would love to spend 10-30
% hours working on solving this, in the meantime it is easier to just top
% open up your image in Microsoft Paint or something similair, zoom all the
% way in to 800% and use the pencil tool to edit your image. Once you have
% that done, just save it again and then go to the post_processing function
%
% Contact Info and that fun stuff
% =========================================================================
% Created by Shaun VanWeelden, last updated 2/8/13
% Email: shaun314@iastate.edu 
% I would LOVE to hear your comments, suggestions, questions, and anything
% else you have in mind, please do not hesitate to email me with anything.
%
% Enjoy!

n_out=nargout;
n_in=nargin;

%% Specify Load and Save Image locations
if n_in<2; 
    
%Open GUI to ask user where to load and save image
[name_load, location]=uigetfile('*.bmp;*.jpg;*.png;*.tif','What image would you like to load:');
addpath(location) %#ok<MCAP>


[name_new, path]=uiputfile('What would you like your picture to be called:');
name_new=[path name_new '.bmp'];

elseif n_in==2
    [path, name, ext]=fileparts(varargin{1});
    addpath(path)
    name_load=[name ext];
    
    name_new=[varargin{2} '.bmp'];
    
elseif n_in==5
    [path, name, ext]=fileparts(varargin{2});
    addpath(path)
    name_load=[name ext];
    
    name_new=[varargin{3} '.bmp'];
end

%Get extension
ext=name_load(length(name_load)-2:length(name_load));

%% Turn initial image into M x N x 3 uint8 image format 
if strcmp(ext,'bmp')
    %i.e its already a bitmap image
    [X,map]=imread(name_load);
    A=ind2rgb(X,map);
    A=255*A;
    img=uint8(A);
else
    if strcmp(ext,'png')
        img=imread(name_load,'BackgroundColor',[1 1 1]); %for transparent images
    else
        img=imread(name_load);
        if length(size(img))==2
            %i.e its a grayscale image
            img(:,:,2)=img(:,:,1);
            img(:,:,3)=img(:,:,1);
        end
    end
end

%% Get width and height of mosaic and resize image
if n_in~=5
    C=input('What is the width of your mosaic: ');
    R=input('What is the height of your mosaic: ');
else
    C=varargin{4};
    R=varargin{5};
end
    
%Possibly re-work this so it will not "blend" colors when resizing?
img=imresize(img,[R C],'nearest');

%% Specify Colormap 

if n_in==1 || n_in==5
    map=mosaic_color_map(varargin{1});
else
    map=mosaic_color_map;
end

colormap(map);

%% Turn image source colors into colors matching color map

img=rgb2ind(img,map,'nodither');
% Use dithering for lifelike images and "real" photos. Turning these types
% of photos into lego mosaics is extremely difficult. Type doc rgb2ind to
% learn more about ditheing options and what it does.

if n_out==1
    rgbimg=ind2rgb(img,map);
    varargout{1}=rgbimg;
elseif n_out==2
    varargout{1}=img;
    varargout{2}=map;
end
   
%% Save Image

imshow(img,map)
axis('equal')
imwrite(img,map,name_new,'bmp');

end