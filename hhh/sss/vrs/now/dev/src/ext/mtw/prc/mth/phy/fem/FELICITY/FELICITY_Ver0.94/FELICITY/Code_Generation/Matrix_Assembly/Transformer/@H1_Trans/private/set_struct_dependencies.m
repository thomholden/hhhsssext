function Opt = set_struct_dependencies(obj,Opt)
%set_struct_dependencies
%
%   This does one pass through the dependency check.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% if you want the gradient
if ~isempty(obj.f.Grad)
    if Opt.Grad
        if and((obj.GeoMap.TopDim==1),(obj.GeoMap.GeoDim > 1))
            % then you need the arc-length derivative
            Opt.d_ds = true;
        end
    end
elseif Opt.Grad
    error('Grad cannot be used in this context!');
end
%etc......
if ~isempty(obj.f.Hess)
    if Opt.Hess
        Opt.Grad = true;
        if and((obj.GeoMap.TopDim==1),(obj.GeoMap.GeoDim > 1))
            % then you need the arc-length 2nd derivative
            Opt.d2_ds2 = true;
        end
    end
elseif Opt.Hess
    error('Hess cannot be used in this context!');
end
if ~isempty(obj.f.d2_ds2)
    if Opt.d2_ds2
        if (obj.GeoMap.TopDim~=1)
            error('Topological dimension must be 1!');
        end
        % then you need the arc-length 1st derivative
        Opt.d_ds = true;
    end
elseif Opt.d2_ds2
    error('d2_ds2 cannot be used in this context!');
end

% there are no other dependencies...

end