function [stochTsOut, validFromOutS] = stochast (tsInH,tsInL,tsInC, kperiods, dperiods, dmamethod);

% stoscts = stochosc(tsobj, kperiods, dperiods, dmamethod);

stochTsOut= stochosc(tsInH,tsInL,tsInC, kperiods, dperiods, dmamethod);
validFromOutS=kperiods+dperiods-1;