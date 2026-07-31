function [grid_setup,reduction,corr_setup,FEM_setup,gridx,gridy,...
    dispx,dispy,scale,small_strain,large_strain,...
    gridx_DU,gridy_DU,grid_setup_reduced,gridx_reduced,gridy_reduced,...
    corr_setup_reduced,dispx_reduced,dispy_reduced,gridx_def,gridy_def,...
    gridx_DU_def,gridy_DU_def] = load_computed_data

%Load the data that was computed with "compute_data" function
%Remove last column that contains only zeros

try
    load('grid_scale_data');    %gridx_scale, gridy_scale
    gridx = gridx_scale;
    gridy = gridy_scale;
    
    load FEM_setup;
    load('disp_smooth_data');   %dispx_smooth, dispy_smooth
    dispx = dispx_smooth;
    dispy = dispy_smooth;
    scale = FEM_setup.scale;
    
    load('DU_data');            %DU_FEM, D2U_FEM, gridx_DU, gridy_DU, large strain, small strain
    
catch
    load('grid_data');          %gridx, gridy
    
    FEM_setup.N_Node_DU = [];
    load('disp_raw_data');      %dispx_raw,dispy_raw
    dispx = dispx_raw;
    dispy = dispy_raw;
    scale = 1;
    
    small_strain = [];
    large_strain = [];
    gridx_DU = [];
    gridy_DU = [];
end




load('grid_reduced_data');  %gridx_reduced, gridy_reduced
load('disp_reduced_data');  %dispx_reduced,dispy_reduced

load grid_setup;
load grid_setup_reduced
try
    reduction = grid_setup_reduced.reduction;
catch
    reduction = [];
end
load corr_setup;
load corr_setup_reduced;


try
    load grid_deformed_data
catch
    gridx_def = [];
    gridy_def = [];
    gridx_DU_def = [];
    gridy_DU_def = [];
end