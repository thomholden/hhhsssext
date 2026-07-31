% This code is written for using Smith chart for the measurements of the
% transmision line. VSWR, Gama_load, Gama_in Z_in, Z_out 

clear
clc
disp('lossless line : 1');
disp('lossy line    : 2');
v=input('lossless? lossy?');
switch v
    case 1
% lossless line

l=input('enter the (length of the line)/(wave length) ');
y=1./[-1000 -25 -10 -6 -4 -3 -2.5 -2 -1.55 -1.2 -1 -.85  -.75 -.62 -.52 -.45 -.37 -.3 -.21  -.15 -.1 -.05];
x=y;
r=[1./linspace(.001,1,10)-1 -1./linspace(.001,1,5)+1];
set(gcf,'Color',[1,1,1])
axis off

 for j=1:length(r)
    circlee(r(j)/(r(j)+1),0,1/(1+r(j))) ;
    clc
    set(gcf,'Color',[1,1,1])
    axis off

 end
 hold on
 for i=1:length(x)
    circlee(1,1/x(i),1/x(i)) ;
    clc
    set(gcf,'Color',[1,1,1])
    axis off

 end
circleB(.5,0,.5) 
title('SMITH CHART','fontname','times','fontsize',15,'fontweight','bold')
text(-.4,1.2,'zoom for better precision','fontname','times','fontsize',10)
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
plot([0 0],[-1 1],'--','linewidth',2)
ylabel('\Gamma_i','fontname','times','fontsize',15,'fontweight','bold')
xlabel('\Gamma_r','fontname','times','fontsize',15,'fontweight','bold')
plot([-1 1],[0 0],'--','linewidth',2)
text(1,0,'OC');
text(-1.08,0,'SC');
text(0.5,0.55,'r=1');
text(0.6,1,'Inductive');
text(0.6,-1,'Capacetive');
circleBB(0,0,1)
text(1/sqrt(2),-1/sqrt(2),'\rho=1');
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
set(gcf,'Color',[1,1,1])
axis off

text(1.0078,.41,'j5');
text(.66,.87,'j2')
text(0,1.08,'j1')
text(-.74,.87,'j0.5')
text(-1,.49,'j0.2')
text(-1.3,0,'j0')
%%%
text(1.0078,-.41,'-j5');
text(.66,-.87,'-j2')
text(0,-1.08,'-j1')

text(-.74,-.87,'-j0.5')
text(-1,-.49,'-j0.2')
%%%
text(.62,.04,'5')
text(.3,.04,'2')
text(-0.02,.04,'1')
text(-0.3,.04,'0.5')
text(-0.7,0.04,'0.2')

