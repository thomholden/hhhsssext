function cmap=mosaic_color_map(varargin)
% Provide either a colormap as a matrix, or edit this file to just type the
% colors you would like. Note that if you provide a color map, it should
% contain values between 0 and 1, and if you were to type in the values,
% just follow the example below.
%
% It is generally a good idea when making logos etc. to use JUST the colors
% you would like in the logo, oherwise due to resizing, some colors are
% blended and might look different than expected.

if length(varargin)==1;
    cmap=varargin{1};
else
    cmap=[
    000 000 000  %Black
    000 000 255  %Blue
    000 140 000  %Green
    000 255 000  %Bright Green
    255 000 000  %Red
    255 255 255  %White 
    255 255 000  %Yellow
    ];
    cmap=cmap/255;
end
% The following link has a list of LEGO colors, but they look off to me
% http://cpan.uwinnipeg.ca/htdocs/LEGO-Colors/LEGO/Colors.html
end