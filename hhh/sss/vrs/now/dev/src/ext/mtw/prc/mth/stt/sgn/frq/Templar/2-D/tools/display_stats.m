%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

eval_pll;

if (~exist('opll'))
  opll = -Inf;
end

inc = npll - opll;

status = [iter,round(npll),round(inc),num_high_states,...
        num_changed_transforms, round(template.low_var)];

disp(status)

progress_chart = [progress_chart; status];

opll = npll;

