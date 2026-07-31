function []=post_processing(color_map,color_NAMES,load_img_name,save_img_name,run_anim)
% 
% Summary
% ========================================================================= 
%
% Given an image, and other arguments, this function will
% take the image and fit LEGO pieces to it to produce a buildable mosaic.
%
% This works best after running the "pre_processing" function on your
% source image.
%
% Specify all arguments either with the actual argument, or just use an
% empty anything (i.e [] '' () {} etc.) if you do not have that argument,
% it will prompt you to provide it in the script for all inputs 
%
% Description of inputs and outputs
% =========================================================================
% Input 1) color_map - the Nx3 matrix specifying the rgb values, see help 
% colormap for more info, you can use the generate_colormap function to do
% this part for you automatically
%
% Input 2) color_NAMES - A cell array specifying the colors in the color
% map, make sure they are in the same order as the color map, an example
% cell array would be {'red' 'blue' 'yellow'}, the generate color_map
% function can also do this for you. 
%
% Input 3) load_img_name is the name of the image you would like to load,it 
% is reccommended to be a bitmap directly produced from the pre_processing,
% but in theory, any image should work fine. Just make sure you want each
% pixel in the image to be a LEGO "peg" because that is how it is
% processed, you can specify eithe just the name of the image if its on 
% your search path, or the full name if not.
%
% Input 4) save_img_name, do NOT include any extension, extensions and
% "explanations" are automatically appended to the name you provide.
% You can specify just the name to save it to your current work directory,
% or specify the full file path otherwise (the latter not tested tooo well)
%
% Input 5) run_anim, as the code is now, everytime it puts a brick in the
% mosaic, it will show you where it is which can be really fun to watch or
% create videos of (..if you want help with videos, let me know). It does
% take (on my computer which is average) .2 seconds per peice to show the
% animation, so a detailed 64x64 peg mosaic would have about 1,000 pieces
% and take just over 3 min to complete.. while it is pretty cool to watch,
% it definitely gets a bit dry and is something I would like to improve
%
% There are no outputs that this function returns because it simply saves
% all the files it needs. You can change this pretty easily as you see fit.
% The saved files are:
%
% name_gridded_image.bmp, contains lines drawn around every peg for "easy"
% repurposing of this software
%
% name_instructions.bmp, contains lines drawn to show each brick and
% provide you with an easy thing to build from either on the computer or to
% print off. It doubles the image size so it is a little bit easier to zoom
% and whatnot also. 
%
% name_parts_list.txt, writes the needed pieces to a text file, this is
% exactly the same as what is shown in the command window
%
% Known Issues and Hopeful Future Updates
% =========================================================================
% - It tries showing you the gridded img, and currently there is no uiwait
%   or pause, so the animation or finished image usually instantly cover it
%   up, it is in its own seperate fig window so you can still view it if
%   you want to
%
% - The animation is VERY slow. Without the animation, it can create the
%   entire instruction manual to a 64x64 mosaic, save it, the gridded image, 
%   and the parts list in less than a second, with the animation it takes
%   over two and a half minutes, this is probably easily fixable, but right
%   now I am just excited to get the code done honestly
%
% - I think it would be really cool if you could customize the parts list,
%   it wouldn't be too difficult, just involve a little more flexible code
%   than it currently has and you would need to take the specific code that
%   is filling the mosaic with each type of brick (i.e. 2x4, 1x3, etc) and
%   put that into its own helper function, which really should be done
%   anyway
%
% Contact Info and that fun stuff
% =========================================================================
% Created by Shaun VanWeelden, last updated 2/8/13
% Email: shaun314@iastate.edu 
% I would LOVE to hear your comments, suggestions, questions, and anything
% else you have in mind, please do not hesitate to email me with anything.
%
% Enjoy!

%% Get Initial Image and name of new image

%load image
if isempty(load_img_name)
    [loaded_image_name, location]=uigetfile('*.bmp','What image would you like to load?');
    addpath(location) %#ok<MCAP>
else
    [path, load_name, ext]=fileparts(load_img_name);
    addpath(path)
    loaded_image_name=[load_name ext];
end


%name your new image

if isempty(save_img_name)
    [savename, path]=uiputfile('What do you want your new image called? ');
    new_image_name=[path savename];
else
    new_image_name=save_img_name;
end

%% Get colors in the color map for parts list

global name

if isempty(color_map)
    map=mosaic_color_map;
else
    map=color_map; 
end

if isempty(color_NAMES)
    
    color_names={'start'};
    for i=1:size(map,1)
        color_namer(map(i,:))
        color_names{i}=name;
        fprintf('\n')
    end
    
