function imageData = getBitmap(f)
%
% IMAGEDATA = GETBITMAP(F)
%
% retrieves an image of the figure from the figure handle f.

% Make correct settings for the pixel to dpi transformation
set(f,'PaperUnits','inches');
resolution = get(0, 'screenp');

% redraw the image using dpi resolution
pos = get(f, 'position');
set(f,'PaperPosition', pos ./ (resolution));

% Create the output filename
imageData = hardcopy(f, '-dopengl', '-r96');
