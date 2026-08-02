function rotated_im = cp_rotate(im, theta)

% rotate, crop, and fill in corners with what was cropped out

[N1,N2] = size(im);
dithered_im = im + 0.00001;
	% add in dither, so that only the corners of the rotated and
        % cropped image are exactly zero
cropped_im = imrotate(dithered_im, theta, 'nearest', 'crop');
mirror_im = dithered_im(N1:-1:1,:);
	% cropped corners are same shape as blank corners - take transpose
	% to get the correct orientation
rotated_im = cropped_im + (~cropped_im).*mirror_im;

