function [Rt_MLE,Rt_Lower,Rt_Upper]=stockRisk(dailyReturn,studyPeriod)
% This function assesses risk of stock index by applying  extreme value
% modeling theory. Block Maxima Method (BMM) is used to estimate Generalized 
% Extreme Value distribution (GEV). It quantifies negative return level in 
% 95% asymptotic confidence interval by profile likelihood method.
%
% arguments (input):
%   dailyReturn - vector containing daily return of one stock index for a
%                 long time period. Values in the vector must be in 
%                 percentage, e.g. 3% means a 3% percent daily return for
%                 the whole market.
%   studyPeriod - Time period needs to be analyzed.
%
% arguments (output):
%   Rt - expectation of negative return in the next time period.
%   Rt_Lower, Rt_Upper - 95% asymptotic confidence interval of negative
%                        return.
% Example: stockRisk(x,5) assesses x and its next 5-years negative return.
%
% References: Embrechts, P., etc.,(1997), Modelling Extremal Events for Insurance and Finance,
%             McNeil, A. J., etc.,(2005), Quantitative Risk Management: Concepts, Techniques, Tools
%
% Next will work on investment strategy using the risk assessment result
% from this function. May also develop C++ version then.
%
%
% Author: Yaming Wang. ETH Zurich.
% email: yaming.wang@sed.ethz.ch
% Release: 1.01
% Release data: 10.08.2012


%% BMM
% minus cause we are interested in loss

x=-dailyReturn;

figure;
bar(-x);
xlabel('time (day)');
ylabel('daily change (%)');
title('Historical stock market daily change data (%)');

% box maxima method, separate data into k boxes, each with 260 data (one year approximately 260 transaction days)
for ii=1:ceil(length(x)/260)-1
    y(ii)=max(x(1+260*(ii-1):260*ii));
end

% MLE parameters of generalized extreme value distribution (GEV)
[paramEsts,paramCIs]=gevfit(y);

kMLE=paramEsts(1);
sigmaMLE=paramEsts(2);
muMLE=paramEsts(3);

ymax=1.1*max(y);
ymin=1.1*min(y);
bins=(floor(ymin):ceil(ymax));
figure;
h=bar(bins,histc(y,bins)/length(y),'histc');
set(h,'FaceColor',[0.9 0.9 0.9]);

ygrid=linspace(ymin,ymax,100);
line(ygrid,gevpdf(ygrid,kMLE,sigmaMLE,muMLE));
xlabel('Block Maximum'); ylabel('Probability Density');
xlim([ymin,ymax]);
legend('Empirical PDF','Fitted Generalized Extreme Value PDF','location','southeast');

title('Empirical maxima PDF and generalized extreme value distribution (GEV)');

[F,yi] = ecdf(y);
figure;
stairs(yi,F,'r');
hold on;
plot(ygrid,gevcdf(ygrid,kMLE,sigmaMLE,muMLE),'-');
hold off;
xlabel('Block Maximum'); ylabel('Cumulative Probability');
legend('Empirical CDF','Fitted Generalized Extreme Value CDF','location','southeast');
xlim([ymin ymax]);
title('Empirical maxima CDF and cumulative generalized extreme value distribution (GEV)');

%% compute negative return

% define P(M>R(n,k))=1/k;
Rt_MLE=gevinv(1-1/studyPeriod,kMLE,sigmaMLE,muMLE);

% using profile likelihood to estimate confidencial interval
nllCritVal = gevlike([kMLE,sigmaMLE,muMLE],y) + .5*chi2inv(.95,1);
CIobjfun = @(params) gevinv(1-1/studyPeriod,params(1),params(2),params(3));
CIconfun = @(params) deal(gevlike(params,y) - nllCritVal, []);
opts = optimset('Algorithm','active-set', 'Display','notify', 'MaxFunEvals',500,...
    'RelLineSrchBnd',.1, 'RelLineSrchBndDuration',Inf);
[params,Rt_Lower,flag,output] = ...
    fmincon(CIobjfun,paramEsts,[],[],[],[],[],[],CIconfun,opts);

CIobjfun = @(params) -gevinv(1-1/studyPeriod,params(1),params(2),params(3));
[params,Rt_Upper,flag,output] = ...
    fmincon(CIobjfun,paramEsts,[],[],[],[],[],[],CIconfun,opts);
Rt_Upper = -Rt_Upper;

Rt_CI = [Rt_Lower, Rt_Upper];

figure;
bar(x);
hold on;
plot(1:12000,ones(1,12000).*Rt_MLE,'r-.',1:12000, ones(1,12000)'.*Rt_CI(1),'k-.',1:12000,ones(1,12000).*Rt_CI(2),'k-.');
hold off;
xlabel('Time (day)'); ylabel('Negative returns');
temLegend1=['Expectation of ',num2str(studyPeriod),'-years negative return level'];
temLegend2=['%95 confidence interval of ',num2str(studyPeriod),'-years negative return level'];
legend('Empirical daily negative returns',temLegend1,temLegend2,'location','northeast');

% ====================================================
%      end of function
% ====================================================