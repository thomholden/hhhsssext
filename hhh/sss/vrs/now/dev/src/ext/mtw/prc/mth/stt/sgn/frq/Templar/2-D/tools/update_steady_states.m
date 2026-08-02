%
% Let the states and noise var converge to a fixed point
% 
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice Univ.     
% Author: Clay Scott (cscott@rice.edu).  See License.txt


          update_marginals;             if iter > 1, display_stats; end,
          update_low_var;               display_stats;
          while 1
             mold_states=template.states;
             update_states;
             if mold_states == template.states
                break;
             end
             display_stats;      
	     update_low_var;	display_stats;
          end
 
