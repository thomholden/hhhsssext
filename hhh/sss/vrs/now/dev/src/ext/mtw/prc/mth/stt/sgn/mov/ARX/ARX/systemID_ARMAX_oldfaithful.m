%Sumit Tripathi
function systemID_ARMAX_oldfaithful()
clc;
clear all;
close all;
load OldFaithdata.m;
u_in=OldFaithdata(:,1);
y_out=OldFaithdata(:,2);
% ARX Process-----------------------------
L=length(u_in)
u_in_ID=u_in;% Input data used for Identification
u_in_vfy=u_in;% Input data used for verification

y_out_ID=y_out;% Output data used for Identification
y_out_vfy=y_out;%Output data used for verification
m=5; %Parameter to be used to generate order of delay for Input, Output and Error
n=length(y_out_ID)-m;
I=eye(n,1)+1;
I(1)=I(1)-1;
A=I; % Initialize Matrix A
Y=y_out_ID((m+1):end); % Defining Y vector
length(Y)
na=1;
% Put output delay 1 to m-na in A matrix
for k=1:1:m-na
    A=[A y_out_ID((m-k+1):(end-k))];
end
% Put "Current Input -- mth delayed Input" to Matrix A
for p=1:1:m
    k=p-1;
    A=[A u_in_ID((m-k+1):(end-k))];
end
A(:,1)=[]; % Delete 1st column of Matrix A, which was used to Initialize it
parsol=inv(A'*A)*A'*Y

% Generate Identified Output(Predicted Seconds) vector based on previous
% outputs, current and previous Inputs and Parameters solved by Least
% square method
n=length(y_out_vfy)-m;
I=eye(n,1)+1;
I(1)=I(1)-1; 
A=I;
for k=1:1:m-na
    A=[A y_out_vfy((m-k+1):(end-k))];
end

for p=1:1:m
    k=p-1;
    A=[A u_in_vfy((m-k+1):(end-k))];
end
A(:,1)=[]; % Delete 1st column of Matrix A, which was used to Initialize it
y_out_sysID=A*parsol;

figure(1)
t=linspace(1,length(y_out_sysID),length(y_out_sysID));
plot(t,y_out_sysID,'r','linewidth',1.5);
hold on;
vfy=y_out_vfy((m+1):end);
plot(t,vfy,'g');
title('Oldfaithful Erruption predicted seconds identified By ARX algorithm');
legend('Identified predicted seconds','Actual time difference between erruption');
ylabel('Seconds');
xlabel('ith element corresponds to ith time diffrence between erruption(t parametrization)');

%---------------------------------------------------------------------
%ARMAX MODEL to Predict erruption Seconds
Y_actual=y_out_ID((m+1):end); % Since 1st m values are used in delay modeling in ARX
u=u_in_ID((m+1):end);
Y_verify=y_out_vfy((m+1):end);
U_verify=u_in_vfy((m+1):end);
error =vfy- y_out_sysID;% Error vector consists of Actual erruption 
%Interval - predicted ARX erruption interval

    n=length(Y_actual)-m;
    I=eye(n,1)+1;
    I(1)=I(1)-1;
    A=I;% Initialize A
    
    Y=Y_actual((m+1):end);
    for k=1:1:m-na
        A=[A Y_actual((m-k+1):(end-k))];
    end

    for p=1:1:m
        k=p-1;
        A=[A u((m-k+1):(end-k))];
    end

    for p=1:1:m
        k=p;
        A=[A error((m-k+1):(end-k))];
    end

    A(:,1)=[];% Delete 1st column of Matrix A, which was used to Initialize it
    parsol=inv(A'*A)*A'*Y

% Generate Identified Output(Predicted Seconds) vector based on previous
% outputs, previous errors, current and previous Inputs and Parameters solved
% by Least square method
n=length(Y_verify)-m;
I=eye(n,1)+1;
I(1)=I(1)-1; % I is a Colums vector with all elements as Unity
A=I;
Y=Y_verify((m+1):end);
for k=1:1:m-na
    A=[A Y_verify((m-k+1):(end-k))];
end

for p=1:1:m
    k=p-1;
    A=[A U_verify((m-k+1):(end-k))];
end

for p=1:1:m
    k=p;
    A=[A error((m-k+1):(end-k))];
end
A(:,1)=[];
Y_sysID=A*parsol;

figure(2)
t=linspace(1,length(Y_sysID),length(Y_sysID));
plot(t,Y_sysID,'r','linewidth',1.5);
hold on;
vfy=Y_verify((m+1):end);
plot(t,vfy,'g');

title('Oldfaithful Erruption predicted seconds identified By ARMAX algorithm');
legend('Identified predicted seconds','Actual time difference between erruption');
ylabel('Seconds');
xlabel('ith element corresponds to ith time diffrence between erruption(index parametrization)');