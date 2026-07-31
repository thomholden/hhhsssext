function animateEx
% Function illustrating animateinlineLaTeX

runEx1=1;
runEx2=1;

if runEx1
    
    % Example 1, moving sine and cosine curves
    
    AniLaTeX=[];
    frameContent='';
    figureDirectory='example1';
    figcounter=0;
    filename='example1';
    frmps=6;
    
    mkdir(figureDirectory);
    
    loops=140;
    
    points=200;
    
    phi=linspace(0,2*pi*(1-1/loops),loops);
    
    theta=linspace(0,14,points);
    
    for i=1:loops
        
        y1=sin(theta-phi(i));
        y2=0.64*cos(1.42*theta+2*phi(i));
        
        figure(1),plot(theta,y1,'r',theta,y2,'b');
        
        set(gcf,'PaperPositionMode','auto')
        
        figcounter=figcounter+1;
        print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
        AniLaTeX=animategraphicsLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,frameContent,frmps);
        
    end
    
    figure(1),close;
    animategraphicsLaTeX(AniLaTeX,[figureDirectory,'/',filename],'autoplay,loop,width=3.5in');
    
    clear AniLaTeX filename figureDirectory includegraphicsOptions frmps;
    
end

if runEx2
    
    % Example 2, Set of rotating points in R^3 on a unit sphere colored in
    % different colors
    
    AniLaTeX=[];
    includegraphicsOptions='';
    figureDirectory='example2';
    figcounter=0;
    filename='example2';
    frmps=5;
    
    axvec=[-1.1 1.1 -1.1 1.1 -1.1 1.1];
    
    mkdir(figureDirectory);
    
    loops=150;
    
    numpnt=69;
    
    p=randn(3,numpnt);
    for i=1:numpnt
        p(:,i)=p(:,i)/norm(p(:,i));
    end
    clr=rand(numpnt,3);
    
    [R0,~]=qr(randn(3));
    R1=R0(:,[2 1 3]);
    
    alphavec=pi*cos(linspace(0,pi*(1-1/loops),loops));
    alphavec1=linspace(0,2*pi*(1-1/loops),loops);
    
    for i=1:loops
        
        figure(1),hold on;
        
        plot3(axvec(1),axvec(3),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        plot3(axvec(2),axvec(3),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        plot3(axvec(1),axvec(4),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        plot3(axvec(2),axvec(4),axvec(5),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        plot3(axvec(1),axvec(3),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        plot3(axvec(2),axvec(3),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        plot3(axvec(1),axvec(4),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        plot3(axvec(2),axvec(4),axvec(6),'.','Color',0.9999*[1 1 1],'MarkerSize',0.1);
        
        ptemp=(R1'*[cos(alphavec1(i)) -sin(alphavec1(i)) 0;sin(alphavec1(i)) cos(alphavec1(i)) 0;0 0 1]*R1)*(R0'*[cos(alphavec(i)) -sin(alphavec(i)) 0;sin(alphavec(i)) cos(alphavec(i)) 0;0 0 1]*R0)*p;
        for j=1:numpnt
            plot3(ptemp(1,j),ptemp(2,j),ptemp(3,j),'.','color',clr(j,:),'markersize',9);
        end
        
        axis equal;
        view(2);
        axis(axvec);
        axis off
        
        set(gcf,'PaperPositionMode','auto')
        
        figcounter=figcounter+1;
        print(gcf,'-depsc2','-loose',[figureDirectory,'/',filename,'No',num2str(figcounter),'.eps']);
        AniLaTeX=animateinlineLaTeX(AniLaTeX,[filename,'No',num2str(figcounter),'.eps'],figureDirectory,includegraphicsOptions,frmps);
        
        figure(1),close;
        
    end
    
    animateinlineLaTeX(AniLaTeX,[figureDirectory,'/',filename],'autoplay,loop,width=3.5in');
    
    clear AniLaTeX filename figureDirectory includegraphicsOptions frmps;
    
end
