function Geo_Opt = Update_Geometric_Options(obj,Func_Opt,Geo_Opt)
%Update_Geometric_Options
%
%   This updates the given geometric based on what the function options are for
%   this type of transformation.

% Copyright (c) 03-13-2012,  Shawn W. Walker

if (length(obj) > 1)
    error('This only operates on a *single* object.');
end

TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;

if Func_Opt.Grad
    if (TD==1)
        Geo_Opt.Inv_Det_Jacobian = true;
        if (GD > 1)
            Geo_Opt.Tangent_Vector = true;
        end
    elseif (TD==2)
        if (GD==2)
            Geo_Opt.Inv_Grad = true;
        elseif (GD==3)
            Geo_Opt.Inv_Metric = true;
        else
            error('Invalid!');
        end
    else
        Geo_Opt.Inv_Grad = true;
    end
end

if Func_Opt.d_ds
    if (TD ~= 1)
        error('Can only use .d_ds on domains with topological dimension 1!');
    end
    Geo_Opt.Inv_Det_Jacobian = true;
end

end