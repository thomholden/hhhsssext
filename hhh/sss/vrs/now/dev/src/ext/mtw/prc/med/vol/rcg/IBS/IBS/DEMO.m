%% ====================================================================
% Author: Mohammad Rouhani, Morpheo Team, INRIA Rhone Alpes, (2013)
% Email: mohammad.rouhani@inria.fr
% Title: convolutions between two B-Spline basis functions
% Place of publication: Grenoble, France
% Available from: URL
% http://www.iis.ee.ic.ac.uk/~rouhani/mycodes/IBS.rar
%====================================================================
% When using this software, PLEASE ACKNOWLEDGE the effort that went 
% into development BY REFERRING THE PAPER:
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
% Rouhani M. and Sappa A.D., Implicit B-spline fitting using the 3L 
% algorithm, IEEE Conference on on Image Processing (ICIP'11), 2011.
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
%% ==IP FITTING============================================================
%1. Load the data points:
load('Bunny.mat'); load('Duck.mat'); %or any other data set
%Note: the data points must be normalized (in unit cube).

%2. Call the 3L algorithm to compute IP coefficient vector:
L=10; %regularization parameter; increase it for a coarser surface.
P=IBSL3_3DTRI(.01,20,L,model, model_tri); %IBS size can be increased to 30.

%3. Represent the IP surface (zero leve set): 
IBSLevelSurf(P,[.5 .6 .8],0.03); %the visulaization step can be decreased;
%if the surface is not completly reconstruced, change "box" parameters.
