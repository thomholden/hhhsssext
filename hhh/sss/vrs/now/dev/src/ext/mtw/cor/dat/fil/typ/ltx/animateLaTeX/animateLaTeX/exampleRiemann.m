function exampleRiemann()

arrl=0.15;
arrw=arrl/5;
arrScal=0.85;

spa=0.063;
spa2=0.1;

fosi=16;
font='Times';

upperyadd=3.5;

myLW=0.8;

xyticksL=0.05;

axls=[-0.25 3.85 -1.5 1.85];
axvec=1.01*axls;
axvec(4)=axvec(4)+upperyadd;

axlsU=axls;
axlsU(3:4)=axlsU(3:4)+upperyadd;

precStr='%4.3f';
ylRieText=-1.35;

sca=130;

figure('Position',[50 50 sca*(axvec(2)-axvec(1)) sca*(axvec(4)-axvec(3))]),hold on;
set(gca,'XTick',[],'YTick',[]);
set(gca,'Position',[0 0 1 1]);
axis(axvec);
axis equal
axis off;

plot(axvec(1),axvec(3),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot(axvec(2),axvec(4),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);

% Plot the coordinate axis

hxaxU=plotArrow([axls(1);upperyadd],[axls(2);upperyadd],arrl,arrw,arrScal,myLW);
hyaxU=plotArrow([0;axls(3)+upperyadd],[0;axls(4)+upperyadd],arrl,arrw,arrScal,myLW);
hxlabU=text('Interpreter','latex','String','$x$','Position',[axls(2)-arrl,arrw+spa+upperyadd],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
hylabU=text('Interpreter','latex','String','$y$','Position',[arrw+spa,axls(4)-arrl+upperyadd],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');


numfvals=280;

xstart=axls(1);
xend=axls(2);

xvals=linspace(xstart,xend,numfvals);

myFunc=@(x)(x-0.45).*(x-1.87).*(x-3.11);
myFuncNeg=@(x)-myFunc(x);

a=0.2;
b=3.45;


xFuncText=fminbnd(myFuncNeg,0.6,1.5);

hfuncU=plotInAxis(axlsU,xvals,myFunc(xvals)+upperyadd,'k-','LineWidth',myLW);

hfuncTextU=text('Interpreter','latex','String','$y=f(x)$','Position',[xFuncText,myFunc(xFuncText)+spa+upperyadd],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

hatU=plot([a,a],[-xyticksL,0]+upperyadd,'k-','LineWidth',myLW);
haU=text('Interpreter','latex','String','$a$','Position',[a,-spa-xyticksL-spa2+upperyadd],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

hbtU=plot([b,b],[-xyticksL,0]+upperyadd,'k-','LineWidth',myLW);
hbU=text('Interpreter','latex','String','$b$','Position',[b,-spa-xyticksL-spa2+upperyadd],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');


xResultText=0.125;

huRieUf=text('Interpreter','latex','String','$U(f,P)=\,$?','Position',[xResultText,1],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
hlRieLf=text('Interpreter','latex','String','$L(f,P)=\,$?','Position',[xResultText,2/3],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');


% Do the animation

AniLaTeX=[];
animategraphicsOptions='controls,width=3.5in';
includegraphicsOptions='';
figureDirectory='exRiemann';
figcounter=0;
filename='exRiemann';
frmps=1;

mkdir(figureDirectory);

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);


delete(hfuncU,hfuncTextU,hxaxU,hatU,haU,hbtU,hbU,huRieUf,hlRieLf);


hyaxL=plotArrow([0;axls(3)],[0;axls(4)],arrl,arrw,arrScal,myLW);
hxlabL=text('Interpreter','latex','String','$x$','Position',[axls(2)-arrl,arrw+spa],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
hylabL=text('Interpreter','latex','String','$y$','Position',[arrw+spa,axls(4)-arrl],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');


numIntv=1;
ivl=b-a;

imax=14;

for i=1:imax
    
    hrectL=zeros(1,numIntv);
    hrectU=zeros(1,numIntv);
    
    lRieVal=0;
    uRieVal=0;
    
    for j=1:numIntv
        
        xvalstmp=linspace(a+(j-1)*ivl,a+j*ivl,numfvals);
        fvalstmp=myFunc(xvalstmp);
        
        valRiemann=min(fvalstmp);
        
        lRieVal=lRieVal+valRiemann*ivl;
        
        if valRiemann<0
            clr=[0.666,0.666,1];
        else
            clr=[1,0.666,0.666];
        end
        
        if i>8
            hrectL(j)=patch([a+(j-0.5)*ivl,a+(j-1)*ivl,a+(j-1)*ivl,a+j*ivl,a+j*ivl,a+(j-0.5)*ivl],[0,0,valRiemann,valRiemann,0,0],'k');
            set(hrectL(j),'FaceColor',clr,'EdgeColor',clr,'LineWidth',0.1);
        else
            hrectL(j)=patch([a+(j-0.5)*ivl,a+(j-1)*ivl,a+(j-1)*ivl,a+j*ivl,a+j*ivl,a+(j-0.5)*ivl],[0,0,valRiemann,valRiemann,0,0],'k');
            set(hrectL(j),'FaceColor',clr,'EdgeColor',0.666666667*clr,'LineWidth',0.1);
        end
        
        valRiemann=max(fvalstmp);
        
        uRieVal=uRieVal+valRiemann*ivl;
        
        if valRiemann<0
            clr=[0.666,0.666,1];
        else
            clr=[1,0.666,0.666];
        end
        
        if i>8
            hrectU(j)=patch([a+(j-0.5)*ivl,a+(j-1)*ivl,a+(j-1)*ivl,a+j*ivl,a+j*ivl,a+(j-0.5)*ivl],[0,0,valRiemann,valRiemann,0,0]+upperyadd,'k');
            set(hrectU(j),'FaceColor',clr,'EdgeColor',clr,'LineWidth',0.1);
        else
            hrectU(j)=patch([a+(j-0.5)*ivl,a+(j-1)*ivl,a+(j-1)*ivl,a+j*ivl,a+j*ivl,a+(j-0.5)*ivl],[0,0,valRiemann,valRiemann,0,0]+upperyadd,'k');
            set(hrectU(j),'FaceColor',clr,'EdgeColor',0.666666667*clr,'LineWidth',0.1);
        end
        
    end
    
    hxaxL=plotArrow([axls(1);0],[axls(2);0],arrl,arrw,arrScal,myLW);
    hxaxU=plotArrow([axls(1);upperyadd],[axls(2);upperyadd],arrl,arrw,arrScal,myLW);
    hfuncL=plotInAxis(axls,xvals,myFunc(xvals),'k-','LineWidth',myLW);
    hfuncU=plotInAxis(axlsU,xvals,myFunc(xvals)+upperyadd,'k-','LineWidth',myLW);
    hfuncTextL=text('Interpreter','latex','String','$y=f(x)$','Position',[xFuncText,myFunc(xFuncText)+spa],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    hfuncTextU=text('Interpreter','latex','String','$y=f(x)$','Position',[xFuncText,myFunc(xFuncText)+spa+upperyadd],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    hlRieLf=text('Interpreter','latex','String','$L(f,$','Position',[xFuncText+0.34,ylRieText],'HorizontalAlignment','right','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    huRieUf=text('Interpreter','latex','String','$U(f,$','Position',[xFuncText+0.34,ylRieText+upperyadd],'HorizontalAlignment','right','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    hlRieP=text('Interpreter','latex','String',['$P_{',num2str(numIntv),'}$'],'Position',[xFuncText+0.5,ylRieText],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    huRieP=text('Interpreter','latex','String',['$P_{',num2str(numIntv),'}$'],'Position',[xFuncText+0.5,ylRieText+upperyadd],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    hlRie=text('Interpreter','latex','String',['$)=',num2str(lRieVal,precStr),'$'],'Position',[xFuncText+0.67,ylRieText],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    huRie=text('Interpreter','latex','String',['$)=',num2str(uRieVal,precStr),'$'],'Position',[xFuncText+0.67,ylRieText+upperyadd],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    if i<imax
        delete(hfuncL,hfuncU,hfuncTextL,hfuncTextU,hxaxL,hxaxU,hlRieLf,huRieUf,hlRieP,huRieP,hlRie,huRie,hrectL,hrectU);
        ivl=0.5*ivl;
        numIntv=2*numIntv;
    else
        delete(hlRieLf,huRieUf,hlRieP,huRieP,hlRie,huRie,hrectL,hrectU);
    end
    
end

delete(hfuncL,hfuncTextL,hxaxL,hyaxL,hxlabL,hylabL);

precStr2='%11.9f';

hatU=plot([a,a],[-xyticksL,0]+upperyadd,'k-','LineWidth',myLW);
haU=text('Interpreter','latex','String','$a$','Position',[a,-spa-xyticksL-spa2+upperyadd],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

hbtU=plot([b,b],[-xyticksL,0]+upperyadd,'k-','LineWidth',myLW);
hbU=text('Interpreter','latex','String','$b$','Position',[b,-spa-xyticksL-spa2+upperyadd],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

huRieUf=text('Interpreter','latex','String',['$U(f,P_{',num2str(numIntv),'})=',num2str(uRieVal,precStr2),'$'],'Position',[xResultText,1],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
hlRieLf=text('Interpreter','latex','String',['$L(f,P_{',num2str(numIntv),'})=',num2str(lRieVal,precStr2),'$'],'Position',[xResultText,2/3],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
hlRieP=text('Interpreter','latex','String',['$\big{(}U(f,P_{',num2str(numIntv),'})+L(f,P_{',num2str(numIntv),'})\big{)}/2=',num2str((uRieVal+lRieVal)/2,precStr2),'$'],'Position',[xResultText,1/3],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

hResult=text('Interpreter','latex','String',['$\int_{a}^{b}f(x)dx=',num2str(quad(myFunc,a,b,1e-14),precStr2),'$'],'Position',[xResultText,0],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

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
