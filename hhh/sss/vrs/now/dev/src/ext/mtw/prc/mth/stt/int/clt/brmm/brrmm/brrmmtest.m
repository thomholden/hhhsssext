function brrmmtest()
%BRRMMTEST    Bayesian robust simplicial mixture model test script
%   
%   This routine tests the capabilities of the BRRMM on synthetic data. It
%   generates a set of input-output data from a BRRMM with unknown
%   parameters and, from these data, it estimates the parameters of the
%   model responsible for generating them.
%   
%   Copyright (c) 2014 Gabriel Agamennoni.

% Specify the number of inputs and outputs, the number of non-linear
% effects, mixture components and the number of points.
nin=2;
nout=5;
neff=5;
ncomp=3;
npoint=500;

% Set the parameters for generating the model. These parameters control the
% variability of the mode hyper-parameters. Increasing a parameter makes
% the corresponding hyper-parameters more and more similar across different
% mixture components, resulting in a higher overlap.
param.prop=5;
param.gain=1/5;
param.noise=5;

% Set the equivalent number of observations for sampling. This value should
% be faily high to ensure that the simulated parameters are close to the
% generated hyper-parameters. It has no effect on the results.
nobs=500;

% Set the number of degrees of freedom. Increasing the number of degrees of
% freedom decreases the percentage of outliers in the data.
ndeg=5;

% Print a header and display the status.
fprintf('\n')
fprintf('Generating data ... ')

% Generate a set of random hyper-parameters for sampling.
[prop,gain,noise]=genparam(param,nin,nout,ncomp);

% Create a Bayesian robust regression mixture model object for simulation.
obj=brrmm(nin,nout,neff,ncomp);

% Generate the non-linear effects.
eff=randn(neff,ncomp);

% Specify the non-linear part of the model. The non-linear part consists of
% a parametric function, where the parameterization is controlled by the
% component-specific effects.
obj.fun=genfun(nin,nout,neff,ncomp);
obj.eff=eff;

% Set the model hyper-parameters. Use the equivalent number of observations
% to ensure that the simulated parameters are close to the hyper-parameters
% generated earlier.
obj.prop=prop;
obj.stren=nobs;
obj.gain=gain;
obj.scale=repmat((nobs/ncomp)*eye(nin),[1,1,ncomp]);
obj.noise=noise;
obj.shape(:)=max(nobs/ncomp,nout);

% Generate a set of random input data.
in=rand(nin,npoint)-1/2;

% Feed these inputs to the model. Simulate a set of model parameters and,
% with these parameters, generate a set of output data.
[~,~,out]=obj.sim(in,'ndeg',ndeg);

% Update the status.
fprintf('Done\n')
fprintf('Estimating model ... ')

% Create a new object for estimation.
obj=brrmm(nin,nout,neff,ncomp);

% Set the non-linear part of the model. Initialize the effects randomly.
obj.fun=genfun(nin,nout,neff,ncomp);
obj.eff=randn(neff,ncomp);

% Estimate the model parameters and component probabilities. This is where
% the numerical heavy-lifting occurs. The estimation algorithm approximates
% the posterior distributions over model parameters and hidden variables,
% given the input-output data. Upon convergence, the BRRMM object will
% contain the parameter posteriors. Estimation may take a while, depending
% on the size of the problem.
[obj,bound,comp]=obj.estim(in,out,'ndeg',ndeg);

% Update the status.
fprintf('Done\n')
fprintf('Plotting results ... ')

% Close existing figures to avoid build-up.
close('all')

% Display the learning results. As a sanity check, plot the lower bound on
% the marginal log-likelihood of the data, also known as the model
% evidence. The bound should be monotonically increasing.
boundplot(bound)

% Display the clustering results. Create a matrix of scatter plots and plot
% each input dimension against each output dimension, and color the data
% according to their component probabilities. Data corresponding to the
% same component may be colored differently. This is because the color of
% each individual point is calculated as a convex combination of colors,
% with the coefficients given by the component probabilities.
scatterplot(in,out,comp.prob)

% Update the status and print a footer.
fprintf('Done\n')
fprintf('\n')

end



function [prop,gain,noise]=genparam(param,nin,nout,ncomp)

% Generate the proportion hyper-parameters.
prop=randg(param.prop,ncomp);
prop=prop/sum(prop);

% Generate the gain hyper-parameters.
gain=randn(nout,nin,ncomp)/param.gain;

% Allocate space for the remaining hyper-parameters.
noise=zeros(nout,nout,ncomp);

% Generate the noise hyper-parameters.
for i=1:ncomp
    fact=randn(nout,nout+param.noise)/sqrt(nout+param.noise);
    noise(:,:,i)=fact*fact';
end

end



function handle=genfun(~,nout,neff,~)

% Set amplitude.
amp=20;

