training_data = cell(T);
obs_noise_var = .1;

w=4;

ring=zeros(N1,N2);

ring(N1/2-w/2+1:N1/2+w/2,N2/2-w/2+1:N2/2+w/2)=ones(w,w);
ring(N1/2-w/4+1:N1/2+w/4,N2/2-w/4+1:N2/2+w/4)=zeros(w/2,w/2);

ring = 1.33*ring; % so that ring has as much mass as square

cross=zeros(N1,N2);

cross(N1/2-w:N1/2+w,N2/2:N2/2)=ones(2*w+1,w/4);
cross(N1/2:N1/2,N2/2-w:N2/2+w)=ones(w/4,2*w+1);

for i=1:T
  x=unidrnd(9) - 5;
  y=unidrnd(9) - 5;
  u=unidrnd(25) - 13;
  v=unidrnd(25) - 13;
  training_data{i}=circshift(ring,x,y)+circshift(cross,u,v)+ ... 
     randn(N1,N2)*sqrt(obs_noise_var);
end
