%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt




figure;

  for i= 1:4
	subplot(4,5,i)
	displayimagesc(template_iterances{i});
  end

