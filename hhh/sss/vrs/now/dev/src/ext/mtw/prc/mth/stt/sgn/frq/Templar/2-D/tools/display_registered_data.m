%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

figure

for t=1:T

if t<=20

subplot(4,5,t)
tran=transforms(:,t);
h=tran(1);
v=tran(2);
r=tran(3);
%displayimagesc(inv_transform(training_data{t},h,v,r));
reg_data{t}=inv_transform(training_data{t},h,v,r);
displayimagesc(reg_data{t})

end

end
