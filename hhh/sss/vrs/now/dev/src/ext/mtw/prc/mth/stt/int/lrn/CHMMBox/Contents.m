% CHMMBOX, version 1.2, Iead Rezek, Oxford University, February 2001
% Matlab toolbox for Max. aposteriori estimation of two chain Coupled
% Hidden Markov Models
%
% (Adapted from Hidden Markov Toolbox
% Version 3.2  01-Oct-99
% Copyright (c) by William Penny, Imperial College, London)
%
% chmminit          initialise Gaussian observation CHMM
% chmmtrain         train CHMM
% chmmdecode        make classifications using CHMM
%
% cobsinit          initialise CHMM's observation models
% obsinit           initialise single channel's observation model
%
% cobsupdate        update CHMM's observation models
% obsupdate         update single channel's observation model
%
% obslike           likelihood of data given observation model
%
% Auxiliary routines
%
% mdsum        - sum of MD arrays across multiple dimensions
% rprod        - product of MD arrays by MD arrays
% mddiv        - division of MD arrays by MD arrays
% joinpdf      - join 2 MD probability distributions conditioned on multiple
%                dimensions 
%
% Other routines
%
% hmmrandinit - random initialisation of CHMM 
% hmmdatainit - data driven initialisation of CHMM 
% chmmsim     - samples from a CHMM with gaussian observation model
% fhmmsim     - samples from a factorial HMM with gaussian observation model
% hmmsim      - samples from a standard HMM with gaussian observation model
% multinom    - samples from a multinomial distribution
% sampgauss   - samples from a normal distribution
%
% Demonstrations
% 
% demgausschmm - Gaussian observation CHMM trained on synthetic time series
% sleepdemo          -  modelling sleep stages with Gaussian observation CHMM

