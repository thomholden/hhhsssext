function [mmar] = rmar (data,seg_size,offset,ns,order)

% function [mmar] = rmar (data,seg_size,offset,ns,order)
% Running multivariate autoregressive (MAR) model
% data 		data
% seg_size	size of each segement in samples
% offset	the overlap between segments in samples
% ns		sample rate
% order		of MAR model
% mmar		multiple mar models

offset=ceil(offset);
disp('Running MAR estimate');
 
Nd=size(data,1);
 
hseg_size=round(seg_size/2);
segments=max(size(1:offset:Nd));
 
disp(sprintf(' Calculated splitting of sequence into %d segments.'...
              ,segments));
 
if (offset>=seg_size) disp(' No Overlapping!');
  else disp(' With Overlapping!'); end;
 
h=waitbar(0,sprintf('Running MAR estimate; %d Segments',segments));
 
% Pad series with mean value
mdata=mean(data);
data=[ones(hseg_size,1)*mdata; data; ones(hseg_size,1)*mdata];

segment_counter=1;
for i=1:offset:Nd-seg_size+1,
   dx=data(i:i+seg_size-1,:);

   mmar(segment_counter)= mar_learn (dx,order);

   segment_counter=segment_counter+1;
   waitbar(segment_counter/segments);
 
end;
close(h);
 
