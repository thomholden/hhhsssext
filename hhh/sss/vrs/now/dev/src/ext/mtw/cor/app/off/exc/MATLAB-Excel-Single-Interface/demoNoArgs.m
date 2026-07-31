function demoNoArgs

%   Copyright 2006 The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2006/08/17 09:11:48 $

% visualise peaks
surf( peaks );

% make it look nice
light;
shading interp;
lighting phong;
colormap copper;

% make transparent temporarily
N = 100;
for n = 1:N
    alpha( 2*abs(n-1-N/2)/N )
    drawnow
end

end % function