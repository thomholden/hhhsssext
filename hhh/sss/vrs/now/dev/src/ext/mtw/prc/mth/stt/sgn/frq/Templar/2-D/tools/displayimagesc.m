function [] = displayimage(im)
%
%
imagesc(im)
colormap(gray)
axis('square')
set(gca,'XTick',[])
set(gca,'YTick',[])

