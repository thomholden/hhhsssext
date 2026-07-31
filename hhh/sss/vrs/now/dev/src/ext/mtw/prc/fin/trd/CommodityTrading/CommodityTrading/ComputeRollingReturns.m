%% Compute rolling returns

% Copyright 2013 The MathWorks, Inc.

clc;
fwdWindow=[1 2 3:3:15];
fwdIdx=createLags(stratIndex,-fwdWindow);
rollingRtns=fwdIdx./repmat(stratIndex,[1 numel(fwdWindow)]);
avgRollingRtns=12 * (nanmean(rollingRtns)-1)' ./ fwdWindow';
avgRollingStds=(nanstd(rollingRtns))';
rollingSharpes=(avgRollingRtns) ./ ...
    avgRollingStds * sqrt(12) ./ sqrt(fwdWindow');
array=[avgRollingRtns ...
    avgRollingStds rollingSharpes]
figure;
set(gca,'XTickLabel',fwdWindow,'XTick',1:length(fwdWindow));
hold on;
box on;
bar(array);