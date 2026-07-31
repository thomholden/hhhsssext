function pp = reflectThroughCylinder(R, v, p)
% Reflect apparent points p lying within a cylinder of radius R across the
% cylinder's surface with respect to a viewpoint v to make an anamorphic
% model defined by points pp. When viewed in the reflection of a cylinder,
% the anamorhpic model defined by the points pp will reproduce the image of
% the model defined by the points p.
%
% p = n-by-3 pointIndex-by-CartesianCoordinate
%
% For an explanation of the physics and mathematics behind this function,
% search the blog MATLAB Spoken Here for articles on 3D printing.

% Copyright 2013 The MathWorks, Inc.


% Find point of intersection on the cylinder of the vector from p to v
% defined by 
% J = p + t*(v-p) where t is in the range [0,1]
% The intersection point satisfies
% R^2 = J(:,1).^2 + J(:,2).^2
% which sets up a quadratic equation in terms of t.
A = p(:,1).^2 + p(:,2).^2 - 2*p(:,1)*v(1)...
  + v(1)^2    + v(2)^2    - 2*p(:,2)*v(2);
B = 2*(p(:,1)*v(1) + p(:,2)*v(2) - p(:,1).^2 - p(:,2).^2);
C = p(:,1).^2 + p(:,2).^2 - R^2;
t = (-B + sqrt(B.^2 - 4*A.*C))./(2*A);

% The intersection point c is then
pv = bsxfun(@minus,v,p);
c  = p + bsxfun(@times,t,pv);

% Find the angle of reflection
pc = c - p;
theta = 2*(atan2(c(:,2),c(:,1))-atan2(pc(:,2),pc(:,1)));

% Find the reflected points pp
Rotate = [cos(theta) -sin(theta) zeros(numel(theta),1),...
          sin(theta)  cos(theta) zeros(numel(theta),3),...
                                 -ones(numel(theta),1)]; % negative so that pp_z = p_z
Rotate = reshape(Rotate',3,3,[]);

p = reshape(p',3,1,[]);
c = reshape(c',3,1,[]);

pp = zeros(size(p));
for k = 1:size(p,3)
  pp(:,:,k) = Rotate(:,:,k) * (c(:,:,k) - p(:,:,k)) + c(:,:,k);
end
pp = reshape(pp,3,[])';

end