function net = mlp2normp(net, pw)
%MLP2NORMP Create Gaussian prior for mlp.
%
%	Description
%	NET = MLP2NORMP(NET, PW) takes an mlp network data
%	structure NET and prior hyper-parameters array PW and returns a
%	network data structure NET identical to the input network,
%	except that the weight priors have been created to the
%	network. 
%
%       PW is of the form:
%
%       {{Ak A1 Nu1 A2 Nu2}...
%        {Ak A1 Nu1}...
%        {Ak A1 Nu1 A2 Nu2}...
%        {Ak A1 Nu1}}
%
%       where the first row represents first layer weights w1,
%       second row represents first layer biases b1, third row
%       second layer weights w2 and fourth row second layer biases
%       b2. If A2 and Nu2 are included ARD is used for prior
%       creation for the given layer. Similarly Ak represents first
%       level hyper-parameters, A1 and Nu1 second level
%       hyper-parameters and A2 and Nu2 third level hyper-parameters.
%
%       If A1 or A2 are negative in the case of first or second 
%       layer weights, they are scaled according to the number of 
%       inputs (in the first layer) or number of hidden units (
%       in the second layer). The scaling is done to 
%       Ai = -Ai/(K^(1/Nui)).

% Copyright (c) 1999 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

net.p.w=[];
net.p.pw = pw;
type=[0 0 0 0];
for i=1:4
  
  % Possible scalings
  if length(pw{i}) > 1 & pw{i}{2} < 0
    if i==1
      pw{i}{2}=-pw{i}{2}/(net.nin^(1/pw{i}{3}));
    elseif i==3
      pw{i}{2}=-pw{i}{2}/(net.nhid^(1/pw{i}{3}));
    end
  end
  if length(pw{i}) > 3 & pw{i}{4} < 0
    if i==1
      pw{i}{4}=-pw{i}{4}/(net.nin^(1/pw{i}{5}));
    elseif i==3
      pw{i}{4}=-pw{i}{4}/(net.nhid^(1/pw{i}{5}));
    end
  end
  
  % Normal (hierarchical) prior
  net.p.w{i} = norm_p(pw{i});
  % Check type for index creation
  if length(pw{i})>3
    type(i)=1;
  end
end

% Create indexes for network
indx=mlp2index(net, type);
for i=1:4
  net.p.w{i}.ii=indx{i};
end
