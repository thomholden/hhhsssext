%
% Determine which model most accurately represents the given image
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt
function m = mostlikely(x,template_list,scope)

C = size(template_list, 2);
hoods=zeros(1,C);

for c=1:C
  hoods(c)=likelihood(x,template_list{c},[0 0 0]',scope,scope);
end
 
[nuttin, m]=max(hoods);
