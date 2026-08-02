function [sum] = probks (alam)

% function [sum] = probks (alam)

eps1=0.001;
eps2=0.00000001;

fac=2;
sum=0;
termbf=0;

a2=-2*alam^2;
for j=1:100,
	term=fac*exp(a2*j^2);
	sum=sum+term;	
	if (abs(term)<=eps1*termbf | abs(term)<=eps2*sum)
		return
	end
	fac=-fac;
	termbf=abs(term);
end
sum=1;