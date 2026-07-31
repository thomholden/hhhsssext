function exampleLS()

liwi=1;
fosi=20;

viewVec=[0.55 -1 0.55];
viewVec=viewVec/norm(viewVec);

xpatch=0.71*[-1,-1,1,1,-1,-1];
ypatch=0.71*[0,-1,-1,1,1,0];
zpatch=[0,0,0,0,0,0];

Pstart=[0;0;0];

q=[0.47,0.32,0.57]';
qp=q;
qp(3)=0;

qn=q;
qn(1:2)=0;

norL=1;
radi=0.01*norL;
lenArr=0.05*norL;

viewVecp=viewVec;
viewVecp(3)=0;
viewVecp=viewVecp/norm(viewVecp);

axvec=[-1 1 -1 1 -1 1];


% Do the animation

AniLaTeX=[];
animategraphicsOptions='autoplay,width=3.5in';
includegraphicsOptions='';
figureDirectory='exLS';
figcounter=0;
filename='exLS';
frmps=2;

mkdir(figureDirectory);


figure(1),hold on
set(gcf,'Position',[50 50 720 600])

view(viewVec);

axis equal
axis(axvec);
set(gca,'XTick',[])
set(gca,'XTickLabel',{})
set(gca,'YTick',[])
set(gca,'YTickLabel',{})
set(gca,'ZTick',[])
set(gca,'ZTickLabel',{})

set(gca,'Position',[-0.4 -0.4 1.8 1.8])
axis off

plot3(axvec(1),axvec(3),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(3),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(1),axvec(4),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(4),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(1),axvec(3),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(3),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(1),axvec(4),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(4),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);

plot3([xpatch(1:4),-0.0475],[ypatch(1:4),0.71],[zpatch(1:4),0],'k-','LineWidth',liwi);
plot3([-0.0575,-0.385],[0.71,0.71],[0,0],'k-','LineWidth',liwi);
plot3([-0.395,xpatch(5:end)],[0.71,ypatch(5:end)],[0,zpatch(5:end)],'k-','LineWidth',liwi);

plot3([0,0],[0,0],[0,-0.381],'k--','LineWidth',liwi);
plot3([0,0],[0,0],[-0.398,-0.87],'k-','LineWidth',liwi);

plot3(0.065*[-1,-1,0],[0,0,0],0.065*[0,1,1],'k-','LineWidth',liwi);
plot3(0.065*[-1,0],[0,0],[0,0],'k:','LineWidth',liwi);


hl=plot3([0,0],[0,0],[0.87,0],'k-','LineWidth',liwi);

text('Interpreter','latex','String','$\mathrm{Null}\,\mathbf{A}^{\mathrm{T}}$','Position',[-0.02,0,0.775],'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',fosi,'FontName','Times','Color','k');
text('Interpreter','latex','String','$\mathrm{Col}\,\mathbf{A}$','Position',[-0.11,-0.55,0],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',fosi,'FontName','Times','Color','k');

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

plotArrow3(Pstart,q,lenArr,radi,liwi);
text('Interpreter','latex','String','$\,\mathbf{b}$','Position',q,'HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',fosi,'FontName','Times','Color','k');

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

plotArrow3(Pstart,qp,lenArr,radi,liwi);
text('Interpreter','latex','String','$\mathbf{A}\hat{\mathbf{x}}$','Position',qp-0.075*viewVecp','HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',fosi,'FontName','Times','Color','k');

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

delete(hl);
plot3([0,0],[0,0],[q(3)+0.01,0.87],'k-','LineWidth',liwi);
plotArrow3(Pstart,qn,lenArr,radi,liwi);
text('Interpreter','latex','String','$\mathbf{r}$','Position',[0.04,0,q(3)-lenArr],'HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',fosi,'FontName','Times','Color','k');

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);

animateinlineLaTeX(AniLaTeX,[figureDirectory,'/',filename],animategraphicsOptions);
close;


function h=plotArrow3(Pstart,Pend,arrl,radi,liwi,clr)

if nargin<6
    clr=[0,0,0];
end

dir=Pend-Pstart;
dir=dir/norm(dir);

dirp=radi*null(dir');

h=[0,0];

numN=50;

angle=linspace(0,2*pi,numN);

patchPoints=zeros(3,numN+1);
patchPoints(:,1:numN)=dirp(:,1)*cos(angle)+dirp(:,2)*sin(angle);
patchPoints(:,1+numN)=arrl*dir;

trsl=Pend-arrl*dir;

patchPoints(1,:)=patchPoints(1,:)+trsl(1);
patchPoints(2,:)=patchPoints(2,:)+trsl(2);
patchPoints(3,:)=patchPoints(3,:)+trsl(3);

TRI=[1:(numN-1);2:numN;(numN+1)*ones(1,numN-1)]';

h(1)=plot3([Pstart(1),Pend(1)-0.5*arrl*dir(1)],[Pstart(2),Pend(2)-0.5*arrl*dir(2)],[Pstart(3),Pend(3)-0.5*arrl*dir(3)],'-','LineWidth',liwi,'Color',clr);
h(2)=patch('faces',TRI,'vertices',patchPoints','FaceColor',clr,'FaceAlpha',1,'EdgeColor','none');
