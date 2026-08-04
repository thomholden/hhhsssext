function [rec, net0, rstate] = mlp2c_mc(opt, net, p, t, pp, tt, rec, rstate)
% MLP2C_MC Monte Carlo sampling for model mlp2c, softmax classification
%
%   [REC, NET0, RSTATE] = MLP2c_MC(OPT, NET, P, T, PP, TT, REC, RSTATE)
%   Performs MCMC sampling for MLP network with softmax output function. 
%   The parameters in are. 
%     NET     - network
%     OPT     - options, see below
%     P       - train data
%     T       - train targets
%     PP      - test data (optional)
%     TT      - test targets (optional)
%     REC     - record to continue (optional)
%     RSTATE  - state of the random generator
%   Returns:
%     REC     - record including weights, errors and hyperparameters
%     NET0    - network
%     RSTATE  - state of the random generator
%
%   

% Copyright (c) 1998-2005 Aki Vehtari

% Check arguments
if nargin < 4
  error('Not enough arguments')
end

% Set empty options to default values
opt=feval([net.type '_mcopt'],opt);

% Use function handles
fe=str2fun('mlp2c_e');
fg=str2fun('mlp2c_g');
pw1=net.p.w{1};
pw1psf=str2fun([pw1.p.s.f '_e']);
if isfield(pw1.p,'s')
  if isfield(pw1.p.s,'p')
    pw1pspsf=str2fun([pw1.p.s.p.s.f '_e']);
  end
end

% Test data?
if nargin < 6 | isempty(pp)
  pp=[];tt=[];
end

p0=p;
net0=net;
if isfield(net,'inputii')
  net.nin=sum(net.inputii);
  net.nwts=(net.nin+1)*net.nhid+(net.nhid+1)*net.nout;
  net.w1=net0.w1(net.inputii,:);
  type = [0 0 0 0];
  for i=1:4
    if length(net.p.pw{i})>3
      type(i)=1;
    end
  end
  indx=mlp2index(net, type);
  for i=1:4
    net.p.w{i}.ii=indx{i};
  end
  net.p.w{1}.a.s=net0.p.w{1}.a.s(net.inputii);
  % If scaling of hyperparameters is used, scale them according to 
  % the new number of input variables.
  if length(net.p.pw{1}) > 3 & net.p.pw{1}{4} < 0
    net.p.w{1}.p.s.p.s.a.s = -net.p.pw{1}{4}/(net.nin^(1/net.p.pw{1}{5}));
  end
  if length(net.p.pw{3}) > 3 & net.p.pw{3}{4} < 0
    net.p.w{3}.p.s.p.s.a.s = -net.p.pw{3}{4}/(net.nhid^(1/net.p.pw{3}{5}));
  end
  p=p0(:,net.inputii);
end

% Initialize record
if nargin < 7 | isempty(rec)
  % No old record
  rec.type='mlp2c';
  rec.numInputs=net0.nin;
  rec.numLayers=1;
  rec.numHidden=net0.nhid;
  rec.numOutputs=net0.nout;
  ri=1;
  rec=recappend(rec, ri, net0, p, t, pp, tt, 0);
  rec=recappend(rec, ri+opt.nsamples, net0, p, t, pp, tt, 0);
else
  ri=size(rec.rejects,1);
  rec=recappend(rec, ri+opt.nsamples, net0, p, t, pp, tt, 0);
end

if nargin > 7
  if isempty(rstate)
    hmc2('state',sum(100*clock));
  else
    hmc2('state',rstate);
  end
end

