function [comp,weight,out]=genvar(fun,eff,prop,gain,noise,in,ndeg)

% Store model size and number of points.
[nout,~,ncomp]=size(gain);
[~,npoint]=size(in);

% Format parameters for sampling.
prop=[0;cumsum(prop(:))];
for i=1:ncomp
    noise(:,:,i)=chol(noise(:,:,i),'lower');
end

% Generate weights.
if isinf(ndeg)
    weight=ones(npoint,1);
else
    weight=max(randg(ndeg/2,npoint,1)/(ndeg/2),eps());
end

% Allocate space for remaining data.
comp=zeros(npoint,1);
out=zeros(nout,npoint);

% Generate remaining data.
empty=isempty(fun)||isempty(eff);
for i=1:npoint
    comp(i)=min(find(rand()>=prop,1,'last'),ncomp);
    if ~empty
        out(:,i)=feval(fun,eff(:,comp(i)),in(:,i));
    end
    out(:,i)=out(:,i)+gain(:,:,comp(i))*in(:,i)+...
        (noise(:,:,comp(i))*randn(nout,1))/sqrt(weight(i));
end

end