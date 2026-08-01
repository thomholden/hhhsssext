function obj = Get_Mesh_Info(obj,Mesh,SubName)
%Get_Mesh_Info
%
%   This sets (records) mesh info data so that the Finite Element Space knows
%   what mesh it is attached to.
%
%   obj = obj.Get_Mesh_Info(Mesh,SubName);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   SubName = (string) name of the specific subdomain that obj.DoFmap is
%             defined on. If SubName = [], the obj.DoFmap is defined on the
%             global mesh.

% Copyright (c) 06-30-2012,  Shawn W. Walker

% if the sub-domain is the global mesh
if strcmp(SubName,Mesh.Name)
    SubName = []; % then assume default
end

obj.Mesh_Info.Name     = Mesh.Name;
obj.Mesh_Info.SubName  = SubName;
if ~isempty(SubName)
    obj.Mesh_Info.SubIndex = Mesh.Get_Subdomain_Index(SubName);
    if (obj.Mesh_Info.SubIndex < 1)
        disp(['ERROR: there is a problem with this subdomain: ', SubName]);
        error('ERROR: Subdomain not found!');
    end
else % finite element space is defined on the global mesh
    obj.Mesh_Info.SubIndex = [];
end

status = obj.Verify_Mesh(Mesh);

end