% ZOOMING
for oo=1:2
[gx(oo) gy(oo)]=ginput(1);% just left click
set(gcf,'Color',[1,1,1])
axis off
end
gMx=abs(gx(1)-gx(2)); % maximum distance on x
gMy=abs(gy(1)-gy(2)); % maximum distance on y
gm=[(gx(1)+gx(2))/2 (gy(1)+gy(2))/2]; % center of the zoomed frame
close
circleB(.5,0,.5) 
text(-.4,1.2,'zoom for better precision')
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
plot([0 0],[-1 1],'--','linewidth',2)
ylabel('\Gamma_i','fontname','times','fontsize',15,'fontweight','bold')
xlabel('\Gamma_r','fontname','times','fontsize',15,'fontweight','bold')
plot([-1 1],[0 0],'--','linewidth',2)
circleBB(0,0,1)
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
set(gcf,'Color',[1,1,1])
axis off
gamar=[gm(1)-gMx/2 gm(1)+gMx/2];
gamai=[gm(2)-gMy/2 gm(2)+gMy/2];
xlim(gamar)
ylim(gamai)
rr(1)=real((1+gamar(1)+sqrt(-1)*gamai(1))./(1-(gamar(1)+sqrt(-1)*gamai(1))));
rr(2)=real((1+gamar(1)+sqrt(-1)*gamai(2))./(1-(gamar(1)+sqrt(-1)*gamai(2))));
rr(3)=real((1+gamar(2)+sqrt(-1)*gamai(1))./(1-(gamar(2)+sqrt(-1)*gamai(1))));
rr(4)=real((1+gamar(2)+sqrt(-1)*gamai(2))./(1-(gamar(2)+sqrt(-1)*gamai(2))));
rm=min(min(rr(1),rr(2)),min(rr(3),rr(4)));
rM=max(max(rr(1),rr(2)),max(rr(3),rr(4)));
figure(1)
r=linspace(rm,rM,15);
d1=max(gamar); 
d2=max(gamai); 
d3=min(gamar); 
d4=min(gamai); 
gi=zeros(1,length(r));
GRp=zeros(1,length(r));
GRn=zeros(1,length(r));
GRp(1)=r(1)/(r(1)+1)+sqrt(1/(r(1)+1)^2-d2^2);
GRn(1)=r(1)/(r(1)+1)-sqrt(1/(r(1)+1)^2-d2^2);

 for j=2:length(r)
    circleeth(r(j)/(r(j)+1),0,1/(1+r(j))) ;
    
    gi(j)=sqrt(1./((r(j)+1).^2)-(d1-r(j)./(r(j)+1)).^2);
    hold on
    text(d1+.05,.5*(d2-d4)+d4,'resistance','fontsize',10,'Fontname','times','fontweight','bold');
    title('resistance','fontsize',10,'Fontname','times','fontweight','bold');
    str=num2str(r(j));
    if (d4>0)&&(gi(j)>d4)&&(gi(j)<d2)
        hold on            
        text(d1,gi(j),str,'FontSize',9,'Fontname','times','fontweight','bold');
    elseif (d2<0)&&((-gi(j))>d4)&&((-gi(j))<d2)
        hold on            
        text(d1,-gi(j),str,'FontSize',9,'Fontname','times','fontweight','bold');
    elseif (d4<0)&&(d2>0)&&((-gi(j))>d4)&&((-gi(j))<d2)
        text(d1,-gi(j),str,'FontSize',9,'Fontname','times','fontweight','bold');
    elseif (d4<0)&&(d2>0)&&((gi(j))>d4)&&((gi(j))<d2)
        text(d1,gi(j),str,'FontSize',9,'Fontname','times','fontweight','bold');
    end
    
    GRp(j)=r(j)/(r(j)+1)+sqrt(1/(r(j)+1)^2-d2^2);
    GRn(j)=r(j)/(r(j)+1)-sqrt(1/(r(j)+1)^2-d2^2);
    if (GRp(j)>d3)&&(GRp(j)<d1)
        text(GRp(j),d2,str(1:4),'FontSize',9,'Fontname','times','fontweight','bold');
    end
    %---
    if (GRn(j)>d3)&&(GRn(j)<d1)
        text(GRn(j),d2,str(1:4),'FontSize',9,'Fontname','times','fontweight','bold');
    end
    
    clc
    set(gcf,'Color',[1,1,1])
    axis off
 end
hold on
xlim(gamar)
ylim(gamai)

