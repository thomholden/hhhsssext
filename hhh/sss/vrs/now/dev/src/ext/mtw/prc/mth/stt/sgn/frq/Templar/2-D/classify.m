%
% classify.m - see example_cl.m for usage info
%
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

cmap = zeros(C,T);
nerr=0;

for c=1:C  
  for t=1:T
    x = test_data_list{c}{t};
    m = mostlikely(x,template_list,scope);
    cmap(c,t)=m;
    if m ~=c
      nerr = nerr+1;
    end
  end
end

cmap
misclassification_rate = nerr/(C*T)

