function abc_cc(op);
% Adventures in Bifurication & Chaos Tool using Matlab - The Chua Circuit Paradigm

%Peadar Forbes, Keith O' Donoghue,James McEvoy, Tomas Murray, 

% Variables available to all functions - Unlimited scope
global H_ABC_pp F_ABC_pp G_ABC_pp A_ABC_pp P_ABC_PP Timeseries Points

% What happens here? Basically when the m file is run without an
% argument (if nargin == 0), we decide that it is been run for the first
% time and draw the GUI (figure with ui components).
%
% On subsequent uicomponent callbacks (when a button is pressed etc), we run the code
% associated with that uicomponent, this code is partitioned within the
% switch loop! James McEvoy


% If no input argument, draw the GUI
if nargin == 0
   op = 0;
end

% Switch Loop, Controls GUI in an Event_Driven fashion -> Callbacks!!
switch op
    % Draw figure :: Case 0 just sets up the GUI aesthetics, go to Case 1 to see the science bit! 
    case 0
        % Erase any previously recorded data
        clear global data
        
        % Background Color
        back_clr = [0.7529 0.7929 0.97];%[0.4529 0.431759929 0.74508716517];
        
        % Figure
        F_ABC_pp = figure('Color',back_clr, ...
	        'MenuBar','none', ...
	        'Name','ABC++ Cubic Non-linearity', ...
	        'NumberTitle','off', ...
            'Units','normalized', ...
	        'Position',[.005 .039 .99 .93], ...
            'CloseRequestFcn','abc_cc(3)',...
            'RendererMode','manual', ...
            'Renderer','painters', ...
	        'Resize','off', ...
            'ToolBar','none', ...
            'Visible','off');        
        
        % AXES 
        G_ABC_pp(1) = axes('Parent',F_ABC_pp,'Units','normalized',...% Main Stage
            'XColor',[1 0 0],'YColor',[0 1 0],'ZColor',[0 0 1],... % Color x,y & z axes
            'Position',[0.049 0.065 0.5286 0.6096]);
        
        G_ABC_pp(3) = axes('Parent',F_ABC_pp,'Units','normalized',...% Time Series Stage
            'Color',[1 1 1],'Position',[0.049 0.7596 0.5286 0.15]);
        
        G_ABC_pp(4) = axes('Parent',F_ABC_pp,'Units','normalized',...
            'Color',[1 1 1],'CameraUpVector',[0 1 0],...
            'Position',[0.6296 0.7096 0.3586 0.2096],...
            'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0]...
            );
        
        % Read in chua image and place it axes 4
        warning off  % Suppress Warning
        axes(G_ABC_pp(4));
		imagen=imread('etc\chua.png');
		image(imagen);
	    axis off;
        warning on  % Turn back on warnings
        
        % UI Components
        H_ABC_pp(1) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % File Open Button
            'Units','normalized',...
            'Position',[0.00195 0.966 0.0586 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','File Open',...
            'Visible','on',...
            'CallBack','abc_cc(1)'); %Execute Switch Case 1 if pressed
        
        H_ABC_pp(27) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % File Save Button
            'Units','normalized',...
            'Position',[0.0635 0.966 0.0586 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','File Save',...
            'Visible','on',...
            'CallBack','abc_cc(8)'); %Execute Switch Case 8 if pressed
        

        H_ABC_pp(2) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Info Button
            'Units','normalized','Position',[0.202 0.966 0.0586 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Info',...
            'Visible','on',...
            'CallBack','abc_cc(2)'); %Execute Switch Case 2 if pressed
        
        H_ABC_pp(3) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Close Button
            'Units','normalized','Position',[0.263 0.966 0.0586 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Close',...
            'Visible','on',...
            'CallBack','abc_cc(3)'); %Execute Switch Case 3 if pressed
        
        H_ABC_pp(6) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Save Figure Button
            'Units','normalized','Position',[0.125 0.966 0.074 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Save Figure',...
            'Visible','on',...
            'CallBack','abc_cc(6)'); %Execute Switch Case 6 if pressed
        
        H_ABC_pp(4) = uicontrol('Style','slider','Min',0,'Max',360,... % Slider
            'Units','normalized','Position',[0.039 0.003 0.54 0.024],...
            'SliderStep',[0.01 0.1],...
            'Visible','on',...
            'CallBack','abc_cc(4)'); %Execute Switch Case 4 if pressed
        
        H_ABC_pp(5) = uicontrol('Style','slider','Min',0,'Max',360,... % Slider
            'Units','normalized','Position',[0.003 0.065 0.018 0.6096],...
            'SliderStep',[0.01 0.1],...
            'Visible','on',...
            'CallBack','abc_cc(5)'); %Execute Switch Case 5 if pressed
        
        H_ABC_pp(100) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Export Button
            'Units','normalized','Position',[0.325 0.966 0.0586 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Export',...
            'Visible','on',...
            'CallBack','abc_cc(13)'); %Execute Switch Case 13 if pressed
        

         
                           
        % UI Aesthetics
        A_ABC_pp(1) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame (Chua Parameters etc)
            'Units','normalized','Position',[0.6296 0.5 0.3586 0.21],'Style','frame');
        
        A_ABC_pp(2) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame  (Circuit Parameters)
            'Units','normalized','Position',[0.6296 0.9192 0.2 0.026],'Style','frame');
        
        A_ABC_pp(55) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame  (Eigen Values)
            'Units','normalized','Position',[0.6296 0.46 0.2 0.026],'Style','frame');
        
        A_ABC_pp(57) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame (Eigen Values 2)
            'Units','normalized','Position',[0.6296 0.293 0.3586 0.168],'Style','frame');
        
        A_ABC_pp(3) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame  (Phase-Space)
            'Units','normalized','Position',[0.03199 0.693 0.4 0.028],'Style','frame');
        
        A_ABC_pp(41) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame  (Timeseries)
            'Units','normalized','Position',[0.03199 0.92 0.45 0.029],'Style','frame');
        
        A_ABC_pp(42) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.04199 0.926 0.0953 0.02],'String','TimeSeries ->','Style','text');
        
        A_ABC_pp(56) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.461 0.18 0.024],'String','Eigen Values :-','Style','text');
        
        A_ABC_pp(58) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.431 0.1 0.024],'String','Inner Region :-','Style','text');
        
        A_ABC_pp(65) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.75 0.431 0.07 0.024],'String','(Real)','Style','text');
        
        A_ABC_pp(69) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','right',...
            'FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.82 0.431 0.13 0.027],'String','','Style','edit');
        
        A_ABC_pp(66) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.75 0.404 0.07 0.024],'String','(Real)','Style','text');
        
        A_ABC_pp(70) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','right',...
            'FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.82 0.404 0.13 0.027],'String','','Style','edit');
        
        A_ABC_pp(75) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.75 0.377 0.07 0.024],'String','(Real)','Style','text');
        
        A_ABC_pp(76) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','right',...
            'FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.82 0.377 0.13 0.027],'String','','Style','edit');
        
        A_ABC_pp(77) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.75 0.349 0.07 0.024],'String','(Real)','Style','text');
        
        A_ABC_pp(78) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','right',...
            'FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.82 0.349 0.13 0.027],'String','','Style','edit');
        
        A_ABC_pp(67) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.75 0.322 0.07 0.024],'String','(Real)','Style','text');
        
        A_ABC_pp(71) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','right',...
            'FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.82 0.322 0.13 0.027],'String','','Style','edit');
        
        A_ABC_pp(68) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.75 0.295 0.07 0.024],'String','(Real)','Style','text');
        
        A_ABC_pp(72) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','right',...
            'FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.82 0.295 0.13 0.027],'String','','Style','edit');
        
        A_ABC_pp(59) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.349 0.1 0.024],'String','Outer Region :-','Style','text');

        A_ABC_pp(60) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame  (Eigen Plane)
            'Units','normalized','Position',[0.6296 0.252 0.2 0.026],'Style','frame');
        
        A_ABC_pp(61) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame (Eigen Plane 2)
            'Units','normalized','Position',[0.6296 0.193 0.3586 0.06],'Style','frame');
        
        A_ABC_pp(62) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.253 0.18 0.023],'String','Eigen Planes :-','Style','text');
        
        A_ABC_pp(63) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','center',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.637 0.224 0.34 0.024],'String','n\a','Style','text');
        
        A_ABC_pp(64) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','center',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.637 0.196 0.34 0.024],'String','n\a','Style','text');
        
        A_ABC_pp(80) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame  (StateSpace Options)
            'Units','normalized','Position',[0.6296 0.151 0.2 0.026],'Style','frame');
        
        A_ABC_pp(81) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame (StateSpace Options 2)
            'Units','normalized','Position',[0.6296 0.092 0.3586 0.06],'Style','frame');
        
        A_ABC_pp(62) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.1525 0.18 0.023],'String','State-Space Options:-','Style','text');
        
        A_ABC_pp(100) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame  (Additional Options)
            'Units','normalized','Position',[0.6296 0.051 0.2 0.026],'Style','frame');
        
        A_ABC_pp(101) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Frame (Additional Options 2)
            'Units','normalized','Position',[0.6296 0.012 0.3586 0.04],'Style','frame');
        
        A_ABC_pp(102) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.052 0.18 0.023],'String','Additional Options:-','Style','text');
        
        A_ABC_pp(43) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[1 0 0],...
            'Units','normalized','Position',[0.13 0.926 0.015 0.02],'String','I3','Style','text');
        
        A_ABC_pp(44) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Edit
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.143 0.922 0.03 0.026],'String','','Style','edit');
        
        A_ABC_pp(45) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.173 0.926 0.03 0.018229],'String','A/div','Style','text');
        
        A_ABC_pp(46) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 1 0],...
            'Units','normalized','Position',[0.21 0.926 0.017 0.02],'String','V2','Style','text');
        
        A_ABC_pp(47) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Edit
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.227 0.922 0.03 0.026],'String','','Style','edit');
        
        A_ABC_pp(48) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.256 0.926 0.03 0.018229],'String','V/div,','Style','text');
        
        A_ABC_pp(49) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 1],...
            'Units','normalized','Position',[0.294 0.926 0.017 0.02],'String','V1','Style','text');
        
        A_ABC_pp(50) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Edit
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.311 0.922 0.03 0.026],'String','','Style','edit');
        
        A_ABC_pp(51) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.34 0.926 0.03 0.018229],'String','V/div,','Style','text');
        
        A_ABC_pp(52) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.375 0.926 0.017 0.02],'String','  T','Style','text');
        
        A_ABC_pp(53) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Edit
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.392 0.922 0.03 0.026],'String','','Style','edit');
        
        A_ABC_pp(54) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.421 0.926 0.03 0.018229],'String','s/div','Style','text');
        
        A_ABC_pp(120) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Edit
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',9,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.63 0.96 0.36 0.028],'String','','Style','edit');
        
        A_ABC_pp(40) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.04199 0.694 0.0953 0.024],'String','State-Space ->','Style','text');
        
        A_ABC_pp(4) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.14199 0.694 0.0953 0.024],'String','Azimuth Angle:','Style','text');
        
        A_ABC_pp(5) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.27 0.694 0.0953 0.024],'String','Elevation Angle:','Style','text');
        
        A_ABC_pp(6) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.238 0.7 0.03 0.018229],'String','0','Style','text');
        
        A_ABC_pp(7) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.3653 0.7 0.03 0.018229],'String','0','Style','text');
        
        A_ABC_pp(13) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.68 0.2 0.026],'String','Chua Diode Parameters :-','Style','text');
        
        A_ABC_pp(14) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.63 0.2 0.026],'String','Initial States :-','Style','text');
        
        A_ABC_pp(15) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.58 0.2 0.026],'String','Current States :-','Style','text');
        
        A_ABC_pp(16) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.53 0.2 0.026],'String','Integration Parameters :-','Style','text');
        
        A_ABC_pp(17) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.635 0.9198 0.18 0.024],'String','Circuit Parameters :-','Style','text');
        
        A_ABC_pp(8) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (R0)
            'HorizontalAlignment','left','Units','normalized','Position',[0.661 0.751 0.06 0.028],'Style','edit');
        
        A_ABC_pp(9) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (L)
            'HorizontalAlignment','left','Units','normalized','Position',[0.661 0.827 0.06 0.028],'Style','edit');
        
        A_ABC_pp(10) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (G)
            'HorizontalAlignment','left','Units','normalized','Position',[0.841 0.885 0.06 0.028],'Style','edit');
        
        A_ABC_pp(11) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (C2)
            'HorizontalAlignment','left','Units','normalized','Position',[0.773 0.767 0.06 0.028],'Style','edit');
        
        A_ABC_pp(12) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (C1)
            'HorizontalAlignment','left','Units','normalized','Position',[0.888 0.767 0.06 0.028],'Style','edit');
        
        A_ABC_pp(18) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (a)
            'HorizontalAlignment','left','Units','normalized','Position',[0.66 0.654 0.03 0.028],'Style','edit');
        
        A_ABC_pp(19) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (b)
            'HorizontalAlignment','left','Units','normalized','Position',[0.74 0.654 0.03 0.028],'Style','edit');
        
        A_ABC_pp(20) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (c)
            'HorizontalAlignment','left','Units','normalized','Position',[0.82 0.654 0.03 0.028],'Style','edit');
        
        A_ABC_pp(200) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (d)
            'HorizontalAlignment','left','Units','normalized','Position',[0.9 0.654 0.03 0.028],'Style','edit','String','0');
        
        A_ABC_pp(21) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (Initial I3)
            'HorizontalAlignment','left','Units','normalized','Position',[0.7 0.604 0.06 0.028],'Style','edit');
        
        A_ABC_pp(22) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (Initial V2)
            'HorizontalAlignment','left','Units','normalized','Position',[0.8 0.604 0.06 0.028],'Style','edit');
        
        A_ABC_pp(23) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (Initial V1)
            'HorizontalAlignment','left','Units','normalized','Position',[0.9 0.604 0.06 0.028],'Style','edit');
        
        A_ABC_pp(24) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% text Box (Current I3)
            'HorizontalAlignment','left','Units','normalized','Position',[0.7 0.554 0.06 0.028],'Style','edit');
        
        A_ABC_pp(25) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% text Box (Current V2)
            'HorizontalAlignment','left','Units','normalized','Position',[0.8 0.554 0.06 0.028],'Style','edit');
        
        A_ABC_pp(26) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% text Box (Current V1)
            'HorizontalAlignment','left','Units','normalized','Position',[0.9 0.554 0.06 0.028],'Style','edit');
        
        A_ABC_pp(27) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (StepSize)
            'HorizontalAlignment','left','Units','normalized','Position',[0.7 0.504 0.06 0.028],'Style','edit');
        
        A_ABC_pp(28) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (Number of Steps)
            'HorizontalAlignment','left','Units','normalized','Position',[0.8 0.504 0.06 0.028],'Style','edit');
        
        A_ABC_pp(29) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.648 0.655 0.01 0.024],'String','a','Style','text');
        
        A_ABC_pp(30) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.72 0.655 0.02 0.024],'String','b','Style','text');
        
        A_ABC_pp(31) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.80 0.655 0.02 0.024],'String','c','Style','text');
        
        A_ABC_pp(310) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.88 0.655 0.02 0.024],'String','d','Style','text');
        
        
        A_ABC_pp(32) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[1 0 0],...
            'Units','normalized','Position',[0.68 0.605 0.02 0.024],'String','I3','Style','text');
        
        A_ABC_pp(33) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 1 0],...
            'Units','normalized','Position',[0.78 0.605 0.02 0.024],'String','V2','Style','text');
        
        A_ABC_pp(34) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 1],...
            'Units','normalized','Position',[0.88 0.605 0.02 0.024],'String','V1','Style','text');
        
        A_ABC_pp(35) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[1 0 0],...
            'Units','normalized','Position',[0.68 0.555 0.02 0.024],'String','I3','Style','text');
        
        A_ABC_pp(36) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 1 0],...
            'Units','normalized','Position',[0.78 0.555 0.02 0.024],'String','V2','Style','text');
        
        A_ABC_pp(37) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 1],...
            'Units','normalized','Position',[0.88 0.555 0.02 0.024],'String','V1','Style','text');
        
        A_ABC_pp(38) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.64 0.505 0.06 0.024],'String','Step Size','Style','text');
        
        A_ABC_pp(39) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.775 0.505 0.02 0.024],'String','No.','Style','text');
        
        A_ABC_pp(73) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.87 0.505 0.04 0.024],'String','Start T','Style','text');
        
        A_ABC_pp(74) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Input Box (Start Time)
            'HorizontalAlignment','left','Units','normalized','Position',[0.92 0.504 0.06 0.028],'Style','edit');
        
        % Work Back from EigenValues Button
        H_ABC_pp(7) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Eigen Button
            'Units','normalized','Position',[0.896 0.26 0.092 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Reverse Eigen',...
            'Visible','off',...
            'CallBack','abc_cc(9)');
        
        % Recalculate Button
        H_ABC_pp(10) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Recalculate Button
            'Units','normalized','Position',[0.908 0.467 0.08 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Recalculate',...
            'Visible','off',...
            'CallBack','abc_cc(7)');
        
        % Poincaré Button
        H_ABC_pp(22) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Poincaré Button
            'Units','normalized','Position',[0.64 0.0165 0.072 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Poincaré',...
            'Visible','off',...
            'CallBack','abc_cc(10)');
        
        % ChuaDiode DP Char Button
        H_ABC_pp(223) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % ChuaDiode DP Char Button
            'Units','normalized','Position',[0.72 0.0165 0.16 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Driving-Point Characteristic',...
            'Visible','off',...
            'CallBack','abc_cc(12)');
        
        % FFT Button
        H_ABC_pp(211) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % FFT Button
            'Units','normalized','Position',[0.89 0.0165 0.072 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','FFT',...
            'Visible','off',...
            'CallBack','abc_cc(22)');
        
        % Input NonLinearity coefficients Button
        H_ABC_pp(212) = uicontrol('Parent',F_ABC_pp,'Style','pushbutton',... % Cubic
            'Units','normalized','Position',[0.89 0.06 0.072 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Cubic',...
            'Visible','off',...
            'CallBack','abc_cc(22)');
        
        
        % Radio Buttons
        H_ABC_pp(6) = uicontrol('Style','radiobutton','Min',0,'Max',1,... % Radio
            'Units','normalized','Position',[0.76 0.124 0.014 0.024],...
            'BackgroundColor',[1 1 1],'Visible','off',...
            'CallBack','abc_cc(11)'); %Execute Switch Case 11 if pressed
        A_ABC_pp(83) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.632 0.124 0.13 0.024],'String','Zoom on Attractor','Style','text');
        
        H_ABC_pp(8) = uicontrol('Style','radiobutton','Min',0,'Max',1,... % Radio
            'Units','normalized','Position',[0.855 0.124 0.014 0.024],...
            'BackgroundColor',[1 1 1],'Visible','off',...
            'CallBack','abc_cc(11)'); %Execute Switch Case 11 if pressed
        A_ABC_pp(84) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.78 0.124 0.07 0.024],'String','Toggle Grid','Style','text');
        
        H_ABC_pp(12) = uicontrol('Style','radiobutton','Min',0,'Max',1,... % Radio
            'Units','normalized','Position',[0.966 0.124 0.014 0.024],...
            'BackgroundColor',[1 1 1],'Visible','off',...
            'CallBack','abc_cc(11)'); %Execute Switch Case 11 if pressed
        
        %A_ABC_pp(85) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
        %    'FontName','Helvetica','HorizontalAlignment','left',...
        %    'FontSize',10,'ForegroundColor',[0 0 0],...
        %    'Units','normalized','Position',[0.88 0.124 0.087 0.024],'String','Toggle Planes','Style','text');
        
        H_ABC_pp(13) = uicontrol('Style','radiobutton','Min',0,'Max',1,... % Radio
            'Units','normalized','Position',[0.76 0.096 0.014 0.024],...
            'BackgroundColor',[1 1 1],'Visible','off',...
            'CallBack','abc_cc(11)'); %Execute Switch Case 11 if pressed
        %A_ABC_pp(110) = uicontrol('Parent',F_ABC_pp,'BackgroundColor',[1 1 1],...% Text
        %    'FontName','Helvetica','HorizontalAlignment','left',...
        %    'FontSize',10,'ForegroundColor',[0 0 0],...
        %    'Units','normalized','Position',[0.632 0.096 0.13 0.024],'String','Toggle Plane Fills','Style','text');

        % Set focus on Main Stage
        axes(G_ABC_pp(1));
        
        % Make Application Visible
        set(F_ABC_pp,'visible','on');
        
    
    % File Open
    case 1
        % Home Directory
        home = pwd;
        % Navigate to default data directory
        cd data;
        %Open File Open Dialog
        [filename, pathname] = uigetfile('*.abc','Select Data File');        
        if filename~=0 % Yes file exists
            % Navigate to data directory - if different from default
            cd(pathname);
            % Clear file buffer & Read in File Contents, comma delimited
            clear global system_vars;
            attractor_description = file_routine('read',filename,'null');
            set(A_ABC_pp(120),'String',attractor_description);
            system_vars = dlmread('temp.txt');
            
            % Change Application Title Bar
            set(F_ABC_pp,'Name',['ABC++ Cubic Nonlinearity [',pathname,filename,']']);
            % Return to home dir
            cd(home);
           
            sys_variables = [system_vars(5:12),system_vars(23:26)]; % L,R0,C2,G,Ga,Gb,E,C1,a,b,c,d
            integ_variables = [system_vars(14:16),system_vars(1:2)]; % x0,y0,z0,dataset_size,step_size
           
           
            
            % Calculate Timeseries
            global Timeseries;
            
            Timeseries = chua(sys_variables,integ_variables);
            % Calculate System Equilibrium Points
            global Points;
            Points = equil_points(sys_variables);
            
            % Plot Time Series
            %-----------------
            reset(G_ABC_pp(3)); % Erase any Axes Buffer
            axes(G_ABC_pp(3)); % Point to small top Stage
            % Set up time axis, (start-time) to (start-time + number_of_steps*step_size) in increments of (step_size)!
            t = system_vars(13):system_vars(2):(system_vars(13)+system_vars(1)*system_vars(2));
            % Plot series scaled by relavent ratio
            plot(t/system_vars(17),Timeseries(1,:)/system_vars(18),'Color','r');hold on;
            plot(t/system_vars(17),Timeseries(2,:)/system_vars(19),'Color','g');hold on;
            plot(t/system_vars(17),Timeseries(3,:)/system_vars(20),'Color','b');
            axis tight;grid on;
            
            % Calculate Eigen Points & Planes, then place them on GUI
            Eigen_Planes = eigen(sys_variables,Points);
             % Planes
            set(A_ABC_pp(63),'HorizontalAlignment','left');
            set(A_ABC_pp(64),'HorizontalAlignment','left');
            if Eigen_Planes(1,2)>=0 % Just checking signs to make eigenplane output aesthetic pleasing as a string!
                sign(1,1) = '+';
            else
                sign(1,1) = '-';
            end
            if Eigen_Planes(1,3)>=0
                sign(1,2) = '+';
            else
                sign(1,2) = '-';
            end
            if Eigen_Planes(2,2)>=0
                sign(1,3) = '+';
            else
                sign(1,3) = '-';
            end
            if Eigen_Planes(2,3)>=0
                sign(1,4) = '+';
            else
                sign(1,4) = '-';
            end
            %set(A_ABC_pp(63),'String',[num2str(Eigen_Planes(1,1)),'x ',sign(1,1),' ',num2str(abs(Eigen_Planes(1,2))),'y ',sign(1,2),' ',num2str(abs(Eigen_Planes(1,3))),'z = 0 ']);
            %set(A_ABC_pp(64),'String',[num2str(Eigen_Planes(2,1)),'x ',sign(1,3),' ',num2str(abs(Eigen_Planes(2,2))),'y ',sign(1,4),' ',num2str(abs(Eigen_Planes(2,3))),'z +/- ',num2str(abs(Eigen_Planes(2,4))),' = 0']);
             % Place Points on GUI
            if isreal(Eigen_Planes(3,1))
                set(A_ABC_pp(65),'String','(Real)');
            else
                set(A_ABC_pp(65),'String','(Complex)');
            end
            set(A_ABC_pp(69),'String',num2str(Eigen_Planes(3,1)));
            if isreal(Eigen_Planes(3,2))
                set(A_ABC_pp(66),'String','(Real)');
            else
                set(A_ABC_pp(66),'String','(Complex)');
            end
            set(A_ABC_pp(70),'String',num2str(Eigen_Planes(3,2)));
            if isreal(Eigen_Planes(3,3))
                set(A_ABC_pp(75),'String','(Real)');
            else
                set(A_ABC_pp(75),'String','(Complex)');
            end
            set(A_ABC_pp(76),'String',num2str(Eigen_Planes(3,3)));
            if isreal(Eigen_Planes(4,1))
                set(A_ABC_pp(77),'String','(Real)');
            else
                set(A_ABC_pp(77),'String','(Complex)');
            end
            set(A_ABC_pp(78),'String',num2str(Eigen_Planes(4,1)));
            if isreal(Eigen_Planes(4,2))
                set(A_ABC_pp(67),'String','(Real)');
            else
                set(A_ABC_pp(67),'String','(Complex)');
            end
            set(A_ABC_pp(71),'String',num2str(Eigen_Planes(4,2)));
            if isreal(Eigen_Planes(4,3))
                set(A_ABC_pp(68),'String','(Real)');
            else
                set(A_ABC_pp(68),'String','(Complex)');
            end
            set(A_ABC_pp(72),'String',num2str(Eigen_Planes(4,3)));
        
            
         
            
            % Plot Attractor
            %---------------
            reset(G_ABC_pp(1)); % Erase any Axes Buffer
            axes(G_ABC_pp(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');hold on;
            xlabel('I3');
            ylabel('V2');
            zlabel('V1');
            % Plot Equilibrium Points
            plot3(Points(1,1),Points(2,1),Points(3,1),'.', ...
                'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
            text(Points(1,1),Points(2,1),Points(3,1),'  P^{-}','Color',[1 0 0],'FontWeight','bold');
            plot3(Points(1,2),Points(2,2),Points(3,2),'.', ...
                'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
            text(Points(1,2),Points(2,2),Points(3,2),'  0','Color',[1 0 0],'FontWeight','bold');
            plot3(Points(1,3),Points(2,3),Points(3,3),'.', ...
                'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
            text(Points(1,3),Points(2,3),Points(3,3),'  P^{+}','Color',[1 0 0],'FontWeight','bold');
            

            
            xarray = [Timeseries(1,:)];
            yarray = [Timeseries(2,:)];
            zarray = [Timeseries(3,:)];
            
            xmax = max(xarray);
            xmin = min(xarray);
            ymax = max(yarray);
            ymin = min(yarray);
            zmax = max(zarray);
            zmin = min(zarray);
            
            if abs(xmax) > abs(xmin)
                xlimit = 1.5*abs(xmax);
            else
                xlimit = 1.5*abs(xmin);
            end
            if abs(zmax) > abs(zmin)
                zlimit = 1.5*abs(zmax);
            else
                zlimit = 1.5*abs(zmin);
            end
            if abs(ymax) > abs(ymin)
                ylimit = 1.5*abs(ymax);
            else
                ylimit = 1.5*abs(ymin);
            end
            
                    axis([-xlimit xlimit -ylimit ylimit -zlimit zlimit]);
            grid on;
            
            
            % Color Axes - Necessary after reset it would seem
            set(G_ABC_pp(1),'XColor',[1 0 0],'YColor',[0 1 0],'ZColor',[0 0 1]);
            
            % Rotate Attractor viewpoint to one stored in file
            view(system_vars(21),system_vars(22));                                         
            
            % Set sliders to reflect this
            set(H_ABC_pp(4),'Value',system_vars(21));
            set(H_ABC_pp(5),'Value',system_vars(22));
            
            % Set text_angles to reflect this
            set(A_ABC_pp(6),'String',num2str(system_vars(21)));
            set(A_ABC_pp(7),'String',num2str(system_vars(22)));
            
            % Set Parameters Edit boxes - Max Significant to 20 decimal places!
            set(A_ABC_pp(8),'String',num2str(system_vars(6),20)) % Set R0
            set(A_ABC_pp(9),'String',num2str(system_vars(5),20)) % Set L
            set(A_ABC_pp(10),'String',num2str(system_vars(8),20)) % Set G
            set(A_ABC_pp(11),'String',num2str(system_vars(7),20)) % Set C2
            set(A_ABC_pp(12),'String',num2str(system_vars(12),20)) % Set C1
            set(A_ABC_pp(18),'String',num2str(system_vars(23),20)) % Set a
            set(A_ABC_pp(19),'String',num2str(system_vars(24),20)) % Set b
            set(A_ABC_pp(20),'String',num2str(system_vars(25),20)) % Set c
            set(A_ABC_pp(200),'String',num2str(system_vars(26),20)) % Set d
            set(A_ABC_pp(21),'String',num2str(system_vars(14),20)) % Set Initial I3
            set(A_ABC_pp(22),'String',num2str(system_vars(15),20)) % Set Initial V2
            set(A_ABC_pp(23),'String',num2str(system_vars(16),20)) % Set Initial V1
            set(A_ABC_pp(24),'String',Timeseries(1,(system_vars(1)+1))) % Set Current I3
            set(A_ABC_pp(25),'String',Timeseries(2,(system_vars(1)+1))) % Set Current V2
            set(A_ABC_pp(26),'String',Timeseries(3,(system_vars(1)+1))) % Set Current V1
            set(A_ABC_pp(27),'String',num2str(system_vars(2))) % Set Step Size
            set(A_ABC_pp(28),'String',num2str(system_vars(1))) % Set No. of steps
            set(A_ABC_pp(44),'String',num2str(system_vars(18))) % Set I3 A/div
            set(A_ABC_pp(47),'String',num2str(system_vars(19))) % Set V2 V/div
            set(A_ABC_pp(50),'String',num2str(system_vars(20))) % Set V1 V/div
            set(A_ABC_pp(53),'String',num2str(system_vars(17))) % Set T s/div
            set(A_ABC_pp(74),'String',num2str(system_vars(13))) % Set Start Time
            
            % Set Radio buttons visible & Reset
            set(H_ABC_pp(8),'Visible','on');
            set(H_ABC_pp(8),'Value',0);
            set(H_ABC_pp(6),'Visible','on');
            set(H_ABC_pp(6),'Value',0);
            %set(H_ABC_pp(12),'Visible','on');
            %set(H_ABC_pp(12),'Value',0);
            %set(H_ABC_pp(13),'Visible','on');
            %set(H_ABC_pp(13),'Value',0);
            
            % Set Recalculate Button visible
            set(H_ABC_pp(10),'Visible','on');
            % Set Poincaré Button visible
            %set(H_ABC_pp(22),'Visible','on');
            % Set ChuaDiode DP Char Button visible
            set(H_ABC_pp(223),'Visible','on');
            
            
            % STILL ONLY BETA VERSION QUALITY, REMOVE %s TO TRY THEM OUT
            % Set FFT Button visible - Not till its working - PSD function incorrect
            %set(H_ABC_pp(211),'Visible','on');
            % Set ReverseEigen Button visible
            %set(H_ABC_pp(7),'Visible','on');
            
            % Set Cubic button visible
            %set(H_ABC_pp(212),'Visible','on');
            
            
        else
            % Return to home dir when no file selected
            cd(home);
        end
              
    % Info Dialog
    case 2
        helpdlg(strvcat(' Peadar Forbes, Keith O Donoghue, James McEvoy, Tomás Uí Mhuirithe','  ','Supervisor: Prof. Michael P Kennedy','  ','Adventures in Bifurication & Chaos using Matlab','  ','University College Cork 2004'),'Information');
     
    % Close Application
    case 3
        if strcmp(questdlg('Exit ABC++?','Close','Yes','No','No'),'Yes')
            delete(F_ABC_pp);
        end
    
    % Azimuth Angle Slider
    case 4
        % Set Main Stage viewing angle to slider values
        axes(G_ABC_pp(1));
        view(get(H_ABC_pp(4),'Value'),get(H_ABC_pp(5),'Value'));
        % Set text_angles to reflect this
        set(A_ABC_pp(6),'String',num2str(round(get(H_ABC_pp(4),'Value'))));
        set(A_ABC_pp(7),'String',num2str(round(get(H_ABC_pp(5),'Value'))));
        
    % Elevation Angle Slider
    case 5
        % Set Main Stage viewing angle to slider values
        axes(G_ABC_pp(1));
        view(get(H_ABC_pp(4),'Value'),get(H_ABC_pp(5),'Value'));
        % Set text_angles to reflect this
        set(A_ABC_pp(6),'String',num2str(round(get(H_ABC_pp(4),'Value'))));
        set(A_ABC_pp(7),'String',num2str(round(get(H_ABC_pp(5),'Value'))));
        
    % Take User inputed values and recalculate
    case 7     
        sys_variables = [str2double(get(A_ABC_pp(9),'String')),str2double(get(A_ABC_pp(8),'String')),str2double(get(A_ABC_pp(11),'String')),str2double(get(A_ABC_pp(10),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(12),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(200),'String'))]; % L,R0,C2,G,Ga,Gb,E,C1,a,b,c,d
        integ_variables = [str2double(get(A_ABC_pp(21),'String')),str2double(get(A_ABC_pp(22),'String')),str2double(get(A_ABC_pp(23),'String')),str2double(get(A_ABC_pp(28),'String')),str2double(get(A_ABC_pp(27),'String'))]; % x0,y0,z0,dataset_size,step_size
        
        clear global data;
        % Calculate Timeseries
        global Timeseries;
        Timeseries = chua(sys_variables,integ_variables);
        % Calculate System Equilibrium Points
        global Points;
        Points = equil_points(sys_variables);
        
        % Plot Time Series
        %-----------------
        
            
        reset(G_ABC_pp(3)); % Erase any Axes Buffer
        axes(G_ABC_pp(3)); % Point to small top Stage
        % Set up time axis, (start-time) to (start-time + number_of_steps*step_size) in increments of (step_size)!
        t = str2double(get(A_ABC_pp(74),'String')):str2double(get(A_ABC_pp(27),'String')):(str2double(get(A_ABC_pp(74),'String')) + str2double(get(A_ABC_pp(28),'String'))*str2double(get(A_ABC_pp(27),'String')));
        % Plot series scaled by relavent ratio
      
        plot(t/str2double(get(A_ABC_pp(53),'String')),Timeseries(1,:)/str2double(get(A_ABC_pp(44),'String')),'Color','r');hold on;
        plot(t/str2double(get(A_ABC_pp(53),'String')),Timeseries(2,:)/str2double(get(A_ABC_pp(47),'String')),'Color','g');hold on;
        plot(t/str2double(get(A_ABC_pp(53),'String')),Timeseries(3,:)/str2double(get(A_ABC_pp(50),'String')),'Color','b');
        axis tight;grid on;
        
% Calculate Eigen Points & Planes, then place them on GUI
            Eigen_Planes = eigen(sys_variables,Points);
             % Planes
            set(A_ABC_pp(63),'HorizontalAlignment','left');
            set(A_ABC_pp(64),'HorizontalAlignment','left');
            if Eigen_Planes(1,2)>=0 % Just checking signs to make eigenplane output aesthetic pleasing as a string!
                sign(1,1) = '+';
            else
                sign(1,1) = '-';
            end
            if Eigen_Planes(1,3)>=0
                sign(1,2) = '+';
            else
                sign(1,2) = '-';
            end
            if Eigen_Planes(2,2)>=0
                sign(1,3) = '+';
            else
                sign(1,3) = '-';
            end
            if Eigen_Planes(2,3)>=0
                sign(1,4) = '+';
            else
                sign(1,4) = '-';
            end
            %set(A_ABC_pp(63),'String',[num2str(Eigen_Planes(1,1)),'x ',sign(1,1),' ',num2str(abs(Eigen_Planes(1,2))),'y ',sign(1,2),' ',num2str(abs(Eigen_Planes(1,3))),'z = 0 ']);
            %set(A_ABC_pp(64),'String',[num2str(Eigen_Planes(2,1)),'x ',sign(1,3),' ',num2str(abs(Eigen_Planes(2,2))),'y ',sign(1,4),' ',num2str(abs(Eigen_Planes(2,3))),'z +/- ',num2str(abs(Eigen_Planes(2,4))),' = 0']);
             % Place Points on GUI
            if isreal(Eigen_Planes(3,1))
                set(A_ABC_pp(65),'String','(Real)');
            else
                set(A_ABC_pp(65),'String','(Complex)');
            end
            set(A_ABC_pp(69),'String',num2str(Eigen_Planes(3,1)));
            if isreal(Eigen_Planes(3,2))
                set(A_ABC_pp(66),'String','(Real)');
            else
                set(A_ABC_pp(66),'String','(Complex)');
            end
            set(A_ABC_pp(70),'String',num2str(Eigen_Planes(3,2)));
            if isreal(Eigen_Planes(3,3))
                set(A_ABC_pp(75),'String','(Real)');
            else
                set(A_ABC_pp(75),'String','(Complex)');
            end
            set(A_ABC_pp(76),'String',num2str(Eigen_Planes(3,3)));
            if isreal(Eigen_Planes(4,1))
                set(A_ABC_pp(77),'String','(Real)');
            else
                set(A_ABC_pp(77),'String','(Complex)');
            end
            set(A_ABC_pp(78),'String',num2str(Eigen_Planes(4,1)));
            if isreal(Eigen_Planes(4,2))
                set(A_ABC_pp(67),'String','(Real)');
            else
                set(A_ABC_pp(67),'String','(Complex)');
            end
            set(A_ABC_pp(71),'String',num2str(Eigen_Planes(4,2)));
            if isreal(Eigen_Planes(4,3))
                set(A_ABC_pp(68),'String','(Real)');
            else
                set(A_ABC_pp(68),'String','(Complex)');
            end
            set(A_ABC_pp(72),'String',num2str(Eigen_Planes(4,3)));
        
        % Plot Attractor
        %---------------
        reset(G_ABC_pp(1)); % Erase any Axes Buffer
        axes(G_ABC_pp(1)); % Point to main stage            
        plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');hold on;
        xlabel('I3');
        ylabel('V2');
        zlabel('V1');
        
        % Plot Equilibrium Points
        plot3(Points(1,1),Points(2,1),Points(3,1),'.', ...
             'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
        text(Points(1,1),Points(2,1),Points(3,1),'  P^{-}','Color',[1 0 0],'FontWeight','bold');
        plot3(Points(1,2),Points(2,2),Points(3,2),'.', ...
                'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
        text(Points(1,2),Points(2,2),Points(3,2),'  0','Color',[1 0 0],'FontWeight','bold');
        plot3(Points(1,3),Points(2,3),Points(3,3),'.', ...
                'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
        text(Points(1,3),Points(2,3),Points(3,3),'  P^{+}','Color',[1 0 0],'FontWeight','bold');
        

        
        xarray = [Timeseries(1,:)];
        yarray = [Timeseries(2,:)];
        zarray = [Timeseries(3,:)];
        
        xmax = max(xarray);
        xmin = min(xarray);
        ymax = max(yarray);
        ymin = min(yarray);
        zmax = max(zarray);
        zmin = min(zarray);
        
        if abs(xmax) > abs(xmin)
            xlimit = 1.5*abs(xmax);
        else
            xlimit = 1.5*abs(xmin);
        end
        if abs(zmax) > abs(zmin)
            zlimit = 1.5*abs(zmax);
        else
            zlimit = 1.5*abs(zmin);
        end
        if abs(ymax) > abs(ymin)
            ylimit = 1.5*abs(ymax);
        else
            ylimit = 1.5*abs(ymin);
        end
        
        
        axis([-xlimit xlimit -ylimit ylimit -zlimit zlimit]);
        grid on;

       
        
        
        
        % Color Axes - Necessary after reset it would seem
        set(G_ABC_pp(1),'XColor',[1 0 0],'YColor',[0 1 0],'ZColor',[0 0 1]);                      
        
        % Rotate Attractor viewpoint to one stored in file
        view(str2double(get(A_ABC_pp(6),'String')),str2double(get(A_ABC_pp(7),'String')));
        
        % Set sliders to reflect this
        set(H_ABC_pp(4),'Value',str2double(get(A_ABC_pp(6),'String')));
        set(H_ABC_pp(5),'Value',str2double(get(A_ABC_pp(7),'String')));
        
        % Set text_angles to reflect this
        set(A_ABC_pp(6),'String',get(A_ABC_pp(6),'String'));
        set(A_ABC_pp(7),'String',get(A_ABC_pp(7),'String'));
        
        set(A_ABC_pp(24),'String',Timeseries(1,(integ_variables(4)+1))); % Set Current I3
        set(A_ABC_pp(25),'String',Timeseries(2,(integ_variables(4)+1))); % Set Current V2
        set(A_ABC_pp(26),'String',Timeseries(3,(integ_variables(4)+1))); % Set Current V1
        
    % Save Figure
    case 6      
        home = pwd;
        [filename, pathname, filterindex] = uiputfile( ...
            {
            '*.eps','Encapsulated Postscript (*.eps)'; ...
                '*.jpg','JPEG image (*.jpg)'; ...
                '*.emf','Enhanced metafile (*.emf)'}, ...
            'Save Figure as');
        if filename ~= 0 % Yes Save figure
            cd(pathname);
            if filterindex == 1
                extension = 'epsc';
            elseif filterindex == 2
                extension = 'jpg';
            elseif filterindex == 3
                extension = 'emf';
            end
            saveas(G_ABC_pp(1),filename,extension);
            cd(home);
        else
            cd(home);
        end
    
    % Save parameters to file
    case 8
        home = pwd;
        cd('data');
        [filename, pathname, filterindex] = uiputfile( ...
            {
            '*.abc','ABC File (*.abc)'; ...
                '*.txt','Text File (*.txt)'}, ...
            'Save File as');
        if filename ~= 0 % Yes Save figure
            cd(pathname);
            if filterindex == 1
                extension = 'abc';
            elseif filterindex == 2
                extension = 'txt';
            end
            file_contents=[get(A_ABC_pp(28),'String'),',',get(A_ABC_pp(27),'String'),', 0, -1,',get(A_ABC_pp(9),'String'),',',get(A_ABC_pp(8),'String'),',',get(A_ABC_pp(11),'String'),',',get(A_ABC_pp(10),'String'),',',get(A_ABC_pp(19),'String'),',',get(A_ABC_pp(20),'String'),',',get(A_ABC_pp(18),'String'),',',get(A_ABC_pp(12),'String'),',',get(A_ABC_pp(74),'String'),',',get(A_ABC_pp(21),'String'),',',get(A_ABC_pp(22),'String'),',',get(A_ABC_pp(23),'String'),',',get(A_ABC_pp(53),'String'),',',get(A_ABC_pp(44),'String'),',',get(A_ABC_pp(47),'String'),',',get(A_ABC_pp(50),'String'),',',get(A_ABC_pp(6),'String'),',',get(A_ABC_pp(7),'String'),',',get(A_ABC_pp(18),'String'),',',get(A_ABC_pp(19),'String'),',',get(A_ABC_pp(20),'String'),',',get(A_ABC_pp(200),'String'),',"',get(A_ABC_pp(120),'String'),'"'];
            file_routine('write',[filename,'.',extension],file_contents);
            
            cd(home);
        else
            cd(home);
        end
        
    % Work Back From Eigen Values **BETA QUALITY SEE LINE**
    case 9
        eigenvalue_inner = [str2double(get(A_ABC_pp(69),'String')),str2double(get(A_ABC_pp(70),'String')),str2double(get(A_ABC_pp(76),'String'))];
        eigenvalue_outer = [str2double(get(A_ABC_pp(78),'String')),str2double(get(A_ABC_pp(71),'String')),str2double(get(A_ABC_pp(72),'String'))];
        system_variables = reverse_eigen(eigenvalue_inner,eigenvalue_outer);
        % 'system_variables' in this form -> [L R0 C2 G Ga Gb E C1]
        set(A_ABC_pp(9),'String',num2str(system_variables(1,1),20)); % Set L
        set(A_ABC_pp(8),'String',num2str(system_variables(1,2),20)); % Set R0
        set(A_ABC_pp(11),'String',num2str(system_variables(1,3),20)); % Set C2
        set(A_ABC_pp(10),'String',num2str(system_variables(1,4),20)); % Set G
        set(A_ABC_pp(19),'String',num2str(system_variables(1,5),20)); % Set Ga
        set(A_ABC_pp(20),'String',num2str(system_variables(1,6),20)); % Set Gb
        set(A_ABC_pp(18),'String',num2str(system_variables(1,7),20)); % Set E
        set(A_ABC_pp(12),'String',num2str(system_variables(1,8),20)); % Set C1
        
    % Pop up Poincaré Section Window ...
    case 10
        sys_variables = [str2double(get(A_ABC_pp(9),'String')),str2double(get(A_ABC_pp(8),'String')),str2double(get(A_ABC_pp(12),'String')),str2double(get(A_ABC_pp(10),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(11),'String'))]; % L,R0,C2,G,Ga,Gb,E,C1
        integ_variables = [str2double(get(A_ABC_pp(21),'String')),str2double(get(A_ABC_pp(22),'String')),str2double(get(A_ABC_pp(23),'String')),str2double(get(A_ABC_pp(28),'String')),str2double(get(A_ABC_pp(27),'String'))]; % x0,y0,z0,dataset_size,step_size
        view_angle=[str2double(get(A_ABC_pp(6),'String')) str2double(get(A_ABC_pp(7),'String'))];
        % Cant pass data naturally between GUI as I designed them ... this
        % hack saves required variables to disk which can then be read by
        % the poincaré_popup GUI
        savefile = 'data\temp.mat';
        save(savefile,'Timeseries','sys_variables','integ_variables','view_angle')
        % Add etc directory to Matlab's Path: so as to call poincare_popup!
        home = pwd;
        addpath([home,'\etc'])
        poincare_popup(0);
                
    % State-Space Options    
    case 11 
        axes(G_ABC_pp(1)); % Point to main stage
        % Zoom in on attractor
        if get(H_ABC_pp(6),'Value') == 1 % If (Zoom) radio selected
            xarray = [Timeseries(1,:)];
            yarray = [Timeseries(2,:)];
            zarray = [Timeseries(3,:)];
            xmax = max(xarray);
            xmin = min(xarray);
            ymax = max(yarray);
            ymin = min(yarray);
            zmax = max(zarray);
            zmin = min(zarray);
            axis([xmin xmax ymin ymax zmin zmax]);
        else
            xarray = [Timeseries(1,:),Points(1,:)];
            yarray = [Timeseries(2,:),Points(2,:)];
            zarray = [Timeseries(3,:),Points(3,:)];
            xmax = max(xarray);
            xmin = min(xarray);
            ymax = max(yarray);
            ymin = min(yarray);
            zmax = max(zarray);
            zmin = min(zarray);        
            if abs(xmax) > abs(xmin)
                xlimit = 1.4*abs(xmax);
            else
                xlimit = 1.4*abs(xmin);
            end
            if abs(zmax) > abs(zmin)
                zlimit = 1.4*abs(zmax);
            else
                zlimit = 1.4*abs(zmin);
            end
            if abs(ymax) > abs(ymin)
                ylimit = 1.4*abs(ymax);
            else
                ylimit = 1.4*abs(ymin);
            end
            axis([-xlimit xlimit -ylimit ylimit -zlimit zlimit]);
        end
        % Turn on/off grid
        if get(H_ABC_pp(8),'Value') == 1
            grid off;axis off;
        else
            grid on;axis on;
        end

     
    % Show ChuaDiode Driving Point Characteristic    
    case 12
        R0=str2num(get(A_ABC_pp(8),'String'));% Get R0
        Gb=str2num(get(A_ABC_pp(20),'String'));% Get Gb
        G=str2num(get(A_ABC_pp(10),'String'));% Get G
        sys_variables = [str2double(get(A_ABC_pp(9),'String')),str2double(get(A_ABC_pp(8),'String')),str2double(get(A_ABC_pp(11),'String')),str2double(get(A_ABC_pp(10),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(12),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(200),'String'))]; % L,R0,C2,G,Ga,Gb,E,C1,a,b,c,d

        dp_popup(R0,Gb,G,Points,sys_variables);
    
        %Export figure so it can be saved
    case 13
        
        figure(10)
        
        sys_variables = [str2double(get(A_ABC_pp(9),'String')),str2double(get(A_ABC_pp(8),'String')),str2double(get(A_ABC_pp(11),'String')),str2double(get(A_ABC_pp(10),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(12),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(200),'String'))]; % L,R0,C2,G,Ga,Gb,E,C1,a,b,c,d
        integ_variables = [str2double(get(A_ABC_pp(21),'String')),str2double(get(A_ABC_pp(22),'String')),str2double(get(A_ABC_pp(23),'String')),str2double(get(A_ABC_pp(28),'String')),str2double(get(A_ABC_pp(27),'String'))]; % x0,y0,z0,dataset_size,step_size
        
        clear global data;
        % Calculate Timeseries
        global Timeseries;
        Timeseries = chua(sys_variables,integ_variables);
        % Calculate System Equilibrium Points
        global Points;
        Points = equil_points(sys_variables);
        
        % Plot Time Series
        %-----------------
        
            

        % Set up time axis, (start-time) to (start-time + number_of_steps*step_size) in increments of (step_size)!
        t = str2double(get(A_ABC_pp(74),'String')):str2double(get(A_ABC_pp(27),'String')):(str2double(get(A_ABC_pp(74),'String')) + str2double(get(A_ABC_pp(28),'String'))*str2double(get(A_ABC_pp(27),'String')));
        % Plot series scaled by relavent ratio
      
        plot(t/str2double(get(A_ABC_pp(53),'String')),Timeseries(1,:)/str2double(get(A_ABC_pp(44),'String')),'Color','r');hold on;
        plot(t/str2double(get(A_ABC_pp(53),'String')),Timeseries(2,:)/str2double(get(A_ABC_pp(47),'String')),'Color','g');hold on;
        plot(t/str2double(get(A_ABC_pp(53),'String')),Timeseries(3,:)/str2double(get(A_ABC_pp(50),'String')),'Color','b');
        axis tight;grid on;
        
        figure(11)
% Calculate Eigen Points & Planes, then place them on GUI
            Eigen_Planes = eigen(sys_variables,Points);
             
        
        % Plot Attractor
        %---------------
           
        plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');hold on;
        
        
        % Plot Equilibrium Points
        plot3(Points(1,1),Points(2,1),Points(3,1),'.', ...
             'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
        text(Points(1,1),Points(2,1),Points(3,1),'  P^{-}','Color',[1 0 0],'FontWeight','bold');
        plot3(Points(1,2),Points(2,2),Points(3,2),'.', ...
                'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
        text(Points(1,2),Points(2,2),Points(3,2),'  0','Color',[1 0 0],'FontWeight','bold');
        plot3(Points(1,3),Points(2,3),Points(3,3),'.', ...
                'MarkerSize',20,'Color',[.8 .4 .2]);hold on;
        text(Points(1,3),Points(2,3),Points(3,3),'  P^{+}','Color',[1 0 0],'FontWeight','bold');
        

        
        xarray = [Timeseries(1,:)];
        yarray = [Timeseries(2,:)];
        zarray = [Timeseries(3,:)];
        
        xmax = max(xarray);
        xmin = min(xarray);
        ymax = max(yarray);
        ymin = min(yarray);
        zmax = max(zarray);
        zmin = min(zarray);
        if abs(xmax) > abs(xmin)
            xlimit = 1.5*abs(xmax);
        else
            xlimit = 1.5*abs(xmin);
        end
        if abs(zmax) > abs(zmin)
            zlimit = 1.5*abs(zmax);
        else
            zlimit = 1.5*abs(zmin);
        end
        if abs(ymax) > abs(ymin)
            ylimit = 1.5*abs(ymax);
        else
            ylimit = 1.5*abs(ymin);
        end

        axis([-xlimit xlimit -ylimit ylimit -zlimit zlimit]);
        
       

        
    % Show FFT Popup Window **BETA QUALITY SEE LINE**
    case 22
        x0=str2double(get(A_ABC_pp(21),'String'));
        y0=str2double(get(A_ABC_pp(22),'String'));
        z0=str2double(get(A_ABC_pp(23),'String'));
        dataset_size=str2double(get(A_ABC_pp(27),'String'));
        step_size=str2double(get(A_ABC_pp(28),'String'));
        integ_variables = [x0,y0,z0,dataset_size,step_size];
        fft_popup(Timeseries,integ_variables);
               
end

%%%%%%%%%%%%%%%%%%%%%%
%Integration routine
%%%%%%%%%%%%%%%%%%%%%%

function TimeSeries = chua(sys_variables,integ_variables)
% Syntax: TimeSeries=chua(L,R0,C2,G,Ga,Gb,C1,E,x0,y0,z0,dataset_size,step_size)


L  =           sys_variables(1);
R0 =           sys_variables(2);
C2 =           sys_variables(3);
G  =           sys_variables(4);
Ga =           sys_variables(5);
Gb =           sys_variables(6);
E  =           sys_variables(7);
C1 =           sys_variables(8);
x0 =           integ_variables(1);
y0 =           integ_variables(2);
z0 =           integ_variables(3);
dataset_size = integ_variables(4);
step_size =    integ_variables(5);


%Initial Conditions set by x0,y0,z0
TimeSeries = [x0, y0, z0]'; % models initial conditions 
                            %x0 = I3, y0 = V2, z0 = V1 from datafiles
                            


% Optimized Runge-Kutta Variables
%--------------------------------

h = step_size; %*(G/C2);
h2 = (h)*(.5);
h6 = (h)/(6);



k1 = [0 0 0]';
k2 = [0 0 0]';
k3 = [0 0 0]';
k4 = [0 0 0]';
M = [0 0 0]';

% Calculate Time Series
%----------------------
% values have to be switched around 
M(1) = TimeSeries(3);   %V1
M(2) = TimeSeries(2);   %V2 
M(3) = TimeSeries(1); %I3

for i=1:dataset_size
    % Runge Kutta
    % Round One
    k1(1) = (G*(M(2) - M(1)) - gnor(M(1),sys_variables))/C1;
    k1(2) = (G*(M(1) - M(2)) + M(3))/C2;
    k1(3) = (-(M(2) + R0*M(3)))/L;
    % Round Two
    k2(1) = (G*(M(2) + h2*k1(2) - (M(1) + h2*k1(1))) - gnor(M(1) + h2*k1(1),sys_variables))/C1;
    k2(2) = (G*(M(1) + h2*k1(1) - (M(2) + h2*k1(2))) + M(3) + h2*k1(3))/C2;
    k2(3) = (-(M(2) + h2*k1(2) + R0*(M(3) + h2*k1(3))))/L;
    % Round Three
    k3(1) = (G*(M(2) + h2*k2(2) - (M(1) + h2*k2(1))) - gnor(M(1) + h2*k2(1),sys_variables))/C1;
    k3(2) = (G*(M(1) + h2*k2(1) - (M(2) + h2*k2(2))) + M(3) + h2*k2(3))/C2;
    k3(3) = (-(M(2) + h2*k2(2) + R0*(M(3) + h2*k2(3))))/L;
    
    % Round Four
    k4(1) = (G*(M(2) + h*k3(2) - (M(1) + h*k3(1))) - gnor(M(1) + h*k3(1),sys_variables))/C1;
    k4(2) = (G*(M(1) + h*k3(1) - (M(2) + h*k3(2))) + M(3) + h*k3(3))/C2;
    k4(3) = (-(M(2) + h*k3(2) + R0*(M(3) + h*k3(3))))/L;
    
    M = M + (k1 + 2*k2 + 2*k3 + k4)*(h6); %Finishes integration and assigns values to M(1),
                                          %M(2) and M(3)   
    
    TimeSeries(3,i+1) = M(1);  %TimeSeries 3 is V1
    TimeSeries(2,i+1) = M(2);  %TimeSeries 2 is V2
    TimeSeries(1,i+1) = M(3); %TimeSeries 1 is I3
    
    i=i+1;
end

%gnor Calculates the cubic nonlinearity
function gnor =  gnor(x,sys_variables)

    a = sys_variables(9);
    b = sys_variables(10);
    c = sys_variables(11);
    d = sys_variables(12);
    
    gnor = a*(x.^3) + b*(x.^2) + c*x + d;

%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%

function Returns = equil_points(sys_variables)
% Syntax: Returns = equil_points(sys_variables)
%
% Returns = [Pminus,Zero,Pplus]
% sys_variables = [L,R0,C2,G,Ga,Gb,E,C1];

% Initialize Variables
L  = sys_variables(1);
R0 = sys_variables(2);
C2 = sys_variables(3);
G  = sys_variables(4);
Ga = sys_variables(5);
Gb = sys_variables(6);
E  = sys_variables(7);
C1 = sys_variables(8);
a = sys_variables(9);
b = sys_variables(10);
c = sys_variables(11);
d = sys_variables(12);


y1 = ((1 + c*R0 + (c/G))/ (-R0*a*(1 + (3/(G*R0)) + (3/((G^2)*(R0^2))) + (1/((R0^3)*(G^3))))))^0.5;
z1 = y1/(-R0);
x1 = y1 - (z1/G);


x2 = (-1)*x1;
y2 = (-1)*y1;
z2 = (-1)*z1;

Returns(1,1) = z2;
Returns(2,1) = y2;
Returns(3,1) = x2;

Returns(1,2) = 0;
Returns(2,2) = 0;
Returns(3,2) = 0;

Returns(1,3) = z1;
Returns(2,3) = y1;
Returns(3,3) = x1;


%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%

function root = cardano(b,c,d) % Solves the roots of a 3rd degree poly
% Cardanos to solve y^3 -by^2 +cy -d = 0
% put y = x + b/3
% Equation Simplifies to x^3 + mx = n
% Where m = c -b^2/3 & n = d - bc/3 + 2b^3/27

% NB************Could use matlab's built-in roots funstion

m = c - b^2/3;
n = d - b*c/3 + 2*b^3/27;
delta = m^3/27 + n^2/4;

if delta > 0 % 1 Real root and a Complex pair
    Temp = n^2/4 + m^3/27;
    tempa = -n/2 + sqrt(Temp);
    tempb = -n/2 - sqrt(Temp);
    % root3A = cuberoot(tempa);
    if tempa == 0
        root3A = 0;
    elseif tempa > 0
        root3A = exp(log(tempa)/3);
    else
        root3A = -1*exp(log(abs(tempa))/3);
    end
    % root3B = cuberoot(tempb);
    if tempb == 0
        root3B = 0;
    elseif tempb > 0
        root3B = exp(log(tempb)/3);
    else
        root3B = -1*exp(log(abs(tempb))/3);
    end
    root(1,1) = (root3A + root3B -b/3);
    root(1,2) = (-(root3A + root3B)/2 - b/3) + (sqrt(3)*(root3A - root3B)/2)*i;
    root(1,3) = (-(root3A + root3B)/2 - b/3) - (sqrt(3)*(root3A - root3B)/2)*i;
    
elseif abs(delta) < 1e-13 % Three real roots, two identical
    root(1,1) = 2*cuberoot(-n/2) - b/3;
    root(1,2) = cuberoot(n/2) - b/3;
    root(1,3) = root(2);
    
else % Three real roots
    TanAngle = (sqrt(-4*m^3 -27*n^2))/(sqrt(27)*n);
    Angle = atan(TanAngle);
    root(1,1) = -2*sign(n)*sqrt(abs(m)/3)*cos(Angle/3) - b/3;
    root(1,2) = -2*sign(n)*sqrt(abs(m)/3)*cos(2*pi/3 + Angle/3) - b/3;
    root(1,3) = -2*sign(n)*sqrt(abs(m)/3)*cos(4*pi/3 + Angle/3) - b/3;
end

%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%

function otherpoint = pointplane(a,b,c,d,xpoint,ypoint,zpoint,missingaxis)
% Uses simple geometry:'plane equation' manipulation to return a missing point
% using plane equation ax+by+cz+d=0 coefficients to calculate. Just zero
% fill the point you dont know and pass which axis its on.
switch missingaxis
    case 'x'
        otherpoint = ((-d-b*ypoint-c*zpoint)/a);
    case 'y'
        otherpoint = ((-d-a*xpoint-c*zpoint)/b);
    case 'z'
        otherpoint = ((-d-a*xpoint-b*ypoint)/c);
end

%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%


function eigen_plane = eigen(sys_variables,eq_points)
%   eigen_plane is a 4x4 matrix that represents three eigenplanes
%   and 3 eigenvalues for each region

%   eigenplane is of the form 
%   row 1 is the inner eigenplane [a b c d]....where d is always 0
%   row 2 is eigenplane2 [a b c d]....where [ax+by+cz(+-)d=0] is the eigenplane

%   row 3 is the inner eigenvalues [real complex complex]
%   row 4 is the outer eigenvalues [real complex complex]

%   The eigenvectors have to be shifted to the equilibrium points in order
%   to plot the eigenplane.
%   sys_variables is a 1x8 matrix that contains the system variables as shown
%   sys_variables = [L,R0,C2,G,Ga,Gb,E,C1];

L  = sys_variables(1);
R0 = sys_variables(2);
C2 = sys_variables(3);
G  = sys_variables(4);
Ga = sys_variables(5);
Gb = sys_variables(6);
E  = sys_variables(7);
C1 = sys_variables(8);
a = sys_variables(9);
b = sys_variables(10);
c = sys_variables(11);
d = sys_variables(12);

y1 = ((1 + c*R0 + (c/G))/ (-R0*a*(1 + (3/(G*R0)) + (3/((G^2)*(R0^2))) + (1/((R0^3)*(G^3))))))^0.5;
z1 = y1/(-R0);
x1 = y1 - (z1/G);

M = ((-3*a*(x1^2)) - c - G)/C1;
M0 = (G+c)*(-1/C1);

%The characteristic equation for the middle region
%Places the coefficients of the characteristic polynomial in a matrix
%Beginning at the highest coefficent (lambda)^3

inner_equation(1) = 1;
inner_equation(2) = ((R0/L)+(G/C2) - M0);
inner_equation(3) = (1/L*C2)*(1 + G*R0) - ((G^2)/(C1*C2)) - (M0*(G/C2 + R0/L));
inner_equation(4) = (-M0/(L*C2))*(1+G*R0) - (((G^2)*R0)/(L*C1*C2));

% The characteristic equation for the outer regions
outer_equation(1) = 1;
outer_equation(2) = ((R0/L)+(G/C2) - M);
outer_equation(3) = (1/L*C2)*(1 + G*R0) - ((G^2)/(C1*C2)) - (M*(G/C2 + R0/L));
outer_equation(4) = (-M/(L*C2))*(1+G*R0) - (((G^2)*R0)/(L*C1*C2));

% Roots of the characteristic equations for the inner and outer region
% Both come with the real eigenvalue first then complex conjugate pair next (if roots complex)
eig_inner = cardano(inner_equation(2),inner_equation(3),inner_equation(4));
eig_outer = cardano(outer_equation(2),outer_equation(3),outer_equation(4));

% Inner Region Normal Vector
normal_vector(1,1) = (C1*(eig_inner(1)-M0))/(G*(L*eig_inner(1)+R0));
normal_vector(1,2) = (C1/G)*(eig_inner(1)-M0); 
normal_vector(1,3) = 1;
% Outer Region Normal Vector
normal_vector(2,1) = (C1*(eig_inner(1)-M))/(G*(L*eig_inner(1)+R0));
normal_vector(2,2) = (C1/G)*(eig_inner(1)-M); 
normal_vector(2,3) = 1;

% Inner Region EigenPlane ->
% Using formula of plane
% a(x-x0)+b(y-y0)+c(z-z0)+d=0
% where [a b c]' is a vector normal to plane & (x0,y0,z0) is a point on the plane
complex_plane(1,1) = (-L/C1)*normal_vector(1,1);
complex_plane(1,2) = (C2/C1)*normal_vector(1,2);
complex_plane(1,3) = normal_vector(1,3);
complex_plane(1,4) = 0;
% Outer Region EigenPlane ->
complex_plane(2,1) = (-L/C1)*normal_vector(2,1);
complex_plane(2,2) = (C2/C1)*normal_vector(2,2); 
complex_plane(2,3) = normal_vector(2,3);
complex_plane(2,4) = -((complex_plane(2,1)*eq_points(1,1)) + (complex_plane(2,2)*eq_points(2,1)) + (complex_plane(2,3)*eq_points(3,1)));

% Append on EigenValues Aswell
complex_plane(3,1:3)=eig_inner(1:3);
complex_plane(4,1:3)=eig_outer(1:3);

% Remove Commma to debug EigenPlanes & Values from console
eigen_plane=complex_plane;

 
%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%% 

function string = file_routine(rw,filename,data)

switch rw
    case 'read'
        % Read in file
        fid = fopen(filename,'r');
        F = fread(fid);
        fclose(fid);
        len = length(F);
        % Open tmp file for writing
        fid = fopen('temp.txt','wb');
        for i=1:(len-1)
            if F(i)==39 % Search for '   Peadar - 39 = ascii for ' ?
                stop = i;
                % Write everything before ' to tmp file, this is then an argument to dlmread in main program body 
                temp = char(F(1:(stop-1))');
                fwrite(fid,temp);
                % Store everything after ' in string, this is the attractor description
                string = char(F((stop+1):(len-1))');
            elseif F(i)==34 % Search for "
                stop = i;
                % Write everything before ' to tmp file, this is then an argument to dlmread in main program body 
                temp = char(F(1:(stop-1))');
                fwrite(fid,temp);
                % Store everything after ' in string, this is the attractor description
                string = char(F((stop+1):(len-1))');              
            end
        end
        fclose(fid);
        
    case 'write'
        % Write file to disk
        fid = fopen(filename,'wb');
        fprintf(fid,data);
        fclose(fid);
        
end


%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%

function f = dp_popup(R0,Gb,G,Points,sys_variables)
% Display ChuaDiode DrivingPoint Characteristic in popup window

    %Background Color
    back_clr = [0.7529 0.7929 0.97];
	% Figure
	h0 = figure('Color',[0.83137 0.81569 0.78431], ...
	    'Color',back_clr, ...
		'Name','ChuaDiode Driving-Point Characteristic', ...
		'NumberTitle','off', ...
		'Units','normalized','Position',[.3 .32 .4 .4], ...
		'Resize','off', ...
		'ToolBar','none', ...
		'Visible','off', ...
        'WindowStyle','modal');
   
    h1 = axes('Parent',h0, ...
        'Color',[1 1 1],'CameraUpVector',[0 1 0],...
		'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
		'Units','normalized','Position',[.13 .13 .79 .79]);

    % Draw Dp Char
    x = (-10:0.01:10);
    cubic = gnor(x,sys_variables);
    plot(x,cubic,'k');
    hold on;

    % Draw loadline IR = -G'(VR) where G' = 1/(R + R0)
    R = 1/G;
    IR = (-1)*(1/(R + R0))*(x);
    plot(x,IR);
    
    % Draw Axes
    Ga = 1;
    if abs(Ga) > abs((Ga+2*Gb))
        ylimit = Ga;
    else
        ylimit = (Ga+2*Gb);
    end
    line([0,0],[-ylimit,ylimit],'Color',[0 0 0]);
    hold on;
    line([-10,10],[0,0],'Color',[0 0 0]);
    hold on;

    % Plot Equilibrium Points
    plot(Points(3,1), Points(1,1), 'ro');
    plot(Points(3,3), Points(1,3), 'ro');
    
    
    xlabel('\bfV_R');
    ylabel('\bfI_R');
    axis('tight');
  
    axis([-10 10 -.005 .005]);

    

    set(h0,'Visible','on');
 
    
    
%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%

function f = fft_popup(Timeseries,integ_variables)
% Display FFT in popup window

%Background Color
back_clr = [0.7529 0.7929 0.97];
% Figure
h0 = figure('Color',[0.83137 0.81569 0.78431], ...
    'Color',back_clr, ...
    'Name','Attractor Power Spectrum Density', ...
    'NumberTitle','off', ...
    'Units','normalized','Position',[.3 .4 .4 .4], ...
    'Resize','off', ...
    'ToolBar','none', ...
    'Visible','off', ...
    'WindowStyle','modal');

h1 = axes('Parent',h0, ...
    'Color',[1 1 1],'CameraUpVector',[0 1 0],...
    'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
    'Units','normalized','Position',[.1 .1 .8067 .83]);

power_density = psd(Timeseries,integ_variables);
plot(power_density(1,:));

set(h0,'Visible','on');
    
%%%%%%%%%%%%%%%%%%%&
% SubFunction  Tom %
%%%%%%%%%%%%%%%%%%%%

function system_variables = reverse_eigen(inner_roots,outer_roots)

char_inner=poly(inner_roots);
char_outer=poly(outer_roots);

delta(1)=char_inner(2)-char_outer(2);
delta(2)=char_inner(3)-char_outer(3);
delta(3)=char_inner(4)-char_outer(4);

X0=(delta(2)/delta(1))-char_inner(2);
Y0=(delta(2)/delta(1))-char_outer(2);


df=char_outer(3) + (-delta(3)/delta(1)) + (Y0*delta(2)/delta(1));
a=(char_outer(4)+(delta(3)*Y0/delta(1)))/(-df);

d=-char_outer(2)-a-Y0;
e=-d;
ad=a*d;

bc=ad-(delta(3)/delta(1));

f=(char_outer(4)+(Y0*delta(3)/delta(1)))/(-ad);
C2=1;
b=bc;
L=(-1/b);
R0=(a/b);   
G=e;
C1=(G)*(1/f);
Ga_dash=(-X0)*(C1);
Ga=Ga_dash-G;

Gb_dash=(-Y0)*(C1);
Gb=Gb_dash-G;
E=1;

system_variables = [L R0 C2 G Ga Gb E C1];


%%%%%%%%%%%%%%%%%%%&
% SubFunction  Tom %
%%%%%%%%%%%%%%%%%%%%

function power_density=psd(data_set,integration_param)


% integ_variables = [x0,y0,z0,dataset_size,step_size]; 
step_size=integration_param(5);

samp_freq=(1/step_size);

len=length(data_set);

%This looks at the size of the data_set that is to be examined
%If the data set is greater than 3000 it examines it in terms of smaller
%blocks that are averaged together

if(len<3000)       
    frame_number=1;
    if(mod(len,2)==1)
        len=len-1;
    end
    point_number=len;
elseif(len<10000)
    point_number=1000;
    frame_number=len/point_number;
    frame_number=frame_number-mod(frame_number,1);    
elseif(len<50000)
    point_number=5000;
    frame_number=len/point_number;
    frame_number=frame_number-mod(frame_number,1);
else
    point_number=10000;
    frame_number=len/point_number;
    frame_number=frame_number-mod(frame_number,1);
end 

accumulator(1:point_number)=0; 

for index=1:frame_number
    
    data_load=data_set(1+((index-1)*point_number):index*point_number);
    z=hanning_window(data_load);
    len=length(z);
    Z=fft(z,point_number);
    Pzz = (Z.* conj(Z) )/ point_number;
    
    if(frame_number==1)
        accumulator=Pzz;
    else
        ac_l=length(accumulator);
        pz_l=length(Pzz);
        accumulator=accumulator+Pzz;
    end
    
end

accumulator=accumulator/frame_number;

power_density(1,1:point_number/2)=accumulator(1:point_number/2);
power_density(2,1:point_number/2)=samp_freq*(1:point_number/2)/point_number;


%%%%%%%%%%%%%%%%%%%&
% SubFunction  Tom %
%%%%%%%%%%%%%%%%%%%%

function window_data=hanning_window(data_set)
% Applies a Hanning Windows to the dataset, attenuating the extremities!

if( mod(length(data_set),2)==0)    
    
    M=length(data_set);
    n=0.5*(M);
    
    for index=-n:n-1
        w=0.5 +0.5*cos(2*pi*index/M);
        window_data(index+n+1)=data_set(index+n+1)*w;
    end;
else
    
    M=length(data_set);
    n=0.5*(M-1);
    
    for index=-n:n
        w=0.5 +0.5*cos(2*pi*index/M);
        window_data(index+n+1)=data_set(index+n+1)*w;
    end;
    
end;