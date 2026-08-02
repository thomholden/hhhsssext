function im2 = transform(im, h,v,r);

im1= rot(im,r);
im2= translate(im1,h,v);