xx(1)=imag((1+gamar(1)+sqrt(-1)*gamai(1))./(1-(gamar(1)+sqrt(-1)*gamai(1))));
xx(2)=imag((1+gamar(1)+sqrt(-1)*gamai(2))./(1-(gamar(1)+sqrt(-1)*gamai(2))));
xx(3)=imag((1+gamar(2)+sqrt(-1)*gamai(1))./(1-(gamar(2)+sqrt(-1)*gamai(1))));
xx(4)=imag((1+gamar(2)+sqrt(-1)*gamai(2))./(1-(gamar(2)+sqrt(-1)*gamai(2))));
xm=min(min(xx(1),xx(2)),min(xx(3),xx(4)));
xM=max(max(xx(1),xx(2)),max(xx(3),xx(4)));
figure(1)
x=linspace(xm,xM,15);
giii=zeros(1,length(x));
giiii=zeros(1,length(x));
GRRp=zeros(1,length(x));
GRRn=zeros(1,length(x));
GRRp(1)=1+sqrt(1/(x(1)^2)-(d4-1/x(1))^2);
GRRn(1)=1-sqrt(1/(x(1)^2)-(d4-1/x(1))^2);

 for i=2:length(x)
    circlee(1,1/x(i),1/x(i)) ;
    giii(i)=sqrt((1/x(i))^2-(d3-1)^2)+1/x(i);    
    giiii(i)=-sqrt((1/x(i)).^2-(d3-1).^2)+1./x(i);    
        strr=num2str(x(i));
        text(d3-.1,.5*(d2-d4)+d4,'inductance','fontsize',10)
        text(.5*(d1-d3)+d3,d4-.01,'inductance','fontsize',10)
     if (giii(i)>d4)&&(giii(i)<d2)
        hold on            
        text(d3,giii(i),num2str(x(i)),'FontSize',8);
     end
     
     if (giiii(i)>d4)&&(giiii(i)<d2)
        hold on
        text(d3,giiii(i),num2str(x(i)),'FontSize',8);         
     end

    GRRp(i)=1+sqrt(1/(x(i)^2)-(d4-1/x(i))^2);
    GRRn(i)=1-sqrt(1/(x(i)^2)-(d4-1/x(i))^2);
    if (GRRp(i)>d3)&&(GRRp(i)<d1)
        text(GRRp(i),d4,strr(1:5),'FontSize',8);
    end
    %---
    if (GRRn(i)>d3)&&(GRRn(i)<d1)
        text(GRRn(i),d4,strr(1:5),'FontSize',8);
    end

    clc
    set(gcf,'Color',[1,1,1])
    axis off
 end
xlim(gamar)
ylim(gamai)
[g(1),g(2)]=ginput(1);

close
y=1./[-1000 -25 -10 -6 -4 -3 -2.5 -2 -1.55 -1.2 -1 -.85  -.75 -.62 -.52 -.45 -.37 -.3 -.21  -.15 -.1 -.05];
x=y;
r=[1./linspace(.001,1,10)-1 -1./linspace(.001,1,5)+1];
set(gcf,'Color',[1,1,1])
axis off
 for j=1:length(r)
    circlee(r(j)/(r(j)+1),0,1/(1+r(j))) ;
    clc
    set(gcf,'Color',[1,1,1])
    axis off

 end
 hold on
 for i=1:length(x)
    circlee(1,1/x(i),1/x(i)) ;
    clc
    set(gcf,'Color',[1,1,1])
    axis off

 end
circleB(.5,0,.5) 
title('SMITH CHART','fontname','times','fontsize',15,'fontweight','bold')
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
plot([0 0],[-1 1],'--','linewidth',2)
ylabel('\Gamma_i','fontname','times','fontsize',15,'fontweight','bold')
xlabel('\Gamma_r','fontname','times','fontsize',15,'fontweight','bold')
plot([-1 1],[0 0],'--','linewidth',2)
text(1,0,'OC');
text(-1.08,0,'SC');
text(0.5,0.55,'r=1');

text(0.6,1,'Inductive');
text(0.6,-1,'Capacetive');
circleBB(0,0,1)
text(1/sqrt(2),-1/sqrt(2),'\rho=1');
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
but=1;
set(gcf,'Color',[1,1,1])
axis off

text(1.0078,.41,'j5');
text(.66,.87,'j2')
text(0,1.08,'j1')
text(-.74,.87,'j0.5')
text(-1,.49,'j0.2')
text(-1.3,0,'j0')
%%%
text(1.0078,-.41,'-j5');
text(.66,-.87,'-j2')
text(0,-1.08,'-j1')
text(-.74,-.87,'-j0.5')
text(-1,-.49,'-j0.2')
%%%
text(.62,.04,'5')
text(.3,.04,'2')
text(-0.02,.04,'1')
text(-0.3,.04,'0.5')
text(-0.7,0.04,'0.2')


