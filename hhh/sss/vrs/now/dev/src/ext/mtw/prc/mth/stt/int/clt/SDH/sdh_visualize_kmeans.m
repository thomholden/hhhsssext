function sdh_visualize_kmeans(S, s)

% SDH_VISUALIZE_KMEANS Visualize k-means in comparable style.
%
%  sdh_visualize_kmeans(S, [subplot])
% 
%   Input arguments ([]'s are optional): 
%     S (struct) Smoothened Data Histogram structure, see sdh_calculate
%     s (scalar) Optional subplot handle. If not given, new figure is created.
%
%  See also SDH_DEMO1.

% elias 25/04/2002

if ~isstruct(S) |  ~isfield(S,'type') | ~strcmp(S.type,'sdh'),
    error('(sdh_visualize_kmeans) first argument is not SDH structure.');
end

if nargin<2,
    f = figure;
    s = subplot(1,1,1);
else
    subplot(s);
end

hold on; 

x = S.msize(2);
y = S.msize(1);
c = 2^S.interp.ntimes;

if strcmp(S.frame,'on'), f = 1;
else f = 0;
end

o=f*c+1;

for i=1:x, plot([o+(i-1)*c, o+(i-1)*c],[o, o+c*(y-1)],'k-');
end
for i=1:y, plot([o, o+c*(x-1)],[o+(i-1)*c, o+(i-1)*c],'k-');
end

for i=1:y,
    for j=1:x,
        plot(o+(j-1)*c, o+(i-1)*c,'k.');
    end
end

% visualize kmeans
c = S.matrix;
m = max(max(c)); % number of clusters
x = size(c,1);
y = size(c,2);

z = zeros(x,y);
for i=1:m,
    o = z;
    o(c==i)=1;
    contour(o,1,'-r');
end
box on

set(s,'ydir','reverse');
set(s,'xtick',[-REALMAX REALMAX]);
set(s,'ytick',[-REALMAX REALMAX]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%