function bwim = bw(im)
% bw.m : convert color image to black and white

bwim=.3*im(:,:,1)+.59*im(:,:,2)+.11*im(:,:,3);
