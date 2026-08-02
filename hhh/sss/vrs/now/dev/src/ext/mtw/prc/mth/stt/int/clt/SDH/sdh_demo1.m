function sdh_demo1
% SDH_DEMO1 Compare SDH with U-Matrix and k-means clustering of model vectors.

% elias 14/04/2002

f = figure;
set(f,'numbertitle','off');
set(f,'name','SDH Demo1');


% create 2-dimensional data set

% axis limits
x_min = -1.75; x_max = 2.75;
y_min = -3.5;  y_max = 3;

% items per cluster (priors)
a = 1000;
b = 1000;
c =  500;
d = 1500;
e = 1000;

abcde = a + b + c + d + e; % total items

% rotate clusters (covariance)
ROT_a = [.3 0; 0 .7];
ROT_b = [.4 0; 0 .5];
ROT_c = [.3 0; 0 .3];
ROT_d = [.5 0; 0 .4];
ROT_e = [.4 0; 0 .5];

% translate clusters (mean)
TRA_a = [-.5  1  ];
TRA_b = [-.5 -1  ];
TRA_c = [0.5 -0.1];
TRA_d = [1.5  1  ];
TRA_e = [0.5 -2.5];

% propability density function
grid = normpdf(y_min:0.1:y_max,TRA_a(2),ROT_a(4))'*normpdf(x_min:0.1:x_max,TRA_a(1),ROT_a(1)).*a;
grid = grid + normpdf(y_min:0.1:y_max,TRA_b(2),ROT_b(4))'*normpdf(x_min:0.1:x_max,TRA_b(1),ROT_b(1)).*b;
grid = grid + normpdf(y_min:0.1:y_max,TRA_c(2),ROT_c(4))'*normpdf(x_min:0.1:x_max,TRA_c(1),ROT_c(1)).*c;
grid = grid + normpdf(y_min:0.1:y_max,TRA_d(2),ROT_d(4))'*normpdf(x_min:0.1:x_max,TRA_d(1),ROT_d(1)).*d;
grid = grid + normpdf(y_min:0.1:y_max,TRA_e(2),ROT_e(4))'*normpdf(x_min:0.1:x_max,TRA_e(1),ROT_e(1)).*e;

% draw random sample
D = randn(abcde, 2);
D(1:a,:)                 = D(1:a,:)*ROT_a             + repmat(TRA_a,a,1);
D(a+1:a+b,:)             = D(a+1:a+b,:)*ROT_b         + repmat(TRA_b,b,1);
D(a+b+1:a+b+c,:)         = D(a+b+1:a+b+c,:)*ROT_c     + repmat(TRA_c,c,1);
D(a+b+c+1:a+b+c+d,:)     = D(a+b+c+1:a+b+c+d,:)*ROT_d + repmat(TRA_d,d,1);
D(a+b+c+d+1:a+b+c+d+e,:) = D(a+b+c+d+1:abcde,:)*ROT_e + repmat(TRA_e,e,1);

s = subplot(2,3,1);
contourf([x_min:0.1:x_max],[y_min:0.1:y_max],grid,4)
title('PDF');
set(s,'xtick',[-REALMAX REALMAX]);
set(s,'ytick',[-REALMAX REALMAX]);

s = subplot(2,3,2);
plot(D(:,1),D(:,2),'k.','markersize',1); hold on;
title(['Sample (N=',num2str(abcde),')']); 
axis([x_min x_max y_min y_max])
set(s,'xtick',[-REALMAX REALMAX]);
set(s,'ytick',[-REALMAX REALMAX]);

% SOM
x = 6; y = 8; % map size
sD = som_data_struct(D);
sM = som_lininit(sD,'rect','msize',[x y]);
disp('Start SOM training ...');
sM = som_batchtrain(sM,sD,'radius',3.5:-.5:0.5,'tracking',0);
disp('Done.');

s = subplot(2,3,3);
M = sM.codebook;
hold on;

plot(D(:,1),D(:,2),'k.','markersize',1,'color',[0.8 0.9 1]*.8); hold on;

for i=1:y
    idx=((i-1)*x+1):((i-1)*x+x);
    plot(M(idx,1),M(idx,2),'k-');
end
for i=1:x
    idx=(0:(y-1))*x+i;
    plot(M(idx,1),M(idx,2),'k-');
    plot(M(idx,1),M(idx,2),'k.');
end               
axis([x_min x_max y_min y_max]); box on
set(s,'xtick',[-REALMAX REALMAX])
set(s,'ytick',[-REALMAX REALMAX])
title('SOM');

% SDH
s = subplot(2,3,4);
S = sdh_calculate(sD,sM);
S.matrix = rot90(rot90(S.matrix));  % note: rot90 usually doesn't make sense.
sdh_visualize(S,'subplot',s,'contour','nodes');
title('SDH (s=3)')

% U-Matrix
s = subplot(2,3,5);
u = som_umat(sM); u = u(1:2:end,1:2:end);
u = rot90(rot90(u)); % note: rot90 usually doesn't make sense.
S.matrix = interp2(sdh_addframe(max(max(u))-u,1),2,'cubic');
sdh_visualize(S,'contour','subplot',s,'nodes');
title('U-Matrix');

% K-Means
s = subplot(2,3,6);
eb = REALMAX;
for i=1:100,
    [centroids,clusters,err] = kmeans('batch', M, 5);
    if err < eb,
        cb = clusters; eb = err;
    end
end
cb = rot90(rot90(reshape(cb,6,8))); % note: rot90 usually doesn't make sense.
S.matrix = interp2(sdh_addframe(cb,1),2,'nearest');
sdh_visualize_kmeans(S,s);
axis tight;
title('K-Means');

sdh_colormap('blueish');
