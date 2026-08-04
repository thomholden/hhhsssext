function [rec, gp0, rstate] = gp2r_mc(opt, gp, p, t, pp, tt, rec, rstate)
% GP2R_MC   Monte Carlo sampling for model GP2R
%
%   rec = mlp2r_mc(opt, gp, p, t, pp, tt, rec)
%     gp      - gp
%     opt     - options, see below
%     p       - train data
%     t       - train targets
%     pp      - test data (optional)
%     tt      - test targets (optional)
%     rec     - record to continue (optional)
%     rstate  - state of the random generator
%   Returns:
%     rec     - record including hyper-parameters and errors
%     gp      - gp
%     rstate  - state of the random generator
%
%   Set default options for GPRMC
%    opt=gp2r_mc;
%      return default options
%    opt=gp2r_mc(opt);
%      fill empty options with default values
%
%   The options and defaults are
%   nsamples (100)
%     the number of samples retained from the Markov chain
%   repeat (1)
%     the number of iterations of basic updates
%   gibbs (0)
%     1 to sample sigmas with gibbs sampling
%   persistence_reset (0)
%     1 to reset persistence after every repeat iterations
%   display (1)
%     1 to display miscallenous data
%     2 to display more miscallenous data
%   plot (1)
%     1 to plot miscallenous data
%

% Copyright (c) 1998-2000 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

% Check arguments
if nargin < 4
  error('Not enough arguments')
end

% Set empty options to default values
opt=gp2_mcopt(opt);

% Use function handles
me=str2fun('gp2r_e');
mg=str2fun('gp2r_g');
de=str2fun('gp2r_de');
if opt.sample_variances & ~isempty(gp.p.noiseSigmas)
  noisef=str2fun(['cond_' gp.f '_' gp.p.noiseSigmas.f]);
end

% Test data?
if nargin < 6 | isempty(pp)
  pp=[];tt=[];
end

gp.slrej=0;
p0=p;
pp0=pp;
gp0=gp;
% If inputs are sampled initialize parameters
if isfield(gp,'inputii')
  gp.nin=sum(gp.inputii);
  if length(gp0.expSigmas)>1
    gp.expSigmas=gp0.expSigmas(gp.inputii);
  else
    gp.expSigmas=gp0.expSigmas(gp.inputii);
  end
  p=p0(:,gp.inputii);
  if ~isempty(pp)
    pp=pp0(:,gp.inputii);
  end  
end

% Initialize record
if nargin < 7 | isempty(rec)
  % No old record
  rec.type=gp.type;
  rec.numInputs=gp0.nin;
  rec.numOutputs=gp0.nout;
  ri=1;
  rec=recappend(rec, ri, gp0, p, t, pp, tt, 0);
  rec=recappend(rec, ri+opt.nsamples, gp0, p, t, pp, tt, 0);
else
  ri=size(rec.rejects,1);
  rec=recappend(rec, ri+opt.nsamples, gp0, p, t, pp, tt, 0);
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
  ebase=sqrt(mean(mean((tt-repmat(mean(t),length(tt),1)).^2)));
else
  ebase=NaN;
end

% Get hyperparameter vector
w = gp2pak(gp);

if opt.display
  % Be verbose
  fprintf(' ');
  fprintf('cycle ');
  fprintf('etr    ');
  if ~isempty(pp)
    fprintf('etst   ');
  end
  fprintf('sigma  ');
  if isfield(rec,'noiseNus') & ~isempty(rec.noiseNus)
    fprintf('nu  ');
  end
  if isfield(rec,'lambda') & ~isempty(rec.lambda)
    fprintf('a   ');
  end
  fprintf('rej   ');
  fprintf('\n');
end

psi=0.5;
if isfield(opt,'sample_inputs')
  if isfield(opt,'psample_inputs')
    psi=opt.psample_inputs;
  end
end

