function val=repval(val,dim,nrep)

% Calculate number of dimensions.
ndim=max(ndims(val),max(dim));

% Allocate space for indices.
ind=cell(ndim,1);

% Compute indices.
for i=1:ndim
    ind{i}=(1:size(val,i))';
    for j=find(i==dim)
        ind{i}=ind{i}(:,ones(1,nrep(j)));
    end
end

% Replicate values.
val=val(ind{:});

end