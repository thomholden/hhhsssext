% example1.m
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

clear all;  close all;
path('./tools',path);	% add tools directory to path

T = 20;		% # of training images
N1=32;		% # of rows in each  training image
N2=32;		% # of columns in each  training image

% comment these lines out if not using wavelets
scaling_filter = [1 1]/sqrt(2);		% Haar
J = 5;					% depth of wavelet transform

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load training data into variable 'training_data', which is a 
% cell of length T, and each entry in the cell is a training image

gen_squares;

display_training_data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify transformations

shape='square';  	% the shape of the range of translations
			% can be either 'circle' or square';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify range (scope) of transforms (translation, rotation)
%
% mesh: specifies the transformations that you believe to be
%       inherent in the data being analyized.  Each row of this matrix specifies
%       the transformations for a particular iteration of TEMPLAR (it saves time
%       by first doing a course search and then refining).   Each row of
%       'mesh' is then converted into a 'scope', which is a data structure
%       that makes it easy to loop through all the different transformations.  
% 	The columns of mesh specify the transformations as follows: (note that
% 	a column functions differently depending on 'shape'
%
%	if shape = 'square' and 
%	mesh = [
%		8 	2 	4 	1; 
%		4 	1 	2 	1] 
%	then in the first iteration, TEMPLAR searches over horizontal 
%	translations from -8 pixels to 8 pixels, at incremnts of 2 pixels,
%	and over vertical shifts from -4 pixels to 4 pixels, at 1 pixel
%	increments.  For the second and all subsequent iterations, TEMPLAR
%	searches over a 5 x 9 grid, at every pixel.
%
%	if shape = 'circle' and 
%	mesh = [	a	b	c	d]
%	then in the first iteration, TEMPLAR searches over all 
%	transformations of the form t * r, where r is a rotation about
%	the origin (center of the image) followed by a translation t.  t 
%	searches over all translations by multiples of b pixels that lie 
%	within a circle of radius a.  r searches over all rotations by 
%	angles of the form +/- k*c degrees, k=0,1,...,d.  If d=Inf,
%	TEMPLAR searches all the way around the circle.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mesh = [
	8	1	8	1
	8	1	8	1
	6	1	6	1
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run TEMPLAR and display template

templar;

display_template;
%display_registered_data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% synthesize some new images from learned model

%synthesize;
%display_synth_data;




