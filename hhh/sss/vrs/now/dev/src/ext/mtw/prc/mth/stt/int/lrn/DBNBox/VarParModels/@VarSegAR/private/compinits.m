function [init]=compinits(X,K,options);
% compute the initialisation values for segmented AR models 
% - calls different methods
  
  switch options.initmeth
    case 'mvkalman'
     init = mvkf(X,K,options);
   case 'segAR'
    init = segmentedAR(X,K,options);
   otherwise
    error('Unknown initialisation type option');
  end
  
%  init = univardAR(X,K,p,gamma);
