function y = rot(x, theta);
%
% uncomment the rotation implementation you wish to use
%


% crop corners and paste into new vacancies

y = cp_rotate(x,theta);

% crop corners

%y = imrotate(x,theta, interp_method, 'crop');

