function ss = mlp2r_steps(net, x, y)
%MLP2R_STEPS Calculate heuristic stepsizes for 2-layer network.
%
%	Description
%	SS = MLP2R_STEPS(NET, X, Y) takes a network data structure NET
%	together with a matrix X of input vectors and a matrix Y of
%       target vectors and calculates heuristic stepsizes SS.
%
%	See also
%	MLP2, HMC2, MLP2R_MC, NORM_S
%

% Copyright (c) 1999-2000 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

N=length(x);
nin=net.nin;
nhid=net.nhid;
nout=net.nout;

% Active weights
w=ones(1,net.nwts);
net=mlp2unpak(net,w);

% Evaluate second derivatives of minus log likelihood with respect
% to output units 
seconds_o=feval([net.p.r.f '_s'],net.p.r.a);

% evaluate the second derivative of minus log likelihood with
% respect to hidden layer units (withhout summarizing component
% values, which is done at the last part of function). 
switch net.p.w{3}.f
 case 'norm'
   seconds_s = (seconds_o*(net.w2.*net.p.w{3}.a.s.^2)');
 otherwise
  error('Unknown prior')
end

% Initialize stepsize variables to second derivatives of minus log prior.
switch net.p.w{1}.f
 case 'norm'
  if size(net.p.w{1}.a.s)==[1 1]
    net.w1=net.w1./net.p.w{1}.a.s.^2;
  else
    net.w1=net.w1./net.p.w{1}.a.s(ones(1,nhid),:)'.^2;
  end  
 otherwise
  error('Unknown prior')
end
   
switch net.p.w{2}.f
 case 'norm'
  net.b1=net.b1./net.p.w{2}.a.s.^2;
 otherwise
  error('Unknown prior')
end
   
switch net.p.w{3}.f
  case 'norm'
   if size(net.p.w{3}.a.s)==[1 1]
     net.w2=net.w2./net.p.w{3}.a.s.^2;
   elseif size(net.p.w{3}.a.s)==size(net.w2)
     net.w2=net.w2./net.p.w{3}.a.s.^2;
   else
     net.w2=net.w2./net.p.w{3}.a.s(ones(1,nhid),:).^2;
   end
 otherwise
  error('Unknown prior')
end
switch net.p.w{4}.f
 case 'norm'
  net.b2=net.b2./net.p.w{4}.a.s.^2;
 otherwise
  error('Unknown prior')
end

% Add second derivatives of prior distribution to the second
% derivatives of minus log likelihood with respect to input weights
% and biases and hiddenlayer weights and biases.
net.w1=net.w1+sum(x.^2)'*seconds_s;
net.b1=net.b1+N.*seconds_s;
net.w2=net.w2+ones(nhid,1)*(N.*seconds_o);
net.b2=net.b2+N.*seconds_o;

ss=mlp2pak(net);
ss=1./sqrt(ss);
