%% a) Simple Plot
figure
plot(10:24,rand(1,15));
akZoom();

%% b) Image
figure
imagesc(magic(40));
akZoom();

%% c) Plotyy (linked axes)
figure
plotyy(1:15, rand(1,15), 1:15, rand(1,15));
akZoom();

%% d) Plotyy (independent axes)
figure
ax = plotyy(1:15, rand(1,15), 1:15, rand(1,15));
akZoom({ax(1), ax(2)});

%% e) Subplots (independent axes)
figure
for k = 1:4
  y = rand(1,15);
  subplot(2, 2, k);
  plot(y);
end
akZoom();

%% e) Subplots (linked axes)
figure
ax = NaN(4,1);
for k = 1:4
  y = rand(1,15);
  ax(k) = subplot(2, 2, k);
  plot(y);
end
akZoom(ax);

%% f) Subplots (mixture of linked and indipendent axes)
figure
ax = NaN(4,1);
for k = 1:4
  y = rand(1,15);
  ax(k) = subplot(2, 2, k);
  plot(y);
end
akZoom({[ax(1),ax(3)],ax(2),[ax(3),ax(4)]});

%% g) Different figures (linked)
figure;
im1 = imread('peppers.png');
imshow(im1)
ax1 = gca;
figure
im2 = rgb2gray(im1);
imshow(im2)
ax2 = gca;
akZoom([ax1,ax2]);

%% h) All axes in all open figures (independent)
figure
plotyy(1:15, rand(1,15), 1:15, rand(1,15));
figure
plot(rand(1,15));
akZoom('all');

%% i) All axes in all open figures (linked)
% Note the blinking boundaries in the log-plot when you try to
% pan/zoom in a way that would make the limits exceed valid double
% values: smaller than 2.2e-308 or larger than 1.8e308
figure
plotyy(1:15, rand(1,15), 1:15, rand(1,15));
figure
loglog(exp(1:800), exp(1:800));
akZoom('all_linked');

%% j) Custom mapping of mouse buttons
figure
semilogx(rand(1,150));
akZoom('rlm')