plot(g(1),g(2),'bo', 'linewidth',2);
disp('zLoad__________________________');
gL=g(1)+sqrt(-1)*g(2);% gama load
rho=abs(gL);
zLoad=(1+gL)./(1-gL) %load impedance
disp('VSWR____________________________')
VSWR=(1+rho)/(1-rho)
text(g(1),g(2)+.06,'z load');
text(g(1)+.02,g(2),rho/sqrt(2),num2str(zLoad),'fontsize',9);
  xlim ([-1.1 1.1])
  ylim ([-1.1 1.3])
  set(gcf,'Color',[1,1,1])
    axis off
% input ampedance 
disp('input impedance__________________________')
zin=(1+(g(1)+sqrt(-1)*g(2))*(exp(-4*pi*sqrt(-1)*l)))/(1-(g(1)+sqrt(-1)*g(2))*(exp(-4*pi*sqrt(-1)*l)))
gamain=(g(1)+sqrt(-1)*g(2))*(exp(-4*pi*sqrt(-1)*l));
gg=[real(gamain) imag(gamain)];
plot(gg(1),gg(2),'bo')
text(gg(1),gg(2)-.02,'z in')
text(gg(1)+.02,gg(2),rho/sqrt(2),num2str(zin),'fontsize',9);
phase=angle(gamain);
set(gcf,'Color',[1,1,1])
axis off
if phase<angle(complex(g(1),g(2)))
 t1 = phase:.01:angle(complex(g(1),g(2)));
 tt=rho.*ones(1,length(t1));
 polar(t1,tt,'r')
 set(gcf,'Color',[1,1,1])
axis off
else 
 t1 = phase:.01:angle(complex(g(1),g(2)))+2*pi;
 tt=rho.*ones(1,length(t1));
 polar(t1,tt,'r')
 set(gcf,'Color',[1,1,1])
axis off
end
% lossy line

    case 2
a=input('enter the attenuation cefficient: '  );
l=input('enter the line length: ');
lam=input('enter the wavelength: ');
y=1./[-1000 -25 -10 -6 -4 -3 -2.5 -2 -1.55 -1.2 -1 -.85  -.75 -.62 -.52 -.45 -.37 -.3 -.21  -.15 -.1 -.05];
x=y;
r=[1./linspace(.001,1,10)-1 -1./linspace(.001,1,5)+1];
set(gcf,'Color',[1,1,1])
axis off
 for j=1:length(r)
    circlee(r(j)/(r(j)+1),0,1/(1+r(j))) ;
    set(gcf,'Color',[1,1,1])
axis off

    clc
 end
 hold on
 for i=1:length(x)
    circlee(1,1/x(i),1/x(i)) ;
    clc
    set(gcf,'Color',[1,1,1])
axis off
 end
circleB(.5,0,.5) 
title('SMITH CHART','fontname','times','fontsize',15,'fontweight','bold')
text(-.4,1.2,'zoom for better precision','fontname','times','fontsize',10)
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
plot([0 0],[-1 1],'--','linewidth',2)
ylabel('\Gamma_i','fontname','times','fontsize',15,'fontweight','bold')
xlabel('\Gamma_r','fontname','times','fontsize',15,'fontweight','bold')
plot([-1 1],[0 0],'--','linewidth',2)
text(1,0,'OC');
text(-1.08,0,'SC');
text(0.5,0.55,'r=1');
text(0.6,1,'Inductive');
text(0.6,-1,'Capacetive');
circleBB(0,0,1)

text(1/sqrt(2),-1/sqrt(2),'\rho=1');
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
set(gcf,'Color',[1,1,1])
axis off
text(1.0078,.41,'j5');
text(.66,.87,'j2')
text(0,1.08,'j1')
text(-.74,.87,'j0.5')
text(-1,.49,'j0.2')
text(-1.3,0,'j0')
%%%
text(1.0078,-.41,'-j5');
text(.66,-.87,'-j2')
text(0,-1.08,'-j1')
text(-.74,-.87,'-j0.5')
text(-1,-.49,'-j0.2')
%%%
text(.62,.04,'5')
text(.3,.04,'2')
text(-0.02,.04,'1')
text(-0.3,.04,'0.5')
text(-0.7,0.04,'0.2')
% ZOOMING
for oo=1:2
[gx(oo) gy(oo)]=ginput(1);% just left click
set(gcf,'Color',[1,1,1])
axis off

