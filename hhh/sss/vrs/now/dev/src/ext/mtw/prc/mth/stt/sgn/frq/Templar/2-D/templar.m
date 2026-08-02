% TEMPLAR
% This script implements TEMPLAR, the template learning algorithm
% described in my Master's thesis A Hierarchical Wavelet-Based Framework
% for Pattern Analysis and Synthesis, ECE Department, Rice University, May
% 2000.
%
% Inputs
%	T:	# of training data
%	N1:	# of rows
%	N2:	# of columns
%	scaling-filter:	for wavelet transform
%	J:	depth of wavelet decomposition
%	training-data: 1xT cell; each cell is N1xN2
%	shape:	shape of region of translations
%	mesh:	specifies transformations for each iteration
%
%
%	See example1.m or example2.m for usage details.
%
%
% Outputs
% 	template	a structure with fields 'states',
% 			'high_mean', 'high_var', (all arrays the size of the 
%			training data) and 'low_var', a scalar.
%	transforms:	A 3xT matrix where each column specifies the 
%			learned transform for each training image
%	template_iterances:	A cell variable whose i-th entry is the 
%				template variable on iteration i
%	transform_iterances:	A cell variable whose i-th entry is the 
%				transform variable on iteration i
%	
% While running - 
%	After every update step, TEMPLAR produces a status report of the 
%	form
%	
%	status = [a	b	c	d	e	f]
%
%	where
%		a = iteration number
%		b = penalized log-likelihood (PLL)
%		c = increment in PLL since last step
%		d = number of significant coefficients
%		e = number of transformations that changed since 
%			transforms was last updated
%		f = common variance of insignificant coefficients.
%
%
%
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice Univ.
% Author: Clay Scott (cscott@rice.edu).  See License.txt

N = N1*N2; % total number of pixels

if ~exist('initialize')
	initialize = 'tran';		% 'tran' or 'temp'
end

if ~exist('first_temp_iter')
  first_temp_iter = 2;
end

if ~exist('temp_learning_method')
  temp_learning_method = 1;	% 1 -> standard
end				% 2 -> swap s, low_var until fixed

[num_refinements,nul]=size(mesh);
scopes=cell(1,num_refinements);
for i=1:num_refinements
  scopes{i}=generate_scope(mesh(i,:),shape);	
end

if shape == 'circle'
  finest_mesh=[max(mesh(:,1)) min(mesh(:,2)) min(mesh(:,3)) ...
	max(mesh(:,4))];
else
  finest_mesh=[max(mesh(:,1)) min(mesh(:,2)) max(mesh(:,3)) ...
	min(mesh(:,4))];  
end
finest_scope=generate_scope(finest_mesh,shape);

% identity transformation only
trivial_mesh = [.5, 1, 0, 0];	
trivial_scope=generate_scope(trivial_mesh,'circle');

interp_method = 'nearest';	% only 'nearest' works for this algorithm
				% since the others distort the noise covariance
				% (making it non-diagonal)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify wavelet transform parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D1 = N1*2^(-J); D2 = N2*2^(-J);         % D1 x D2 scaling coeffs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% specify complexity penalty term
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

which_pen=1;
switch which_pen
  case 1			% MDL from paper
    log_penalty=-2*ones(1,N)*log2(N);
  case 2			% MDL, favors coarser scale coeffs
    lp=zeros(N1,N2);
    for j=0:J-1
      lp(1:N1/2^j,1:N2/2^j)=50^j;
    end
    lp=lp/sum(sum(lp));
    log_penalty=-log2(N)+log2(reshape(lp,1,N));
  case 3
    log_penalty=zeros(1,N); 	%no penalty
end

% log_penalty = -2*(0:N)*log2(N); 		% MDL
% log_penalty=zeros(1,N+1); 		% no penalty

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize TEMPLAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic, start_time = cputime;

  max_iterations=20;	% stop the madness after this many iterations, or 
  tolerance = 0; 	% stop when new_pll - old_pll is <= this amount
  old_pll=-Inf; 		% pll stands for penalized log likelihood 
  progress_chart=[];	
  time_chart=[];
 
  template=struct('states', zeros(N1,N2), ... 
		'high_mean', zeros(N1,N2), ...
		'high_var', zeros(N1,N2), ...
		'low_var', 0); 
 
  % initialize template
  if initialize == 'temp'
    template.high_mean = atomic_rep(training_data{temp_index});
    template.high_var(1:end,1:end) = ones(N1,N2);
    template.states=zeros(N1,N2);
    second_moment=(template.high_mean).^2;
    template.states(1:D1,1:D2)=ones(D1,D2); update_low_var;
    template.states=ones(N1,N2);
  else
    template.states(1:D1,1:D2)=ones(D1,D2);	% scaling coeffs not zero mean
  end

  % initialize transforms
  transforms=zeros(3,T);	% shifts and angles initialized to zero

  num_changed_transforms=T;
  num_high_states=sum(sum(template.states));

  old_states = template.states;
  old_transforms = transforms;
  locked_on = 0;		% boolean, turns to 1 when transforms don't
				% change from one iteration to the next

  figure;			% for template iterations
  template_iterances=cell(1, max_iterations); 
  transform_iterances=cell(1, max_iterations); 
  init_wavelet_data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Execute TEMPLAR - Main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for iter=1:max_iterations
    
    iter_start_time = cputime;

    % update template
    if (initialize == 'tran') | (iter >= first_temp_iter) 
      switch temp_learning_method
	case 1
	  update_marginals;		if iter > 1, display_stats; end,
	  update_low_var;		display_stats;
	  update_states;		display_stats;
          update_low_var;         	display_stats;
	case 2
	  update_steady_states;
      end
    end

    %display template
    template_iterances{iter}=spatial_mean(template);
%    if iter <= 20		
%	subplot(4,5,iter)
%	displayimagesc(template_iterances{iter})
%       pause(1)	% to give the figure a chance to refresh on the screen
%    end
    if iter <= 10		
	subplot(4,5,iter + 5*(floor(iter/6)))
	displayimagesc(template_iterances{iter})
	subplot(4,5,5 + iter + 5*(floor(iter/6)))
	displayimagesc(template.states)
       pause(1)	% to give the figure a chance to refresh on the screen
    end

    update_transforms;

    % compute the number of transformations that changed this iteration
    num_changed_transforms=length(find(max(abs(transforms-old_transforms))));

    display_stats;
    new_pll = npll;

    transform_iterances{iter} = transforms;

    %tally information about this iteration
    elapsed_iter_time = cputime-iter_start_time;
    iter_time =  round([floor(elapsed_iter_time/3600) ...
        mod(floor(elapsed_iter_time/60),60) mod(elapsed_iter_time,60)]);
    time_chart = [time_chart; iter_time];

    % check for convergence
    if  (old_transforms == transforms) & (iter >= num_refinements)
    %if  (new_pll - old_pll <= tolerance) & (iter >= num_refinements)
      	  num_iter=iter-1;
          break
   end

    if iter >= max_iterations
      warning('templar.m: tolerance not reached')
    end    

    old_pll = new_pll;
    old_transforms = transforms;
    old_states = template.states;
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tally run time, on cpu and in real life, in hours, minutes and seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
end_time = cputime-start_time;
elapsed_cpu_time = round([floor(end_time/3600) ...
	mod(floor(end_time/60),60) mod(end_time,60)])

real_end = toc;
elapsed_real_time = round([floor(real_end/3600) ...
	mod(floor(real_end/60),60) mod(real_end,60)])


clear wavelet_data	% huge variable

