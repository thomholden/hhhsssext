% CLASSIFICATION
% This shows a pruned LDA unit
% learning a linear decision boundary

% Start with separation=2, Ns=0, N=100. Gradually make it more difficult

plevel=0.05;

% Two cluster centres are separated by this much in each of the 2 
% informative inputs
separation=0.7;

% Number of spurious inputs
Ns=7;

% Number of data points
N=100;

% Generate data
x1=randn(N/2,2)+1+separation;
y1=ones(N/2,1);
x0=randn(N/2,2)+1;
y0=zeros(N/2,1);


%plot(x1(:,2),x1(:,1),'x');
%hold on
%plot(x0(:,2),x0(:,1),'o');
%hold off

% Generate Ns spurious inputs
xs0=2*randn(N/2,Ns)+2;
xs1=2*randn(N/2,Ns)+2;

% To demonstrate why just eleminating smallest weights would fail try:
%xs=0.02*randn(N,Ns)+2;
% Of course you could get round this by normalising your data first

x0=[xs0,x0];
x1=[xs1,x1];
[vars] = forward (x0,x1,plevel);
vars

return

%Get outputs from trained MLP
ypred = linnode(x(:,vars),w);

[c,tp,tn,fp,fn]=lclassify(y,ypred,0.5);
cr=c/N;
disp(sprintf('Correct classification rate = %1.3f',cr));


hold off
plot(x1(:,2),x1(:,1),'x');
hold on
plot(x0(:,2),x0(:,1),'o');

if ~(length(w)==3)
	return
end

x1min=min(x(:,1));
x1max=max(x(:,1));
hold on
plindisc(w,x1min,x1max);



