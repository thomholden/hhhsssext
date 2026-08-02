
T = 16;		% # of training images
N1=32;		% # of rows
N2=32;		% # of columns

scaling_filter = [1 1]/sqrt(2);	% Haar
J = 5;					% depth of wavelet transform

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load training data into variable 'training_data', which is a 
% cell of length T, and each entry in the cell is a training image

gen_rings;		% synthetic example from paper

display_training_data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify transformations

shape='square';  	% the shape of the range of translations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify range (scope) of transforms (translation, rotation, and scaling)
%
% mesh: see example.m for details

mesh=[
	8	1	8	1
	8	1	8	1
	6	1	6	1
];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run TEMPLAR

templar;

save ri_dat template;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display template

display_template;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% synthesize some new images from learned model

%synthesize;
%display_synth_data;




