training_data = cell(T);

w=4;

back=zeros(N1,N2);

back(N1/2-w/2+1:N1/2+w/2,N2/2-w/2+1:N2/2+w/2)=ones(w,w);

for i=1:T
  x=N1/2 + unidrnd(9) - 5;
  y=N2/2 + unidrnd(9) - 5;
  u=N1/2 + unidrnd(25) - 13;
  v=N2/2 + unidrnd(25) - 13;
end
