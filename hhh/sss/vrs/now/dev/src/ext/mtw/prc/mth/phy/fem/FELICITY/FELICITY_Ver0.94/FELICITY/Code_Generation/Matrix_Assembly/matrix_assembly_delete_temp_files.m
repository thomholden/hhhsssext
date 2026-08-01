function status = matrix_assembly_delete_temp_files()
%matrix_assembly_delete_temp_files
%
%   Delete files.

% Copyright (c) 01-01-2011,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get the main directory that this class is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% list dirs to delete
Dirs_to_Delete( 1).str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_1', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 1).str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_1', 'Scratch_Dir');
Dirs_to_Delete( 2).str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 2).str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Scratch_Dir');
Dirs_to_Delete( 3).str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_3', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 3).str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_3', 'Scratch_Dir');
Dirs_to_Delete( 4).str1 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Coarse_Square', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 4).str2 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Coarse_Square', 'Scratch_Dir');
Dirs_to_Delete( 5).str1 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Refined_Square', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 5).str2 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Refined_Square', 'Scratch_Dir');
Dirs_to_Delete( 6).str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 6).str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0', 'Scratch_Dir');
Dirs_to_Delete( 7).str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0_Codim_1', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 7).str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0_Codim_1', 'Scratch_Dir');
Dirs_to_Delete( 8).str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 8).str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1', 'Scratch_Dir');
Dirs_to_Delete( 8).str3 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1', 'AutoGen_DoFNumbering');
Dirs_to_Delete( 9).str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1_Codim_1', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 9).str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1_Codim_1', 'Scratch_Dir');
Dirs_to_Delete( 9).str3 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1_Codim_1', 'AutoGen_DoFNumbering');
Dirs_to_Delete(10).str1 = fullfile(Main_Dir, 'Unit_Test', 'Mesh_Size', 'Dim_1', 'Assembly_Code_AutoGen');
Dirs_to_Delete(10).str2 = fullfile(Main_Dir, 'Unit_Test', 'Mesh_Size', 'Dim_1', 'Scratch_Dir');
Dirs_to_Delete(11).str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_1', 'Assembly_Code_AutoGen');
Dirs_to_Delete(11).str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_1', 'Scratch_Dir');
Dirs_to_Delete(12).str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_2', 'Assembly_Code_AutoGen');
Dirs_to_Delete(12).str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_2', 'Scratch_Dir');
Dirs_to_Delete(13).str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_3', 'Assembly_Code_AutoGen');
Dirs_to_Delete(13).str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_3', 'Scratch_Dir');
Dirs_to_Delete(14).str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Mixed_Geometry_1', 'Assembly_Code_AutoGen');
Dirs_to_Delete(14).str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Mixed_Geometry_1', 'Scratch_Dir');

% delete them!
for ind = 1:length(Dirs_to_Delete)
    stat1 = DDir.Remove_Dir(Dirs_to_Delete(ind).str1);
    stat2 = DDir.Remove_Dir(Dirs_to_Delete(ind).str2);
    stat3 = DDir.Remove_Dir(Dirs_to_Delete(ind).str3);
    if or(or(stat1~=0,stat2~=0),stat3~=0)
        disp('Delete directory failed!');
        status = -1;
        return;
    end
end

% % delete some remaining files
% Files_to_Delete(1).str = fullfile(Main_Dir, 'Samples', 'mex_Assemble_Example_1D');
% 
% % delete them!
% for ind = 1:length(Files_to_Delete)
%     stat1 = DDir.Delete_File_All_Ext(Files_to_Delete(ind).str);
%     if (stat1~=0)
%         disp('Delete File failed!');
%         status = -1;
%         return;
%     end
% end

end