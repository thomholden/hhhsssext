function CODE = Output_PHI_Codes(obj,PHI_Struct,Num_Basis)
%Output_PHI_Codes
%
%   This outputs an array of structs, each of which contains the C++ code for
%   implementing that quantity.
%
%   Note: these must be stored in order of dependencies, i.e. the ones that
%   don't depend on anything come first, etc...
%   Note: PHI_Struct is a struct with the same fields as given by
%         Output_PHI_Struct.

% Copyright (c) 02-20-2012,  Shawn W. Walker

CODE = obj.PHI_Val_C_Code(1); % init

INDEX = 0; % init
if PHI_Struct.Mesh_Size
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Mesh_Size_C_Code(Num_Basis);
end
if PHI_Struct.Val
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Val_C_Code(Num_Basis);
end
if PHI_Struct.Grad
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Grad_C_Code(Num_Basis);
end
if PHI_Struct.Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Metric_C_Code;
end
if PHI_Struct.Det_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_Metric_C_Code;
end
if PHI_Struct.Inv_Det_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Det_Metric_C_Code;
end
if PHI_Struct.Inv_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Metric_C_Code;
end
if PHI_Struct.Det_Jacobian
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_Jac_C_Code;
end
if PHI_Struct.Det_Jacobian_with_quad_weight
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_Jac_w_Weight_C_Code;
end
if PHI_Struct.Inv_Det_Jacobian
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Det_Jac_C_Code;
end
if PHI_Struct.Inv_Grad
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Grad_C_Code;
end
if PHI_Struct.Tangent_Vector
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Tangent_Vector_C_Code;
end
if PHI_Struct.Normal_Vector
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Normal_Vector_C_Code;
end
if PHI_Struct.Tangent_Space_Projection
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Tan_Space_Proj_C_Code;
end
if PHI_Struct.Hess
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Hess_C_Code(Num_Basis);
end
if PHI_Struct.Inv_Hess
    error('Not implemented!');
%     INDEX = INDEX + 1;
%     CODE(INDEX) = obj.XXXX;
end
if PHI_Struct.Second_Fund_Form
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_2nd_Fund_Form_C_Code;
end
if PHI_Struct.Det_Second_Fund_Form
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_2nd_Fund_Form_C_Code;
end
if PHI_Struct.Inv_Det_Second_Fund_Form
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Det_2nd_Fund_Form_C_Code;
end

if and(obj.TopDim==1,obj.GeoDim==3) % curve in 3-D
    if PHI_Struct.Total_Curvature_Vector
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_Vector_C_Code;
    end
    if PHI_Struct.Total_Curvature
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_C_Code;
    end
else % else we must compute the scalar (total) curvature first
    if PHI_Struct.Total_Curvature
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_C_Code;
    end
    if PHI_Struct.Total_Curvature_Vector
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_Vector_C_Code;
    end
end

if PHI_Struct.Gauss_Curvature
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Gauss_Curvature_C_Code;
end

if (INDEX==0)
    CODE = []; % output nothing...
end

%                         Mesh_Size: [1x1 sym]
%                               Val: [1x1 sym]
%                              Grad: [1x1 sym]
%                            Metric: []
%                        Det_Metric: []
%                    Inv_Det_Metric: []
%                        Inv_Metric: []
%                      Det_Jacobian: [1x1 sym]
%     Det_Jacobian_with_quad_weight: [1x1 sym]
%                  Inv_Det_Jacobian: [1x1 sym]
%                          Inv_Grad: [1x1 sym]
%                    Tangent_Vector: []
%                     Normal_Vector: []
%          Tangent_Space_Projection: [1x1 sym]
%                              Hess: [1x1 sym]
%                          Inv_Hess: []
%                  Second_Fund_Form: []
%              Det_Second_Fund_Form: []
%          Inv_Det_Second_Fund_Form: []
%            Total_Curvature_Vector: []
%                   Total_Curvature: []
%                   Gauss_Curvature: []
%                       Orientation: [] (sometimes)

end