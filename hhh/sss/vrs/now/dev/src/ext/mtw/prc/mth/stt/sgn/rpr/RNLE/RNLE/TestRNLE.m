function TestRNLE()
%TestRNLE    Run robust non-linear estimator on synthetic data
%   
%   This routine tests the performance of the RNLE on synthetic data. After
%   generating a sequence of input-output data, it estimates the underlying
%   state sequence via the robust non-linear estimation algorithm.
%   
%   Estimation results are plotted once per iteration. Upon convergence,
%   the routine creates a video with these plots and stores it in the same
%   directory where this test file is located.
%   
%   Copyright (c) 2013 Gabriel Agamennoni.

% Set system options.
Sigma=10;
Rho=28;
Beta=8/3;

% Set sampling options.
BurnIn=20;
SampFreq=20;
NumPoint=200;
NumStep=10;
IntegMeth='Dormand-Prince';

% Set estimation options.
FiltWindow=4;
OutParam=1;
OutType='output';
MaxIter=100;
RelTol=1e-3;
AbsTol=0.1;
RejThres=1e-4;
RedFact=.5;

% Set recording/plotting options.
FrameRate=1;
VidQuality=95;
ConfLevel=.99;

% Set uncertainty parameters.
InitParam=5;
TransParam=.5;
ObsParam=1;

% Store dimensionality.
Dim=3;

% Close existing figures.
close('all')

% Sample initial conditions close to attractor.
[~,State]=ode45(@(t,x)Lorenz(x),[0,BurnIn],randn(Dim,1));
InitCond=State(end,:)';

% Create input vectors.
In=ones(1,NumPoint)/SampFreq;

% Instantiate robust non-linear estimator.
Obj=RNLE(1,Dim,Dim);

% Set functions.
Obj.InitFun=@InitFun;
Obj.TransFun=@TransFun;
Obj.ObsFun=@ObsFun;

% Generate data.
[State,Out]=Obj.Sim(In,...
    'OutParam',OutParam,...
    'OutType',OutType);

% Allocate space for estimates.
Mean=zeros(Dim,NumPoint);
Var=zeros(Dim,Dim,NumPoint);

% Initialize estimates and uncertainties.
for i=1:NumPoint
    
    % Store range of indices.
    Ind=max(i-FiltWindow,1):min(i+FiltWindow,NumPoint);
    
    % Set estimates to local medians.
    Val=sort(Out(:,Ind),2);
    Mean(:,i)=Val(:,floor(numel(Ind)/2)+1);
    
    % Set uncertainties to local mean absolute deviations.
    Val=sort(abs(bsxfun(@minus,Out(:,Ind),Mean(:,i))),2);
    Var(:,:,i)=diag(Val(:,floor(numel(Ind)/2)+1));
    
end

% Initialize plot.
[~,Axes,Patch,Text]=Plot(In,State,Out,...
    Mean,Var,ConfLevel);

% Create path for video file.
Path=regexprep(mfilename('fullpath'),mfilename(),'RNLE.avi');

% Open video stream.
VidStream=VideoWriter(Path);
VidStream.FrameRate=FrameRate;
VidStream.Quality=VidQuality;
open(VidStream);

% Write first frame.
Frame=getframe(Axes);
writeVideo(VidStream,Frame);

% Set counter.
Count=0;

% Run robust non-linear estimator.
Obj.Estim(Mean,In,Out,...
    'OutParam',OutParam,...
    'OutType',OutType,...
    'MaxIter',MaxIter,...
    'RelTol',RelTol,...
    'AbsTol',AbsTol,...
    'RejThres',RejThres,...
    'RedFact',RedFact,...
    'CallBack',@CallBack);

% Close video stream.
close(VidStream);

    % Callback function.
    function Stop=CallBack(Mean,Var)
        
        % Update plot.
        for j=1:Dim
            
            % Evaluate widths of confidence intervals.
            HalfWidth=sqrt(2)*erfcinv(1-ConfLevel)*...
                reshape(sqrt(Var(j,j,:)),1,NumPoint);
            
            % Update patches.
            set(Patch(j),'YData',[Mean(j,:)-HalfWidth,...
                Mean(j,end:-1:1)+HalfWidth(end:-1:1)])
            
        end
        
        % Update text.
        Count=Count+1;
        set(Text,'String',sprintf('Iteration %d',Count))
        
        % Write new frame.
        Frame=getframe(Axes);
        writeVideo(VidStream,Frame);
        
        % Do not stop.
        Stop=false();
        
    end

    % Initialization function.
    function [Mean,Var]=InitFun(~)
        Mean=InitCond;
        Var=InitParam^2*eye(Dim);
    end

    % Transition function.
    function [Mean,Var,dMean,dVar]=TransFun(State,Step)
        
        % Solve initial value problem to compute mean vector and derivatives.
        [Mean,dMean]=erkdiff(@Lorenz,State,0:Step/NumStep:Step,IntegMeth);
        
        % Compute variance-covariance matrix and derivatives.
        Var=TransParam^2*eye(Dim);
        dVar=zeros(Dim,Dim,Dim);
        
    end

    % Observation function.
    function [Mean,Var,dMean,dVar]=ObsFun(State,~)
        
        % Compute mean vector and derivatives.
        Mean=State(1:Dim);
        dMean=eye(Dim,Dim);
        
        % Compute variance-covariance matrix and derivatives.
        Var=ObsParam^2*eye(Dim);
        dVar=zeros(Dim,Dim,Dim);
        
    end

    % Differential equations for Lorenz system.
    function [Fun,Jac,Hess]=Lorenz(State)
        
        % Evaluate function.
        Fun=[Sigma*(State(2)-State(1));...
            State(1)*(Rho-State(3))-State(2);...
            State(1)*State(2)-Beta*State(3)];
        
        % Evaluate Jacobian.
        Jac=[-Sigma,Sigma,0;...
            Rho-State(3),-1,-State(1);...
            State(2),State(1),-Beta];
        
        % Evaluate Hessian.
        Hess=cat(3,...
            [0,0,0;0,0,-1;0,1,0],...
            [0,0,0;0,0,0;1,0,0],...
            [0,0,0;-1,0,0;0,0,0]);
        
    end

