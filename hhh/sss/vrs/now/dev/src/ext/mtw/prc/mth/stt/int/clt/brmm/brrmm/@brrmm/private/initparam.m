function param=initparam(param,in,~)

% Store model size and number of points.
[~,nin,ncomp]=size(param.gain);
[~,npoint]=size(in);

% Store identity matrix.
id=eye(nin);

% Initialize distributions over model parameters.
param.stren=param.stren+npoint;
param.scale=param.scale+(npoint/ncomp)*id(:,:,ones(1,1,ncomp));
param.shape=param.shape+npoint/ncomp;

end