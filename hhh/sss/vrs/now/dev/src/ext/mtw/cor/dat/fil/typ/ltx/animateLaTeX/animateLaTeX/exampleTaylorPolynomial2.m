function exampleTaylorPolynomial2()

arrl=0.45;
arrw=arrl/5;
arrScal=0.85;

spa=0.2;

fosi=25;
font='Times';

myLW=1.1;

axls=[-4 10 -5 5];
axvec=1.01*axls;

sca=50;

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


numfvals=200;

xstart=axls(1)+0.2;
xend=axls(2)-0.2;

xvalsln=linspace(-1+1e-3,xend,numfvals);

xvals=linspace(xstart,xend,numfvals);

myFunc=@(x)log(x+1);

plot([-1 -1],axls(3:4),'k--','LineWidth',myLW);

plot(xvalsln,myFunc(xvalsln),'k-','LineWidth',myLW);

xFuncText=4;
text('Interpreter','latex','String','$y=\ln(1+x)$','Position',[xFuncText,2.5],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');


% Do the animation

AniLaTeX=[];
animategraphicsOptions='controls,width=3.5in';
includegraphicsOptions='';
figureDirectory='exTaylorPoly2';
figcounter=0;
filename='exTaylorPoly2';
frmps=0.5;

mkdir(figureDirectory);

for i=1:10
    
    n=i;
    htaylor=plot(xvals,lnTaylor(xvals,n),'b-','LineWidth',myLW);
    
    if i<4
        hTtext=text('Interpreter','latex','String',['$y=P_{',num2str(n),'}(x)$'],'Position',[0.15,-2.5],'HorizontalAlignment','left','VerticalAlignment','top','FontSize',fosi,'FontName',font,'Color','b');
    elseif i>9
        hTtext=text('Interpreter','latex','String',['$y=P_{',num2str(n),'}(x)$'],'Position',[1.8,-2.5],'HorizontalAlignment','left','VerticalAlignment','top','FontSize',fosi,'FontName',font,'Color','b');
    else
        hTtext=text('Interpreter','latex','String',['$y=P_{',num2str(n),'}(x)$'],'Position',[-1.15,-2.5],'HorizontalAlignment','right','VerticalAlignment','top','FontSize',fosi,'FontName',font,'Color','b');
    end
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    delete(htaylor,hTtext);
    
end

animateinlineLaTeX(AniLaTeX,[figureDirectory,'/',filename],animategraphicsOptions);
close;


function y=lnTaylor(x,n)

y=x;

mySign=1;

for i=2:n
    
    mySign=-mySign;
    
    y=y+(mySign/i)*x.^i;
    
end

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