% -------------- Start sampling ----------------------------
for k=1:opt.nsamples
  
  if opt.persistence_reset
    rstate=hmc2('state');
    rstate.mom=[];
    hmc2('state',rstate);
  end
  
  rejs = 0;
  for l=1:opt.repeat
    
    % ------------------- Sample inputs with RJMCMC --------------------------
    if isfield(opt,'sample_inputs') & opt.sample_inputs==1
      % pick random input and change its state, here:
      % k           is the number of input variables on the model.
      % pswitch     is the probability of switching the states of two inputs
      % lpk         is the log prior of k
      % gp.inputii  is the (logical) index array showing the inputs that are on
      while psi>rand(1)
	if isfield(opt,'rj_opt') & isfield(opt.rj_opt,'pswitch')
	  pswitch=opt.rj_opt.pswitch;
	else
	  pswitch=1/3;
	end
	lpk=opt.rj_opt.lpk;
	w=gp2pak(gp);
	gpold=gp;
	k=sum(gp.inputii);
        
        % select one input variable randomly and switch its state
	ci=intrand([1 length(gp.inputii)]);
	if k==gp0.nin | pswitch==0 | rand(1)>pswitch
	  if gp.inputii(ci)==1
            % case death, remove one input.
            % evaluate the error for k inputs
	    [foo,e]=feval(me, w, gp, p, t);
            if k==gp0.nin
              e=e-lpk(k)+log(gp0.nin);
            else
              e=e-lpk(k)-log(1-pswitch)+log(gp0.nin);
            end
            % evaluate the error for k-1 inputs
            % first create new gp, from which the ci:th input is removed
	    gp.inputii(ci)=0;
	    gp.nin=gp.nin-1;
            if length(gp0.expSigmas)>1
              % if ARD is used remove the expSigma connecting to ci:th input
              gp.expSigmas=gp0.expSigmas(gp.inputii);
            else
              gp.expSigmas=gp0.expSigmas;
            end
	    [foo,ed]=feval(me, gp2pak(gp), gp, p0(:,gp.inputii), t);
            if k==2
              ed=ed -lpk(k-1)-log(1-pswitch)+log(gp0.nin-1);
            else
              ed=ed -lpk(k-1)-log(1-pswitch)+log(gp0.nin);
            end
            
            % Evaluate the acceptance ratio
	    a=e-ed;
	    if exp(a) > rand(1)
	      % accept
	      if isfield(opt,'lab')
		fprintf('Removed input %2d: %s -> k=%d (p=%.2f)\n',...
			ci,deblank(opt.lab(ci,:)),k-1,exp(a));
		if k-1<=10
		  disp(opt.lab(gp.inputii,:))
		end
	      else
		fprintf('Removed input %2d: -> k=%d (p=%.2f)\n', ci, k-1, exp(a));
	      end
	      gp0.inputii=gp.inputii;
	      p=p0(:,gp.inputii);
	      w=gp2pak(gp);
	    else
	      gp=gpold;
	    end
	  else
            % case birth, add one input
            % first find new sample to give birth if k=1
            if k==1
              ci=randpick(find(~gp.inputii));
            end
            % evaluate the error of k inputs
	    [foo,e]=feval(me, w, gp, p, t);
            if k==1
              e=e - lpk(k)-log(1-pswitch)+log(gp0.nin-1);
            else
              e=e - lpk(k)-log(1-pswitch)+log(gp0.nin);
            end

            % evaluate the error of k+1 inputs
            % first create new gp, in which ci:th input is added
	    gp.inputii(ci)=1;
	    gp.nin=gp.nin+1;
            if length(gp0.expSigmas)>1
              % if ARD is used add the expSigma connecting to ci:th input and evaluate
              % the proposal value for it
              gp.expSigmas=gp0.expSigmas(gp.inputii);
              cci=sum(gp.inputii(1:ci));
              gp.expSigmas(cci)=sqrt(invgamrand(gp.p.expSigmas.a.s.^2,gp.p.expSigmas.a.nu));
            else
              gp.expSigmas=gp0.expSigmas;
            end
            % evaluate the error
	    [foo,ed]=feval(me, gp2pak(gp), gp, p0(:,gp.inputii), t);
            if k == gp0.nin - 1
              ed=ed - lpk(k+1)+log(gp0.nin);
            else
              ed=ed - lpk(k+1)+log(gp0.nin)-log(1-pswitch);
            end
            
            % evaluate the acceptance ratio
	    a=e-ed;
	    if exp(a) > rand(1)
	      % accept
	      if isfield(opt,'lab')
		fprintf('Added input %2d: %s -> k=%d (p=%.2f)\n',...
			ci,deblank(opt.lab(ci,:)),k+1,exp(a));
		if k+1<=10
		  disp(opt.lab(gp.inputii,:))
		end
	      else
		fprintf('Added input %2d: -> k=%d (p=%.2f)\n', ci,k+1,exp(a));
	      end
	      gp0.inputii=gp.inputii;
	      p=p0(:,gp.inputii);
	      w=gp2pak(gp);
	    else
	      gp=gpold;
	    end
	  end
	else
          % case switch, switch the states of two random inputs while maintaining 
          % same number of active input variables. 
          % First choose the inputs to switch
	  if gp.inputii(ci)==1
	    pii=find(~gp.inputii);
	    ci2=pii(intrand([1 length(pii)]));
	  else
	    pii=find(gp.inputii);
	    ci2=ci;
	    ci=pii(intrand([1 length(pii)]));
	  end
          % evaluate the error of old gp
	  [foo,e]=feval(me, w, gp, p, t);
          
          % create the new gp, in which the states of two inputs are changed
	  gp.inputii(ci)=~gp.inputii(ci);
	  gp.inputii(ci2)=~gp.inputii(ci2);
          if length(gp0.expSigmas)>1
            gp.expSigmas=gp0.expSigmas(gp.inputii);
            cci=sum(gp.inputii(1:ci2));
            gp.expSigmas(cci)=sqrt(invgamrand(gp.p.expSigmas.a.s.^2,gp.p.expSigmas.a.nu));
          else
            gp.expSigmas=gp0.expSigmas;
          end
          % evaluate the error of new gp
	  [foo,ed]=feval(me, gp2pak(gp), gp, p0(:,gp.inputii), t);
          
          % evaluate the acceptance ratio
	  a=e-ed;
	  if exp(a) > rand(1)
	    % accept
	    if isfield(opt,'lab')
	      fprintf('Switched input %2d %s to %2d: %s (p=%.2f)\n',...
		      ci,deblank(opt.lab(ci,:)),ci2,deblank(opt.lab(ci2,:)),exp(a));
	      if k<=10
		disp(opt.lab(gp.inputii,:))
	      end
	    else
	      fprintf('Switched input %2d to %2d: (p=%.2f)\n', ci,ci2,exp(a));
	    end
	    gp0.inputii=gp.inputii;
	    p=p0(:,gp.inputii);
	    w=gp2pak(gp);
	    rstate=hmc2('state');
	    rstate.mom=[];
	    hmc2('state',rstate);
	  else
	    gp=gpold;
	  end
	end
      end % while psi 
    elseif isfield(opt,'sample_inputs') & opt.sample_inputs==2
      % randomly add or remove one input.
      % k           is the number of input variables on the model.
      % pswitch     is the probability of switching the states of two inputs
      % pdeath      is the probability of removing on einput
      % lpk         is the log prior of k
      % gp.inputii  is the (logical) index array showing the inputs that are on
      while psi>rand(1)
	if isfield(opt,'rj_opt') & isfield(opt.rj_opt,'pswitch')
	  pswitch=opt.rj_opt.pswitch;
	else
	  pswitch=1/3;
	end
        w=gp2pak(gp);
        pdeath = opt.rj_opt.pdeath;
        pbirth=1-pdeath;
        lpk=opt.rj_opt.lpk;
	gpold=gp;
	k=sum(gp.inputii);

        % randomly add or remove one input variable
	if k==gp0.nin | pswitch==0 | rand(1)>pswitch
	  if (k==gp0.nin | pdeath>=rand(1)) & k > 1
            % death
            ci=randpick(find(gp.inputii));
            % evaluate the error of old gp
            [foo,e]=feval(me, w, gp, p, t);
            if k==gp0.nin
              e=e -lpk(k)+log(k);
            else
              e=e -lpk(k)-log(1-pswitch)-log(pdeath)+log(k);
            end

	    % k-1
	    gp.inputii(ci)=0;
	    gp.nin=gp.nin-1;
            if length(gp0.expSigmas)>1
              gp.expSigmas=gp0.expSigmas(gp.inputii);
            else
              gp.expSigmas=gp0.expSigmas;
            end
            % evaluate the error of new gp
	    [foo,ed]=feval(me, gp2pak(gp), gp, p0(:,gp.inputii), t);
            if k==2
              ed=ed -lpk(k-1)-log(1-pswitch)+log(gp0.nin-1);
            else
              ed=ed -lpk(k-1)-log(1-pswitch)-log(pbirth)+log(gp0.nin-(k-1));
            end            
            % evaluate the acceptance ratio
	    a=e-ed;
	    if exp(a) > rand(1)
	      % accept
	      if isfield(opt,'lab')
		fprintf('Removed input %2d: %s -> k=%d (p=%.2f)\n',...
			ci,deblank(opt.lab(ci,:)),k-1,exp(a));
		if k-1<=10
		  disp(opt.lab(gp.inputii,:))
		end
	      else
		fprintf('Removed input %2d: -> k=%d (p=%.2f)\n', ci, k-1, exp(a));
	      end
	      gp0.inputii=gp.inputii;
	      p=p0(:,gp.inputii);
	      w=gp2pak(gp);
	    else
	      gp=gpold;
	    end
	  else
            % case birth
            ci=randpick(find(~gp.inputii));
            % evaluate the error of old gp
	    [foo,e]=feval(me, w, gp, p, t);
            if k==1
              e=e -lpk(k)-log(1-pswitch)+log(gp0.nin-k);
            else
              e=e -lpk(k)-log(1-pswitch)-log(pbirth)+log(gp0.nin-k);
            end

	    % evaluate the error of k+1
	    gp.inputii(ci)=1;
	    gp.nin=gp.nin+1;
            if length(gp0.expSigmas)>1
              % if ARD is used add the expSigma connecting to ci:th input and evaluate
              % the proposal value for it
              gp.expSigmas=gp0.expSigmas(gp.inputii);
              cci=sum(gp.inputii(1:ci));
              gp.expSigmas(cci)=sqrt(invgamrand(gp.p.expSigmas.a.s.^2,gp.p.expSigmas.a.nu));
            else
              gp.expSigmas=gp0.expSigmas;
            end
            % evaluate the error of new gp
	    [foo,ed]=feval(me, gp2pak(gp), gp, p0(:,gp.inputii), t);
            if k == gp0.nin-1
              ed=ed -lpk(k+1)+log(gp0.nin);
            else
              ed=ed -lpk(k+1)-log(1-pswitch)-log(pdeath)+log(k+1);
            end
            % evaluate the acceptance ratio
	    a=e-ed;
	    if exp(a) > rand(1)
	      % accept
	      if isfield(opt,'lab')
		fprintf('Added input %2d: %s -> k=%d (p=%.2f)\n',...
			ci,deblank(opt.lab(ci,:)),k+1,exp(a));
		if k+1<=10
		  disp(opt.lab(gp.inputii,:))
		end
	      else
		fprintf('Added input %2d: -> k=%d (p=%.2f)\n', ci,k+1,exp(a));
	      end
	      gp0.inputii=gp.inputii;
	      p=p0(:,gp.inputii);
	      w=gp2pak(gp);
	    else
	      gp=gpold;
	    end
	  end
	else
          % case switch. switch the states of two random inputs.
          % First choose the inputs to switch
          ci=intrand([1 gp0.nin]);
	  if gp.inputii(ci)==1
	    ci2=randpick(find(~gp.inputii));
	  else
	    ci2=ci;
	    ci=randpick(find(gp.inputii));
	  end
          % evaluate the error of old gp
	  [foo,e]=feval(me, w, gp, p, t);
	  gp.inputii(ci)=~gp.inputii(ci);
	  gp.inputii(ci2)=~gp.inputii(ci2);
          if length(gp0.expSigmas)>1
            gp.expSigmas=gp0.expSigmas(gp.inputii);
            cci=sum(gp.inputii(1:ci2));
            gp.expSigmas(cci)=sqrt(invgamrand(gp.p.expSigmas.a.s.^2,gp.p.expSigmas.a.nu));
          else
            gp.expSigmas=gp0.expSigmas;
          end
          % evaluate the error of new gp
	  [foo,ed]=feval(me, gp2pak(gp), gp, p0(:,gp.inputii), t);
          % acceptance ratio
	  a=e-ed;
	  if exp(a) > rand(1)
	    % accept
	    if isfield(opt,'lab')
	      fprintf('Switched input %2d %s to %2d: %s (p=%.2f)\n',...
		      ci,deblank(opt.lab(ci,:)),ci2,deblank(opt.lab(ci2,:)),exp(a));
	      if k<=10
		disp(opt.lab(gp.inputii,:))
	      end
	    else
	      fprintf('Switched input %2d to %2d: (p=%.2f)\n', ci,ci2,exp(a));
	    end
	    gp0.inputii=gp.inputii;
	    p=p0(:,gp.inputii);
	    w=gp2pak(gp);
	    rstate=hmc2('state');
	    rstate.mom=[];
	    hmc2('state',rstate);
	  else
	    gp=gpold;
	  end
	end
      end % while psi 
    end
    % --------------------- end sample inputs ------------------------------------
    
    % Sample hyperparameters with hmc
    w = gp2pak(gp);
    [w, energies, diagn] = hmc2(me, w, opt.hmc_opt, mg, gp, p, t);
    rstate=hmc2('state');
    rejs=rejs+diagn.rej;
    w=w(end,:);
    
    % sample latent values in order to be able to sample variances
    gp = gp2unpak(gp, w);
    [gl,invC]=gpvalues(gp, p, t);
    r=gl-t;
    
    % Sample variances
    if opt.sample_variances & ~isempty(gp.p.noiseSigmas)
      gp.noiseSigmas=feval(noisef, [], gp, gp.p.noiseSigmas.a, r');
      switch gp.f
       case 'norm'
	gp.noiseVariances=gp.noiseSigmas.^2;
       case 'gnorm'
	ii=gp.ii;
	for i=1:length(ii)
	  gp.noiseVariances(ii{i})=gp.noiseSigmas(i).^2;
	end
       otherwise
	error('Unknown function...');
      end
    end
    
    if isfield(gp,'inputii')
      gptmp=gp0;
      gp0=rmfield(gp,'expSigmas');
      gp0.nin=gptmp.nin;
      gp0.expSigmas=gptmp.expSigmas;
      gp0.expSigmas(gp.inputii)=gp.expSigmas;
    else
      gp0=gp;
    end

  end % for l=1:opt.repeat

	  
  %% Record
  ri=ri+1;
  rec=recappend(rec, ri, gp0, p, t, pp, tt, rejs/opt.repeat, gl, invC);
  rec.rstate(ri,1)=rstate;
	      
  if opt.display
    % Be verbose
    fprintf(' ');
    fprintf('%4d  ',ri);
    fprintf('%.3f  ',rec.etr(ri,1));
    if ~isempty(pp)
      fprintf('%.3f  ',rec.etst(ri,1));
    end
    if ~isempty(gp.noiseVariances)
      switch gp.f
       case 'norm'
	fprintf('%.2f ',rec.noiseHyper(ri,:));
       case 'gnorm'
	fprintf('%.2f ',rec.noiseSigmas(ri,:));
       otherwise
	error('Uknown function...');
      end
    elseif ~isempty(gp.noiseSigmas)
      fprintf('%.2f ',rec.noiseSigmas(ri,:));
    else
      fprintf('   ');
    end
    fprintf(' ');
    if isfield(rec,'noiseNus') & ~isempty(rec.noiseNus)
      fprintf('%.1f ',rec.noiseNus(ri,:));
    end
    if isfield(rec,'lambda') & ~isempty(rec.lambda)
      fprintf('%.0f ',rec.lambda(ri));
    end
    fprintf(' ');
    fprintf('%.1e',rec.rejects(ri));
    fprintf('\n');
  end % if opt.display  
end

function rec = recappend(rec, ri, gp, p, t, pp, tt, rejs, gl, invC)
% RECAPPEND - Record append
%          Description
%          REC = RECAPPEND(REC, RI, GP, P, T, PP, TT, REJS, GL, INVC) takes
%          old record REC, record index RI, training data P, target
%          data T, test data PP, test target TT and rejections
%          REJS. RECAPPEND returns a structure REC containing following
%          record fields of:
%
%          type                - type of Gaussian proses 'gp'
%          numInputs           - number of inputs
%          numOutputs          - number of outputs
%          constSigmas         - logarithm of constant offset
%                                in covariance function
%          linearHyper         - Hyperparameter for logarithm of
%                                linear term in covariance function 
%          linearSigmas        - logarithm of linear term in 
%                                covariance function
%          jitterSigmas        - logarithm of jitter term in 
%                                covariance function
%          expHyper            - Hyperparameter for parameters in
%                                exponential part of covariance function
%          expHyperNu          - Nu for hyperparameter above
%          expSigmas           - logarithm of length scale for each input
%          expScale            - logarithm of general scale for exponential 
%                                part
%          inputii             - inputii's for input variable selection
%          noiseHyper          - standard deviation for hyper-parameter
%                                of residual model
%          noiseHyperHyper     - standard deviation for hyper-parameter
%                                of parameter above
%          noiseSigmas         - Scale of residual distribution
%                                standard deviation for normal distribution 
%                                Degrees of freedom for t-distribution
%          noiseNus            - Nu for hyper-parameter of residual model
%          noiseNusHyper       - Hyperparameter for Nu above
%          noiseVariances      - Individual variance for each data
%                                point, used in covariable
%                                dependent groupped noise model  
%          latentValues        - Latent values
%          k                   - number of inputs in input variable selection
%          etr                 - Train error
%          e                   - Residual
%          edata               - Data error
%          eprior              - Prior error
%          etst                - Test error
%          rejects             - rejection rate
%
%          every record field is a matrix containing the recorded
%          information from an iteration i in its row i.

gpp=gp.p;
if ~isempty(gp.constSigmas)
  rec.constSigmas(ri,:)=gp.constSigmas;
elseif ri==1
  rec.constSigmas=[];
end
if ~isempty(gp.linearSigmas)
  if ~isempty(gpp.linearSigmas)
    rec.linearHyper(ri,:)=gpp.linearSigmas.a.s;
  elseif ri==1
    rec.linearHyper=[];
  end
  rec.linearSigmas(ri,:)=gp.linearSigmas;
elseif ri==1
  rec.linearSigmas=[];
end
if ~isempty(gp.jitterSigmas)
  rec.jitterSigmas(ri,:)=gp.jitterSigmas;
elseif ri==1
  rec.jitterSigmas=[];
end
if ~isempty(gp.expSigmas)
  if ~isempty(gpp.expSigmas)
    rec.expHyper(ri,:)=gpp.expSigmas.a.s;
    if isfield(gpp.expSigmas.p,'nu')
      rec.expHyperNu(ri,:)=gpp.expSigmas.a.nu;
    end
  elseif ri==1
    rec.expHyper=[];
  end
  rec.expSigmas(ri,:)=gp.expSigmas;
  if isfield(gp,'inputii');
    rec.inputii(ri,:)=gp.inputii;
  end
elseif ri==1
  rec.expSigmas=[];
  rec.inputii=[];
end
if ~isempty(gp.expScale)
  rec.expScale(ri,:)=gp.expScale;
elseif ri==1
  rec.expScale=[];
end
if ~isempty(gp.noiseSigmas)
  if ~isempty(gpp.noiseSigmas)
    rec.noiseHyper(ri,:)=gpp.noiseSigmas.a.s;
    if ~isempty(gpp.noiseSigmas.p) & ~isempty(gpp.noiseSigmas.p.s.p)
      rec.noiseHyperHyper(ri,:)=gpp.noiseSigmas.p.s.a.s;
    end
    if ~isempty(gpp.noiseSigmas.p) ...
	  & any(strcmp(fieldnames(gpp.noiseSigmas.p),'nu'))
      rec.noiseNus(ri,:)=gpp.noiseSigmas.a.nu;
      if ~isempty(gpp.noiseSigmas.p.nu.p)
	rec.noiseNusHyper(ri,:)=gpp.noiseSigmas.p.nu.a.s;
      end
    end
  elseif ri==1
    rec.noiseHyper=[];
  end
  rec.noiseSigmas(ri,:)=gp.noiseSigmas;
elseif ri==1
  rec.noiseSigmas=[];
end
if ~isempty(gp.noiseVariances)
  rec.noiseVariances(ri,:)=gp.noiseVariances;
elseif ri==1
  rec.noiseVariances=[];
end
if nargin>8
  rec.latentValues(ri,:)=gl;
end
if isfield(gp,'inputii')
  gp.nin=sum(gp.inputii);
  rec.k(ri,:)=gp.nin;
  gp.expSigmas=gp.expSigmas(gp.inputii);
end
if nargin>9
  g=gp2fwd(gp, p, t, [], invC);
else
  g=gp2fwd(gp, p, t, []);
end
rec.etr(ri,:)=sqrt(mean(mean((g-t).^2)));
[rec.e(ri,:),rec.edata(ri,:),rec.eprior(ri,:)]=gp2r_e(gp2pak(gp), gp, p, t);
if ~isempty(pp)
  if nargin>9
%    g=gp2fwd(gp, p, t, pp, invC); Does not work!!! FIX THIS!
    g=gp2fwd(gp, p, t, pp);
  else
    g=gp2fwd(gp, p, t, pp);
  end
  rec.etst(ri,:)=sqrt(mean(mean((g-tt).^2)));
end
rec.rejects(ri,1)=rejs;
