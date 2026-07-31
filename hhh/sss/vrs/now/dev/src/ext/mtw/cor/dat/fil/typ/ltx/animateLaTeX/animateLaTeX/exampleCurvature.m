function exampleCurvature()

arrl=0.2;
arrw=arrl/5;
arrScal=0.85;

spa=0.075;

fosi=20;
font='Times';

myLW=1.1;

axls=[-3.25 3.25 -2.25 2.25];
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
numfvals=170;

xstart=-3;
xend=3;

xvals=linspace(xstart,xend,numfvals);

myFunc=@(x)1.1*(sin(pi*x)+sin(sin(pi^2*x/2)));
myDFunc=@(x)1.1*(pi*cos(pi*x) + (pi^2*cos((pi^2*x)/2).*cos(sin((pi^2*x)/2)))/2);
myD2Func=@(x)1.1*(-pi^2*sin(pi*x)-(pi^4*cos((pi^2*x)/2)^2.*sin(sin((pi^2*x)/2)))/4 -(pi^4*sin((pi^2*x)/2).*cos(sin((pi^2*x)/2)))/4);

plot(xvals,myFunc(xvals),'k-','LineWidth',myLW);

% Do the animation

AniLaTeX=[];
animategraphicsOptions='controls,width=3.5in';
includegraphicsOptions='';
figureDirectory='exCurvature';
figcounter=0;
filename='exCurvature';
frmps=7;

mkdir(figureDirectory);

numN=10000;
xvalcN=linspace(xstart+0.05,xend-0.05,numN);
lec=sqrt(1+myDFunc(xvalcN).^2);
lec=cumsum(lec);
lec=lec-lec(1);

iters=90;
anglvec=linspace(0,2*pi,150);

ixvali=1;
xvali=xvalcN(ixvali);
ds=lec(end)/(iters-1);

for i=1:iters
    
    funcVal=myFunc(xvali);
    dfuncVal=myDFunc(xvali);
    d2funcVal=myD2Func(xvali);
    
    if abs(d2funcVal)<1e-4
        hcir=plot([xstart,xend],dfuncVal*[xstart,xend]+funcVal-dfuncVal*xvali,'g-','LineWidth',myLW);
        hpn=plot(xvali,funcVal,'ko','MarkerSize',pntsi);
    else
        rdi=abs((1+dfuncVal^2)^1.5/d2funcVal);
        
        if rdi<100
            nrml=[-dfuncVal;1];
            nrml=nrml/norm(nrml);
            
            tgt=[1;dfuncVal];
            tgt=tgt/norm(tgt);

            cc=(sign(d2funcVal)*rdi)*nrml;
            cc(1)=cc(1)+xvali;
            cc(2)=cc(2)+funcVal;
            
            cricl=tgt*sin(anglvec)-sign(d2funcVal)*nrml*cos(anglvec);
            
            hcir=plot(rdi*cricl(1,:)+cc(1),rdi*cricl(2,:)+cc(2),'g-','LineWidth',myLW);
            hpn=plot(xvali,funcVal,'ko','MarkerSize',pntsi);
        else
            hcir=plot([xstart,xend],dfuncVal*[xstart,xend]+funcVal-dfuncVal*xvali,'g-','LineWidth',myLW);
            hpn=plot(xvali,funcVal,'ko','MarkerSize',pntsi);
        end
        
    end
    
    set(gcf,'PaperPositionMode','auto')

    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

    delete(hcir,hpn);
    
    for j=ixvali:numN
        if (lec(j)-lec(ixvali))>ds
            ixvali=j;
            xvali=xvalcN(ixvali);
            break
        end
    end
    
end

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
