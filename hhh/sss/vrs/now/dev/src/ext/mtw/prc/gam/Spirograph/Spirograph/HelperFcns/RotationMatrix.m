function M = RotationMatrix(theta)

M = [cos(theta) -sin(theta) ;
     sin(theta)  cos(theta)];