if ~isempty(tt)
  % Base error by guessing mean
  w = mlp2pak(net);
  [foo,ebase]=feval(fe, w*0,net,pp,tt);ebase=ebase/length(pp);
  g=mlp2c_sim(mlp2unpak(net, w*0),pp);[g,gi]=max(g');
  n=length(tt);
  epbase=1-mean(tt(sub2ind([n net.nout],1:n,gi))==1);
else
  ebase=NaN;
  epbase=NaN;
end

% Get weight vector
w = mlp2pak(net);

if opt.display
  % Be verbose
  fprintf(' ');
  fprintf('cycle ');
  fprintf('etr    ');
  if ~isempty(pp)
    fprintf('etst   ');
  end
  fprintf(' ');
  fprintf('rej   ');
  fprintf('\n');
end

% Ensure that log(1-y) is computable: need exp(a) > eps
maxcut = -log(eps);
% Ensure that log(y) is computable
mincut = -log(1/realmin - 1);

psi=0.5;
if isfield(opt,'sample_inputs')
  if isfield(opt,'psample_inputs')
    psi=opt.psample_inputs;
  end
end


% ---------------------------------------------------------------------------------------------
for k=1:opt.nsamples
  
  if opt.persistence_reset
    rstate=hmc2('state');
    rstate.mom=[];
    hmc2('state',rstate);
  end
  
  rejs = 0;
  for l=1:opt.repeat
    
    % -----------  Sample inputs with RJMCMC -----------------------------------------
    if isfield(opt,'sample_inputs') & opt.sample_inputs==1
      % pick random input and change its state, here
      % k           is the number of input variables on the model.
      % pswitch     is the probability of switching the states of two inputs
      % lpk         is the log prior of k
      % net.inputii is the (logical) index array showing the inputs that are on
      while psi>rand(1)
	if isfield(opt,'rj_opt') & isfield(opt.rj_opt,'pswitch')
	  pswitch=opt.rj_opt.pswitch;
	else
	  pswitch=1/3;
	end
	lpk=opt.rj_opt.lpk;
	w = mlp2pak(net);
	netold=net;
	k=sum(net.inputii);
        
        % select one input variable randomly and switch its state
	ci=intrand([1 length(net.inputii)]);
        if k==net0.nin | pswitch==0 | rand(1)>pswitch
	  if net.inputii(ci)==1 & k>1
	    % case death, remove one input.
            % evaluate the error for k inputs
	    pw1=net.p.w{1};
	    [foo,e]=feval(fe, w, net, p, t);
            if k==net0.nin  
              e=e + feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k) +log(net0.nin);
            else
              e=e + feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k)-log(1-pswitch)+log(net0.nin);
            end
	    % evaluate the error for k-1 inputs
            % first create new network, from which the ci:th input is removed
	    net.inputii(ci)=0;
	    net.nin=sum(net.inputii);
	    net.nwts=(net.nin+1)*net.nhid+(net.nhid+1)*net.nout;
	    net.w1=net0.w1(net.inputii,:);
            % create the new index structure
	    type = [0 0 0 0];
            for i=1:4
              if length(net.p.pw{i})>3
                type(i)=1;
              end
            end
            indx=mlp2index(net, type);
            for i=1:4
              net.p.w{i}.ii=indx{i};
            end
	    net.p.w{1}.a.s=net0.p.w{1}.a.s(net.inputii);
            % If scaling of hyperparameters is used, scale them according to 
            % the new number of input variables.
            if length(net.p.pw{1}) > 3 & net.p.pw{1}{4} < 0
              net.p.w{1}.p.s.p.s.a.s = -net.p.pw{1}{4}/(net.nin^(1/net.p.pw{1}{5}));
            end
            if length(net.p.pw{3}) > 3 & net.p.pw{3}{4} < 0
              net.p.w{3}.p.s.p.s.a.s = -net.p.pw{3}{4}/(net.nhid^(1/net.p.pw{3}{5}));
            end
	    pw1=net.p.w{1};
            % evaluate the error of new network. 
            [foo,ed]=feval(fe, mlp2pak(net), net, p0(:,net.inputii), t);
            % The prior term has to be taken in the error because of scaling the hyperparameters.
            if k==2
              ed=ed +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k-1)-log(1-pswitch)+log(net0.nin-1);
            else
              ed=ed +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k-1)-log(1-pswitch)+log(net0.nin);
            end

            % evaluate the acceptance probability
	    a=e-ed;
	    if exp(a) > rand(1)
	      % accept
	      if isfield(opt,'lab')
		fprintf('Removed input %2d: %s -> k=%d (p=%.2f)\n',...
			ci,deblank(opt.lab(ci,:)),k-1,exp(a));
		if k-1<=10
		  disp(opt.lab(net.inputii,:))
		end
	      else
		fprintf('Removed input %2d: -> k=%d (p=%.2f)\n',ci,k-1,exp(a));
	      end
	      net0.inputii=net.inputii;
	      p=p0(:,net.inputii);
	      w=mlp2pak(net);
	    else
              % reject
	      net=netold;
	    end
	  else
	    % case birth, add one input
            % first find new sample to give birth if k=1
            if k==1
              pii=find(~net.inputii);
              bi=intrand([1 length(pii)]);
              ci = pii(bi);
            end
            % evaluate the error of k inputs
	    pw1=net.p.w{1};
	    [foo,e]=feval(fe, w, net, p, t);
            if k==1
              e=e + feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a) - lpk(k)-log(1-pswitch)+log(net0.nin-1);
            else
              e=e + feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a) - lpk(k)-log(1-pswitch)+log(net0.nin);
            end
              
	    % evaluate the error of k+1 inputs
            % first create new network, in which ci:th input is added
	    net.inputii(ci)=1;
	    net.nin=sum(net.inputii);
	    net.nwts=(net.nin+1)*net.nhid+(net.nhid+1)*net.nout;
	    net.w1=net0.w1(net.inputii,:);
            % create the new index structure
	    type = [0 0 0 0];
            for i=1:4
              if length(net.p.pw{i})>3
                type(i)=1;
              end
            end
            indx=mlp2index(net, type);
            for i=1:4
              net.p.w{i}.ii=indx{i};
            end
	    net.p.w{1}.a.s=net0.p.w{1}.a.s(net.inputii);
            % If scaling of hyperparameters is used, scale them according to 
            % the new number of input variables.
            if length(net.p.pw{1}) > 3 & net.p.pw{1}{4} < 0
              net.p.w{1}.p.s.p.s.a.s = -net.p.pw{1}{4}/(net.nin^(1/net.p.pw{1}{5}));
            end
            if length(net.p.pw{3}) > 3 & net.p.pw{3}{4} < 0
              net.p.w{3}.p.s.p.s.a.s = -net.p.pw{3}{4}/(net.nhid^(1/net.p.pw{3}{5}));
            end
	    pw1=net.p.w{1};
            % evaluate variance for new input
	    cci=sum(net.inputii(1:ci));
	    net.p.w{1}.a.s(cci)=sqrt(invgamrand(pw1.p.s.a.s.^2,pw1.p.s.a.nu));
	    net.w1(cci,:)=randn(1,net.nhid).*net.p.w{1}.a.s(cci);
            % evaluate the error
	    [foo,ed]=feval(fe, mlp2pak(net), net, p0(:,net.inputii), t);
            % The prior term has to be taken in the error because of scaling the hyperparameters.
            if k == net0.nin - 1
              ed=ed + feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a) - lpk(k+1)+log(net0.nin);
            else
              ed=ed + feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a) - lpk(k+1)+log(net0.nin)-log(1-pswitch);
            end
            % evaluate the acceptance probability
	    a=e-ed;
	    if exp(a) > rand(1)
	      % accept
	      if isfield(opt,'lab')
		fprintf('Added input %2d: %s -> k=%d (p=%.2f)\n',...
			ci,deblank(opt.lab(ci,:)),k+1,exp(a));
		if k-1<=10
		  disp(opt.lab(net.inputii,:))
		end
	      else
		fprintf('Added input %2d: -> k=%d (p=%.2f)\n',ci,k+1,exp(a));
	      end
	      net0.inputii=net.inputii;
	      p=p0(:,net.inputii);
	      w=mlp2pak(net);
	    else
              % reject
	      net=netold;
	    end
	  end
	else
	  % case switch, switch the states of two random inputs.
          % First choose the inputs to switch
	  if net.inputii(ci)==1
	    pii=find(~net.inputii);
	    ci2=pii(intrand([1 length(pii)]));
	  else
	    pii=find(net.inputii);
	    ci2=ci;
	    ci=pii(intrand([1 length(pii)]));
	  end
          % evaluate the error of old network
	  [foo,e]=feval(fe, w, net, p, t);
          
          % create the new network, in which the states of two inputs are changed
	  net.inputii(ci)=~net.inputii(ci);
	  net.inputii(ci2)=~net.inputii(ci2);
	  net.w1=net0.w1(net.inputii,:);
          % create the indexes
          type = [0 0 0 0];
          for i=1:4
            if length(net.p.pw{i})>3
              type(i)=1;
            end
          end
          indx=mlp2index(net, type);
          for i=1:4
            net.p.w{i}.ii=indx{i};
          end
	  net.p.w{1}.a.s=net0.p.w{1}.a.s(net.inputii);
	  pw1=net.p.w{1};
          % evaluate variance for new input
	  cci=sum(net.inputii(1:ci2));
	  net.p.w{1}.a.s(cci)=sqrt(invgamrand(pw1.p.s.a.s.^2,pw1.p.s.a.nu));
	  net.w1(cci,:)=randn(1,net.nhid).*net.p.w{1}.a.s(cci);
          % evaluate the error of new network
	  [foo,ed]=feval(fe, mlp2pak(net), net, p0(:,net.inputii), t);

	  % evaluate the acceptance ratio
          a=e-ed;
	  if exp(a) > rand(1)
	    % accept
	    if isfield(opt,'lab')
	      fprintf('Switched input %2d %s to %2d: %s (p=%.2f)\n',...
		      ci,deblank(opt.lab(ci,:)),ci2,deblank(opt.lab(ci2,:)),exp(a));
	      if k<=10
		disp(opt.lab(net.inputii,:))
	      end
	    else
	      fprintf('Switched input %2d to %2d: (p=%.2f)\n', ci,ci2,exp(a));
	    end
	    net0.inputii=net.inputii;
	    p=p0(:,net.inputii);
	    w=mlp2pak(net);
	  else
            % reject
	    net=netold;
	  end
	end
      end  
    elseif isfield(opt,'sample_inputs') & opt.sample_inputs == 2
      % randomly add or remove one input.
      % k           is the number of input variables on the model.
      % pswitch     is the probability of switching the states of two inputs
      % pdeath      is the probability of removing on einput
      % lpk         is the log prior of k
      % net.inputii is the (logical) index array showing the inputs that are on
      while psi>rand(1)
	if isfield(opt,'rj_opt') & isfield(opt.rj_opt,'pswitch')
	  pswitch=opt.rj_opt.pswitch;
	else
	  pswitch=1/3;
	end
        w = mlp2pak(net);
        pdeath=opt.rj_opt.pdeath;
        pbirth=1-pdeath;
        lpk=opt.rj_opt.lpk;
        netold=net;
        k=sum(net.inputii);
        
        % randomly add or remove one input variable
        if k==net0.nin | pswitch==0 | rand(1)>pswitch
          if (k==net0.nin | pdeath>=rand(1)) & k > 1 
            % case death
            pii=find(net.inputii);
            % k
            pw1=net.p.w{1};
            [foo,e]=feval(fe, w, net, p, t);
            if k==net0.nin
              e=e+ feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k)+log(k);
            else
              e=e+ feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k)-log(1-pswitch)-log(pdeath)+log(k);
            end

            % k-1
            di=intrand([1 k]);
            net.inputii(pii(di))=0;
            net.nin=sum(net.inputii);
            net.nwts=(net.nin+1)*net.nhid+(net.nhid+1)*net.nout;
            net.w1=net0.w1(net.inputii,:);
            % create the indexes
            type = [0 0 0 0];
            for i=1:4
              if length(net.p.pw{i})>3
                type(i)=1;
              end
            end
            indx=mlp2index(net, type);
            for i=1:4
              net.p.w{i}.ii=indx{i};
            end
            net.p.w{1}.a.s=net0.p.w{1}.a.s(net.inputii);
            % If scaling of hyperparameters is used, scale them according to 
            % the new number of input variables.
            if length(net.p.pw{1}) > 3 & net.p.pw{1}{4} < 0
              net.p.w{1}.p.s.p.s.a.s = -net.p.pw{1}{4}/(net.nin^(1/net.p.pw{1}{5}));
            end
            if length(net.p.pw{3}) > 3 & net.p.pw{3}{4} < 0
              net.p.w{3}.p.s.p.s.a.s = -net.p.pw{3}{4}/(net.nhid^(1/net.p.pw{3}{5}));
            end
            pw1=net.p.w{1};
            
            % evaluate the error of new net
            [foo,ed] = feval(fe, mlp2pak(net), net, p0(:,net.inputii), t);
            % The prior term has to be taken in the error because of scaling the hyperparameters.
            if k==2
              ed=ed +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k-1)-log(1-pswitch)+log(net0.nin-1);
            else
              ed=ed +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k-1)-log(1-pswitch)-log(pbirth)+log(net0.nin-(k-1));
            end

            % evaluate the acceptance ratio
            a=e-ed;
            if exp(a) > rand(1)
              % accept
              fprintf('Removed input %2d: -> k=%d (p=%.2f)\n',pii(di),k-1,exp(a));
              net0.inputii=net.inputii;
              p=p0(:,net.inputii);
              w=mlp2pak(net);
            else
              net=netold;
            end
          else
            % case birth
            pii=find(~net.inputii);
            % k
            % Evaluete the error of old network
            pw1=net.p.w{1};
            [foo,e]=feval(fe, w, net, p, t);
            if k==1
              e=e +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k)-log(1-pswitch)+log(net0.nin-k);
            else
              e=e +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k)-log(1-pswitch)-log(pbirth)+log(net0.nin-k);
            end
            
            % k+1
            bi=intrand([1 length(pii)]);
            net.inputii(pii(bi))=1;
            net.nin=sum(net.inputii);
            net.nwts=(net.nin+1)*net.nhid+(net.nhid+1)*net.nout;
            net.w1=net0.w1(net.inputii,:);
            % create the indexes
            type = [0 0 0 0];
            for i=1:4
              if length(net.p.pw{i})>3
                type(i)=1;
              end
            end
            indx=mlp2index(net, type);
            for i=1:4
              net.p.w{i}.ii=indx{i};
            end
            net.p.w{1}.a.s=net0.p.w{1}.a.s(net.inputii);
            % If scaling of hyperparameters is used, scale them according to 
            % the new number of input variables.
            if length(net.p.pw{1}) > 3 & net.p.pw{1}{4} < 0
              net.p.w{1}.p.s.p.s.a.s = -net.p.pw{1}{4}/(net.nin^(1/net.p.pw{1}{5}));
            end
            if length(net.p.pw{3}) > 3 & net.p.pw{3}{4} < 0
              net.p.w{3}.p.s.p.s.a.s = -net.p.pw{3}{4}/(net.nhid^(1/net.p.pw{3}{5}));
            end
            pw1=net.p.w{1};
            % evaluate variance for new input
            cci=sum(net.inputii(1:pii(bi)));
	    net.p.w{1}.a.s(cci)=sqrt(invgamrand(pw1.p.s.a.s.^2,pw1.p.s.a.nu));
	    net.w1(cci,:)=randn(1,net.nhid).*net.p.w{1}.a.s(cci);
            % evaluate the error of new network
            [foo, ed] = feval(fe, mlp2pak(net), net, p0(:,net.inputii), t);
            % The prior term has to be taken in the error because of scaling the hyperparameters.
            if k == net0.nin-1
              ed=ed +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k+1)+log(net0.nin);
            else
              ed=ed +feval(pw1pspsf,pw1.p.s.a.s,pw1.p.s.p.s.a)-lpk(k+1)-log(1-pswitch)-log(pdeath)+log(k+1);
            end

            % evaluate the acceptance ratio
            a=e-ed;
            if exp(a) > rand(1)
              % accept
              fprintf('Added input %2d: -> k=%d (p=%.2f)\n',pii(bi),k+1, exp(a));
              net0.inputii=net.inputii;
              p=p0(:,net.inputii);
              w=mlp2pak(net);
            else
              net=netold;
            end
          end
        else
          % case switch, switch the states of two random inputs.
          % First choose the inputs to switch
          ci=intrand([1 length(net.inputii)]);
	  if net.inputii(ci)==1
	    pii=find(~net.inputii);
	    ci2=pii(intrand([1 length(pii)]));
	  else
	    pii=find(net.inputii);
	    ci2=ci;
	    ci=pii(intrand([1 length(pii)]));
	  end
          % evaluate the error of old network
	  [foo,e]=feval(fe, w, net, p, t);
          
          % create the new network, in which the states of two inputs are changed
	  net.inputii(ci)=~net.inputii(ci);
	  net.inputii(ci2)=~net.inputii(ci2);
	  net.w1=net0.w1(net.inputii,:);
          % create the indexes
          type = [0 0 0 0];
          for i=1:4
            if length(net.p.pw{i})>3
              type(i)=1;
            end
          end
          indx=mlp2index(net, type);
          for i=1:4
            net.p.w{i}.ii=indx{i};
          end
	  net.p.w{1}.a.s=net0.p.w{1}.a.s(net.inputii);
	  pw1=net.p.w{1};
	  cci=sum(net.inputii(1:ci2));
	  net.p.w{1}.a.s(cci)=sqrt(invgamrand(pw1.p.s.a.s.^2,pw1.p.s.a.nu));
	  net.w1(cci,:)=randn(1,net.nhid).*net.p.w{1}.a.s(cci);
          % evaluate the error of new network
	  [foo,ed]=feval(fe, mlp2pak(net), net, p0(:,net.inputii), t);
	  % evaluate the acceptance ratio
          a=e-ed;
	  if exp(a) > rand(1)
	    % accept
	    if isfield(opt,'lab')
	      fprintf('Switched input %2d %s to %2d: %s (p=%.2f)\n',...
		      ci,deblank(opt.lab(ci,:)),ci2,deblank(opt.lab(ci2,:)),exp(a));
	      if k<=10
		disp(opt.lab(net.inputii,:))
	      end
	    else
	      fprintf('Switched input %2d to %2d: (p=%.2f)\n', ci,ci2,exp(a));
	    end
	    net0.inputii=net.inputii;
	    p=p0(:,net.inputii);
	    w=mlp2pak(net);
	  else
            % reject
	    net=netold;
	  end
        end
      end
    end
    % ------------------ end sample inputs -------------------------
    
    % Sample weights with hmc
    w = mlp2pak(net);
    [w, energies, diagn] = hmc2(fe, w, opt.hmc_opt, fg, net, p, t);
    rstate=hmc2('state');
    rejs=rejs+diagn.rej;
    w=w(end,:);
    
    net = mlp2unpak(net, w);
    
    if opt.gibbs
      % Sample hyperparameters with Gibbs sampling
      for j=1:length(net.p.w)
	pw=net.p.w{j};
	net.p.w{j}=gibbs(pw, reshape(w(pw.ii),size(pw.ii)));
      end
    end 
    
    if isfield(net,'inputii')
      net0.inputii=net.inputii;
      net0.w1(net.inputii,:)=net.w1;
      net0.b1=net.b1;
      net0.w2=net.w2;
      net0.b2=net.b2;
      net0.p.w{1}.a.s(net.inputii)=net.p.w{1}.a.s;
      net0.p.w{1}.p.s.a.s=net.p.w{1}.p.s.a.s;
      net0.p.w{1}.p.s.a.nu=net.p.w{1}.p.s.a.nu;
      net0.p.w{2}.a.s=net.p.w{2}.a.s;
      net0.p.w{3}.a.s=net.p.w{3}.a.s;
      net0.p.w{4}.a.s=net.p.w{4}.a.s;
    else
      net0=net;
    end
      
  end 
  % ---------- for l=1:opt.repeat ------------------------------
  
  %% Record
  ri=ri+1;
  rec=recappend(rec, ri, net0, p, t, pp, tt, rejs/opt.repeat);
  rec.rstate(ri,1)=rstate;
	      
  if opt.display
    % Be verbose
    fprintf(' ');
    fprintf('%4d  ',ri);
    fprintf('%.3f  ',rec.etr(ri,1));
    if ~isempty(pp)
      fprintf('%.3f  ',rec.etst(ri,1));
    end
    fprintf(' ');
    fprintf(' ');
    fprintf('%.1e',rec.rejects(ri));
    fprintf('\n');
  end 
    
 
