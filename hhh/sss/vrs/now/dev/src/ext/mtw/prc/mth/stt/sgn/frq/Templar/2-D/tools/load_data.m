function [training_data] = load_data(data_dir,T)
%
%If your training images are in a directory 'data_dir,' and are
%stored in a format that is recognized by the IP toolbox's
%imread, command, use this command to load the data into
%the training_data variable.
%
%For example
%	data_dir='./data';	T=10;
%	td=load_data(data_dir,T);



working_dir = pwd;
cd(data_dir);

imlist = dir(data_dir);

if T > length(imlist)-2;
  error('load_data.m: Too many training images')
end
training_data=cell(1,T);

for t = 1:T
  filename = imlist(t+2).name;
  im =  double(imread(filename));
  if length(size(im)) > 2
    bwim=.3*im(:,:,1)+.59*im(:,:,2)+.11*im(:,:,3);
               	% convert to black and white
  else
    bwim=im;
  end
  training_data{t}=bwim;
end

cd(working_dir);
