
z=[-30:0.1:30];
p_cauchy=cauchy(z);
plot(z,p_cauchy,':');
hold on

p_gauss=ugauss(z,0,1);
plot(z,p_gauss);