% Return function handle.
handle=@fun;

    function [val,deriv]=fun(eff,in)
        
        % Store size.
        [~,npoint]=size(in);
        
        % Allocate space.
        val=zeros(nout,npoint);
        deriv=zeros(nout,neff,npoint);
        
        % Evaluate function and derivatives.
        for i=1:min(nout,neff)
            aux=exp(-log1p(exp(-eff(i))));
            val(i,:)=amp*(aux-1/2);
            deriv(i,i,:)=amp*aux*(1-aux);
        end
        
    end

end



function boundplot(bound)

% Create a figure.
handle.fig=figure(...
    'NumberTitle','off',...
    'Name','Variational Lower Bound');

% Create a pair of axes.
handle.axis=axes(...
    'Parent',handle.fig,...
    'NextPlot','add',...
    'Box','on',...
    'Layer','top',...
    'FontName','times',...
    'FontSize',12);

% Annotate the axes with a title and labels.
set(get(handle.axis,'XLabel'),...
    'String','Iteration',...
    'FontName','times',...
    'FontSize',12)
set(get(handle.axis,'YLabel'),...
    'String',{'Variational lower bound on the',...
        'marginal log-likelihood of the data'},...
    'FontName','times',...
    'FontSize',12)
set(get(handle.axis,'Title'),...
    'String','Variational lower bound',...
    'FontName','times',...
    'FontSize',12)

% Plot the variational lower bound at each iteration.
line(...
    'Parent',handle.axis,...
    'XData',1:numel(bound),...
    'YData',bound,...
    'Color','b',...
    'LineWidth',2,...
    'Marker','.',...
    'MarkerSize',15)

% Adjust the axis limits.
set(handle.axis,...
    'XLim',[0,numel(bound)+1])

end



function scatterplot(in,out,prob)

% Set the options for plotting.
ncolor=50;
margin=1/5;
fact=1/5;
dilut=1/2;

% Store the number of inputs and outputs, and the number of mixture
% components.
[nin,~]=size(in);
[nout,~]=size(out);
[ncomp,~]=size(prob);

% Build a color palette by quantizing colors.
palette=hsv(ncomp);
warn=warning('Off','stats:kmeans:EmptyCluster');
[ind,color]=kmeans(prob'*palette,ncolor,...
    'Distance','cityblock',...
    'EmptyAction','drop',...
    'OnLinePhase','off');
warning(warn)

% Create a figure.
handle.fig=figure(...
    'NumberTitle','off',...
    'Name','Component Probabilities');

% Create a pair of invisible axes.
handle.axis=axes(...
    'Parent',handle.fig,...
    'Position',[(1-fact)*margin/2,(1-fact)*margin/2,...
        1-(1-fact)*margin,1-(1-fact)*margin],...
    'Visible','off');

% Add the title to the axes.
set(get(handle.axis,'Title'),...
    'String','Clustering results',...
    'FontName','times',...
    'FontSize',12,...
    'Visible','on')
set(get(handle.axis,'XLabel'),...
    'String','Outputs',...
    'FontName','times',...
    'FontSize',12,...
    'Visible','on')
set(get(handle.axis,'YLabel'),...
    'String','Inputs',...
    'FontName','times',...
    'FontSize',12,...
    'Visible','on')

% Allocate space for the axis handles.
handle.axis=zeros(nin,nout);

% Pre-compute the axis dimensions.
height=(1-margin)/nin; 
width=(1-margin)/nout;

% Plot the data.
vert=1-margin/2-height; 
for i=1:nin
    horiz=margin/2;
    for j=1:nout
        
        % Create a pair of axes.
        handle.axis(i,j)=axes(...
            'Parent',handle.fig,...
            'Units','normalized',...
            'Position',[horiz,vert,width,height],...
            'NextPlot','add',...
            'Box','on',...
            'Layer','top',...
            'FontName','times',...
            'FontSize',12);
        
        % Adjust the tick labels.
        if i==1&&nin>1
            set(handle.axis(i,j),...
                'XAxisLocation','top')
        elseif i<nin
            set(handle.axis(i,j),...
                'XTickLabel',{})
        end
        if j==nout&&nout>1
            set(handle.axis(i,j),...
                'YAxisLocation','right')
        elseif j>1
            set(handle.axis(i,j),...
                'YTickLabel',{})
        end
        
        % Plot the data.
        for k=1:ncolor
            line(...
                'Parent',handle.axis(i,j),...
                'XData',in(i,ind==k),...
                'YData',out(j,ind==k),...
                'Color',(1-dilut)*color(k,:)+...
                    dilut*get(handle.axis(i,j),'Color'),...
                'LineWidth',2,...
                'LineStyle','none',...
                'Marker','.',...
                'MarkerSize',10)
        end
        
        % Update horizontal position.
        horiz=horiz+width;
        
    end
    vert=vert-height;
end

end