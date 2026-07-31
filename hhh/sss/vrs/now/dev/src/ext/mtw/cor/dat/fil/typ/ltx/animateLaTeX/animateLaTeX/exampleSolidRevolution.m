function exampleSolidRevolution()

liwi=1;
fosi=20;
font='Times';

lenArr=0.2;
radi=lenArr/5;

spa=0.2;


viewVec=[1 0.5 0.5];
viewVec=viewVec/norm(viewVec);

axvec=[-5 5 -5 5 -3 3];

a=1;
b=3;

numC=30;

clr=[0.3,0.3,1];

% Do the animation

AniLaTeX=[];
animategraphicsOptions='controls,width=3.5in';
includegraphicsOptions='';
figureDirectory='exSolidRev';
figcounter=0;
filename='exSolidRev';
frmps=12;

mkdir(figureDirectory);


figure(1),hold on
set(gcf,'Position',[50 50 900 600])

view(viewVec);

axis equal
axis(axvec);
set(gca,'XTick',[])
set(gca,'XTickLabel',{})
set(gca,'YTick',[])
set(gca,'YTickLabel',{})
set(gca,'ZTick',[])
set(gca,'ZTickLabel',{})

set(gca,'Position',[-0.39 -0.4 1.75 1.75])
axis off

plot3(axvec(1),axvec(3),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(3),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(1),axvec(4),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(4),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(1),axvec(3),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(3),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(1),axvec(4),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
plot3(axvec(2),axvec(4),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);

Pstart1=[0;axvec(3);0];
Pend1=[0;axvec(4);0];
Pstart2=[0;0;axvec(5)];
Pend2=[0;0;axvec(6)];
Pstart3=[axvec(1);0;0];
Pend3=[axvec(2);0;0];

plotArrow3(Pstart1,Pend1,lenArr,radi,liwi);
plotArrow3(Pstart2,Pend2,lenArr,radi,liwi);
plotArrow3(Pstart3,Pend3,lenArr,radi,liwi);

text('Interpreter','latex','String','$x$','Position',[Pend1(1),Pend1(2)+0.5*spa,Pend1(3)-0.5*spa],'HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
text('Interpreter','latex','String','$y$','Position',[Pend2(1),Pend2(2),Pend2(3)+0.75*spa],'HorizontalAlignment','center','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
text('Interpreter','latex','String','$z$','Position',[Pend3(1)+0.5*spa,Pend3(2),Pend3(3)-spa],'HorizontalAlignment','right','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');


circParam=linspace(-pi,pi,numC);

Crv=[zeros(1,numC);b+a*cos(circParam);a*sin(circParam)];
hcrv0=plot3(Crv(1,:),Crv(2,:),Crv(3,:),'k-','LineWidth',liwi);

light

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);



nv2=12;
duAngl=2*pi/30;

numRots=10;

for i=1:numRots
    
    rotParam=i*2*pi/numRots;
    
    hSrf=plotTorus(a,b,numC,nv2,rotParam,duAngl,Crv,liwi,clr);
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    
    if i<numRots
        AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
        delete(hSrf)
    else
        AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps,'*');
    end
    
end

frmps=1.5;

delete(hcrv0);

clrCyl=[1,0.3,0.3];

nrot=45;

nr=0;
nh=0;

numIntv=10;
sliceParam=linspace(-a,a,numIntv+1);

hn=text('Interpreter','latex','String',['$n=',num2str(numIntv),'$'],'Position',[Pend1(1),Pend1(2),Pend1(3)]+[Pend2(1),Pend2(2),Pend2(3)],'HorizontalAlignment','right','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

for i=1:numIntv
    
    r1=sliceParam(i)+b;
    r2=sliceParam(i+1)+b;
    rm=0.5*(sliceParam(i)+sliceParam(i+1));
    h1=-sqrt(a^2-rm^2);
    h2=-h1;
    
    hcyl=plotCyl(r1,r2,h1,h2,nr,nh,nrot,liwi,clrCyl);
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    delete(hcyl);
    
end

delete(hn)

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps,'*');

frmps=0.5;

for j=1:4
    
    hslicesplot=cell(1,numIntv);
    sliceParam=linspace(-a,a,numIntv+1);
    
    for i=1:numIntv
        
        r1=sliceParam(i)+b;
        r2=sliceParam(i+1)+b;
        rm=0.5*(sliceParam(i)+sliceParam(i+1));
        h1=-sqrt(a^2-rm^2);
        h2=-h1;
        
        hslicesplot{i}=plotCyl(r1,r2,h1,h2,nr,nh,nrot,liwi,clrCyl);
        
    end
    
    hn=text('Interpreter','latex','String',['$n=',num2str(numIntv),'$'],'Position',[Pend1(1),Pend1(2),Pend1(3)]+[Pend2(1),Pend2(2),Pend2(3)],'HorizontalAlignment','right','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    for i=1:numIntv
        delete(hslicesplot{i})
    end
    
    delete(hn)
    
    numIntv=2*numIntv;
    
end

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps,'*');


frmps=1.5;

numIntv=10;
sliceParam=linspace(-a,a,numIntv+1);

nr=0;
nh=0;

hn=text('Interpreter','latex','String',['$n=',num2str(numIntv),'$'],'Position',[Pend1(1),Pend1(2),Pend1(3)]+[Pend2(1),Pend2(2),Pend2(3)],'HorizontalAlignment','right','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');

for i=1:numIntv
    
    h1=sliceParam(i);
    h2=sliceParam(i+1);
    hm=0.5*(sliceParam(i)+sliceParam(i+1));
    r1=b-sqrt(a^2-hm^2);
    r2=b+sqrt(a^2-hm^2);
    
    hcyl=plotCyl(r1,r2,h1,h2,nr,nh,nrot,liwi,clrCyl);
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    delete(hcyl);
    
end

delete(hn)

set(gcf,'PaperPositionMode','auto')

figcounter=figcounter+1;
print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps,'*');