end 
% -------- for k=1:opt.nsamples ---------------------------- 
net=net0;

function rec = recappend(rec, ri, net, p, t, pp, tt, rejs)
% RECAPPEND - Record append
%          Description
%          REC = RECAPPEND(REC, RI, NET, P, T, PP, TT, REJS) takes
%          old record REC, record index RI, training data P, target
%          data T, test data PP, test target TT and rejections
%          REJS. RECAPPEND returns a structure REC containing following
%          record fields of:
%
%          type                - Type of networks 'mlp2';
%          numInputs           - Number of inputs
%          numLayers           - Number of layers
%          numHidden           - Number of hidden unit weights
%          numOutputs          - Number of outputs
%          inputHiddenHyper    - sigma for hyperparameters of weights
%                                from input to hidden layer
%          inputHiddenHyperNus - Nu for hyperparameters of weights
%                                from input to hidden layer 
%          inputHiddenSigma    - sigmas for weights from input to
%                                hidden layer
%          inputHiddenNus      - Nus for weights from input to
%                                hidden layer
%          hiddenOutputHyper   - sigma for hyperparameters of weights
%                                from hidden layer to output
%          hiddenOutputSigma   - sigmas for weights from hidden layer
%                                to output
%          hiddenOutputNus     - Nus for weights from hiddenlayer to
%                                output 
%          hiddenBiasSigma     - sigmas for hidden layer biases
%          outputBiasSigma     - sigmas for output biases
%          inputii             - inputii's for input variable selection
%          noiseHyper          - sigma for hyperparameters of noise
%                                distribution 
%          noiseSigmas         - sigmas for noise distributions
%          noiseNus            - Nus for noise distributions
%          inputWeights        - inputweights
%          inputBiases         - inputbiases
%          layerWeights        - layerweights
%          layerBiases         - layerbiases
%          rejects             - rejection rate
%          etr                 - training error 
%          etst                - test error
%          
%          every record field is a matrix containing the recorded
%          information from an iteration i in its row i.

