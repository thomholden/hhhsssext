function newim=translate(im,hz,vt)

% un-comment the kind of periodization you want

newim=hcircshift(vcircshift(im,vt),hz);
%newim=hsymshift(vsymshift(im,vt),hz);
%newim=hcircshift(vsymshift(im,vt),hz);
%newim=hsymshift(vcircshift(im,vt),hz);

