function obj = Set_Fixed_Subdomains(obj,Mesh,Fixed_Subdomain_Names,ARG)
%Set_Fixed_Subdomains
%
%   This sets several subdomain names (in a cell array) where the DoFs (of
%   obj.DoFmap) are considered *fixed*, i.e. this is where the DoFs are to be
%   set by some Dirichlet condition.
%   Note: this overwrites any previously stored fixed subdomain names.
%
%   obj = obj.Set_Fixed_Subdomains(Mesh,Fixed_Subdomain_Names);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   Fixed_Subdomain_Names = cell array of (strings) names of mesh subdomains.
%
%   Output is an updated object.  If the space is tensor valued (more than one
%   component), then it is assumed that *all* components are fixed on those
%   subdomains.
%
%   obj = obj.Set_Fixed_Subdomains(Mesh,Fixed_Subdomain_Names,Comp);
%
%   Similar to above case, except 'Comp' specifies which component (in the
%   case of a tensor-valued space) to fix.

% Copyright (c) 09-07-2012,  Shawn W. Walker

if (nargin==3)
    ARG = [];
end
if isempty(ARG)
    ARG = 'all'; % default to all components
end

if strcmpi(ARG,'all')
    % set the same subdomain name for all tensor components
    for ci = 1:obj.RefElem.Num_Comp
        obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,ci);
    end
else
    % just set it for one component
    Comp = ARG;
    obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,Comp);
end

end