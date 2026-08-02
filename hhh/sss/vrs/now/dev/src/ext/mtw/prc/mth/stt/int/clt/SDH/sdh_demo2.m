function sdh_demo2
% SDH_DEMO2 Analyze Data Histograms as Density Estimators, 
%           Examples: 1-dim

% elias 30/04/2002

fprintf('Histogramm ...');

f = figure;
set(f,'numbertitle','off');
set(f,'name','SDH Demo2');
X = 4; Y = 2; % subplots
FONTSIZE = 8;
HIGHRES = 50; % high resolution used to illustrate true pdf

S = 3; % sdh
N = 200; % data items
BINS = 50;
INTERP= 'cubic';
MIN = -8; MAX = 8; % min max x scale

c = linspace(MIN,MAX,BINS);
c_hr = linspace(MIN,MAX,HIGHRES*BINS);
bin_width = c(2)-c(1);
[p, p_hist, x] = pdf(c,N,bin_width);
[p_hr, p_hist_hr] = pdf(c_hr,N,bin_width);

bin_count = hist(x,c);

% data histogram
s = subplot(X,Y,1); set(s,'fontsize',FONTSIZE); 
plot(c_hr,p_hist_hr,'color',[0.6 .9 0.6],'linewidth',2); hold on;
bar(c,bin_count);
axis([MIN-0.1, MAX, 0, max(max(bin_count),max(p_hist_hr))*1.1]);
box on; h=title(['Data Histogram (N=',num2str(N),')']); set(s,'xtick',[]); set(h,'verticalalignment','middle');

fprintf('done.\n')

fprintf('Smoothed Histogramm ...');

% smoothed histogram
w1 = [1:S,S-1:-1:1]; w1 = w1./sum(w1); % ranking
w2 = 1./[S:-1:1,2:S]; w2 = w2./sum(w2); % 1/r

s = subplot(X,Y,2); set(s,'fontsize',FONTSIZE); % filters
plot(w1,'.-r'); hold on
plot(w2,'.-b');
axis([1, (S-1)*2+1, 0, max(max(w1),max(w2))]);
h=title(['SDH Filters (s=',num2str(S),')']); set(s,'xtick',[]); set(h,'verticalalignment','middle');

sdh1 = filter(w1,1,[bin_count,zeros(1,S-1)]);
sdh2 = filter(w2,1,[bin_count,zeros(1,S-1)]);

s = subplot(X,Y,3); set(s,'fontsize',FONTSIZE); % SDH
plot(c_hr,p_hist_hr,'color',[0.6 .9 0.6],'linewidth',2); hold on
plot(c_hr,interp1(c,sdh1(S:end),c_hr,INTERP),'r');
plot(c_hr,interp1(c,sdh2(S:end),c_hr,INTERP),'b');
axis([MIN-0.1, MAX, 0, max(max(bin_count),max(p_hist_hr))*1.1]);
box on; h=title(['SDH (s=',num2str(S),')']); set(s,'xtick',[]); set(h,'verticalalignment','middle');

s = subplot(X,Y,4); set(s,'fontsize',FONTSIZE); % deviation
plot(c, sdh1(S:end) - p_hist,'r'); hold on
plot(c, sdh2(S:end) - p_hist,'b');
plot(c, bin_count - p_hist,'k');
box on; h=title('Deviation'); set(s,'xtick',[]); set(h,'verticalalignment','middle');

fprintf('done.\n')

fprintf('GMM (estimate priors and variance with EM) ...');

% gaussian mixture, centers given, variance not.
% if nothing in bin, then this bin does not contribute to the mixture.

idx = find(bin_count>0); % remove zeros
bc2 = bin_count(idx);
c2 = c(idx);

[sigma pri] = sdh_gmm_init(x, c2);
err = [];
err(1) = sum(log(sdh_gmm_pdf(x, c2, sigma, pri)));

for i=1:14;
    [sigma pri] = sdh_gmm_em(x, c2, sigma, pri);
    err(i+1) = sum(log(sdh_gmm_pdf(x, c2, sigma, pri)));
