function exampleNewton2()

arrl=0.2;
arrw=arrl/5;
arrScal=0.85;

spa=0.075;

fosi=20;
font='Times';

myLW=1.1;

xyticksL=0.05;

axls=[-2 4 -2 2];
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
numfvals=325;

xstart=axls(1);
xend=axls(2);

xvals=linspace(xstart,xend,numfvals);

myFunc=@(x)atan(1.75*atan(x-1))+0.075*(x-1);

plotInAxis(axls,xvals,myFunc(xvals),'k-','LineWidth',myLW);

xFuncText=2.75;
text('Interpreter','latex','String','$y=f(x)$','Position',[xFuncText,myFunc(xFuncText)+0.05],'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',fosi,'FontName',font,'Color','k');


% Do the animation

AniLaTeX=[];
animategraphicsOptions='controls,width=3.5in';
includegraphicsOptions='';
figureDirectory='exNewton2';
figcounter=0;
filename='exNewton2';
frmps=1;

mkdir(figureDirectory);

iters=8;

xtmp=1.7018;

spa2=0.1;

i=-1;
hxt=plot([xtmp,xtmp],[-xyticksL,0],'k-','LineWidth',myLW);
hxtl=text('Interpreter','latex','String',['$x_{',num2str(i+1),'}$'],'Position',[xtmp,-spa-xyticksL-spa2],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

for i=0:iters
    
    ftmp=myFunc(xtmp);
    hpnts=plot(xtmp,ftmp,'ko','MarkerSize',pntsi);
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    delete(hpnts);
    lutn=(myFunc(xtmp+1e-3)-myFunc(xtmp-1e-3))/2e-3;
    xnew=xtmp-ftmp/lutn;
    htangent=plot([xtmp,xnew],[ftmp,0],'b-','LineWidth',myLW);
    hpnts=plot(xtmp,ftmp,'ko','MarkerSize',pntsi);
    
    hxt2=plot([xnew,xnew],[-xyticksL,0],'k-','LineWidth',myLW);
    hxtl2=text('Interpreter','latex','String',['$x_{',num2str(i+1),'}$'],'Position',[xnew,-spa-xyticksL-spa2],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    delete(hxt,hxtl,hxt2,hxtl2,htangent,hpnts);
    
    xtmp=xnew;
    
    hxt=plot([xtmp,xtmp],[-xyticksL,0],'k-','LineWidth',myLW);
    hxtl=text('Interpreter','latex','String',['$x_{',num2str(i+1),'}$'],'Position',[xtmp,-spa-xyticksL-spa2],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    
end

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

animateinlineLaTeX(AniLaTeX,[figureDirectory,'/',filename],animategraphicsOptions);
close;


function h=plotInAxis(axls,xvals,yvals,varargin)

isInside=and(and(xvals>axls(1),xvals<axls(2)),and(yvals>axls(3),yvals<axls(4)));

h=plot(xvals(isInside),yvals(isInside),varargin{:});

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
