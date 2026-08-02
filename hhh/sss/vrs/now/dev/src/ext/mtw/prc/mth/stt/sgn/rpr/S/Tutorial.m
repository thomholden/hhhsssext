function Tutorial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                           TUTORIAL                                %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This Toolbox is to help users for computing S estimator.
% S is a new estimator of synchronization among multiple interacting
% systems. In its simplest version, S estimator quantifies how much'
% the recorded signals are correlated among them.
% 
% To get a deeper understanding about S estimator, please refer to
%
% C. Carmeli, M. Knyazeva, G. Innocenti, O. De Feo
% "Assessment of EEG synchronization based on state-space analysis"
% NeuroImage 25 (2005) 339-354'
%
% Because of its intrinsic multivariate nature, this
% new estimator is particularly suitable for multichannel EEG analysis.
% Our hope is that this toolbox could make easier its application by
% clinical neuroscientists.
% 
% This is the tutorial of the toolbox: an example of application to EEG
% analysis is described.
%
% See also Content.

% Copyright (c) 2005
% Cristian Carmeli, Swiss Federal Institute of Technology 
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

%
%
% =========================================================================
%
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('The main function of this toolbox is computeS.')
disp('----------------')   
disp('S=computeS(TS,Idx)');
disp('S=computeS(TS,Idx,ED)');
disp('----------------')   
disp('Please, press any key to continue...');
pause
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('It computes S estimator given a set of multivariate measurements TS')
disp('and a matrix Idx, each column representing the indexes of recording sites')
disp('(a cluster of sites) among whose you want to assess synchronization phenomena.')
disp('S estimator values is then returned, one value for each cluster. You')
disp('can choose of computing S estimator without or with embedded time')
disp('series, if you specify an additional input ED (the parameters for')
disp('embedding).')
disp('Certainly, you can define Idx by hand, and TS too. However, we make')
disp('available functions to make life much easier.')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('Please, press any key to continue...');
pause
%
disp('Henceforth, we present an example we hope will help to show the')
disp('features of this toolbox. It concerns an application to EEG recordings.')
disp('Specifically, here, a 128 EEG/ERP Geodesic setup is considered.')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('Please, press any key to continue...');
pause
%
disp('Let we start with the collection of recorded data (matrix TS).')
disp('If you have to work with more than one trial for your experiment,')
disp('you should organize the matrix of data merging the different trials')
disp('and separate the trials with NaNs.')
disp('In order to do that, two functions are available.')
disp('fileSelector merges data stored in distinct files, one for each trial')
disp('(check its help for more details on in/output and constraints).')
disp('For this example, we have 40 trials to load in the directory DataTest.')
disp('You may also specify bad trials, which will not be processed. In our')
disp('example let assume the trial 12 and 33 are bad.')
disp('The command to enter would be then the following:')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
[s,errmsg]=sprintf('TS=fileSelector(\''%s\'',\''%s\'',%d,%d,%d,[%d %d],\''%s\'');','DataTest/Test_','mat',2,1,40,12,33,'EEG');
disp(s)
disp('Wait...Data files are being loaded.')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
TS=fileSelector('DataTest/Test_','mat',2,1,40,[12 33],'EEG');
disp('Files loaded. Please, press any key to continue...')
pause
%
disp('If you want to merge data you have already loaded and are in you workspace,')
disp('you may use the function compose (it works similarly to fileSelector).') 
%
disp('Please, press any key to continue...')
pause
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('Now, we need to compute Idx. You can define clusters of electrodes by')
disp('hand, otherwise you can generate clusters using the topology of the')
disp('recording sites, if available. In this example, the 129 electrodes')
disp('(128 + 1 reference electrode)  has some topology we can use.')
disp('You may start by loading the coordinates of the electrodes setup.')
disp('A simplified 2-D version of 128 EEG Geodesic setup coordinates')
disp('is stored in the file CoordInterp.mat')
disp('Please, press any key to continue...')
pause
%
disp('---------------')
disp('Let we load it, and get the matrix of polar coordinates CO')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('load CoordInterp')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
load CoordInterp;
%
disp('Coordinates have been loaded. Please, press any key to continue.')
pause
%
disp('---------------')
disp('To get the topological arrengement of this electrodes net, we compute their') 
disp('incidence matrix A. Let we do it by')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('A=IncidenceMatrix(CO);')
disp('or')
[s, errmsg]=sprintf('A=IncidenceMatrix(CO,\''%s\'');','polar');
disp(s)
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
A=IncidenceMatrix(CO);
%
disp('Incidence matrix computed. Please, press any key to continue...')
pause
%
disp('--------------')
disp('You can compute clusters with the function')
disp('getClusters. This function computes a cluster for each electrode') 
disp('as the set of k-step neighbors of that electrode. To compute 129')
disp('clusters (128 electrodes + reference electrode) defined from 1st')
disp('step neighbors you may write')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('% all electrodes, 1st step neighbors');
disp('Idx=getClusters(A,1);')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
Idx=getClusters(A,1);
disp('Idx computed. Please, press any key to continue...')
pause
disp('--------------')
disp('Moreover, you may specify a region of electrodes of')
disp('interest as a third input (the default case is all 129')
disp('electrodes as seen earlier). Only electrodes indexed in area will') 
disp('be taken into account to form the clusters. For example, if you want')
disp('to compute clusters on 50 electrodes, e.g. the ones from 40 to 89,')
disp('then you may write')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('area=[40:89]');
disp('Idx_a=getClusters(A,1,area);')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
area=[40:89];
Idx_a=getClusters(A,1,area);
%
disp('Idx_a has been computed. Please, press any key to continue...')
pause
%
disp('-----------------')
disp('Another possibility to compute clusters is with')
disp('getSpots. Imagine you may want to compute two clusters, composed')
disp('by the 1st nearest neighbors of two distant electrodes, e.g. 51 and 98.') 
disp('In order to do that, you may write')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('intsite=[51 98];')
disp('Idx_s=getSpots(A,1,intsite);')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
intsite=[51 98];
Idx_s=getSpots(A,1,intsite);
disp('Idx_s has been computed. Please, press any key to continue...')
pause
%
disp('-----------------')
disp('A last possibility is only given when you are dealing with EEG setups.')
disp('You can get clusters indexes of a priori defined brain areas. To get indexes') 
disp('corresponding to the left occipital area (see help getRegionEEG for other')
disp('predefined areas), write simply')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
[s, errmsg]=sprintf('Idx_OL=getRegionEEG(\''%s\'');','OL');
disp(s)
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
Idx_OL=getRegionEEG('OL');
disp('Idx_OL has been computed. Please, press any key to continue...')
pause
%
disp('------------------')
disp('If there is a set of known bad sites, you can clean your')
disp('index from these so that the corresponding values will not')
disp('be taken into account when computing S. In this example,')
disp('if [15 122 123] are bad electrodes')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('Idx=clearBad(Idx, [15 122 123]);') 
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
Idx=clearBad(Idx, [15 122 123]);
disp('Bad electrodes cleared. Please, press any key to continue...')
pause
%
disp('-----------------')
disp('Also, you must mark as bad the reference electrode.')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('Idx=clearBad(Idx,[129]);')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
Idx=clearBad(Idx, [129]);
disp('Reference electrode cleared. Please, press any key to continue...')
pause
%
disp('-----------------')
disp('We can now compute S for the non-embedded time series.')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('S=computeS(TS,Idx);')
disp('S_a=computeS(TS,Idx_a);')
disp('S_OL=computeS(TS,Idx_OL);')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
disp('Please, wait...computation on way.')
%
S=computeS(TS,Idx);
S_a=computeS(TS,Idx_a);
S_OL=computeS(TS,Idx_OL);
%
disp('S, S_a and S_OL have been computed. Please,press any key to continue...')
pause
%
disp('-----------------')
disp('If you want to use embedded time series, you should first compute')
disp('parameters for embedding (ED matrix). This can be done by using the')
disp('function computeED.')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('ED=computeED(TS);')
disp('(please, take into account that this operation may last several minutes') 
disp('of computation time)')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
ED=computeED(TS);
disp('ED computed. Please, press any key to continue...')
pause
disp('-----------------')
disp('Now, S estimator can be computed on embedded time series with')
disp('the following command')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('S_ed=computeS(TS,Idx,ED);')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
disp('Please, wait...computation on way.')
%
S_ed=computeS(TS,Idx,ED);
disp('S_ed computed.')
disp('-----------------')
disp('A few words of comment about using embedded time series. You should be')
disp('aware that using this technique is not a plug and play way of')
disp('working with data. We have set several parameters (that play a role in')
disp('the computation of embedding) to default values you may change depending') 
disp('on your data. Please, read computeED help for further details.')
disp('-----------------')
%
disp('Press any key to continue...')
pause
disp('Once S has been computed, you may want to visualize it.')
% 
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('If you want to visualize S estimator computed over the whole brain')
disp('you may use the function plotS')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('ploS(S)')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
plotS(S);
disp('Press any key to continue...')
pause
%
disp('-----------------')
disp('Furthermore, you may plot S estimator (S_a) computed over a subset of') 
disp('electrodes (area).')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('plotS(S_a,area);')
%  
[s, errmsg]=sprintf('\n'); 
disp(s)
%
plotS(S_a,area);
%    
disp('plotS can be extended in order to make plots when you have other (no EEG) recording')
disp('setups (please check the help of plotS).')
%
disp('Press any key to continue...')
pause
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('Finally, the last possibility offered by the toolbox is a statistical test')
disp('to compare S estimator computed over, e.g., two different experimental conditions.')
disp('In our example, we have two data sets, stored respectively')
disp('in DataTest and DataTest1 (for details about the data, please readme.txt')
disp('in the directories). We have already computed S estimator for the')
disp('data set in DataTest. Let compute S estimator for the second one')
disp('stored in DataTest1. (hp. same bad channels for the two experiments)')
disp('The commands can be the following:')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('% get the data')
[s,errmsg]=sprintf('TS_1=fileSelector(\''%s\'',\''%s\'',%d,%d,%d,[],\''%s\'');','DataTest1/Test_','mat',2,1,40,'EEG');
disp(s)
disp('% compute S over all the electrodes')
disp('S_1=computeS(TS_1,Idx);')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
disp('Please, wait...computation on way.')
%
TS_1=fileSelector('DataTest1/Test_','mat',2,1,40,[],'EEG');
S_1=computeS(TS_1,Idx);
%
disp('S_1 has been computed. Please any key to continue...')
pause
%
disp('-----------------')
disp('Now, you can assess if statistical differences are in the mean (over trials)')
disp('between S and S_1. You get the p-value to which you can accept the null') 
disp('hp. that S and S_1 are equal in mean by')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('intsite=[66 70 71 84 85 90];')
disp('pv=MultiTest(S(:,intsite),S_1(:,intsite))')
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('Here, only a subset of electrode is tested. We should restrict ourselves to') 
disp('test a small number of electrodes due to the few data (trials) available.')
disp('This is the statistics, my dears!')
%
intsite=[66 70 71 84 85 90];
pv=MultiTest(S(:,intsite),S_1(:,intsite))
%
[s, errmsg]=sprintf('\n'); 
disp(s)
%
disp('HAPPY END')
%