% record for hyperparameters of weights from input to hidden layer
if isfield(net.p.w{1}.p,'s') & isfield(net.p.w{1}.p.s,'p')
  rec.inputHiddenHyper(ri,:)=net.p.w{1}.p.s.a.s;
  if isfield(net.p.w{1}.p.s.p,'nu')
    rec.inputHiddenHyperNus(ri,:)=net.p.w{1}.p.s.a.nu(:)';
  else
    rec.inputHiddenHyperNus=[];
  end
else
  rec.inputHiddenHyper=[];
end

% record for sigmas/Nus of weights from input to hidden layer
rec.inputHiddenSigmas(ri,:)=net.p.w{1}.a.s(:)';
if isfield(net.p.w{1}.p,'nu')
  rec.inputHiddenNus(ri,:)=net.p.w{1}.a.nu(:)';
end

% record for hyperparameters of weights from hidden layer to output
if isfield(net.p.w{3}.p,'s') & isfield(net.p.w{3}.p.s,'p')
  rec.hiddenOutputHyper(ri,:)=net.p.w{3}.p.s.a.s;
else
  rec.hiddenOutputHyper=[];
end

% record for sigmas/Nus of weights from hidden layer to output 
rec.hiddenOutputSigmas(ri,:)=net.p.w{3}.a.s(:)';
if isfield(net.p.w{3}.p,'nu')
  rec.hiddenOutputNus(ri,:)=net.p.w{3}.a.nu(:)';
