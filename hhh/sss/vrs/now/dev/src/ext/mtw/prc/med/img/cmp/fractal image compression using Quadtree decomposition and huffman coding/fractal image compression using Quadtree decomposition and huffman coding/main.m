%program for fractal image compression using Quadtree decomposition 
%and huffman coding
% Author        : Arun Kumar
% Email         : mail.drgkumar@gmail.com
% Version       : 1.0
% Date          : 6/6/2014
%% prpare workspace
clc;clear;close all;

%% 1.input Image
fname=uigetfile('*.jpg');%opens ui for select image files
I=imread(fname); %reads selected image
I=imresize(I,[128 128]);%resize image into 256*256
figure,imshow(I);title('Original Image');drawnow;
tic;%record time

%% 2.Quadtree Decomposition
s=qtdecomp(I,0.2,[2 64]);%divides image using quadtree decomposition of
                         %threshold .2 and min dim =2 ,max dim =64
[i,j,blksz] = find(s); %record x and y coordinates and blocksize
blkcount=length(i);  %no of total blocks
avg=zeros(blkcount,1);%record mean values
for k=1:blkcount 
    avg(k)=mean2(I(i(k):i(k)+blksz(k)-1,j(k):j(k)+blksz(k)-1));%find mean 
                                                               %value
end 
avg=uint8(avg);
figure,imshow((full(s)));title('Quadtree Decomposition');drawnow;
%% 3.Huffman Encoding
%prepare data
i(end+1)=0;j(end+1)=0;blksz(end+1)=0;%set boundary elements
data=[i;j;blksz;avg];%record total information
data=single(data); %convert to single
symbols= unique(data);% Distinct symbols that data source can produce
counts = hist(data(:), symbols);%find counts of symblos in given data
p = counts./ sum(counts);% Probability distribution
sp=round(p*1000);% scaled probabilities
dict = huffmandict(symbols,p'); % Create dictionary.
comp = huffmanenco(data,dict);% Encode the data.

%% 4.Compressed
%Time taken for compression
t=toc;
fprintf('Time taken for compression = %f seconds\n',t);
%compression ratio
bits_in_original=8*256*256;
bits_in_final=length(comp)+8*length(symbols)+8*length(sp);
%Compression Ratio = total number of bits in original file, divided by 
%number of bits in final file
CR= bits_in_original/bits_in_final;
fprintf('compression ratio= %f\n',CR);

%% 5.Huffman Decoding
tic;%record time
datanew = huffmandeco(comp,dict);% decode the data.
zeroindx=find(data==0);%find boundries
inew=datanew(1:zeroindx(1)-1); %seperate row index
jnew=datanew(zeroindx(1)+1:zeroindx(2)-1); %seperate column index
blksznew=datanew(zeroindx(2)+1:zeroindx(3)-1);%seperate blocksize
avgnew=datanew(zeroindx(3)+1:end); %seperate mean values

%% 6.Decompressed image
avgnew=uint8(avgnew);
for k=1:blkcount 
  outim(inew(k):inew(k)+blksznew(k)-1,jnew(k):jnew(k)+blksznew(k)-1)=avgnew(k);
end
figure,imshow(outim);title('Decompressed Image');drawnow;

%% PSNR calculation
%Time taken for De-compression
t=toc;
fprintf('Time taken for Decompression = %f seconds\n',t);
%Create psnr object
hpsnr = vision.PSNR;
psnr = step(hpsnr, I,outim);%calculate psnr
fprintf('PSNR= %f\n',psnr);%display psnr
