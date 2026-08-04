function ss = mlp2b_steps(net, x, y)
%MLP2B_STEPS Calculate heuristic stepsizes for 2-layer logistic MLP
%
%	Description
%	S = MLP2B_STEPS(NET, X, Y) takes a network data structure NET
%	together with a matrix X of input vectors and a matrix T of
%       target vectors and calculates heuristic stepsizes S.
%
%	See also
%	MLP2
%

% Copyright (c) 1999-2000 Aki Vehtari

N=length(x);
nin=net.nin;
nhid=net.nhid;
nout=net.nout;

% Active weights
w=ones(1,net.nwts);
net=mlp2unpak(net,w);

% Evaluate second derivatives of minus log likelihood
seconds_o = 1/4;

%if size(net.p.w{3}.a.s)==[1 4]
%  net.p.w{3}.a.s=kron(net.p.w{3}.a.s.^2,ones(1,nhid*nout/length(net.p.w{3}.a.s)));
%  net.p.w{3}.a.s=reshape(net.p.w{3}.a.s.^2,size(net.w2));
%end
seconds_h = (seconds_o*(net.w2.*net.p.w{3}.a.s.^2)');
seconds_s = seconds_h;

% Initialize stepsize variables to second derivatives of minus log prior.
if size(net.p.w{1}.a.s)==[1 1]
  net.w1=net.w1./net.p.w{1}.a.s.^2;
else
  net.w1=net.w1./net.p.w{1}.a.s(ones(1,nhid),:)'.^2;
end  
net.b1=net.b1./net.p.w{2}.a.s.^2;
if size(net.p.w{3}.a.s)==[1 1]
  net.w2=net.w2./net.p.w{3}.a.s.^2;
elseif size(net.p.w{3}.a.s)==size(net.w2)
  net.w2=net.w2./net.p.w{3}.a.s.^2;
else
  net.w2=net.w2./net.p.w{3}.a.s(ones(1,nhid),:).^2;
end
net.b2=net.b2./net.p.w{4}.a.s.^2;

% Add second derivatives of minus log likelihood to stepsize variables.
net.w1=net.w1+sum(x.^2)'*seconds_s;
net.b1=net.b1+N.*seconds_s;
net.w2=net.w2+ones(nhid,1)*(N.*seconds_o);
net.b2=net.b2+N.*seconds_o;

ss=mlp2pak(net);
ss=1./sqrt(ss);
