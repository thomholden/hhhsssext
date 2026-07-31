close all

n = 9;
a = 0;
b = 1;

% Construct refined unidorm plotting grid
x = nodeunif(1001,a,b);


S     = fundefn('spli',n,a,b,1);
xnode = funnode(S);
phi   = funbas(S,x);

figure(1);
for j=1:n
   subplot(3,3,j); plot(x,phi(:,j),'k','LineWidth',2);
   axis([ 0 1 -0.05 1.05]); set(gca,'Ytick',[0 1])
   set(gca,'Xtick',[0 1]);
   if j>=7 
     set(gca,'XtickLabel',{'0' '1'});
   else
     set(gca,'XtickLabel',[]); 
   end
end
subplot(3,3,2); title('Linear Spline Basis Functions','FontSize',14);
