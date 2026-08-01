function CODE = FUNC_Grad_C_Code(obj)
%FUNC_Grad_C_Code
%
%   Generate C-code for evaluation of grad(f) by transformation.
%        \partial_j f_k(qp) = T(\partial_1 phi_k(qp),...,\partial_t phi_k(qp)),
%                             t is the topological dimension of the domain on
%                             which the local basis function is defined,
%                             k is the basis function index,
%                             j is the physical derivative index,
%                             qp are the coordinates of a quadrature point, and
%                             T is some transformation that depends on the local
%                             geometric map.

% Copyright (c) 03-12-2012,  Shawn W. Walker

% make var string
f_Grad_str = obj.Output_CPP_Var_Name('Grad');

% is geometric transformation constant?
if obj.GeoMap.Is_Quantity_Constant('Grad'); % grad(PHI)
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end

TAB = '    ';
% make (local) basis function derivative eval strings
BF_D0 = 'phi_0_Basis_Val_1_0_0[qp_i][basis_i]';
BF_D1 = 'phi_0_Basis_Val_0_1_0[qp_i][basis_i]';
BF_D2 = 'phi_0_Basis_Val_0_0_1[qp_i][basis_i]';

% loop thru all components of the map
EVAL_STR(3).line = []; % init
EVAL_STR(1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR(2).line = [TAB, '{'];
if (obj.GeoMap.TopDim==1) % reference domain is 1-D
    if (obj.GeoMap.GeoDim==1)
        Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');
        TEMP_STR = [f_Grad_str, '[basis_i][qp_i].v[0]', ' = ', 'phi_0_Basis_Val_1_0_0[qp_i]', '[basis_i]', ' * ', ...
            'Mesh->', Inv_Det_Jac_CPP_Name, QP_str, '.a;'];
        EVAL_STR(3).line = [TAB, TEMP_STR];
    else % need the arc-length derivative here...
        Tangent_Vector_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Tangent_Vector');
        f_d_ds_str = obj.Output_CPP_Var_Name('d_ds');
        TEMP_STR = ['Scalar_Mult_Vector(', 'Mesh->', Tangent_Vector_CPP_Name, QP_str, ', ',...
                    f_d_ds_str, '[basis_i][qp_i]', ', ', f_Grad_str, '[basis_i][qp_i]', ');'];
        EVAL_STR(3).line = [TAB, TEMP_STR];
    end
    
elseif (obj.GeoMap.TopDim==2) % reference domain is 2-D
    if (obj.GeoMap.GeoDim==2)
        Inv_Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Grad');
        G_00 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[0][0]'];
        G_01 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[0][1]'];
        G_10 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[1][0]'];
        G_11 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[1][1]'];
        EVAL_STR(3).line = [TAB, f_Grad_str, '[basis_i][qp_i].v[0]', ' = ', G_00, ' * ', BF_D0, ' + ',...
                                                                            G_10, ' * ', BF_D1, ';'];
        EVAL_STR(4).line = [TAB, f_Grad_str, '[basis_i][qp_i].v[1]', ' = ', G_01, ' * ', BF_D0, ' + ',...
                                                                            G_11, ' * ', BF_D1, ';'];
    elseif (obj.GeoMap.GeoDim==3)
        Grad_PHI_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Grad');
        G_MAT = ['Mesh->', Grad_PHI_CPP_Name, QP_str];
        Inv_Metric_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Metric');
        M_00 = ['Mesh->', Inv_Metric_CPP_Name, QP_str, '.m[0][0]'];
        M_01 = ['Mesh->', Inv_Metric_CPP_Name, QP_str, '.m[0][1]'];
        M_10 = ['Mesh->', Inv_Metric_CPP_Name, QP_str, '.m[1][0]'];
        M_11 = ['Mesh->', Inv_Metric_CPP_Name, QP_str, '.m[1][1]'];
        EVAL_STR(3).line = [TAB, 'VEC_2x1 VL; // map local gradient to the tangent space'];
        EVAL_STR(4).line = [TAB, 'VL.v[0] = ', M_00, ' * ', BF_D0, ' + ', M_10, ' * ', BF_D1, ';'];
        EVAL_STR(5).line = [TAB, 'VL.v[1] = ', M_01, ' * ', BF_D0, ' + ', M_11, ' * ', BF_D1, ';'];
        EVAL_STR(6).line = [TAB, 'Mat_Vec(', G_MAT, ', VL, ', f_Grad_str, '[basis_i][qp_i]', ');'];
    else
        error('Invalid!');
    end
elseif (obj.GeoMap.TopDim==3) % reference domain is 3-D
    if (obj.GeoMap.GeoDim==3)
        Inv_Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Grad');
        G_00 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[0][0]'];
        G_01 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[0][1]'];
        G_02 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[0][2]'];
        G_10 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[1][0]'];
        G_11 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[1][1]'];
        G_12 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[1][2]'];
        G_20 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[2][0]'];
        G_21 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[2][1]'];
        G_22 = ['Mesh->', Inv_Grad_CPP_Name, QP_str, '.m[2][2]'];
        EVAL_STR(3).line = [TAB, f_Grad_str, '[basis_i][qp_i].v[0]', ' = ', G_00, ' * ', BF_D0, ' + ',...
                                                                            G_10, ' * ', BF_D1, ' + ',...
                                                                            G_20, ' * ', BF_D2, ';'];
        EVAL_STR(4).line = [TAB, f_Grad_str, '[basis_i][qp_i].v[1]', ' = ', G_01, ' * ', BF_D0, ' + ',...
                                                                            G_11, ' * ', BF_D1, ' + ',...
                                                                            G_21, ' * ', BF_D2, ';'];
        EVAL_STR(5).line = [TAB, f_Grad_str, '[basis_i][qp_i].v[2]', ' = ', G_02, ' * ', BF_D0, ' + ',...
                                                                            G_12, ' * ', BF_D1, ' + ',...
                                                                            G_22, ' * ', BF_D2, ';'];
    else
        error('Invalid!');
    end
end
EVAL_STR(length(EVAL_STR)+1).line = [TAB, '}']; % close the basis loop

% define the data type
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
Defn_Hdr = '// intrinsic gradient of basis function';
Loop_Hdr = '// map gradient from local to global coordinates (indexing is in the C style)';
Loop_Comment = '// multiply local gradient by transpose of Inv_Grad(PHI) matrix';
CONST_VAR = obj.Is_Quantity_Constant('Grad');
CODE = obj.create_basis_func_declaration_and_eval_code(f_Grad_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end