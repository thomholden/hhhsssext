function[f] = util(Wts)
% Mean-variance utility calculation, invoked by PORTOPTGADS
% Example: none (Oh, FEX code metrics..) 
global expRetExt expCovExt A
f = - (expRetExt*(Wts') - A*Wts*expCovExt*(Wts')/2);
