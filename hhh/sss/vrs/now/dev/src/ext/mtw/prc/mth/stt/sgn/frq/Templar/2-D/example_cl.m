%
% Classify square and ring data
%
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt
close all;  clear 
all;

C = 2;          			% number of classes
N1=32; N2=32;				% dimension of images
template_list=cell(1,C);	

% comment these lines out if not using wavelets
scaling_filter = [1 1]/sqrt(2);         % Haar
J = 5;                                  % depth of wavelet transform

path('./tools', path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load trained models (should have same wavelet and same N1, N2)
%
% to generate square_data and ring_data,  run:
%  
%       >> gen_sq_dat;
%       >> close all; clear all;
%       >> gen_ri_dat;
%       >> close all; clear all;

load sq_dat
template_list{1} = template;
load ri_dat
template_list{2} = template;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate test data
%
%

test_data_list = cell(1,C);

T = 30;
gen_squares;
test_data_list{1} = training_data;
gen_rings;
test_data_list{2} = training_data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set transformation range
% 

shape = 'square';
mesh = [ 8	1	8	1 ];	
	% can only have one row for classification
scope = generate_scope(mesh,shape);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% classify the test data
%

classify;

