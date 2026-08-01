function testFRAME
% TESTFRAME  Testing function FRAME
%
%     TESTFRAME() performs a series of tests of function FRAME

% Version: 1.2
% 2013 July 22
% Paolo de Leva
% University "Foro Italico", Rome, IT
% -------------------------------------------------------------------------


alpha =  pi/5;      % 45°  about x
beta  = -pi*0.6666; % 120° about y
gamma =  pi*1.6666; % 300° about z
R = composition(alpha, beta, gamma); % Composition of 3 elemental rotations

% First set of tests
x = R(:,1);
y = R(:,2);
z = R(:,3);
check(R, x,y,z);

% Second set of tests
R = R(:,:,ones(1,20));
x = x(:,  ones(1,20));
y = y(:,  ones(1,20));
z = z(:,  ones(1,20));
check(R, x,y,z);

% Third set of tests
clear R2 x2 y2 z2;
R2 = permute(R, [3,1,2]);
x2 = x';
y2 = y';
z2 = z';
check(R2, x2,y2,z2);

% Fourth set of tests
clear R2 x2 y2 z2;
R2 = permute(R, [4,3,1,2]);
x2(1,:,:) = x';
y2(1,:,:) = y';
z2(1,:,:) = z';
check(R2, x2,y2,z2);


% -------------------------------------------------------------------------
function check(R, x,y,z)

x = x * 33.3;
y = y * 29.3;
z = z * 40.567;

R1 = frame(x,y,'z', x,  'x');
R2 = frame(x,y,'z', z+x,'x');
R3 = frame(x,y,'z', y,  'y');
R4 = frame(x,y,'z', z+y,'y');

R5 = frame(y,z,'x', x+y,'y');
R6 = frame(y,z,'x', x+z,'z');

R7 = frame(z,x,'y', y+z,'z');
R8 = frame(z,x,'y', y+x,'x');

factor = 5;
if any( abs( R(:)-R1(:) ) > factor*eps ) || ...
   any( abs( R(:)-R2(:) ) > factor*eps ) || ...     
   any( abs( R(:)-R3(:) ) > factor*eps ) || ...     
   any( abs( R(:)-R4(:) ) > factor*eps ) || ...     
   any( abs( R(:)-R5(:) ) > factor*eps ) || ...     
   any( abs( R(:)-R6(:) ) > factor*eps ) || ...     
   any( abs( R(:)-R7(:) ) > factor*eps ) || ...     
   any( abs( R(:)-R8(:) ) > factor*eps )
   disp 'SOMETHING WRONG :-('
   pause
else
   disp 'Set of tests successfully completed.'
   disp 'Results contained (as expected) rounding errors smaller than'
   disp ([num2str(factor), ' times the machine precision EPS (2^-52).'])
   disp ';-)'
end
disp ' ';


% -------------------------------------------------------------------------
function R = composition(alpha, beta, gamma)
% Composition of three elemental rotations about x, y, z

    s = sin(alpha); c = cos(alpha);
    Rx = [ 1  0  0;
           0  c -s;
           0  s  c ];

    s = sin(beta); c = cos(beta);
    Ry = [ c  0  s;
           0  1  0;
          -s  0  c ];

    s = sin(gamma); c = cos(gamma);
    Rz = [ c -s  0;
           s  c  0;
           0  0  1 ];
       
    R = Rz * Ry * Rx;