end

% record for hidden and output biases
rec.hiddenBiasSigma(ri,:)=net.p.w{2}.a.s(:)';
rec.outputBiasSigma(ri,:)=net.p.w{4}.a.s(:)';

% record for inputii
if isfield(net,'inputii')
  rec.inputii(ri,:)=net.inputii;
end

% record for all weights and biases
rec.inputWeights(ri,:)=reshape(net.w1',1,net.nin*net.nhid);
rec.inputBiases(ri,:)=net.b1;
rec.layerWeights{1}(ri,:)=reshape(net.w2',1,net.nhid*net.nout);
rec.layerBiases{1}(ri,:)=net.b2;

% record of number of rejections
rec.rejects(ri,1)=rejs;


if isfield(net,'inputii')
  net.nin=sum(net.inputii);
end
net.nwts=(net.nin+1)*net.nhid+(net.nhid+1)*net.nout;
if isfield(net,'inputii')
  net.w1=net.w1(net.inputii,:);
end
g=mlp2c_sim(net,p);[g,gi]=max(g');
n=length(t);

% Train error calculation
rec.etr(ri,1)=1-mean(t(sub2ind([n net.nout],1:n,gi))==1);

% Test error calculation
if ~isempty(pp)
  if isfield(net,'inputii')
    pp=pp(:,net.inputii);
  end
  g=mlp2c_sim(net,pp);[g,gi]=max(g');%g=gi';
  n=length(tt);
  rec.etst(ri,1)=1-mean(t(sub2ind([n net.nout],1:n,gi))==1);
end
