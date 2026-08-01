%%  Competition Over Resource Optimization Algorithm, 
%
% Prepared by: Sina Mohseni, Reza Gholami, Niloofar Zarei
%
% Email: sina.mohseni89@gmail.com
% Email: Rezagholami89@gmail.com
% Date: June 2014
% 
% New Eveluoutinary Algorithm based on Animals Behavorial Ecology
%
% Reference: S. Mohseni, R. Gholami, N. Zarei, "Competition Over Resources: A New Optimization
% Algorithm Based on Animal Behavioral Ecology", IEEE INCos2014, Salerno, Italy.
%

%% Variables 
clc;
clear all;
close all;

%% Problem Definition
global NFE;

CostFunction=@(x) Sphere(x);        % Cost Function

nVar=128;             % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin = -5;         % Lower Bound of Variables
VarMax = 5;          % Upper Bound of Variables

%%  COR Parameters

MaxIt = 1000;      % Maximum Number of Iterations

nPop= 100;         % Population Size (Swarm Size)
nGrp= 10;          % Number of Group

d_rate = 1;        % Rate of death for weak groups elimination 

d_search = 0.6;     % Decision spcase persentage for searching ( 0 < d_search < 1 )
p_search= 1.1;      % Inner/outer neighborhood population ratio. ( 1 < p_search )  

%% Initialization

empty_Grp.Position=[];
empty_Grp.Cost=[];
empty_Grp.n_rate=[];

Grp=repmat(empty_Grp,nGrp,1);

sec_min = 0;           % find second optimum for group dividing 
 
   init_1=unifrnd(VarMin,VarMax,nPop, nVar);
   
   for (j = 1:nPop)
     init_2(j) = CostFunction(init_1(j,:));
   end
    
     for i=1:nGrp
     
         a = min(init_2);
         for (j = 1:nPop)
            if (init_2(j) == a)
            Grp(i).Position(1,:) = init_1(j,:);
            Grp(i).Cost(1) = a;
             Grp(i).n_rate = 0;
            init_2(j) = Inf; 
            end
         end

     end
     
BestCost=zeros(MaxIt,1);
WorstCost=zeros(MaxIt,1);
BestPosition=zeros(MaxIt,nVar);
BestCost(:) = Inf;
WorstCost(:) = -Inf;
BestPosition(:) = Inf;

%% COR Main Loop

