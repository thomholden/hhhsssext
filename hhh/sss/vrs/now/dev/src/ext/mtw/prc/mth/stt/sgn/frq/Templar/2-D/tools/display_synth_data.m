%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice Univ.     
% Author: Clay Scott (cscott@rice.edu).  See License.txt

figure, title('Synthesized images');

for t=1:min(T, 20)
    subplot(4, 5, t)
    displayimagesc(synth_data{t});
end 

%orient tall;