end
gMx=abs(gx(1)-gx(2)); % maximum distance on x
gMy=abs(gy(1)-gy(2)); % maximum distance on y
gm=[(gx(1)+gx(2))/2 (gy(1)+gy(2))/2]; % center of the zoomed frame
close
circleB(.5,0,.5) 
text(-.4,1.2,'zoom for better precision')
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
plot([0 0],[-1 1],'--','linewidth',2)
ylabel('\Gamma_i','fontname','times','fontsize',15,'fontweight','bold')
xlabel('\Gamma_r','fontname','times','fontsize',15,'fontweight','bold')
plot([-1 1],[0 0],'--','linewidth',2)
circleBB(0,0,1)
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
set(gcf,'Color',[1,1,1])
axis off
gamar=[gm(1)-gMx/2 gm(1)+gMx/2];
gamai=[gm(2)-gMy/2 gm(2)+gMy/2];
xlim(gamar)
ylim(gamai)
rr(1)=real((1+gamar(1)+sqrt(-1)*gamai(1))./(1-(gamar(1)+sqrt(-1)*gamai(1))));
rr(2)=real((1+gamar(1)+sqrt(-1)*gamai(2))./(1-(gamar(1)+sqrt(-1)*gamai(2))));
rr(3)=real((1+gamar(2)+sqrt(-1)*gamai(1))./(1-(gamar(2)+sqrt(-1)*gamai(1))));
rr(4)=real((1+gamar(2)+sqrt(-1)*gamai(2))./(1-(gamar(2)+sqrt(-1)*gamai(2))));
rm=min(min(rr(1),rr(2)),min(rr(3),rr(4)));
rM=max(max(rr(1),rr(2)),max(rr(3),rr(4)));
r=linspace(rm,rM,15);
figure(1)

d1=max(gamar); 
d2=max(gamai); 
d3=min(gamar); 
d4=min(gamai); 

gi=zeros(1,length(r));
GRp=zeros(1,length(r));
GRn=zeros(1,length(r));
GRp(1)=r(1)/(r(1)+1)+sqrt(1/(r(1)+1)^2-d2^2);
GRn(1)=r(1)/(r(1)+1)-sqrt(1/(r(1)+1)^2-d2^2);

 for j=1:length(r)
    circleeth(r(j)/(r(j)+1),0,1/(1+r(j))) ;
    text(d1+.05,.5*(d2-d4)+d4,'resistance','fontsize',10,'Fontname','times','fontweight','bold');
    title('resistance','fontsize',10,'Fontname','times','fontweight','bold');

    str=num2str(r(j));
    gi(j)=sqrt(1./((r(j)+1).^2)-(d1-r(j)./(r(j)+1)).^2);
    hold on
    if (d4>0)&&(gi(j)>d4)&&(gi(j)<d2)
        hold on            
        text(d1,gi(j),num2str(r(j)),'FontSize',9,'Fontname','times','fontweight','bold');
    elseif (d2<0)&&((-gi(j))>d4)&&((-gi(j))<d2)
        hold on            
        text(d1,-gi(j),num2str(r(j)),'FontSize',9,'Fontname','times','fontweight','bold');
    elseif (d4<0)&&(d2>0)&&((-gi(j))>d4)&&((-gi(j))<d2)
        text(d1,-gi(j),num2str(r(j)),'FontSize',9,'Fontname','times','fontweight','bold');
    elseif (d4<0)&&(d2>0)&&((gi(j))>d4)&&((gi(j))<d2)
        text(d1,gi(j),num2str(r(j)),'FontSize',9,'Fontname','times','fontweight','bold');
    end

    GRp(j)=r(j)/(r(j)+1)+sqrt(1/(r(j)+1)^2-d2^2);
    GRn(j)=r(j)/(r(j)+1)-sqrt(1/(r(j)+1)^2-d2^2);
    if (GRp(j)>d3)&&(GRp(j)<d1)
        text(GRp(j),d2,str(1:4),'FontSize',9,'Fontname','times','fontweight','bold');
    end
    %---
    if (GRn(j)>d3)&&(GRn(j)<d1)
        text(GRn(j),d2,str(1:4),'FontSize',9,'Fontname','times','fontweight','bold');
    end


    clc
    set(gcf,'Color',[1,1,1])
    axis off
 end
 hold on
