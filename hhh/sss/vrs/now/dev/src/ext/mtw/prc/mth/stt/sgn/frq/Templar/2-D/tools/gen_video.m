bgc=double(imread('/home/cscott/research/templar/templates/pebbles.jpg','jpg'));

bg1=bw(bgc);
bg2=bg1(: , 296:296+1168-1);
bg3=imresize(bg2, [256 256], 'nearest');
bg4=bg3(97:97+64-1,:);
bg5=bg4(17:16+32, 65:128+64);
bg=bg5;

carc=double(imread('/home/cscott/research/templar/templates/car2.jpg','jpg'));

car1=bw(carc);
car2=car1(: , 296:296+1168-1);
car3=imresize(car2, [256 256], 'nearest');
car4=car3(97:97+64-1,:);
car5=car4;
car5(:, 150:end)=0;
th=115;
car6=car5.*(car5>=th);
car7=car6(13:32+12, 65:128+64);
car=car7;

offset=(-10:10:80)/5;

for t=1:T
	tcar=translate(car,offset(t),0);
	training_data{t}=bg.*(tcar==0)+tcar+rand(32,128)*75;
end

for t=1:T
	subplot(6,2,t);
	imagesc(training_data{t})
	axis equal
	axis([1 128 1 32])
	colormap(gray)
	set(gca, 'XTick', [])
	set(gca, 'YTick', [])
end
