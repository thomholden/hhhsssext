function obj = setcomponent(obj,name,component)
%RESIZABLE_LAYOUT/SETCOMPONENT - Sets an "external" component in the layout
%
% obj = setcomponent(obj,name,component)
%

% Copyright 2006-2010 The MathWorks, Inc.

elements = obj.elements;
for i=1:size(elements,1)
    for k=1:size(elements,2)
        if ischar(elements{i,k})
            if strcmp(elements{i,k},name)
                obj.elements{i,k} = component;
                obj = resize(obj,obj.position);
                return;
            end
        end
    end
end
error(sprintf('Named component "%s" not found',name));