xlim(gamar)
ylim(gamai)
xx(1)=imag((1+gamar(1)+sqrt(-1)*gamai(1))./(1-(gamar(1)+sqrt(-1)*gamai(1))));
xx(2)=imag((1+gamar(1)+sqrt(-1)*gamai(2))./(1-(gamar(1)+sqrt(-1)*gamai(2))));
xx(3)=imag((1+gamar(2)+sqrt(-1)*gamai(1))./(1-(gamar(2)+sqrt(-1)*gamai(1))));
xx(4)=imag((1+gamar(2)+sqrt(-1)*gamai(2))./(1-(gamar(2)+sqrt(-1)*gamai(2))));
xm=min(min(xx(1),xx(2)),min(xx(3),xx(4)));
xM=max(max(xx(1),xx(2)),max(xx(3),xx(4)));
figure(1)
x=linspace(xm,xM,15);
giii=zeros(1,length(x));
giiii=zeros(1,length(x));
GRRp=zeros(1,length(x));
GRRn=zeros(1,length(x));
GRRp(1)=1+sqrt(1/(x(1)^2)-(d4-1/x(1))^2);
GRRn(1)=1-sqrt(1/(x(1)^2)-(d4-1/x(1))^2);

 for i=1:length(x)
    circlee(1,1/x(i),1/x(i)) ;
    text(d3-.1,.5*(d2-d4)+d4,'inductance','fontsize',10)
    text(.5*(d1-d3)+d3,d4-.01,'inductance','fontsize',10)
    giii(i)=sqrt((1/x(i))^2-(d3-1)^2)+1/x(i);    
    giiii(i)=-sqrt((1/x(i)).^2-(d3-1).^2)+1./x(i);    
    strr=num2str(x(i));
     if (giii(i)>d4)&&(giii(i)<d2)
        hold on            
        text(d3,giii(i),num2str(x(i)),'FontSize',8);
     end
     
     if (giiii(i)>d4)&&(giiii(i)<d2)
        hold on
        text(d3,giiii(i),num2str(x(i)),'FontSize',8);         
     end

    GRRp(i)=1+sqrt(1/(x(i)^2)-(d4-1/x(i))^2);
    GRRn(i)=1-sqrt(1/(x(i)^2)-(d4-1/x(i))^2);
    if (GRRp(i)>d3)&&(GRRp(i)<d1)
        text(GRRp(i),d4,strr(1:5),'FontSize',8);
    end
    %---
    if (GRRn(i)>d3)&&(GRRn(i)<d1)
        text(GRRn(i),d4,strr(1:5),'FontSize',8);
    end

    clc
    set(gcf,'Color',[1,1,1])
    axis off
 end
xlim(gamar)
ylim(gamai)
[g(1),g(2)]=ginput(1);

close
y=1./[-1000 -25 -10 -6 -4 -3 -2.5 -2 -1.55 -1.2 -1 -.85  -.75 -.62 -.52 -.45 -.37 -.3 -.21  -.15 -.1 -.05];
x=y;
r=[1./linspace(.001,1,10)-1 -1./linspace(.001,1,5)+1];
set(gcf,'Color',[1,1,1])
axis off
 for j=1:length(r)
    circlee(r(j)/(r(j)+1),0,1/(1+r(j))) ;
    clc
    set(gcf,'Color',[1,1,1])
    axis off

 end
 hold on
 for i=1:length(x)
    circlee(1,1/x(i),1/x(i)) ;
    clc
    set(gcf,'Color',[1,1,1])
    axis off

 end