for it=1:MaxIt
    
    for i=1:nGrp
        
       a = Grp(i).Position(1,:);
       
    %%%%%%%%%%%%%%%%%% Neighborhood %%%%%%%%%%%%%%%%%%%

    for (j= 1:nGrp)
       Grp(i).local(j,:) = abs(Grp(i).Position(1,:) - Grp(j).Position(1,:));
       Grp(i).local2(j) = ( sum (Grp(i).local(j,:)) )  / (nVar);
    end
    
    Grp(i).local2(i) = Inf; 
    Grp(i).neigh = min(Grp(i).local2);
    
    
    l = (VarMax - VarMin);
    MinNeigh  = (Grp(i).Position(1,:) - (Grp(i).neigh) );     % Inner territory search space 
    MaxNeigh  = ( Grp(i).Position(1,:) +  (Grp(i).neigh) );

    MinNeigh3  = (Grp(i).Position(1,:) -(d_search * l));      % Outer territory search space 
    MaxNeigh3  =  ( Grp(i).Position(1,:) + (d_search * l));
    
    outer = MinNeigh3 - MaxNeigh3;
    Grp(i).Position(1,:)= Grp(i).Position(1,:);               % Head of group 
    
    trs = round ( ((nPop/nGrp) - d_rate *  Grp(i).n_rate) / p_search);
    end1 = ((nPop/nGrp) - d_rate *  Grp(i).n_rate);
    
    %First agent set
    for (j = 2:trs)
       Grp(i).Position(j,:) =  unifrnd( MinNeigh,MaxNeigh,VarSize ); 
    
       Grp(i).Position(j,:)  = max (VarMin, Grp(i).Position(j,:));   
       Grp(i).Position(j,:)  = min (VarMax, Grp(i).Position(j,:));
    end
    %Second agent set
    for (j = trs + 1: end1 + 1)
       Grp(i).Position(j,:) =  unifrnd( MinNeigh3,MaxNeigh3,VarSize );
    
       Grp(i).Position(j,:)  = max (VarMin, Grp(i).Position(j,:));   
       Grp(i).Position(j,:)  = min (VarMax, Grp(i).Position(j,:));
    end
    
    %%%%%%%%%%%%%%%%%% Evaluation %%%%%%%%%%%%%%%%%%%%
            
    %1st Minimum
    for (j = 1:((nPop/nGrp) - d_rate *  Grp(i).n_rate) + 1)
    Grp(i).Cost(j)=CostFunction(Grp(i).Position(j,:));
    end
    
    a = min(Grp(i).Cost);
    
    for (j = 1:((nPop/nGrp) - d_rate *  Grp(i).n_rate)  + 1)
     if (a == Grp(i).Cost(j))
        
       b = Grp(i).Position(1,:);
       Grp(i).Position(1,:) = Grp(i).Position(j,:);
       Grp(i).Position(j,:) = b;
       
       b = Grp(i).Cost(1);
       Grp(i).Cost(1) = Grp(i).Cost(j);
       Grp(i).Cost(j) = b;
       
     end
    end  
       
    end
    
    %%%%%%%%%%%%%%%%%%%% Elitism %%%%%%%%%%%%%%%%%%%%
 WorstCost(it) = -Inf;
 BestCost(it) = +Inf;
  
    for(j = 1:nGrp)
     BestCost(it)= min (BestCost(it) ,Grp(j).Cost(1));
     WorstCost(it)= max (WorstCost(it) , Grp(j).Cost(1) );
    end

     for (j= 1:nGrp)             % Best Group 
       if ( BestCost(it) ==  Grp(j).Cost(1) )
           Grp(j).n_rate = Grp(j).n_rate - 1;
           best_grp_ind = j;
       end
     end
   for (j= 1:nGrp)               % Worst Group 
       if ( WorstCost(it) ==  Grp(j).Cost(1) )
            Grp(j).n_rate = Grp(j).n_rate + 1;
            j;
            Grp(j).n_rate ;

                if (Grp(j).n_rate > (-3 + (nPop/nGrp))/d_rate )
                    sec_min = 1;
                end
       end
   end
                      %find 2nd Minimum and start the new group process 
if (sec_min == 1)         
    sec_min = 0;
   for (j= 1:nGrp)             % Best Group
     if (BestCost(it) == Grp(j).Cost(1))
                                    % Finding 2nd Minimum 
       bb = Grp(j).Cost(1);    
       Grp(j).Cost(1) = Inf; 
       a = min(Grp(j).Cost);         % Finding 2nd Minimum 
       Grp(j).Cost(1) = bb;
       
         for (k = 2:(((nPop/nGrp) - d_rate *  (Grp(j).n_rate + 1)) +1 ))
           if (a == Grp(j).Cost(k))
               NewPosition = Grp(j).Position(k,:);      % 2nd Minimum Position
               NewCost = Grp(j).Cost(k);                % 2nd Minimum Position
           end
          end  
     Grp(j).n_rate = 0; 
      end
   end
   
        
        for (j= 1:nGrp)    % 2nd Best Group
            if (WorstCost(it) == Grp(j).Cost(1))
               Grp(j).Position(1,:) = NewPosition;      % 2nd Minimum Position
               Grp(j).Cost(1) = NewCost;                % 2nd Minimum Cost
               Grp(j).n_rate = 0;
            end 
        end
        
end  

       nfe(it)=NFE;
     disp(['Iteration ' num2str(it) ': Neigh = ' num2str(Grp(1).neigh)   ', Best Cost = ' num2str(BestCost(it))]);
end
    
    

%% Plot
figure();

[Xx,Yy] = meshgrid(VarMin:0.1: VarMax , VarMin:0.1: VarMax);                                
Zz = (Xx.^2 + Yy.^2) ; 

surf(Xx,Yy,Zz)
figure();
contour(Xx,Yy,Zz)
hold on
X = Grp(best_grp_ind).Position(1,1);
Y = Grp(best_grp_ind).Position(1,2);
plot(X,Y,'--rs','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',5)

%% Results

disp([' Best Answer :',num2str(BestCost(MaxIt))])      
disp([' Max NFE:',num2str(nfe(MaxIt))])       
figure(); 
plot(BestCost);
title(num2str(BestCost(MaxIt)));
xlabel('Iteration');
ylabel('Best Cost');
