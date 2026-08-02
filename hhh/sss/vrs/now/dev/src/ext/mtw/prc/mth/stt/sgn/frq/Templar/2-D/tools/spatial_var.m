function z=spatial_var(template)

[n1, n2]=size(template.states);

z=zeros(n1,n2);

for i=1:n1
 for j=1:n2
  if template.states(i,j)==1
    b=zeros(n1,n2);
    b(i,j)=1;
    f=abs(atomic_rep(b,1)).^2;
    z=z+(template.high_var(i,j)*f);
  end  
 end
end