circleB(.5,0,.5) 
title('SMITH CHART','fontname','times','fontsize',15,'fontweight','bold')
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
plot([0 0],[-1 1],'--','linewidth',2)
ylabel('\Gamma_i','fontname','times','fontsize',15,'fontweight','bold')
xlabel('\Gamma_r','fontname','times','fontsize',15,'fontweight','bold')
plot([-1 1],[0 0],'--','linewidth',2)
text(1,0,'OC');
text(-1.08,0,'SC');
text(0.5,0.55,'r=1');
text(0.6,1,'Inductive');
text(0.6,-1,'Capacetive');
circleBB(0,0,1)
text(1/sqrt(2),-1/sqrt(2),'\rho=1');
xlim ([-1.1 1.1])
ylim ([-1.1 1.3])
but=1;
set(gcf,'Color',[1,1,1])
axis off

text(1.0078,.41,'j5');
text(.66,.87,'j2')
text(0,1.08,'j1')
text(-.74,.87,'j0.5')
text(-1,.49,'j0.2')
text(-1.3,0,'j0')
%%%
text(1.0078,-.41,'-j5');
text(.66,-.87,'-j2')
text(0,-1.08,'-j1')
text(-.74,-.87,'-j0.5')
text(-1,-.49,'-j0.2')
%%%
text(.62,.04,'5')
text(.3,.04,'2')
text(-0.02,.04,'1')
text(-0.3,.04,'0.5')
text(-0.7,0.04,'0.2')


plot(g(1),g(2),'bo', 'linewidth',2)
disp('zLoad__________________________')
gL=g(1)+sqrt(-1)*g(2)% gama load
rho=abs(gL)
zLoad=(1+gL)./(1-gL) %load impedance
disp('VSWR____________________________')
VSWR=(1+rho)/(1-rho)
text(g(1),g(2)+.06,'z load');
text(g(1)+.02,g(2),rho/sqrt(2),num2str(zLoad),'fontsize',9);
  xlim ([-1.1 1.1])
  ylim ([-1.1 1.3])
  set(gcf,'Color',[1,1,1])
  axis off
% input ampedance
disp('input impedance__________________________')
zin=(1+(g(1)+sqrt(-1)*g(2))*(exp(-2*a*l-4*pi*sqrt(-1)*l/lam)))/(1-(g(1)+sqrt(-1)*g(2))*(exp(-2*a*l-4*pi*sqrt(-1)*l/lam)))
gamain=(g(1)+sqrt(-1)*g(2))*(exp(-2*a*l-4*pi*sqrt(-1)*l/lam))
gg=[real(gamain) imag(gamain)];
plot(gg(1),gg(2),'bo')
text(gg(1),gg(2)-.09,'z in')
text(gg(1)+.02,gg(2)+.03,num2str(zin))
set(gcf,'Color',[1,1,1])
axis off
phase=angle(gamain);
%FINDING THE LOAD PHASE
 if (g(1)>0)&&(g(2)>0)
     fil=atan(g(2)/g(1));
 elseif (g(1)<0)&&(g(2)>0)
     fil=pi+atan(g(2)/g(1));
 elseif (g(1)<0)&&(g(2)<0)
     fil=pi+atan(g(2)/g(1));
 else
     fil=2*pi+atan(g(2)/g(1)); 
end

len=0:l/10000:l;
re=zeros(1,length(len));
im=zeros(1,length(len));
for i=1:length(len)
re(i)=rho*exp(-2*a*len(i))*cos(fil-4*pi*len(i)/lam);
im(i)=rho*exp(-2*a*len(i))*sin(fil-4*pi*len(i)/lam);
end
plot(re,im,'r','linewidth',3)
set(gcf,'Color',[1,1,1])
axis off
end