else
    
    color_names=color_NAMES;
   
end


%% set parts list

%1st column is color; second is element id (8 possible); 3rd is quantity
parts_list=zeros(8*length(color_names),3);
for i=1:length(color_names)
    for j=1:8
        parts_list((i-1)*8+j,1)=i;
        parts_list((i-1)*8+j,2)=j;
    end
end

%The eight possible parts
id_names={'2x4 Brick','1x6 Brick','1x4 Brick','2x3 Brick','2x2 Brick','1x3 Brick','1x2 Brick','1x1 Brick'};

%% Verify input image format

if ndims(imread(loaded_image_name))==2 %#ok<*ISMAT>

[img, map]=imread(loaded_image_name);
imgrgb=ind2rgb(img,map);
%You need this to convert the bmp to rgb format, otherwise its a 2d matrix

else
    
    if strcmp(loaded_image_name(length(loaded_image_name)-2:length(loaded_image_name)),'png')
        imgrgb=imread(loaded_image_name,'BackgroundColor',[1 1 1]);
    else
        imgrgb=imread(loaded_image_name);
    end
    
end

if isempty(color_map)
    map=mosaic_color_map;
else
    map=color_map; 
end
colormap(map)
img=rgb2ind(imgrgb,map,'nodither'); %dither if you want to do a "real" photo with lots of small bricks
%converts to the LEGO color map indicies, should be perfect correlation

img=img+1;
%You have to add 1 to adjust for the re-indexing done before

%% Create Gridded Image

[R, C]=size(img);
img_grid=zeros(R*4,C*4);
grid_color=50;
for i=0:R-1
    for j=0:C-1
        img_grid(i*4+1:i*4+3,j*4+1:j*4+3)=img(i+1,j+1);
        img_grid(i*4+4,j*4+1:j*4+4)=grid_color;
        img_grid(i*4+1:i*4+4,j*4+4)=grid_color;
    end
end

if isempty(color_map)
    map=mosaic_color_map;
else
    map=color_map; 
end
map(50,:)=[.567 .567 .567];
colormap(map)
axis('equal')
image(img_grid)
imwrite(img_grid,map,[new_image_name '_gridded_image.bmp'],'bmp')

%% Initialize Instruction Manual Image


ins_img=zeros(R*4,C*4);
%instruction manual image

filled_mat=zeros(R,C);
%establish a matrix to see whether a spot has been filled or not

if ~isempty(run_anim)
    if run_anim(1)
        figure 
    end
else
    run_anim=input('Show Animation? (1 = yes, 0 = no): ');
end
%Set up or prompt for any animation settings



%% Fill in the image

%----------------------------------
%--------FILL 2x4 BRICKS-----------
%----------------------------------
        
for i=1:R
    for j=1:C
        
        if filled_mat(i,j)==0
        %Check to see if the spot is open
            
            if R-i+1>=2 && C-j+1>=4
            %Check to see if a 2x4 brick can possibly fit horizontally
            
                if sum(filled_mat(i:i+1,j:j+3))==0
                %See if the space required is all empty
                
                    if sum(sum(img(i:i+1,j:j+3)==img(i,j)))==8
                    %See if they are all the same color
                    
                        ins_img((i-1)*4+1:(i+0)*4+3,(j-1)*4+1:(j+2)*4+3)=img(i,j);
                        %Fill in the color 
                        
                        ins_img((i-1)*4+1:(i+0)*4+4,(j+3)*4)=50; %50 = grid color
                        %Add in the right border
                        
                        ins_img((i+0)*4+4,(j-1)*4+1:(j+3)*4)=50; %50 = grid color
                        %Add in the bottom border
                        
                        filled_mat(i:i+1,j:j+3)=1;
                        %Fill in "filled matrix"
                        
                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end
                        
                    end
                end
            end
           
            if R-i+1>=4 && C-j+1>=2
            %Check to see if a 2x4 brick can possibly fit vertically
            
                if sum(filled_mat(i:i+3,j:j+1))==0
                %See if the space required is all empty
                
                    if sum(sum(img(i:i+3,j:j+1)==img(i,j)))==8
                    %See if they are all the same color
                    
                        ins_img((i-1)*4+1:(i+2)*4+3,(j-1)*4+1:(j+0)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs
                        
                        ins_img((i-1)*4+1:(i+2)*4+4,(j+0)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate
                        
                        ins_img((i+2)*4+4,(j-1)*4+1:(j+0)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+3,j:j+1)=1;
                        %Fill in "filled matrix"
                        
                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end
                        
                    end
                end
            end
            
        end
    end
end

%----------------------------------
%--------FILL 1x6 BRICKS-----------
%----------------------------------

for i=1:R
    for j=1:C

        if filled_mat(i,j)==0
        %Check to see if the spot is open

            if R-i+1>=1 && C-j+1>=6
            %Check to see if a 1x6 brick can possibly fit horizontally

                if sum(filled_mat(i:i+0,j:j+5))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+0,j:j+5)==img(i,j)))==6
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i-1)*4+3,(j-1)*4+1:(j+4)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i-1)*4+4,(j+4)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i-1)*4+4,(j-1)*4+1:(j+4)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+0,j:j+5)=2;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end

            if R-i+1>=6 && C-j+1>=1
            %Check to see if a 1x6 brick can possibly fit vertically

                if sum(filled_mat(i:i+5,j:j+0))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+5,j:j+0)==img(i,j)))==6
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i+4)*4+3,(j-1)*4+1:(j-1)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i+4)*4+4,(j-1)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i+4)*4+4,(j-1)*4+1:(j-1)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+5,j:j+0)=2;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end

        end
    end
