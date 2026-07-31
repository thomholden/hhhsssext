close all; clear all;

disp(' ')
disp(' ')
disp('Distributed Matlab toolbox version Beta 1.77  2001-03')
disp(sprintf('         by Lucio Andrade \n \n'))
disp(' ')

disp('Before continue, launch other matlabs at other computers connected')
disp('to the internet and run worker("hostname") ')
disp('where hostname is the ip address of this machine (e.g. mars.ece.neu.edu)')
disp(' ')
disp('Image toolbox is needed to run this demo ')
disp(' ')
disp('pause');pause

disp(' ')
disp('Now I initialize the master (or majordomo)...')
disp('[ss,rs]=initmajordomo')
[ss,rs]=initmajordomo;


disp('pause');pause
disp('First I will load 256*256 images into a 3-dimensional')
disp('hypercube...')
disp(' ')

close all



di=dir('images/*.jpg');
for i=1:length(di)
 x(:,:,i)=double(imread(['images/' di(i).name]));
 h=figure; imshow(uint8(x(:,:,i)));
end;

target=x(126:140,126:140,6)+rand(15)*10-5;
h=figure; imshow(uint8(target));truesize(h,[50,50])

disp(' ')
disp('The first demo searches all the image data base')
disp('for lena''s eye (fig 9), which has some additive noise')
disp('This is an exhaustive search, certainly not the best (in terms of ')
disp('algorithms) but enough for demostration of this toolbox (I''m sure ')
disp('you''ll have a large variety of challenging parallel problems)') 
disp('We will send overlapped 64x64 blocks of images to the workers,')
disp('as well as the small target image.')
disp(' ')
disp('Every block starts 48 samples from the previous (they are')
disp('overlapped since the target could be at the border of a subimage),')
disp('when the row of subimages is exhasuted the next ')
disp('row 48 samples down is processed, when the image is exhausted')
disp('the next image of the data base is processed. We observe the a ')
disp('powerful control of the data flow is achieved just with the proper')
disp('setting of the indexes, i.e. the user does not have to care about the')
disp('data managment for every parallel intance, a complex structure of')
disp('nested loops is already built in so the user can iterate up to ')
disp('hyperblocks of five dimensions')
if (exist('imread')==2) figure;imshow(imread('para2.tif')); end
disp(' ')
disp('pause');pause
disp(' ')
disp('Indexes are controlled as follows for the subimages (x) and for')
disp('the constant image target (t)')
disp(' ')
disp('    [Dim #elem startat inc blocksize]')
xindexes=[1 5 1 48 64; 2 5 1 48 64;3 8 1 1 1]
tindexes=[1 5*5*8 1 0 15; 2 1 1 0 15]
disp(' ')
disp('[ii,jj,vv]=parallelize(ss,rs,inf,1,''searchsubimage'',3,x,xindexes,target,tindexes);')
disp('ready ?');pause

[ii,jj,vv]=parallelize(ss,rs,inf,1,'searchsubimage',3,x,xindexes,target,tindexes);

kk=ones(25,1)*(1:8);
for k=1:8
  jj(:,:,k)=jj(:,:,k)+ones(5,1)*((0:4)*48);
  ii(:,:,k)=ii(:,:,k)+((0:4)'*48)*ones(1,5);
end
out=sortrows([ii(:),jj(:),kk(:),vv(:)],4);
disp(' ')
disp(' ')
disp('This is the found target:');
k=1;figure(out(k,3));
line([ones(1,5)*out(k,1)+[0 0 15 15 0]],[ones(1,5)*out(k,2)+[0 15 15 0 0]],'color','r')
disp(['Error ' num2str(out(k,4))]); 
disp(' ')
disp('pause');pause

closemajordomo(ss,rs)

disp('End of demo, if you have the image toolbox please go to distm_demo_2')
disp('For further questions/comments please e-mail landrade@ece.neu.edu')

