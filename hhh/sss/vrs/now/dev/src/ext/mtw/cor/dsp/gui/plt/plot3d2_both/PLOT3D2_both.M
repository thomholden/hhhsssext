
% THIS FUNCTION IS DEVELOPED BY C. JEGANATHAN, INDIAN INSTITUTE OF REMOTE
% SENSING (IIRS-NRSA), DEPARTMENT OF SPACE,4 KALIDAS ROAD, DEHRADUN-248001,
% INDIA

% USER HAS TO GIVE xaxis MATRIX DATA and principal (y value of correspong x) (this may be produced
% using Gaussian or Triangular or Trapezoidal or s-function), upper, lower
% matrix represents corresponding upper footprint of principal function and
% lower footprint respectively
% data for input may be produced like the following:
%%%%%%%%%%%%%INPUT DATA EXAMPLE- USING GAUSSIAN FUNCTION-------
% for example
% xaxis = [0:0.05:6]
% principal = [exp(-0.5*(xaxis-3).^2)]
% upper = min(1,1.3*principal)
% lower = 0.7 * principal
%%%%-----------------------------------------------------------
% Gaussian function is used in the example and Interval-Type-2 Fuzzy
% membership is assumed during plot.
% This function will plot Footprint of Uncertainty in  3dimensional mode.
% 
% the principal function will be plotted in red color on top
%% Thanks

function [] = plot3d2_both(principal, upper, lower, xaxis)



lx = length(xaxis) ;

y_upper1 = upper(1:(lx-1))';
y_upper2 = upper(2:lx)' ;
y_principal1    = principal(2:lx)' ;
y_principal2    = principal(1:lx-1)' ;

xaxis1 = xaxis(1:lx-1)' ;
xaxis2 = xaxis(2:lx)' ;


y_lower1 = lower(1:lx-1)' ;
y_lower2 = lower(2:lx)' ;

%y2 = [y_lower1' y_lower2'  y_principal1' y_principal2' ]' ;


xaxis13t = [xaxis1 xaxis1 xaxis1];
xaxis23t = [xaxis2 xaxis2 xaxis2];

y_upper13t = [y_upper1 y_upper1 y_upper1];
y_upper23t = [y_upper2 y_upper2 y_upper2];

y_princ13t = [y_principal1 y_principal1 y_principal1];
y_princ23t = [y_principal2 y_principal2 y_principal2];

y_lower13t = [y_lower1 y_lower1 y_lower1];
y_lower23t = [y_lower2 y_lower2 y_lower2];

xremain = [xaxis1 xaxis1  xaxis2 xaxis2 xaxis1 ];

yremainupper = [y_upper1 y_upper1 y_upper2 y_principal1 y_principal2 ];

yremainlower = [y_lower1 y_lower1 y_lower2 y_principal1 y_principal2 ];
z3t = [1 0 1];

zremain = [1 0 0 0 0];

xup3d = [xaxis13t xaxis23t xaxis23t xaxis13t  xremain];


yup3d = [ y_upper13t y_upper23t y_princ13t y_princ23t  yremainupper];

xlow3d = [xaxis13t xaxis23t xaxis23t xaxis13t  xremain];

ylow3d = [y_lower13t y_lower23t y_princ13t y_princ23t  yremainlower];
zup3d = [z3t z3t z3t z3t zremain];


top = ones(size(xaxis));

figure ;
fill3(xup3d,yup3d,zup3d,'c');
hold on
fill3(xlow3d,ylow3d,zup3d,'g');

plot3(xaxis,principal,top,'r','linewidth',5)

return ;

