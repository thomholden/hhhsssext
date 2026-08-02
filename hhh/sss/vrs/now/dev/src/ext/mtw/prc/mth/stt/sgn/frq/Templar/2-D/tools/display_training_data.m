%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice Univ.     
% Author: Clay Scott (cscott@rice.edu).  See License.txt

num_rows=5; num_cols=6;
num_pics=num_rows*num_cols;

figure, title('training images');

for t=1:min(num_pics,length(training_data))
    subplot(num_rows, num_cols, t)
    displayimagesc(training_data{t});
end 

%orient tall;