end



function [Fig,Axes,Patch,Text]=Plot(In,State,Out,...
    Mean,Var,ConfLevel)

% Set options.
FontName='times';
FontSize=20;
ColorDilut=1/2;
LineWidth=2;
MarkerSize=10;
TextLoc=1/20;
ScreenMarg=1/5;

% Store size.
[Dim,NumPoint]=size(State);

% Allocate space for patches.
Patch=zeros(Dim,1);

% Store color map.
ColorMap=hsv(Dim);

% Create figure.
Fig=figure(...
    'NumberTitle','off',...
    'Name','Robust Non-linear Estimation in State-space Models');

% Create axes.
Axes=axes(...
    'Parent',Fig,...
    'NextPlot','add',...
    'Box','on',...
    'Layer','top',...
    'FontName',FontName,...
    'FontSize',FontSize);

% Annotate axes.
set(get(Axes,'XLabel'),...
    'String','Time',...
    'FontName',FontName,...
    'FontSize',FontSize)
set(get(Axes,'YLabel'),...
    'String','Data',...
    'FontName',FontName,...
    'FontSize',FontSize)
set(get(Axes,'Title'),...
    'String','Robust non-linear estimator on data from the Lorenz system',...
    'FontName',FontName,...
    'FontSize',FontSize)

% Plot states and state estimates.
Time=cumsum(In);
for i=1:Dim
    
    % Compute widths of confidence intervals.
    HalfWidth=sqrt(2)*erfcinv(1-ConfLevel)*...
        reshape(sqrt(Var(i,i,:)),1,NumPoint);
    
    % Dilute color.
    Color=(1-ColorDilut)*ColorMap(i,:)+ColorDilut*get(Axes,'Color');
    
    % Plot estimates.
    Patch(i)=patch(...
        'Parent',Axes,...
        'XData',[Time,Time(end:-1:1)],...
        'YData',[Mean(i,:)-HalfWidth,Mean(i,end:-1:1)+HalfWidth(end:-1:1)],...
        'FaceColor',Color,...
        'EdgeColor','none');
    
    % Plot states.
    line(...
        'Parent',Axes,...
        'XData',Time,...
        'YData',State(i,:),...
        'Color',ColorMap(i,:),...
        'LineStyle','-',...
        'LineWidth',LineWidth)
    
end

% Store extrema.
Min=min(State(:));
Max=max(State(:));

% Plot observations.
for i=1:Dim
    
    % Clamp observations out of bounds.
    Outside=(Out(i,:)<=Min|Out(i,:)>=Max)';
    Out(i,Outside)=Min*(Out(i,Outside)<=Min)+Max*(Out(i,Outside)>=Max);
    
    % Plot observations.
    if any(Outside)
        line(...
            'Parent',Axes,...
            'XData',Time(Outside),...
            'YData',Out(i,Outside),...
            'Color',ColorMap(i,:),...
            'LineStyle','none',...
            'LineWidth',LineWidth,...
            'Marker','x',...
            'MarkerSize',MarkerSize)
    end
    if any(~Outside)
        line(...
            'Parent',Axes,...
            'XData',Time(~Outside),...
            'YData',Out(i,~Outside),...
            'Color',ColorMap(i,:),...
            'LineStyle','none',...
            'LineWidth',LineWidth,...
            'Marker','o',...
            'MarkerSize',MarkerSize)
    end
    
end

% Create handles for legend.
Line(1)=line(...
    'Parent',Axes,...
    'XData',[],...
    'ZData',[],...
    'Color','k',...
    'LineStyle','-',...
    'LineWidth',LineWidth,...
    'Visible','off');
Line(2)=line(...
    'Parent',Axes,...
    'XData',[],...
    'ZData',[],...
    'Color','k',...
    'LineStyle','none',...
    'LineWidth',LineWidth,...
    'Marker','o',...
    'MarkerSize',MarkerSize,...
    'Visible','off');
Line(3)=patch(...
    'Parent',Axes,...
    'XData',[],...
    'ZData',[],...
    'FaceColor',(1-ColorDilut)*get(Fig,'Color')+...
        ColorDilut*get(Axes,'Color'),...
    'EdgeColor','none');

% Annotate plot with legend.
set(legend(Line,'True','Observed','Estimated'),...
    'FontName',FontName,...
    'FontSize',FontSize)

% Annotate plot with text.
Text=text(TextLoc,TextLoc,sprintf('Iteration %d',0),...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'VerticalAlignment','bottom',...
    'FontName',FontName,...
    'FontSize',FontSize,...
    'BackgroundColor',get(Axes,'Color'));

% Adjust axes.
set(Axes,...
    'YLim',[Min-eps(),Max+eps()],...
    'NextPlot','ReplaceChildren')

% Store screen size.
ScreenSize=get(0,'ScreenSize');
ScreenSize(1:2)=ScreenSize(1:2)+(ScreenMarg/2)*ScreenSize(3:4);
ScreenSize(3:4)=(1-ScreenMarg)*ScreenSize(3:4);

% Adjust figure.
set(Fig,...
    'Renderer','ZBuffer',...
    'Position',ScreenSize);

end