end

%----------------------------------
%--------FILL 1x4 BRICKS-----------
%----------------------------------

for i=1:R
    for j=1:C

        if filled_mat(i,j)==0
        %Check to see if the spot is open

            if R-i+1>=1 && C-j+1>=4
            %Check to see if a 1x4 brick can possibly fit horizontally

                if sum(filled_mat(i:i+0,j:j+3))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+0,j:j+3)==img(i,j)))==4
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i-1)*4+3,(j-1)*4+1:(j+2)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i-1)*4+4,(j+2)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i-1)*4+4,(j-1)*4+1:(j+2)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+0,j:j+3)=3;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end                    

            if R-i+1>=4 && C-j+1>=1
            %Check to see if a 1x4 brick can possibly fit vertically

                if sum(filled_mat(i:i+3,j:j+0))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+3,j:j+0)==img(i,j)))==4
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i+2)*4+3,(j-1)*4+1:(j-1)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i+2)*4+4,(j-1)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i+2)*4+4,(j-1)*4+1:(j-1)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+3,j:j+0)=3;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end
        end
    end
end

%----------------------------------
%--------FILL 2x3 BRICKS-----------
%----------------------------------

for i=1:R
    for j=1:C

        if filled_mat(i,j)==0
        %Check to see if the spot is open

            if R-i+1>=2 && C-j+1>=3
            %Check to see if a 2x3 brick can possibly fit horizontally

                if sum(filled_mat(i:i+1,j:j+2))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+1,j:j+2)==img(i,j)))==6
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i+0)*4+3,(j-1)*4+1:(j+1)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i+0)*4+4,(j+1)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i+0)*4+4,(j-1)*4+1:(j+1)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+1,j:j+2)=4;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end

            if R-i+1>=3 && C-j+1>=2
            %Check to see if a 2x3 brick can possibly fit vertically

                if sum(filled_mat(i:i+2,j:j+1))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+2,j:j+1)==img(i,j)))==6
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i+1)*4+3,(j-1)*4+1:(j+0)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i+1)*4+4,(j+0)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i+1)*4+4,(j-1)*4+1:(j+0)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+2,j:j+1)=4;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end
        end
    end
end

%----------------------------------
%--------FILL 2x2 BRICKS-----------
%----------------------------------

for i=1:R
    for j=1:C

        if filled_mat(i,j)==0
        %Check to see if the spot is open

            if R-i+1>=2 && C-j+1>=2
            %Check to see if a 2x2 brick can possibly fit at all 

                if sum(filled_mat(i:i+1,j:j+1))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+1,j:j+1)==img(i,j)))==4
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i+0)*4+3,(j-1)*4+1:(j+0)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i+0)*4+4,(j+0)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i+0)*4+4,(j-1)*4+1:(j+0)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+1,j:j+1)=5;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end
        end
    end
end

        %----------------------------------
        %--------FILL 1x3 BRICKS-----------
        %----------------------------------

