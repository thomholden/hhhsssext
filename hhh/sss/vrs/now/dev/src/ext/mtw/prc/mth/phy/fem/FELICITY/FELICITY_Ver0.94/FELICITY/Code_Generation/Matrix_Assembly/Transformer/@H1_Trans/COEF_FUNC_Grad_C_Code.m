function CODE = COEF_FUNC_Grad_C_Code(obj)
%COEF_FUNC_Grad_C_Code
%
%   Generate C-code for computing coefficient functions.
%       \nabla f_i(qp) = SUM^{NUM_BASIS}_{k=1} c_{ik} * \nabla phi_k(qp), where
%                        phi_k is the kth mapped basis function,
%                        f_i is the ith component of the coef. function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 03-14-2012,  Shawn W. Walker

TAB = '    ';
TAB2 = [TAB, TAB];

% make var string
f_Grad_str = obj.Output_CPP_Var_Name('Grad');

if and(obj.GeoMap.TopDim==1,obj.GeoMap.GeoDim > 1) % curve in higher dimensions
    
    % make var string
    f_d_ds_str = obj.Output_CPP_Var_Name('d_ds');
    CF = [f_Grad_str, '[nc_i][qp_i]', '.v', '[gd_i]'];
    CF_d_ds = [f_d_ds_str, '[nc_i][qp_i]', '.a'];
    TV_str = obj.GeoMap.Output_CPP_Var_Name('Tangent_Vector');
    if obj.GeoMap.Is_Quantity_Constant('Tangent_Vector')
        QP_str = '[0]';
    else
        QP_str = '[qp_i]';
    end
    Mesh_Tangent_str = ['basis_func->Mesh->', TV_str, QP_str, '.v[gd_i]'];
    
    % loop thru all components of the map
    EVAL_STR(8).line = []; % init
    EVAL_STR(1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
    EVAL_STR(2).line = [TAB, '{'];
    EVAL_STR(3).line = [TAB, '// compute the 1-D gradient of the function'];
    EVAL_STR(4).line = [TAB, 'for (int gd_i = 0; (gd_i < GeoDim); gd_i++)'];
    EVAL_STR(5).line = [TAB2, '{'];
    EVAL_STR(6).line = [TAB2, CF, ' = ', Mesh_Tangent_str, ' * ', CF_d_ds, ';']; % C-style indexing
    EVAL_STR(7).line = [TAB2, '}']; % close the basis loop
    EVAL_STR(8).line = [TAB, '}'];
else
    
    % make var string
    BF  = ['basis_func->', f_Grad_str, '[basis_i][qp_i]', '.v'];
    BF0 = ['basis_func->', f_Grad_str, '[0][qp_i]', '.v'];
    CF = [f_Grad_str, '[nc_i][qp_i]', '.v'];
    
    % loop thru all components of the map
    EVAL_STR(6).line = []; % init
    EVAL_STR(1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
    EVAL_STR(2).line = [TAB, '{'];
    EVAL_STR(3).line = [TAB, write_eval_string_BF0(CF,BF0,1)];
    IND = 3;
    if (obj.GeoMap.GeoDim > 1)
        IND = IND + 1;
        EVAL_STR(IND).line = [TAB, write_eval_string_BF0(CF,BF0,2)];
    end
    if (obj.GeoMap.GeoDim > 2)
        IND = IND + 1;
        EVAL_STR(IND).line = [TAB, write_eval_string_BF0(CF,BF0,3)];
    end
    EVAL_STR(IND+1).line = [TAB, '// sum over basis functions'];
    EVAL_STR(IND+2).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
    EVAL_STR(IND+3).line = [TAB2, '{'];
    EVAL_STR(IND+4).line = [TAB2, write_eval_string_BF(CF,BF,1)];
    NXT = length(EVAL_STR);
    if (obj.GeoMap.GeoDim > 1)
        NXT = NXT + 1;
        EVAL_STR(NXT).line = [TAB2, write_eval_string_BF(CF,BF,2)];
    end
    if (obj.GeoMap.GeoDim > 2)
        NXT = NXT + 1;
        EVAL_STR(NXT).line = [TAB2, write_eval_string_BF(CF,BF,3)];
    end
    EVAL_STR(NXT+1).line = [TAB2, '}']; % close the basis loop
    EVAL_STR(NXT+2).line = [TAB, '}'];
end

% define the data type
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
Defn_Hdr = '// (intrinsic) gradient of coefficient function';
Loop_Hdr = '// get gradient of coefficient function';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Grad');
CODE = obj.create_coef_func_declaration_and_eval_code(f_Grad_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end

function STR = write_eval_string_BF0(CF,BF0,gd_i)

vec_str = ['[', num2str(gd_i-1), ']'];
STR = [CF, vec_str, ' = ', BF0, vec_str, ' * ', 'Node_Value[nc_i][kc[0]]', '; // first basis function'];

end

function STR = write_eval_string_BF(CF,BF,gd_i)

vec_str = ['[', num2str(gd_i-1), ']'];
STR = [CF, vec_str, ' += ', BF, vec_str, ' * ', 'Node_Value[nc_i][kc[basis_i]]', ';'];

end