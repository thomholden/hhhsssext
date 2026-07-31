function exampleTangentLine()

arrl=0.2;
arrw=arrl/5;
arrScal=0.85;

spa=0.075;

fosi=20;
font='Times';

myLW=1.1;

xyticksL=0.05;

axls=[-3 3 -0.3 3.5];
axvec=1.01*axls;

sca=100;

figure('Position',[50 50 sca*(axvec(2)-axvec(1)) sca*(axvec(4)-axvec(3))]),hold on;
set(gca,'XTick',[],'YTick',[]);
set(gca,'Position',[0 0 1 1]);
axis(axvec);
axis image
axis off;

plot(axvec(1),axvec(3),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot(axvec(2),axvec(4),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);

% Plot the coordinate axis
plotArrow([axls(1);0],[axls(2);0],arrl,arrw,arrScal,myLW);
plotArrow([0;axls(3)],[0;axls(4)],arrl,arrw,arrScal,myLW);
text('Interpreter','latex','String','$x$','Position',[axls(2)-arrl,arrw+spa],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
text('Interpreter','latex','String','$y$','Position',[arrw+spa,axls(4)-arrl],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');


pntsi=6;
numfvals=125;

xstart=axls(1);
xend=axls(2);

xvals=linspace(xstart,xend,numfvals);

myFunc=@(x)0.15*exp(x)-0.15*x.*(x+7).*exp(-x)./(1+exp(-x))+0.05;

plot(xvals,myFunc(xvals),'k-','LineWidth',myLW);

xFuncText=2.666667;
text('Interpreter','latex','String','$y=f(x)$','Position',[xFuncText,myFunc(xFuncText)],'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',fosi,'FontName',font,'Color','k');


% Do the animation

AniLaTeX=[];
animategraphicsOptions='controls,width=3.5in';
includegraphicsOptions='';
figureDirectory='exTangLine';
figcounter=0;
filename='exTangLine';
frmps=6;

mkdir(figureDirectory);


x0=1;
f0=myFunc(x0);

spa2=0.1;

plot([x0,x0],[-xyticksL,0],'k-','LineWidth',myLW);
text('Interpreter','latex','String','$x_0$','Position',[x0,-spa-xyticksL-spa2],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

iters=50;

myMark={'r-','b-'};

scalfac=0.925;

h0=(1.45/scalfac)*[1,-1];

for j=1:2
    
    h=h0(j);
    
    for i=1:iters
        
        h=scalfac*h;
        x1=x0+h;
        f1=myFunc(x1);
        
        lutn=(f1-f0)/h;
        
        const=f0-lutn*x0;
        
        hxt=plot([x1,x1],[-xyticksL,0],'k-','LineWidth',myLW);
        hxtl=text('Interpreter','latex','String','$x_0+h$','Position',[x1,-spa-xyticksL-spa2],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
        htangent=plot([xstart,xend],lutn*[xstart,xend]+const,myMark{j},'LineWidth',myLW);
        
        hpnts0=plot(x0,f0,'ko','MarkerSize',pntsi);
        hpnts1=plot(x1,f1,'ko','MarkerSize',pntsi);
        
        if j==1
            hhtext=text('Interpreter','latex','String','$h>0$','Position',[x0,axls(4)/3],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','r');
        else
            hhtext=text('Interpreter','latex','String','$h<0$','Position',[-x0,axls(4)/3],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','b');
        end
        
        set(gcf,'PaperPositionMode','auto')
        
        figcounter=figcounter+1;
        print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
        AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
        
        delete(hxt,hxtl,htangent,hpnts0,hpnts1,hhtext);
        
    end
    
end

lutn=(myFunc(x0+1e-3)-myFunc(x0-1e-3))/2e-3;

const=f0-lutn*x0;

htangent=plot([xstart,xend],lutn*[xstart,xend]+const,'m-','LineWidth',myLW);

hpnts0=plot(x0,f0,'ko','MarkerSize',pntsi);

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

delete(htangent,hpnts0);

animateinlineLaTeX(AniLaTeX,[figureDirectory,'/',filename],animategraphicsOptions);
close;


function h=plotArrow(astart,aend,arrl,arrw,sc,lw,clr)

if nargin<7
    clr=[0,0,0];
end

h=[0,0];

dirc=aend-astart;

lgt=norm(dirc);

dirc=dirc/lgt;

xcords=lgt+[-sc*arrl -sc*arrl -arrl 0 -arrl -sc*arrl];
ycords=[0 arrw*1e-3 arrw 0 -arrw -arrw*1e-3];

aline=[astart astart+(lgt-0.5*sc*arrl)*dirc];

h(1)=plot(aline(1,:),aline(2,:),'-','LineWidth',lw,'Color',clr);

xcords2=dirc(1)*xcords-dirc(2)*ycords+astart(1);
ycords2=dirc(2)*xcords+dirc(1)*ycords+astart(2);

h(2)=patch(xcords2,ycords2,'k');

set(h(2),'FaceColor',clr,'EdgeColor',clr);