for i=1:R
    for j=1:C

        if filled_mat(i,j)==0
        %Check to see if the spot is open

            if R-i+1>=1 && C-j+1>=3
            %Check to see if a 1x3 brick can possibly fit horizontally

                if sum(filled_mat(i:i+0,j:j+2))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+0,j:j+2)==img(i,j)))==3
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i-1)*4+3,(j-1)*4+1:(j+1)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i-1)*4+4,(j+1)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i-1)*4+4,(j-1)*4+1:(j+1)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+0,j:j+2)=6;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end

            if R-i+1>=3 && C-j+1>=1
            %Check to see if a 1x3 brick can possibly fit vertically

                if sum(filled_mat(i:i+2,j:j+0))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+2,j:j+0)==img(i,j)))==3
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i+1)*4+3,(j-1)*4+1:(j-1)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i+1)*4+4,(j-1)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i+1)*4+4,(j-1)*4+1:(j-1)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+2,j:j+0)=6;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end
        end
    end
end

%----------------------------------
%--------FILL 1x2 BRICKS-----------
%----------------------------------

for i=1:R
    for j=1:C

        if filled_mat(i,j)==0
        %Check to see if the spot is open

            if R-i+1>=1 && C-j+1>=2
            %Check to see if a 1x2 brick can possibly fit horizontally

                if sum(filled_mat(i:i+0,j:j+1))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+0,j:j+1)==img(i,j)))==2
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i-1)*4+3,(j-1)*4+1:(j+0)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i-1)*4+4,(j+0)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i-1)*4+4,(j-1)*4+1:(j+0)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+0,j:j+1)=7;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end

            if R-i+1>=2 && C-j+1>=1
            %Check to see if a 1x2 brick can possibly fit vertically

                if sum(filled_mat(i:i+1,j:j+0))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+1,j:j+0)==img(i,j)))==2
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i-0)*4+3,(j-1)*4+1:(j-1)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i-0)*4+4,(j-1)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i-0)*4+4,(j-1)*4+1:(j-1)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+1,j:j+0)=7;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end

                    end
                end
            end
        end
    end
end

%----------------------------------
%--------FILL 1x1 BRICKS-----------
%----------------------------------

for i=1:R
    for j=1:C

        if filled_mat(i,j)==0
        %Check to see if the spot is open

            if R-i+1>=1 && C-j+1>=1
            %Check to see if a 1x1 brick can possibly fit at all, always a
            %yes

                if sum(filled_mat(i:i+0,j:j+0))==0
                %See if the space required is all empty

                    if sum(sum(img(i:i+0,j:j+0)==img(i,j)))==1
                    %See if they are all the same color

                        ins_img((i-1)*4+1:(i-1)*4+3,(j-1)*4+1:(j-1)*4+3)=img(i,j);
                        %Fill in the color, the (i-1) (i+2) represents 4
                        %pegs, while (j-1) (j+0) represents 2 pegs

                        ins_img((i-1)*4+1:(i-1)*4+4,(j-1)*4+4)=50; %50 = grid color
                        %Add in the right border
                        %Keep i coordinatates the same as above, just use
                        %last j coordinate

                        ins_img((i-1)*4+4,(j-1)*4+1:(j-1)*4+4)=50; %50 = grid color
                        %Add in the bottom border
                        %opposite of above

                        filled_mat(i:i+0,j:j+0)=8;
                        %Fill in "filled matrix"

                        parts_list((img(i,j)-1)*8+filled_mat(i,j),3)=parts_list((img(i,j)-1)*8+filled_mat(i,j),3)+1;
                        %Add to inventory
                        
                        if run_anim(1)
                            showAlgorithm(filled_mat, ins_img, color_map)
                        end
                        

                    end
                end
            end
        end
    end
end

if run_anim(1)
pause %for animation
end

%% Add Pegs to Image

%Pegs make it look like LEGO bricks and allows for users to easily see what
%type of brick is needed

for i=0:R-1
    for j=0:C-1
        ins_img(i*4+2,j*4+2)=50;
    end
end


%% Double the image size

%Doubles the size of the instruction manual image for better quality and
%zooming

ins_img_temp=zeros(8*R,8*C);
for i=0:R*4-1
    for j=0:C*4-1
        ins_img_temp(i*2+1:i*2+2,j*2+1:j*2+2)=ins_img(i+1,j+1);
    end
end
ins_img=ins_img_temp;

%% Color In and Save "Instruction Manual"

if isempty(color_map)
    map=mosaic_color_map;
else
    map=color_map; 
end
map(50,:)=[.567 .567 .567];
colormap(map)
image(ins_img)
axis('equal')
imwrite(ins_img,map,[new_image_name '_instructions.bmp'],'bmp')


%% Calculate total cost

%Takes quantity of part id and multiplies by unit price 
%Does NOT include cost of baseplates ..yet

