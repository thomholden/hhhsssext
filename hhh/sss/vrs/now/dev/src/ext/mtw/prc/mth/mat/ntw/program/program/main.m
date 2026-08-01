clc
tic
% KHOI TAO CAC THONG SO BAN DAU (INITIALIZING SWARM PARAMETER)
n=20;
dim=5;% Dimmension of searching space
x=load('swarm33.m');% Creating a swarm
vnew=rand(n,dim);% Creating a randomized initial velocity
sig=zeros(n,dim);
vold=vnew;
fitness=zeros(1,n);
pbest=load('swarm33.m');% Creating pbest matrice
gbest=[4 10 24 30 12];% Introducing a randomized gbest
wmax=0.9;
wmin=0.4;
r1=rand(n,dim);% Creating a randomized matrice, size (20x3)
r2=rand(n,dim);% Creating a randomized matrice, size (20x3)
iter=0;
maxiter=60;% Maximum iteration
tap=[8 9 10 11 21 33 35 0 0
    2 3 4 5 6 7 18 19 20
    12 13 14 34 0 0 0 0 0
    15 16 17 29 30 31 36 32 0
    22 23 24 25 26 27 28 37 0];
ta=tap';
% Establish the incidence matrix
data=loadcase(case33);
doc=data.branch;
nhanh=37;
nut=33;
matrix=zeros(nhanh,nut);
    nutdau=doc(:,1);
    nutcuoi=doc(:,2);
for i=1:nhanh
matrix(i,nutdau(i))=1;
matrix(i,nutcuoi(i))=1;
end

 % Calculating fitness function for pbest
 fpbest=zeros(1,n);
 for i=1:n
     fpbest(i)=50000;
 end
% Main loops
while iter<maxiter
    iter=iter+1;
    w=wmax-(wmax-wmin)*iter/maxiter;% Specilize the weight coefficient
    c1=2*rand(1);
    c2=2*rand(1);
    % Updating velocity
    vold=vnew;
    for i=1:n
        for j=1:dim
        vnew(i,j)=w*vnew(i,j)+c1*r1(i,j)*(pbest(i,j)-x(i,j))+c2*r2(i,j)*(gbest(j)-x(i,j));
       if abs(vnew(i,j))==abs(vold(i,j))
           vnew(i,j)=rand(1,1).*vnew(i,j);
       end
        end
    end
    % Updating particles' coordinate 
    for i=1:n
        for k=1:dim            
        sig(i,k)=length(nonzeros(ta(:,k)))/(1+exp(-vnew(i,k)));   
        x(i,k)=ta(ceil(sig(i,k)),k);
        end
    end  
    % Calculating fitness function for each particle  
        y=x';
         for k=1:n
            hop=loadcase(case33) ; matran=matrix;
             for i=1:dim
                 hop.branch(y(i,k),11)=0;
                 matran(x(k,i),:)=0;
             end
                  % Check on constraint of radial distribution network
             for j=1:length(matrix(1,:))
                 for i=1:length(matrix(1,:))
                     if sum(matran(:,i))==1
                         row=find(matran(:,i));
                         matran(row,:)=0;
                     end
                 end
             end
             if sum(sum(matran))==0
                 result=runpf(hop);
                 fitness(k)=sum(result.branch(:,14)+result.branch(:,16))*1e3;
             end
         end
    % Updating pbest
          for k=1:n
            if fitness(k)<fpbest(k)
                 pbest(k,:)=x(k,:);
                 fpbest(k)=fitness(k);
            end
          end
    % Calculating fitness function for gbest
          u=gbest';       
          hop=loadcase(case33);
          for i=1:length(u)
              hop.branch(u(i),11)=0;
          end
          result=runpf(hop);
          fgbest=sum(result.branch(:,14)+result.branch(:,16))*1e3;
          gbestvolt=result.bus(:,8);
          minvolt=min(gbestvolt);
    % Updating gbest   
     for k=1:n
        if fpbest(k)<fgbest
            gbest=pbest(k,:);
        end
     end
end
% Calculating initial configuration
bandau=loadcase(case33);
o=[33 34 35 36 37];
for i=1:length(o)
    bandau.branch(o(i),11)=0;
end
ketqua=runpf(bandau);
tonthat=sum(ketqua.branch(:,14)+ketqua.branch(:,16))*1e3;
dienap=ketqua.bus(:,8);
dienapmin=min(dienap);
gbestvolt;
a=sort(gbest);
ploss=(tonthat-fgbest)*100/tonthat;
plot(dienap,'-sr')
hold on
plot(gbestvolt,'-^b')
ylabel('Voltage (p.u)')
xlabel('Node')
title('Voltage profile')
legend('Before Reconfig','After Reconfig')
hold off
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('==========================================================================================')
disp('******************* SIMULATION RESULTS OF 33 BUS DISTRIBUTION NETWORK ********************')
disp('==========================================================================================')
disp('                       BEFORE RECONFIGURATION              AFTER RECONFIGURATION'          )
disp('------------------------------------------------------------------------------------------')
disp(['Tie switches:              ', num2str(o), '                  ',num2str(a)])
disp('------------------------------------------------------------------------------------------')
disp(['Power loss:                ',num2str(tonthat),' kW','                         ',num2str(fgbest),' kW'])
disp('------------------------------------------------------------------------------------------')
disp(['Power loss reduction:      ', '_______','                             ',num2str(ploss), ' %'])
disp('------------------------------------------------------------------------------------------')
disp(['Minimum voltage:           ',num2str(dienapmin),' pu','                          ',num2str(minvolt),' pu'])
disp('------------------------------------------------------------------------------------------')
toc
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')
disp('      ')