frmps=0.5;

for j=1:4
    
    hslicesplot=cell(1,numIntv);
    sliceParam=linspace(-a,a,numIntv+1);
    
    for i=1:numIntv
        
        h1=sliceParam(i);
        h2=sliceParam(i+1);
        hm=0.5*(sliceParam(i)+sliceParam(i+1));
        r1=b-sqrt(a^2-hm^2);
        r2=b+sqrt(a^2-hm^2);
        
        hslicesplot{i}=plotCyl(r1,r2,h1,h2,nr,nh,nrot,liwi,clrCyl);
        
    end
    
    hn=text('Interpreter','latex','String',['$n=',num2str(numIntv),'$'],'Position',[Pend1(1),Pend1(2),Pend1(3)]+[Pend2(1),Pend2(2),Pend2(3)],'HorizontalAlignment','right','VerticalAlignment','baseline','FontSize',fosi,'FontName',font,'Color','k');
    
    set(gcf,'PaperPositionMode','auto')
    
    figcounter=figcounter+1;
    print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
    AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
    
    for i=1:numIntv
        delete(hslicesplot{i})
    end
    
    delete(hn)
    
    numIntv=2*numIntv;
    
end


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

function h=plotTorus(a,b,numC,nv2,rotAngl,duAngl,Crv,liwi,clr)

alfclr=0.5;
clr2=alfclr*clr;
clr3=alfclr*clr2;

prmVlines=linspace(-pi,pi-2*pi/nv2,nv2);

numPlotV=500;
runAnglParams2=linspace(0,rotAngl,numPlotV)+pi/2;

numUlines=floor(rotAngl/duAngl);

h=zeros(1,nv2+numUlines+2);

for i=1:nv2
    
    yval=a*sin(prmVlines(i));
    r=b+a*cos(prmVlines(i));
    h(i)=plot3(r*cos(runAnglParams2),r*sin(runAnglParams2),yval*ones(1,numPlotV),'-','LineWidth',liwi,'Color',clr2);
    
end

for i=1:numUlines
    
    rotAngltmp=i*duAngl;
    
    crvTransf=Crv;
    crvTransf(1:2,:)=[cos(rotAngltmp) -sin(rotAngltmp);sin(rotAngltmp) cos(rotAngltmp)]*crvTransf(1:2,:);
    h(i+nv2)=plot3(crvTransf(1,:),crvTransf(2,:),crvTransf(3,:),'-','LineWidth',liwi,'Color',clr2);
    
end

crvTransf=Crv;
crvTransf(1:2,:)=[cos(rotAngl) -sin(rotAngl);sin(rotAngl) cos(rotAngl)]*crvTransf(1:2,:);

if abs(rotAngl-2*pi)<1e-5
    h(numUlines+nv2+1)=plot3(crvTransf(1,:),crvTransf(2,:),crvTransf(3,:),'-','LineWidth',liwi,'Color',clr2);
else
    h(numUlines+nv2+1)=plot3(crvTransf(1,:),crvTransf(2,:),crvTransf(3,:),'-','LineWidth',liwi,'Color',clr3);
end

numRotAngls=ceil(rotAngl*50);
rotAnglsParam=linspace(0,rotAngl,numRotAngls);

circParam=linspace(-pi,pi,numC);

Ptorus=getTorusPoints(rotAnglsParam,circParam,a,b);
tri=getTriangulation(numRotAngls,numC);

h(numUlines+nv2+2)=patch('faces',tri,'vertices',Ptorus','FaceColor',clr,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',0.5,'FaceAlpha',0.075);

material shiny

function h=plotCyl(r1,r2,h1,h2,nr,nh,nrot,liwi,clr)

alfclr=0.5;

clr2=alfclr*clr;

prmVlines=linspace(-pi,pi-2*pi/nrot,nrot);

numPlotV=500;
runAnglParams2=linspace(0,2*pi,numPlotV);