end

s = subplot(X,Y,5); set(s,'fontsize',FONTSIZE)
plot(c_hr,p_hr,'color',[0.6 .9 0.6],'linewidth',2); hold on
plot(c_hr,sdh_gmm_pdf(c_hr', c2, sigma, pri)); 
axis([MIN-0.1, MAX, 0, 0.5]);
box on; h=title('GMM (estimate priors & \sigma)'); set(s,'xtick',[]);
set(h,'verticalalignment','middle');

s = subplot(X,Y,6); set(s,'fontsize',FONTSIZE); 
plot(err,'.-b')
box on; h=title('log-likelihood'); set(s,'xtick',[]);
set(h,'verticalalignment','middle');

fprintf('done.\n')

fprintf('GMM (estimate mu, priors and variance with EM) ...');

% train real GMM (estimate mu)
[sigma pri] = sdh_gmm_init(x, c2);
err=[];
err(1) = sum(log(sdh_gmm_pdf(x, c2, sigma, pri)));
num_par(1) = length(c2);
mu = c2; % fix GMM centers at bin centers
min_sigma = 0.01; % if sigma smaller than this, then drop center
for i=1:39;
    [mu sigma pri] = sdh_gmm_em_mu(x, mu, sigma, pri, min_sigma*i);
    err(i+1) = sum(log(sdh_gmm_pdf(x, mu, sigma, pri)));
    num_par(i+1) = length(mu);
end

s = subplot(X,Y,7); set(s,'fontsize',FONTSIZE);
plot(c_hr,p_hr,'color',[0.6 .9 0.6],'linewidth',2); hold on
plot(c_hr,sdh_gmm_pdf(c_hr', mu, sigma, pri)); 
axis([MIN-0.1, MAX, 0, 0.5]);
h=title('GMM (estimate \mu, priors & \sigma)'); set(s,'xtick',[]);
set(h,'verticalalignment','middle');

s = subplot(X,Y,8); set(s,'fontsize',FONTSIZE)
[ax,h1,h2] = plotyy(1:length(err),err,1:length(err),num_par);
set(ax(2),'ycolor','r'); set(h2,'color','r'); set(h2,'marker','.')
set(h1,'marker','.')
s = subplot(ax(1)); set(s,'xtick',[]); ylabel('log-likelihood')
s = subplot(ax(2)); set(s,'xtick',[]); ylabel('centers')
set(ax(2),'fontsize',FONTSIZE); set(ax(1),'fontsize',FONTSIZE)
h=title(['\sigma_{min}=',num2str(min_sigma)]); set(s,'xtick',[]);
set(h,'verticalalignment','middle');

fprintf('done.\n')

function [p, p_hist, x] = pdf(c,N,bin_width)
if 0,
    %% simple data: 1-dim norm pdf
    p = normpdf(c,0,1);
    p_hist = p/p(end/2)*(normcdf(bin_width/2,0,1)-normcdf(-bin_width/2,0,1))*N;
    x = randn(N,1);
else
    %% simple data: 1-dim 3 x norm pdf
    % 3 peeks:
    N = 3*round(N/3);
    x = zeros(N,1);
    x(1:round(N/3)) = x(1:round(N/3))+randn(round(N/3),1)/2-4;
    x(round(N/3)+1:round(2*N/3)) = x(round(N/3)+1:round(2*N/3))+randn(round(N/3),1);
    x(round(2*N/3)+1:N) = x(round(2*N/3)+1:N)+randn(round(N/3),1)/2+4;
    
    p = (normpdf(c,-4,0.5)+normpdf(c,0,1)+normpdf(c,4,0.5))/3;
    
    a = -bin_width/2;
    b = +bin_width/2;
    c = ...
        (normcdf(b,-4,0.5)+normcdf(b,0,1)+normcdf(b,4,0.5))/3- ...
        (normcdf(a,-4,0.5)+normcdf(a,0,1)+normcdf(a,4,0.5))/3;

    p_hist = p/p(end/2)*N*c;
end