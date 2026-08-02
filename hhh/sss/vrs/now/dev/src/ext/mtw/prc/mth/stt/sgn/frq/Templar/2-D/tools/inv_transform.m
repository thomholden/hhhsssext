function im2 = inv_transform(im, h,v,r);

im1= translate(im,-h,-v);
im2= rot(im1,-r);