total_cost=0;
for i=1:length(parts_list)
    if parts_list(i,2)==1
        total_cost=parts_list(i,3)*.19+total_cost; %2x4
    elseif parts_list(i,2)==2
        total_cost=parts_list(i,3)*.14+total_cost; %1x6
    elseif parts_list(i,2)==3
        total_cost=parts_list(i,3)*.13+total_cost; %1x4
    elseif parts_list(i,2)==4
        total_cost=parts_list(i,3)*.11+total_cost; %2x3
    elseif parts_list(i,2)==5
        total_cost=parts_list(i,3)*.09+total_cost; %2x2
    elseif parts_list(i,2)==6
        total_cost=parts_list(i,3)*.11+total_cost; %1x3
    elseif parts_list(i,2)==7
        total_cost=parts_list(i,3)*.09+total_cost; %1x2
    elseif parts_list(i,2)==8
        total_cost=parts_list(i,3)*.07+total_cost; %1x1
    end
end

%% Refine Parts List

%Note: If no piece was used, that row is removed from the parts list

zero_quan=[]; %represents rows with no quantity
count=1;
for i=1:length(parts_list)
    if parts_list(i,3)==0
        zero_quan(count)=i;  %#ok<*AGROW>
        count=count+1;
    end    
end
parts_list(zero_quan,:)=[];

%% Display Parts List

clc

fprintf('       Color       Type       Quantity\n')
fprintf('       =====       ====       ========\n')

for i=1:length(parts_list)
    fprintf('%12s %13s        %.0f\n',color_names{parts_list(i,1)},id_names{parts_list(i,2)},parts_list(i,3))
end

fprintf('\nTotal Part Count: %.0f\n', sum(parts_list(:,3)))
fprintf('Total Cost: $%.2f\n', total_cost)

%% Create Parts List Text File

fid=fopen([new_image_name '_parts_list.txt'],'w+');

fprintf(fid,'       Color       Type       Quantity\n');
fprintf(fid,'       =====       ====       ========\n');

for i=1:length(parts_list)
    fprintf(fid,'%12s %13s        %.0f\n',color_names{parts_list(i,1)},id_names{parts_list(i,2)},parts_list(i,3));
end

fprintf(fid,'\nTotal Part Count: %.0f\n', sum(parts_list(:,3)));
fprintf(fid,'Total Cost: $%.2f\n', total_cost);

fclose(fid);

end %end function

function showAlgorithm(filled_mat, ins_img, color_map)
[R, C]=size(filled_mat);

filled_mat=filled_mat>0; %convert to logic mat

% image(zeros(100,100)) >> all red
% pause

%Add Pegs to instruction image
for i=0:R-1
    for j=0:C-1
        ins_img(i*4+2,j*4+2)=50;
    end
end

%Scale filled_mat to ins_img (4x bigger)
filled_temp=zeros(4*R,4*C);
for i=0:R-1
    for j=0:C-1
        filled_temp(i*4+1:i*4+4,j*4+1:j*4+4)=filled_mat(i+1,j+1);
    end
end

% Multipy together
ins_img=filled_temp.*ins_img;

for i=1:R*4
    for j=1:C*4
        if ins_img(i,j)==0
            ins_img(i,j)=50;
        end
    end
end

% Color In image
if isempty(color_map)
    map=mosaic_color_map;
else
    map=color_map; 
end
map(50,:)=[.567 .567 .567];
colormap(map)
image(ins_img)
axis('equal')
pause(.1)
    
end

function name=color_namer(color)
% Given a color, it shows the color in a gui with an edit box so you can
% name the color, it returns the name given to it.

%Initialize GUI
f=figure('MenuBar','none','Name','Name this color','NumberTitle','off','Position',[200,200,270,120]);

uicontrol('Style','PushButton','String','Accept','Position',[150,25,100,20],...
'CallBack',@AcceptPressed);

uicontrol('Style','Text','String','Name this color:','Position',[130,80,120,15],...
'HorizontalAlignment','left','FontSize',10,'BackgroundColor',[204 204 204]/255); 

color_text = uicontrol('Style','Edit','Position',[130,50,120,25],...
'HorizontalAlignment','left','FontSize',10,'CallBack',@AcceptPressed);

ah = axes('Parent',f,'Position',[.05 .25 .3 .5]);

% Show color
axes(ah);
C=ones(1,1,3);
C(:,:,1)=color(1);
C(:,:,2)=color(2);
C(:,:,3)=color(3);
imshow(C)
uiwait

%When the accept button or enter button is pressed
function AcceptPressed(~,~)

name=get(color_text,'string');

close(f)

end

end