h=zeros(1,4+2*nh+2*nr+nrot+4);

yvals=linspace(h1,h2,nh+2);

for i=1:(nh+2)
    
    yval=yvals(i);
    h(2*i-1)=plot3(r1*cos(runAnglParams2),r1*sin(runAnglParams2),yval*ones(1,numPlotV),'-','LineWidth',liwi,'Color',clr2);
    h(2*i)=plot3(r2*cos(runAnglParams2),r2*sin(runAnglParams2),yval*ones(1,numPlotV),'-','LineWidth',liwi,'Color',clr2);
    
end

if nr>0
    
    dr=(r2-r1)/(nr+1);
    
    for i=1:nr
        
        r=r1+i*dr;
        h(4+2*nh+2*i-1)=plot3(r*cos(runAnglParams2),r*sin(runAnglParams2),h1*ones(1,numPlotV),'-','LineWidth',liwi,'Color',clr2);
        h(4+2*nh+2*i)=plot3(r*cos(runAnglParams2),r*sin(runAnglParams2),h2*ones(1,numPlotV),'-','LineWidth',liwi,'Color',clr2);
        
    end
    
end

hm=(h1+h2)/2;

for i=1:nrot
    
    angl=prmVlines(i);
    h(4+2*nh+2*nr+i)=plot3([r1*cos(angl) r1*cos(angl) r2*cos(angl) r2*cos(angl) r1*cos(angl) r1*cos(angl)],[r1*sin(angl) r1*sin(angl) r2*sin(angl) r2*sin(angl) r1*sin(angl) r1*sin(angl)],[hm h2 h2 h1 h1 hm],'-','LineWidth',liwi,'Color',clr2);
    
end

if nrot>0
    numRotAngls=20*nrot+1;
else
    numRotAngls=999;
end

uvals=linspace(-pi,pi,numRotAngls);

tri=getTriangulation(numRotAngls,2);

P=getCylPoints(uvals,r1,h1,h2);
h(4+2*nh+2*nr+nrot+1)=patch('faces',tri,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',0.5,'FaceAlpha',1.0);

P=getCylPoints(uvals,r2,h1,h2);
h(4+2*nh+2*nr+nrot+2)=patch('faces',tri,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',0.5,'FaceAlpha',1.0);

P=getTopPoints(uvals,r1,r2,h1);
h(4+2*nh+2*nr+nrot+3)=patch('faces',tri,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',0.5,'FaceAlpha',1.0);

P=getTopPoints(uvals,r1,r2,h2);
h(4+2*nh+2*nr+nrot+4)=patch('faces',tri,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceLighting','gouraud','AmbientStrength',0.5,'FaceAlpha',1.0);


function P=getCylPoints(uvals,r,h1,h2)

vvals=[h1,h2];

nu=length(uvals);
nv=length(vvals);
numPnt=nu*nv;

P=zeros(3,numPnt);

[V,U]=meshgrid(vvals,uvals);

for i=1:nu
    rotAngl=uvals(i);
    P(:,((i-1)*nv+1):(i*nv))=[cos(rotAngl) -sin(rotAngl) 0;sin(rotAngl) cos(rotAngl) 0;0 0 1]*[zeros(1,nv);r*ones(1,nv);vvals];
end

function P=getTopPoints(uvals,r1,r2,h)

vvals=[r1,r2];

nu=length(uvals);
nv=length(vvals);
numPnt=nu*nv;

P=zeros(3,numPnt);

[V,U]=meshgrid(vvals,uvals);

for i=1:nu
    rotAngl=uvals(i);
    P(:,((i-1)*nv+1):(i*nv))=[cos(rotAngl) -sin(rotAngl) 0;sin(rotAngl) cos(rotAngl) 0;0 0 1]*[zeros(1,nv);vvals;h*ones(1,nv)];
end

function P=getTorusPoints(uvals,vvals,a,b)

nu=length(uvals);
nv=length(vvals);
numPnt=nu*nv;

P=zeros(3,numPnt);

[V,U]=meshgrid(vvals,uvals);

for i=1:nu
    rotAngl=uvals(i);
    P(:,((i-1)*nv+1):(i*nv))=[cos(rotAngl) -sin(rotAngl) 0;sin(rotAngl) cos(rotAngl) 0;0 0 1]*[zeros(1,nv);b+a*cos(vvals);a*sin(vvals)];
end


function tri=getTriangulation(nu,nv)

tri=zeros(2*(nu-1)*(nv-1),3);

for ii=1:(nu-1)
    for jj=1:(nv-1)
        indtmptri=(ii-1)*(nv-1)+jj;
        indtmp=(ii-1)*nv+jj;
        tri(2*indtmptri-1,:)=[indtmp,indtmp+nv,indtmp+1];
        tri(2*indtmptri,:)=[indtmp+nv+1,indtmp+1,indtmp+nv];
    end
end
