function [h sxy] = DrawCircle(x0,y0,r,N,theta,holes,idx,ShowShape,opts)

[h sxy] = DrawEllipse(x0,y0,r,r,N,theta,holes,idx,ShowShape,opts);
