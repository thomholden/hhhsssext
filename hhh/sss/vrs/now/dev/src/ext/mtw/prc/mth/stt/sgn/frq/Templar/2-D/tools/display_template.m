%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice Univ.     
% Author: Clay Scott (cscott@rice.edu).  See License.txt

figure

subplot(2,2,1)
displayimagesc(spatial_mean(template));
title('Spatial Mean')

subplot(2,2,2)
Ts=1; synthesize;
displayimagesc(synth_data{1});
title('Synthesized Pattern');

subplot (2,2,3)
displayimagesc(template.states);
title('Significant Coefficients');

subplot(2,2,4)
displayimagesc(spatial_var(template));
title('Spatial Variance');


