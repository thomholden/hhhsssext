function f = poincare_popup(decide)
% Run Poincaré Application
%Peadar Forbes
global h a Timeseries approx_1 poincare_points V2vector plane H_ABC_pp vertex_matrix save1 line_drawn visible_line af2 ah aponc exp_data ab abponc

switch decide
    case 0 % Set up Poincaré GUI 
        %Background Color
        back_clr = [0.7529 0.7929 0.97];
        % Figure
        f(1) = figure('Color',[0.83137 0.81569 0.78431], ...
            'Color',back_clr, ...
            'Name','Attractor Poincaré Section', ...
            'NumberTitle','off', ...
            'Units','normalized','Position',[.01 .044 .974 .897], ...
            'Resize','off', ...
            'Menubar','none',...
            'Visible','off', ...
            'WindowStyle','normal');
        
        h(1) = axes('Parent',f(1), ...
            'Color',[1 1 1],'CameraUpVector',[0 1 0],...
            'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
            'Units','normalized','Position',[0.040 0.07 0.5 0.68]);
        
        h(2) = axes('Parent',f(1), ...
            'Color',[1 1 1],'CameraUpVector',[0 1 0],...
            'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
            'Units','normalized','Position',[0.64 0.095 0.35 0.40]);
        
        h(3) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame plane big
            'Units','normalized','Position',[0.01 0.919 0.21 0.04],'Style','frame');
        
        h(4) = axes('Parent',f(1), ...
            'Color',[1 1 1],'CameraUpVector',[0 1 0],...
            'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
            'Units','normalized','Position',[0.64 0.58 0.35 0.40]);
        
        h(5) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame Plane small
            'Units','normalized','Position',[0.01 0.959 0.13 0.03],'Style','frame');
        
        h(6) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame slope big
            'Units','normalized','Position',[0.22 0.759 0.238 0.20],'Style','frame');
        
        h(7) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame Slope
            'Units','normalized','Position',[0.22 0.96 0.08 0.03],'Style','frame');
        
        h(8) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame Options small
            'Units','normalized','Position',[0.01 0.888 0.13 0.03],'Style','frame');
        
        h(9) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame Options big
            'Units','normalized','Position',[0.01 0.759 0.21 0.13],'Style','frame');
        
        h(10) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame Pusbuttons big
            'Units','normalized','Position',[0.458 0.759 0.10 0.14],'Style','frame');
        
        
        % Recalculate due to changed step_size or changed plane
        H_ABC_pp(502) = uicontrol('Parent',f(1),'Style','pushbutton',...
            'Units','normalized','Position',[0.468 0.765 0.08 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Recalculate',...
            'Visible','on',...
            'CallBack','poincare_popup(1)');
        
        % Save Figures
        H_ABC_pp(504) = uicontrol('Parent',f(1),'Style','pushbutton',...
            'Units','normalized','Position',[0.468 0.815 0.08 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Screenshot',...
            'Visible','on',...
            'CallBack','poincare_popup(5)');
        
        % Calculate Slope - Pushbutton
        H_ABC_pp(511) = uicontrol('Parent',f(1),'Style','pushbutton',...
            'Units','normalized','Position',[0.24 0.765 0.1 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Calculate Slope',...
            'Visible','on',...
            'CallBack','poincare_popup(10)');
        
        
        
        % Clear Slope - Pushbutton
        H_ABC_pp(510) = uicontrol('Parent',f(1),'Style','pushbutton',...
            'Units','normalized','Position',[0.365 0.765 0.07 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Clear Slope',...
            'Visible','on',...
            'CallBack','poincare_popup(1)');
        
                
        % Load Experimental - Pushbutton
        H_ABC_pp(513) = uicontrol('Parent',f(1),'Style','pushbutton',...
            'Units','normalized','Position',[0.92 0.5 0.07 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Load Exp',...
            'Visible','on',...
            'CallBack','poincare_popup(11)');

        
        % Export Figures
        H_ABC_pp(515) = uicontrol('Parent',f(1),'Style','pushbutton',...
            'Units','normalized','Position',[0.468 0.86 0.08 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Export',...
            'Visible','on',...
            'CallBack','poincare_popup(15)');
       
 
        
        aponc(1) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame  (View angle)
            'Units','normalized','Position',[0.65 0.005 0.27 0.029],'Style','frame');
        
        aponc(2) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...%View Angle Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.653 0.009 0.08 0.02],'String','View Angle:','Style','text');
        
        
        
        
        aponc(4) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% I3-V2 Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.74 0.009 0.03 0.02],'String','I3-V2','Style','text');
        
        
        aponc(5) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% I3-V1 Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.8 0.009 0.03 0.02],'String','I3-V1','Style','text');
        
        aponc(6) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% V2-V1 Text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.86 0.009 0.05 0.02],'String','V2-V1','Style','text');
        
        a(11) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Plane Equation Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.02 0.965 0.11 0.020],'String','Plane Equation:','Style','text');
        
        a(23) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Options Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.02 0.893 0.11 0.020],'String','Options:','Style','text');
        
        a(12) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% SlopeText
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.23 0.967 0.05 0.021],'String','Slope:','Style','text');
        
        
        a(13) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Step Size Reduction: Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.02 0.827 0.13 0.06],'String','Step Size Reduction:','Style','text');
        
                
        a(22) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Ramp up text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.02 .825 0.1 0.035],'String','Ramp up:','Style','text');
        
        a(24) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Use smart Ramp Up Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.039 0.79 0.13 0.035],'String','Use Smart Ramp-up','Style','text');
        
        a(25) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% View "Red" Points Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.039 0.76 0.13 0.035],'String','View "Red" Points','Style','text');
        
        a(14) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Reduce Step Size input box
            'HorizontalAlignment','left','Units','normalized','Position',[0.155 0.862 0.035 0.025],'Style','edit','String','10');
        
        a(15) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% x coefficient input box 0.70 0.78 0.025 0.025
            'HorizontalAlignment','left','Units','normalized','Position',[0.02 0.925 0.025 0.025],'Style','edit','String','1');
        
        a(24) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Remove Ramp-up input box
            'HorizontalAlignment','left','Units','normalized','Position',[0.155 0.835 0.035 0.025],'Style','edit','String','1');
        
        a(19) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% x coefficient text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.045 0.925 0.021 0.025],'String','x +','Style','text');
    
        
        a(16) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% y coefficient input box
            'HorizontalAlignment','left','Units','normalized','Position',[0.07 0.925 0.025 0.025],'Style','edit','String','0');
        
        a(20) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% y coefficient text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.095 0.925 0.021 0.025],'String','y +','Style','text');
        
        a(17) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% z coefficient input box
            'HorizontalAlignment','left','Units','normalized','Position',[0.12 0.925 0.025 0.025],'Style','edit','String','0');
        
        a(23) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% z coefficient text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.145 0.925 0.021 0.025],'String','z +','Style','text');
        
        a(18) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% d coefficient input box
            'HorizontalAlignment','left','Units','normalized','Position',[0.17 0.925 0.025 0.025],'Style','edit','String','-.00137');
        
        a(21) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% = 0 text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.195 0.925 0.021 0.025],'String','= 0','Style','text');


        
        
        %Slope Calculation GUI components:
        
        af2(2) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...%Linear Region of Graph text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.23 0.92 0.15 0.03],'String','Linear Region of Graph: ','Style','text');
        
        af2(3) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Vxn min value text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.23 0.905 0.1 0.02],'String','V2(xn) min:','Style','text');
        
        af2(4) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Vxmin value input box
            'HorizontalAlignment','left','Units','normalized','Position',[0.295 0.901 0.025 0.025],'Style','edit','String','0.2');
        
        
        af2(5) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Vxn max value text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.35 0.905 0.1 0.02],'String','V2(xn) max:','Style','text');
        
        af2(6) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Vxmax value input box
            'HorizontalAlignment','left','Units','normalized','Position',[0.42 0.901 0.025 0.025],'Style','edit','String','0.6');
        

        
        af2(9) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...%Results: text
            'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.23 0.87 0.1 0.02],'String','Results: ','Style','text');
        
        af2(10) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...%Least Squares Approximation: text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.23 0.845 0.22 0.02],'String','Least Squares Approximation: ','Style','text');
        
        af2(11) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...%Calculated Slope: text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.23 0.82 0.21 0.02],'String','Calculated Slope: ','Style','text');
        
        af2(12) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...%Percentage difference: text
            'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.23 0.795 0.2 0.02],'String','% Diff: ','Style','text');
        
        
        
        

        
        %RADIOBUTTONS-----------------------------------------------
        
        %I3-V2 Radio Button
        H_ABC_pp(506) = uicontrol('Style','radiobutton','Min',0,'Max',1,... % Radio
            'Units','normalized','Position',[0.775 0.006 0.014 0.024],...
            'BackgroundColor',[1 1 1],'Visible','on',...
            'CallBack','poincare_popup(7)'); 
        
        %I3-V1 Radio Button
        H_ABC_pp(507) = uicontrol('Style','radiobutton','Min',0,'Max',1,... % Radio
            'Units','normalized','Position',[0.835 0.006 0.014 0.024],...
            'BackgroundColor',[1 1 1],'Visible','on',...
            'Value',1,...
            'CallBack','poincare_popup(8)'); 
        
        
        %V2-V1 Radio Button
        H_ABC_pp(508) = uicontrol('Style','radiobutton','Min',0,'Max',1,... % Radio
            'Units','normalized','Position',[0.90 0.006 0.014 0.024],...
            'BackgroundColor',[1 1 1],'Visible','on',...
            'CallBack','poincare_popup(9)'); 
        
        
        
        
        %CHECKBOXES--------------------------------------------------------
                
        %Smart Ramp-up checkbox
        H_ABC_pp(510) = uicontrol('Style','checkbox','Min',0,'Max',1,... % Checkbox
            'Units','normalized','Position',[0.02 0.80 0.014 0.02],...
            'BackgroundColor',[1 1 1],'Visible','on',...
            'CallBack','poincare_popup(1)');  
        
        
        
        %Radio button to select which direction through the plane you want
        %to plot in the poincare map(top right) window.
        H_ABC_pp(503) = uicontrol('Style','checkbox','Min',0,'Max',1,... % Checkbox
            'Units','normalized','Position',[0.02 0.77 0.014 0.02],...
            'BackgroundColor',[1 1 1],'Visible','on',...
            'CallBack','poincare_popup(1)');
        %CHECKBOXES END--------------------------------------------
        
        
        
        set(f(1),'Visible','on');
        set(af2(9:12),'Visible','off'); 
        % Read in the variables passed to poincaré_popup that were temp saved to disk!!
        S = load('data\temp.mat');
        Timeseries = S.Timeseries;
        sys_variables = S.sys_variables;
        integ_variables = S.integ_variables;
        view_angle = S.view_angle;
        eigen_value = S.eigen_value;
 
        plane = [str2num(get(a(15),'String')),str2num(get(a(16),'String')),str2num(get(a(17),'String')),str2num(get(a(18),'String'))];
        integ_variables(6) = str2num(get(a(14),'String')); %Gets value for the step_size_divisor
        poincare_points_a = poincare(Timeseries,plane,sys_variables,integ_variables);
        
        poincare_points = poincare_points_a(:,1:4);
        approx_1 = poincare_points_a(:,5:8);
        
        
        if isreal(poincare_points)
            axes(h(2)); %Point to Poincare Section - bottom right
            for i=1:length(poincare_points(:,1))
                if poincare_points(i,4) == 1
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'or');
                    hold on;
                else
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'ob');
                    hold on;
                end
            end  
            hold off;
            xmax = max(poincare_points(:,1));
            xmin = min(poincare_points(:,1));
            zmax = max(poincare_points(:,3));
            zmin = min(poincare_points(:,3));
            ymax = max(poincare_points(:,2));
            ymin = min(poincare_points(:,2));
            
            if xmax > 0
                xmax=xmax*1.1;
            else
                xmax=xmax*.9;
            end
            if xmin > 0
                xmin=xmin*.9;
            else
                xmin=xmin*1.1;
            end
            if zmax > 0
                zmax=zmax*1.1;
            else
                zmax=zmax*.9;
            end
            if zmin > 0
                zmin=zmin*.9;
            else
                zmin=zmin*1.1;
            end
            if ymin > 0
                ymin=ymin*.9;
            else
                ymin=ymin*1.1;
            end
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),xmin,xmax,zmin,zmax,ymin,ymax);
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',.5,'EdgeAlpha',0.1);
            set(h(2),'CameraUpVector',[plane(1) plane(2) plane(3)]);
            xlabel('I3');
            ylabel('V2');
            zlabel('V1');
            view(0,0);axis tight;
            rotate3d on;
            
            axes(h(4)); % Point to Poincare Map - top right 
            
            %This separates the poincare map points into two bins - one for each 
            %direction that they cross the plane in
            
            poin = poincare_points;
            
            bindex=1;
            aindex=1;
            
            
            for i=1:length(poin(:,1))           
                if poin(i,4)==0  %this finds what direction they crossed in 
                    a_poin(aindex,:) = poin(i,:);
                    aindex = aindex+1;
                else
                    b_poin(bindex,:) = poin(i,:);
                    bindex = bindex+1;
                end
                
            end
            
            if(exist('a_poin') && length(a_poin(:,1)) >1) %if a_poin exists
              
                %poin_xnplusone is the value at time t+1
                %this will be plotted against poin_xn, the value at time t
                
                poin_xnplusone(1:length(a_poin(:,1))-1,:) = a_poin(2:length(a_poin(:,1)),:);
                poin_xn(1:length(a_poin(:,1))-1,:) = a_poin(1:length(a_poin(:,1))-1,:);
                if length(poin_xn)~=0
                    I3vector = [poin_xn(:,1),poin_xnplusone(:,1)]; %Sorts them into vectors that can be plotted
                    V2vector = [poin_xn(:,2),poin_xnplusone(:,2)];
                    V1vector = [poin_xn(:,3),poin_xnplusone(:,3)];
                    
                    plot(V2vector(:,1),V2vector(:,2),'.') %Plots the V2 vector at xn+1 against xn
                    xlabel('V2(xn)');
                    ylabel('V2(xn+1)');
                    clear poin;
                else
                    text(0.5,0.5,'Not enough points to plot');
                    axis tight
                end
            end
            axes(h(1)); % Point to main stage - i.e. TimeSeries Trajectory Plotting            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10),(ymin+ymin/10),(ymax+ymax/10));
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',0.7,'EdgeAlpha',0.1);
            %text(,'  E^{c}(0)','Color','m','FontWeight','bold');

            xlabel('I3');
            ylabel('V2');
            zlabel('V1');
            view(view_angle);%axis off;
            rotate3d(h(1));
            
            

        else
           
            % Read in warning image and place it Small Axes
            warning off all % Suppress Warning
            axes(h(2));
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            axes(h(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');

            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            ymin=min(Timeseries(2,:));
            ymax=max(Timeseries(2,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10),(ymin+ymin/10),(ymax+ymax/10));
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',1,'EdgeAlpha',0.1);
            view(view_angle);%axis off;
            rotate3d(h(1));
            
            axes(h(4));
            warning off all % Suppress Warning
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            
        end
        set(H_ABC_pp(503),'Visible','on');
        set(H_ABC_pp(503),'Value',0);
        line_drawn=0;
        
    case 1
        %set(af2(8:12),'Visible','off'); %setting results in slope popup to invisible
        clear('poincare_points');
        S = load('data\temp.mat');
        Timeseries = S.Timeseries;
        sys_variables = S.sys_variables;
        plane = [str2num(get(a(15),'String')),str2num(get(a(16),'String')),str2num(get(a(17),'String')),str2num(get(a(18),'String'))];
        integ_variables = S.integ_variables;
        eigen_value = S.eigen_value;
        %set(a(22),'String',[get(a(15),'String'),'x+',get(a(16),'String'),'y+',get(a(17),'String'),'z+',get(a(18),'String'),'=0']);
        plane = [str2num(get(a(15),'String')),str2num(get(a(16),'String')),str2num(get(a(17),'String')),str2num(get(a(18),'String'))];
        
        integ_variables(6) = str2num(get(a(14),'String')); %Gets the step_size_divisor variable from user
        
        remove_ramp_up = str2num(get(a(24),'String'));
        Timeseries=Timeseries(:,remove_ramp_up:length(Timeseries));

        poincare_points_a = poincare(Timeseries,plane,sys_variables,integ_variables);

        poincare_points = poincare_points_a(:,1:4);
        approx_1 = poincare_points_a(:,5:8);
        
        if isreal(poincare_points)
            axes(h(2)); % Point to Poincare Section bottom right
            
            for i=1:length(poincare_points(:,1)) %plots the points in the window, red for one direction, blue for the other
                if poincare_points(i,4) == 1
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'or');
                    hold on;
                else
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'ob');
                    hold on;
                end
            end  
            hold off;   
            
            xmax = max(poincare_points(:,1));
            xmin = min(poincare_points(:,1));
            ymin = min(poincare_points(:,2));
            ymax = max(poincare_points(:,2));
            zmax = max(poincare_points(:,3));
            zmin = min(poincare_points(:,3));
            if xmax > 0
                xmax=xmax*1.1;
            else
                xmax=xmax*.9;
            end
            if xmin > 0
                xmin=xmin*.9;
            else
                xmin=xmin*1.1;
            end
            if zmax > 0
                zmax=zmax*1.1;
            else
                zmax=zmax*.9;
            end
            if zmin > 0
                zmin=zmin*.9;
            else
                zmin=zmin*1.1;
            end
            if ymin > 0
                ymin=ymin*.9;
            else
                ymin=ymin*1.1;
            end
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),xmin,xmax,zmin,zmax,ymin,ymax);
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',.5,'EdgeAlpha',0.1);
            set(h(2),'CameraUpVector',[plane(1) plane(2) plane(3)]);
            xlabel('I3');
            ylabel('V2');
            zlabel('V1');
            
            if get(H_ABC_pp(506),'Value') == 1
                view(0,90);
                axis tight;
            elseif get(H_ABC_pp(507),'Value') == 1
                view(0,0);  
                axis tight;
            elseif get(H_ABC_pp(508),'Value') == 1
                view(90,0);
                axis tight;
            end
            
            axes(h(4)); % Point to Poincare Map - top right 
            
            %This separates the poincare map points into two bins - one for each 
            %direction that they cross the plane in
            
            poin = poincare_points;
            
            bindex=1;
            aindex=1;
            for i=1:length(poin(:,1))           
                if poin(i,4)==0  %this finds what direction they crossed in 
                    a_poin(aindex,:) = poin(i,:);
                    aindex = aindex+1;
                else
                    b_poin(bindex,:) = poin(i,:);
                    bindex = bindex+1;
                end
                
            end
            
            if(exist('a_poin') && length(a_poin(:,1)) >1) %if a_poin exists
                %poin_xnplusone is the value at time t+1
                %this will be plotted against poin_xn, the value at time t
                
                if get(H_ABC_pp(503),'Value') == 0
                    
                    poin_xnplusone(1:length(a_poin(:,1))-1,:) = a_poin(2:length(a_poin(:,1)),:);
                    poin_xn(1:length(a_poin(:,1))-1,:) = a_poin(1:length(a_poin(:,1))-1,:);
                    

                        I3vector = [poin_xn(:,1),poin_xnplusone(:,1)]; %Sorts them into vectors that can be plotted
                        V2vector = [poin_xn(:,2),poin_xnplusone(:,2)];
                        V1vector = [poin_xn(:,3),poin_xnplusone(:,3)];
                        plot(V2vector(:,1),V2vector(:,2),'.') %Plots the V2 vector at xn+1 against xn


              
                    
                    
                else
                    poin_xnplusone(1:length(b_poin(:,1))-1,:) = b_poin(2:length(b_poin(:,1)),:);
                    poin_xn(1:length(b_poin(:,1))-1,:) = b_poin(1:length(b_poin(:,1))-1,:);

                        I3vector = [poin_xn(:,1),poin_xnplusone(:,1)]; %Sorts them into vectors that can be plotted
                        V2vector = [poin_xn(:,2),poin_xnplusone(:,2)];
                        V1vector = [poin_xn(:,3),poin_xnplusone(:,3)];
                        
                        plot(V2vector(:,1),V2vector(:,2),'.') %Plots the V2 vector at xn+1 against xn
                end
            end
            xlabel('V2(xn)');
            ylabel('V2(xn+1)');
           
            
            clear V2vector;
            clear poin_xnplusone;
            clear poin_xn;
            clear poin;
            
            
            axes(h(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xlabel('I3');
            ylabel('V2');
            zlabel('V1');
            
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            ymin=min(Timeseries(2,:));
            ymax=max(Timeseries(2,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10),(ymin+ymin/10),(ymax+ymax/10));
            %            vertex_matrix = [xmin 0 zmin; xmin 0 zmax; xmax 0 zmin; xmax 0 zmax]

            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',.8,'EdgeAlpha',0.1);
            %view(view_angle);%axis off;
            rotate3d(h(1));
            
             
          
            

            
            
        else
            % Read in warning image and place it Small Axes

            warning off all % Suppress Warning
            axes(h(2));
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            
            
            
            axes(h(4));
            warning off all % Suppress Warning
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            axes(h(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xlabel('Current');
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            ymin=min(Timeseries(2,:));
            ymax=max(Timeseries(2,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10),(ymin+ymin/10),(ymax+ymax/10));
            %vertex_matrix = [xmin 0 zmin; xmin 0 zmax; xmax 0 zmin; xmax 0 zmax]
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',1,'EdgeAlpha',0.1);
            %view(view_angle);%axis off;
            axis on;
            rotate3d(h(1));
            

        end
        line_drawn=0;
        
    
        
     %When toggling between which points, red or blue to show in poincare map   
    case 3
        
        %This separates the poincare map points into two bins - one for each 
        %direction that they cross the plane in
        
        poin = poincare_points;
        
        bindex=1;
        aindex=1;
        for i=1:length(poin)           
            if poin(i,4)==0  %this finds what direction they crossed in,0 means the blue points
                a_poin(aindex,:) = poin(i,:);
                aindex = aindex+1;
            else
                b_poin(bindex,:) = poin(i,:);
                bindex = bindex+1;
            end
            
        end
     

        if get(H_ABC_pp(503),'Value') == 1 % If (Plot Red points in Poincare map) radio selected
              
            %poin_xnplusone is the value at time t+1
            %this will be plotted against poin_xn, the value at time t
            
            poin_xnplusone(1:length(b_poin(:,1))-1,:) = b_poin(2:length(b_poin(:,1)),:);
            poin_xn(1:length(b_poin(:,1))-1,:) = b_poin(1:length(b_poin(:,1))-1,:);
            
            
        else
            
            poin_xnplusone(1:length(a_poin(:,1))-1,:) = a_poin(2:length(a_poin(:,1)),:);
            poin_xn(1:length(a_poin(:,1))-1,:) = a_poin(1:length(a_poin(:,1))-1,:);
            
        end
            I3vector = [poin_xn(:,1),poin_xnplusone(:,1)]; %Sorts them into vectors that can be plotted
            V2vector = [poin_xn(:,2),poin_xnplusone(:,2)];
            V1vector = [poin_xn(:,3),poin_xnplusone(:,3)];
            axes(h(4));
            plot(V2vector(:,1),V2vector(:,2),'.') %Plots the V2 vector at xn+1 against xn
            axes(h(1));
            axis on;
            rotate3d(h(1));
            clear poin_xnplusone;
            clear poin_xn;
            clear V2vector;
            
            
            %Save the figures - code in saving.m file 
        case 4
            savefile = 'data\temp2.mat';
            save(savefile,'poincare_points','plane')
          
            % Add etc directory to Matlab's Path: so as to call poincare_popup!
            saving(0,h,Timeseries,vertex_matrix,plane);
         
            %Screenshot
        case 5
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
                    extension = 'eps';
                elseif filterindex == 2
                    extension = 'jpg';
                elseif filterindex == 3
                    extension = 'emf';
                end
                filename1 = [filename,'_colour'];
                saveas(h(1),filename,extension);
                saveas(h(1),filename1,'epsc');
                cd(home);
            else
                cd(home);
            end
            

            
            
            
            
            %Toggling the View angle on the Poincare Section
        case 7
            if get(H_ABC_pp(506),'Value') == 1
                
                set(H_ABC_pp(507),'Value',0);
                set(H_ABC_pp(508),'Value',0);
                
                axes(h(2)); %Point to poincare section-bottom right
                view(0,90);
                axis tight;
                
            end
            
            
            %Toggling the View angle on the Poincare Section
        case 8       
            if get(H_ABC_pp(507),'Value') == 1
                
                set(H_ABC_pp(506),'Value',0);
                set(H_ABC_pp(508),'Value',0);
                
                axes(h(2)); %Point to poincare section-bottom right
                view(0,0); 
                axis tight;
            end
            
            
            %Toggling the View angle on the Poincare Section  
        case 9
            
            if get(H_ABC_pp(508),'Value') == 1
                
                set(H_ABC_pp(506),'Value',0);
                set(H_ABC_pp(507),'Value',0);
                
                axes(h(2)); %Point to poincare section-bottom right
                view(90,0); 
                axis tight;
            end
            
        %Draw least squares approximation on poincare map - top right    
        case 10
                        
            S = load('data\temp.mat');
            eigen_value = S.eigen_value;
            axes(h(4)); %Point to Poincare map - top right
            
            V2_xmin = str2num(get(af2(4),'String'));
            V2_xmax = str2num(get(af2(6),'String'));
            
            %This code only relevant to slope line when drawn by hand:
            %if(line_drawn~=0)
                
            %    set(visible_line,'Visible','off');
            %end
            
            %Code to manually draw the slope by picking two points on the
            %line - another option
            %x=ginput(1);
            %y=ginput(1);
            %slope = (x(2) - y(2))/(x(1) - y(1))
            %line1 = [x(1) y(1)];
            %line2 = [x(2) y(2)];
            %visible_line= line(line1,line2,'Color',[1 0 0]);
            %set(visible_line,'Visible','on');
            %Calculating slope from eigenvalues:
            
            im = (imag(eigen_value));
            re = (real(eigen_value));
            
            tot = (re*2*pi);
            calculated_slope = exp(tot/im);
            line_drawn=1;
            
            %Calculating slope of the linear region using least squares
            %approximation - EXPLAIN!!!!!!!!!!!
            
            %this FOR statement seperates the x values according to the
            %user specs
            index=1;
            for i=1:length(V2vector(:,1))
                if ((V2vector(i,1) >=V2_xmin) && (V2vector(i,1) <=V2_xmax))
                    A(index,:) = [V2vector(i,1) 1];
                    Y(index) = V2vector(i,2);
                    index=index+1;
                end
            end
            
            Y = Y';
            x = (inv(A'*A))*A'*Y; %x is a 2x1 matrix containing the slope and the constant, i.e. mx+c
            xvector=min(V2vector(:,1)):0.05:max(V2vector(:,1));
            y = x(1)*xvector+x(2);
            
            hold on
            plot(xvector,y,'r');
            axis tight;
            hold off
            least_squares_slope = x(1);
            
            
            if(least_squares_slope >= calculated_slope)
                percentage_diff = 100 - (calculated_slope/least_squares_slope)*100;
            else
                percentage_diff = 100 - (least_squares_slope/calculated_slope)*100;
            end
            
            set(af2(10),'String',['Least Squares Approximation: ',num2str(least_squares_slope)]);
            set(af2(11),'String',['Calculated Slope: ',num2str(calculated_slope)]);
            set(af2(12),'String',['% Diff: ',num2str(percentage_diff),'%']);
            set(af2(9:12),'Visible','on');

            axes(h(1));
            rotate3d(h(1));
            
            %Draw the expermental results    
        case 11
            %|||||||||||||||||||||||||||||||||||||||||||||NB|||||||||||||||||||||||||||||||||||||||||||||||||||||
            %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
            %This assumes that the data is in the form colunm1: I3,
            %column2: V2, and column3: V1
            
            % Home Directory
            home = pwd;
            %Open File Open Dialog
            [filename, pathname] = uigetfile('*.mat','Select Data File');   
            if filename ~= 0 % Yes file exists
                % Navigate to data directory - if different from default
                cd(pathname);
                % Load the .mat file and assign it to struct
                % exp_data.(vec)
                exp_data = load(filename);
                names = fieldnames(exp_data);
                vec = char(names);
                
                axes(h(4));
                hold on
                plot(exp_data.(vec)(1:length(exp_data.(vec))-1,2), exp_data.(vec)(2:length(exp_data.(vec)),2),'.r');
                axis tight
                hold off
                cd(home);
            end
            
            axes(h(1));
            rotate3d(h(1));
            
            %Prepare Experimental Results for program
        case 12
            % Display ChuaDiode DrivingPoint Characteristic in popup window
            
            %Background Color
            back_clr = [0.7529 0.7929 0.97];
            % Figure
            f(4) = figure('Color',[0.83137 0.81569 0.78431], ...
                'Color',back_clr, ...
                'Name','Prepare Experimental Results', ...
                'NumberTitle','off', ...
                'Units','normalized','Position',[.3 .1 .42 .84], ...
                'Resize','off', ...
                'ToolBar','none', ...
                'MenuBar','none',...
                'Visible','off', ...
                'WindowStyle','normal');
            
            h(5) = axes('Parent',f(4), ...
                'Color',[1 1 1],'CameraUpVector',[0 1 0],...
                'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
                'Units','normalized','Position',[0.1 0.49 0.8 0.35]);
          
            
            h(6) = axes('Parent',f(4), ...
                'Color',[1 1 1],'CameraUpVector',[0 1 0],...
                'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
                'Units','normalized','Position',[0.1 0.05 0.8 0.35]);
            
            abponc(1) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% Frame  (Load Data1)
                'Units','normalized','Position',[0.025 0.96 0.2 0.035],'Style','frame');
            
            abponc(2) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% Frame  (Load Data2)
                'Units','normalized','Position',[0.025 0.86 0.45 0.1],'Style','frame');
            
            abponc(6) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% Frame  (Remove Noise1)
                'Units','normalized','Position',[0.475 0.96 0.235 0.035],'Style','frame');
            
            abponc(7) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% Frame  (Remove Noise2)
                'Units','normalized','Position',[0.475 0.86 0.52 0.1],'Style','frame');
                        
            abponc(3) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...%Filename Text
                'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
                'Units','normalized','Position',[0.0265 0.92 0.15 0.03],'String','Filename:','Style','text');
            
            abponc(4) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...%no. of files Text
                'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
                'Units','normalized','Position',[0.0265 0.89 0.15 0.03],'String','No. of files:','Style','text');
           
            abponc(5) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...%Load Data Text
                'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
                'Units','normalized','Position',[0.035 0.962 0.15 0.03],'String','Load Data:','Style','text');
             
            abponc(8) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...%Remove Noise Text
                'FontName','Helvetica','HorizontalAlignment','left','FontWeight','bold','FontSize',10,'ForegroundColor',[0 0 0],...
                'Units','normalized','Position',[0.485 0.962 0.22 0.03],'String','Remove Noise:','Style','text');
            
            abponc(9) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...%Linear Region: Text
                'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
                'Units','normalized','Position',[0.49 0.92 0.4 0.03],'String','Linear Region:','Style','text');
            
            abponc(10) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...%V2(xn)min Text
                'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
                'Units','normalized','Position',[0.49 0.90 0.15 0.03],'String','V2(xn)min','Style','text');
            
            abponc(11) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...%V2(xn)max Text
                'FontName','Helvetica','HorizontalAlignment','left','FontSize',10,'ForegroundColor',[0 0 0],...
                'Units','normalized','Position',[0.75 0.90 0.15 0.03],'String','V2(xn)max','Style','text');
           
            
            ab(1) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% Filename input box
                'HorizontalAlignment','left','Units','normalized','Position',[0.180 0.926 0.15 0.025],'Style','edit','String','data');
            
            ab(2) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% no. of files input box
                'HorizontalAlignment','left','Units','normalized','Position',[0.180 0.895 0.05 0.025],'Style','edit','String','8');
            
            ab(3) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% V2(xn)min input box
                'HorizontalAlignment','left','Units','normalized','Position',[0.63 0.906 0.065 0.025],'Style','edit','String','0.2');
            
            ab(4) = uicontrol('Parent',f(4),'BackgroundColor',[1 1 1],...% V2(xn)max input box
                'HorizontalAlignment','left','Units','normalized','Position',[0.89 0.906 0.065 0.025],'Style','edit','String','0.8');

            % Plot Data - Pushbutton
            H_ABC_pp(511) = uicontrol('Parent',f(4),'Style','pushbutton',...
                'Units','normalized','Position',[0.329 0.864 0.12 0.0325],...
                'ForegroundColor',[0 0 0],...
                'FontWeight','bold',...
                'String','Plot Data',...
                'Visible','on',...
                'CallBack','poincare_popup(13)');
            
            
            % Remove Noise - Pushbutton
            H_ABC_pp(512) = uicontrol('Parent',f(4),'Style','pushbutton',...
                'Units','normalized','Position',[0.5 0.864 0.2 0.0325],...
                'ForegroundColor',[0 0 0],...
                'FontWeight','bold',...
                'String','Remove Noise',...
                'Visible','on',...
                'CallBack','poincare_popup(14)');
            
            
            set(f(4),'Visible','on');
          
            %Plotting data in experimental results popup window    
        case 13
            home = pwd;
            cd results;
            filename = get(ab(1),'String');
            no_of_files= str2num(get(ab(2),'String'));
            
            %Read in files
            for i=1:no_of_files
                name = [filename,num2str(i)];
                name = [name,'.tab'];
                if exist(name)==2 %Check if it exists
                    data{i} = load(name);
                else
                    data{i}=[];
                end
            end
            cd(home);
            for i=no_of_files:10 %10 is the max number of files you can have
                data{i}=[];
            end
            
            results = [data{1};data{2};data{3};data{4};data{5};data{6};data{7};data{8};data{9};data{10}];
            if ~isempty(results)
                %plotting samples
                axes(h(5)) %Point to top graph in experimental results window
                plot(results(:,2),results(:,3),'b.');
            end
            
            
            
            %Removing Noise
        case 14
            home = pwd;
            cd results;
            filename = get(ab(1),'String');
            no_of_files= str2num(get(ab(2),'String'));
            minV2value = str2num(get(ab(3),'String'));
            maxV2value = str2num(get(ab(4),'String'));
            
            %Read in files
            for i=1:no_of_files
                name = [filename,num2str(i)];
                name = [name,'.tab'];
                data{i} = load(name);
            end
            
            for i=no_of_files:10 %10 is the max number of files you can have
                data{i}=[];
            end
            cd(home);
            results = [data{1};data{2};data{3};data{4};data{5};data{6};data{7};data{8};data{9};data{10}];
            results = sortrows(results,2);
            
            vector_index=1;
            section1 = minV2value-0.02;
            section2 = minV2value;
            i = 1;
            noise=0;
            noise_index=1;
            through=0;
           
            % PART 1 OF ALGORITHM - REMOVE NOISE FROM HORIZONTAL SECTION OF GRAPH
            while (i < (length(results(:,1)))) & (section2 < maxV2value)
                tempempty=0;
                passedthrough = 0;
                flag =0;
                index = 1;
                
                section1 = section1+.02;
                section2 = section1+.02;
                
                while (flag==0) & (i < (length(results(:,1)))) & (results(i,2)<section2)  %include - "& results(i,2) < section2"
                    %this should stop
                    %errors ocurring when
                    %there's no data in the
                    %interval selected
                    if (results(i,2) <= section2) & (results(i,2) >= section1)
                        passedthrough = 1;
                        temp(index,:) = [results(i,:)];
                        index=index+1;
                        i=i+1;
                        tempempty=1;
                    else
                        if passedthrough==1
                            flag=1;
                        else
                            i=i+1;
                        end
                    end
                end
                
                if tempempty~=0
                    average = mean(temp(:,3),1);
                    upperlim =average*1.05;
                    lowerlim =average*0.95;
                    for j=1:length(temp(:,1))
                        if (temp(j,3) <= upperlim) & (temp(j,3) >= lowerlim)
                            finalvector(vector_index,:) = temp(j,:);
                            vector_index=vector_index+1;
                            through = through+1;
                        else
                            noisevector(noise_index,:) = temp(j,:);
                            noise=noise+1;
                            noise_index = noise_index+1;
                        end
                    end
                    clear temp;
                    
                else
                    i=i+1;
                end
                
            end
            
            
            first_through = through;
            first_noise = noise;
 
            %PART ii of algorithm - remove noise from vertical part of graph
            ceilingvalue = max(results(:,2));
            while( i < length(results(:,1)))
                if(results(i,2) < 1.02) & (results(i,2) >maxV2value)
                    finalvector(vector_index,:) = results(i,:);
                    vector_index=vector_index+1;
                    through = through+1;
                    i=i+1;
                else
                    noisevector(noise_index,:)= results(i,:);
                    noise=noise+1;
                    noise_index=noise_index+1;
                    i=i+1;
                end
            end       
            
            second_through = through;
            second_noise = noise;
            
            axes(h(6)) %Point to bottom graph in experimental results window
            plot(finalvector(:,2),finalvector(:,3),'b.');
           
            
            finalvector = [finalvector(:,2),finalvector(:,3)];
           
            savefile = [filename,'_finalvector','.mat'];
            save(savefile,'finalvector'); %Save the finalvector as NAME_finalvector.mat file
            
            
       
    %Export each figure to another window for individual saving    
    case 15
        figure(11)
        
        clear('poincare_points');
        S = load('data\temp.mat');
        Timeseries = S.Timeseries;
        sys_variables = S.sys_variables;
        plane = [str2num(get(a(15),'String')),str2num(get(a(16),'String')),str2num(get(a(17),'String')),str2num(get(a(18),'String'))];
        integ_variables = S.integ_variables;
        eigen_value = S.eigen_value;
        %set(a(22),'String',[get(a(15),'String'),'x+',get(a(16),'String'),'y+',get(a(17),'String'),'z+',get(a(18),'String'),'=0']);
        plane = [str2num(get(a(15),'String')),str2num(get(a(16),'String')),str2num(get(a(17),'String')),str2num(get(a(18),'String'))];
        
        integ_variables(6) = str2num(get(a(14),'String')); %Gets the step_size_divisor variable from user
        
        remove_ramp_up = str2num(get(a(24),'String'));
        Timeseries=Timeseries(:,remove_ramp_up:length(Timeseries));

        poincare_points_a = poincare(Timeseries,plane,sys_variables,integ_variables);

        poincare_points = poincare_points_a(:,1:4);
        approx_1 = poincare_points_a(:,5:8);
        
        if isreal(poincare_points)
            for i=1:length(poincare_points(:,1)) %plots the points in the window, red for one direction, blue for the other
                if poincare_points(i,4) == 1
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'or');
                    hold on;
                else
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'ob');
                    hold on;
                end
            end  
            hold off;   
            
            xmax = max(poincare_points(:,1));
            xmin = min(poincare_points(:,1));
            ymin = min(poincare_points(:,2));
            ymax = max(poincare_points(:,2));
            zmax = max(poincare_points(:,3));
            zmin = min(poincare_points(:,3));
            if xmax > 0
                xmax=xmax*1.1;
            else
                xmax=xmax*.9;
            end
            if xmin > 0
                xmin=xmin*.9;
            else
                xmin=xmin*1.1;
            end
            if zmax > 0
                zmax=zmax*1.1;
            else
                zmax=zmax*.9;
            end
            if zmin > 0
                zmin=zmin*.9;
            else
                zmin=zmin*1.1;
            end
            if ymin > 0
                ymin=ymin*.9;
            else
                ymin=ymin*1.1;
            end
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),xmin,xmax,zmin,zmax,ymin,ymax);
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',.5,'EdgeAlpha',0.1);
           % set(gcf,'CameraUpVector',[plane(1) plane(2) plane(3)]);
            xlabel('I3');
            ylabel('V2');
            zlabel('V1');
            
            if get(H_ABC_pp(506),'Value') == 1
                view(0,90);
                axis tight;
            elseif get(H_ABC_pp(507),'Value') == 1
                view(0,0);  
                axis tight;
            elseif get(H_ABC_pp(508),'Value') == 1
                view(90,0);
                axis tight;
            end
            
            figure(12); % Point to Poincare Map - top right 
            
            %This separates the poincare map points into two bins - one for each 
            %direction that they cross the plane in
            
            poin = poincare_points;
            
            bindex=1;
            aindex=1;
            for i=1:length(poin(:,1))           
                if poin(i,4)==0  %this finds what direction they crossed in 
                    a_poin(aindex,:) = poin(i,:);
                    aindex = aindex+1;
                else
                    b_poin(bindex,:) = poin(i,:);
                    bindex = bindex+1;
                end
                
            end
            
            if(exist('a_poin')) %if a_poin exists
                %poin_xnplusone is the value at time t+1
                %this will be plotted against poin_xn, the value at time t
                
                if get(H_ABC_pp(503),'Value') == 0
                    poin_xnplusone(1:length(a_poin(:,1))-1,:) = a_poin(2:length(a_poin(:,1)),:);
                    poin_xn(1:length(a_poin(:,1))-1,:) = a_poin(1:length(a_poin(:,1))-1,:);
                    
                    I3vector = [poin_xn(:,1),poin_xnplusone(:,1)]; %Sorts them into vectors that can be plotted
                    V2vector = [poin_xn(:,2),poin_xnplusone(:,2)];
                    V1vector = [poin_xn(:,3),poin_xnplusone(:,3)];
                    
                    plot(V2vector(:,1),V2vector(:,2),'.') %Plots the V2 vector at xn+1 against xn
                    
                    
                else
                    poin_xnplusone(1:length(b_poin(:,1))-1,:) = b_poin(2:length(b_poin(:,1)),:);
                    poin_xn(1:length(b_poin(:,1))-1,:) = b_poin(1:length(b_poin(:,1))-1,:);
                    
                    I3vector = [poin_xn(:,1),poin_xnplusone(:,1)]; %Sorts them into vectors that can be plotted
                    V2vector = [poin_xn(:,2),poin_xnplusone(:,2)];
                    V1vector = [poin_xn(:,3),poin_xnplusone(:,3)];
                    
                    plot(V2vector(:,1),V2vector(:,2),'.') %Plots the V2 vector at xn+1 against xn
                    
                end
            end
            xlabel('V2(xn)');
            ylabel('V2(xn+1)');
           
            
            clear V2vector;
            clear poin_xnplusone;
            clear poin_xn;
            clear poin;
            
            
            figure(13); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xlabel('I3');
            ylabel('V2');
            zlabel('V1');
            
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            ymin=min(Timeseries(2,:));
            ymax=max(Timeseries(2,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10),(ymin+ymin/10),(ymax+ymax/10));
            %            vertex_matrix = [xmin 0 zmin; xmin 0 zmax; xmax 0 zmin; xmax 0 zmax]

            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',.8,'EdgeAlpha',0.1);
            %view(view_angle);%axis off;
            rotate3d;
            
                    else
            % Read in warning image and place it Small Axes

            warning off all % Suppress Warning
            figure(12);
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            
            
            
            figure(11);
            warning off all % Suppress Warning
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            figure(10); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xlabel('Current');
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            ymin=min(Timeseries(2,:));
            ymax=max(Timeseries(2,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10),(ymin+ymin/10),(ymax+ymax/10));
            %vertex_matrix = [xmin 0 zmin; xmin 0 zmax; xmax 0 zmin; xmax 0 zmax]
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor',[ 0.000 0.502 0.000 ],'FaceAlpha',1,'EdgeAlpha',0.1);
            %view(view_angle);%axis off;
            axis on;
            rotate3d(h(1));
            

        end
            
        end
        
        
        
        
        
    
    
function regional = intersection_finder(time_series,plane)

% 'regional' each row of this returned matrix details the intersection of the trajectory 'time_Series' 
% with the input 'plane'
% The first three columns (n,1:3) of each row are the xyz co-ordinates of the point one side of the plane.
% The next three columns (n,4:6) detail the first point in the data set after the intersection with the plane.
% The seventh column (n,10)is updated every time an intersection is found and details the total number of 
% intersections in that data set.

% Consider two point vectors P1(x1,y1,z1) and P2(x2,y2,z2) taken from the time_series data set
% Now consider a plane of the form (aX + bY + cZ - d = 0)
% If the vector P1P2 intersects the plane then one of the following
% conditions will be true
% condition1:
%  (a*x1 + b*y1 + c*z1 -d > 0) and (a*x2 + b*y2 + c*z2 -d < 0)
% condition2:
%  (a*x1 + b*y1 + c*z1 -d > 0) and (a*x2 + b*y2 + c*z2 -d < 0)
% To complete the algorithm the condition where one of the points lies upon the
% plane is accounted for
% condition3:
% (a*x1 + b*y1 + c*z1 -d == 0) or (a*x2 + b*y2 + c*z2 -d == 0)

a=plane(1);
b=plane(2);
c=plane(3);
d=plane(4);

check='voido';
time_series=time_series';
index=1;
for n=2:length(time_series)
    
    cond11=(a*time_series(n-1,1) + b*time_series(n-1,2) + c*time_series(n-1,3) +d > 0);
    cond12=(a*time_series(n,1) + b*time_series(n,2) + c*time_series(n,3) +d < 0);
    cond1=cond11 && cond12;
    % Checks on direction of the vector for intersection
    
    cond21=(a*time_series(n-1,1) + b*time_series(n-1,2) + c*time_series(n-1,3) +d < 0);
    cond22=(a*time_series(n,1) + b*time_series(n,2) + c*time_series(n,3) +d > 0);
    cond2=cond21 && cond22;
    % Checks the opposite direction of the vector for intersection
    
    cond3=(a*time_series(n,1) + b*time_series(n,2) + c*time_series(n,3) +d == 0);
    % Checks if either point lies upon the plane
    
    if(cond1)
        regional(index,1:3)=time_series(n-1,1:3);
        regional(index,4:6)=time_series(n,1:3);
        regional(index,7)=1;
        regional(index,8)=0;
        index=index+1;
        check='valid';
    end;
    
    if(cond2)
        regional(index,1:3)=time_series(n-1,1:3);
        regional(index,4:6)=time_series(n,1:3); 
        regional(index,7)=0;
        regional(index,8)=0;
        index=index+1;
        check='valid';
    end;    
    
    if(cond3)
        
        regional(index,1:3)=time_series(n,1:3);
        regional(index,4:6)=time_series(n,1:3);
        
        cond23=(a*time_series(n+1,1) + b*time_series(n+1,2) + c*time_series(n+1,3) +d > 0);
        cond25=cond21&&cond23;       
        cond13=(a*time_series(n+1,1) + b*time_series(n+1,2) + c*time_series(n+1,3) +d < 0);
        cond15=cond11 && cond13;
        
        if(cond15)
            regional(index,7)=1;
        end;
        if(cond25)
            regional(index,7)=0;
        end;
        regional(index,8) = 1; %If the point lies on the plane, column 8 indicates this with a one
        index=index+1;
        check='valid';
    end;
   
end;


if(check=='voido')
    clear regional;
    regional(1,1:8)=i; %Sets regional to all imaginary numbers - this occurs when the plane does not
                       %intersect the trajectory

end

%%%%%%%%%%%%%%%%%%%&

%%%%%%%%%%%%%%%%%%%%

function poin = poincare(time_series_1,plane,sys_variables,integ_variables)

% 'time_series' is Nx1 matrix where N is the length of the timeseries
% 'plane' is the plane equation coefficients in matrix form
%  if a plane is desccribed by ax+by+cz-d=0 then the matrix is of the form [a b c d]
%  sys_variables = [L,R0,C2,G,Ga,Gb,C1,E];
%  integ_variables = [x0,y0,z0,dataset_size,step_size];

a=plane(1,1);
b=plane(1,2);
c=plane(1,3);
d=plane(1,4);

execute_flag=1;


approx_1=intersection_finder(time_series_1,plane);

if(~isreal(approx_1)) %if approx_1 is not real, the plane doesnt intersect the trajectory
    poin = approx_1;
    
elseif (length(approx_1(:,1)) ~= 0) 
    
    %this will execute for every set of intersection points found except
    %for the ones which are found to have been lying on the plane already
    %i.e. those with a 1 in the 8th column of approx_1
    %It uses the first point as an initial condition, and then integrates
    %from this initial condition until it crosses the plane
    for i=1:length(approx_1(:,1))
        if(approx_1(i,8) ~= 1)
            approx_2(i,:) = chua(approx_1(i,:),sys_variables,integ_variables,plane);
            
            
        elseif(approx_1(i,8)==1)
            approx_2(i,:) = [approx_1(i,1:3), approx_1(i,8)];
            
        end
        
        
        i=i+1;
    end
        
    poin=[approx_2,approx_1(:,1:4)];
    
end

        
        





function point = chua(approx_1,sys_variables,integ_variables,plane)
%This will integrate from the initial conditions i.e. the point on one side
%of the plane, to the plane until it either lands on the plane or crosses
%to the other side of it
%it returns an n by 4 matrix "point" which contains the x y z co-ordinates
%for the point and also what direction it was going in indicated by a 1 or
%a 0

% Syntax: TimeSeries=chua(sys_variables,integ_variables)
% sys_variables = [L,R0,C2,G,Ga,Gb,E,C1];
% integ_variables = [x0,y0,z0,dataset_size,step_size];


% Models Initial Variables
%-------------------------
%NB C2 and C1 were passed incorrectly to this function(as usual) so be
%careful of this when editing - peadar
L  =           sys_variables(1);
R0 =           sys_variables(2);
C1 =           sys_variables(3);
G  =           sys_variables(4);
Ga =           sys_variables(5);
Gb =           sys_variables(6);
E  =           sys_variables(7);
C2 =           sys_variables(8);
x0 =           integ_variables(1);
y0 =           integ_variables(2);
z0 =           integ_variables(3);
dataset_size = integ_variables(4);
step_size =    integ_variables(5);
step_size_divisor = integ_variables(6);

a=plane(1,1);
b=plane(1,2);
c=plane(1,3);
d=plane(1,4);


x0 = approx_1(1);
y0 = approx_1(2);
z0 = approx_1(3);

TimeSeries = [x0, y0, z0]'; % these are the initial conditions on one side of the plane
                            

% Optimized Runge-Kutta Variables
%--------------------------------

h = step_size*G/C2;

h = h/step_size_divisor;
h2 = (h)*(.5);
h6 = (h)/(6);

anor = Ga/G;
bnor = Gb/G;
bnorplus1 = bnor + 1;
alpha = C2/C1;
beta = C2/(L*G*G);
gammaloc = (R0*C2)/(L*G);

bh = beta*h;
bh2 = beta*h2;
ch = gammaloc*h;
ch2 = gammaloc*h2;
omch2 = 1 - ch2;

k1 = [0 0 0]';
k2 = [0 0 0]';
k3 = [0 0 0]';
k4 = [0 0 0]';
M = [0 0 0]';

% Calculate Time Series
%----------------------

M(1) = TimeSeries(3)/E;
M(2) = TimeSeries(2)/E;
M(3) = TimeSeries(1)/(E*G);

check = 'voido';
i=1;
index = 1;
while check == 'voido'
    % Runge Kutta
    % Round One
    k1(1) = alpha*(M(2) - bnorplus1*M(1) - (.5)*(anor - bnor)*(abs(M(1) + 1) - abs(M(1) - 1)));
    k1(2) = M(1) - M(2) + M(3);
    k1(3) = -beta*M(2) - gammaloc*M(3);
    % Round Two
    temp = M(1) + h2*k1(1);
    k2(1) = alpha*(M(2) + h2*k1(2) - bnorplus1*temp - (.5)*(anor - bnor)*(abs(temp + 1) - abs(temp - 1)));
    k2(2) = k1(2) + h2*(k1(1) - k1(2) + k1(3));
    k2(3) = omch2*k1(3) - bh2*k1(2);
    % Round Three
    temp = M(1) + h2*k2(1);
    k3(1) = alpha*(M(2) + h2*k2(2) - bnorplus1*temp - (.5)*(anor - bnor)*(abs(temp + 1) - abs(temp - 1)));
    k3(2) = k1(2) + h2*(k2(1) - k2(2) + k2(3));
    k3(3) = k1(3) - bh2*k2(2) - ch2*k2(3);
    % Round Four
    temp = M(1) + h*k3(1);
    k4(1) = alpha*(M(2) + h*k3(2) - bnorplus1*temp - (.5)*(anor - bnor)*(abs(temp + 1) - abs(temp - 1)));
    k4(2) = k1(2) + h*(k3(1) - k3(2) + k3(3));
    k4(3) = k1(3) - bh*k3(2) - ch*k3(3);
    
    M = M + (k1 + 2*k2 + 2*k3 + k4)*(h6);
    
    TimeSeries(3,i+1) = E*M(1);
    TimeSeries(2,i+1) = E*M(2); 
    TimeSeries(1,i+1) = (E*G)*M(3);
  

    %Code for checking whether or not the point has passed the plane

    cond11=(a*TimeSeries(1,i) + b*TimeSeries(2,i) + c*TimeSeries(3,i) +d > 0);
    cond12=(a*TimeSeries(1,i+1) + b*TimeSeries(2,i+1) + c*TimeSeries(3,i+1) +d < 0);
    cond1=cond11 && cond12;
    % Checks on direction of the vector for intersection
    
    cond21=(a*TimeSeries(1,i) + b*TimeSeries(2,i) + c*TimeSeries(3,i) +d < 0);
    cond22=(a*TimeSeries(1,i+1) + b*TimeSeries(2,i+1) + c*TimeSeries(3,i+1) +d > 0);
    cond2=cond21 && cond22;
    % Checks the opposite direction of the vector for intersection
    
    cond3=(a*TimeSeries(1,i+1) + b*TimeSeries(2,i+1) + c*TimeSeries(3,i+1) +d == 0);
    % Checks if either point lies upon the plane
    
    if(cond1)
        point(1,1:3)=TimeSeries(1:3,i)';
        point(1,4)=1;
        check='valid';
    end;
    
    if(cond2)
        point(1,1:3)=TimeSeries(1:3,i)'; 
        point(1,4)=0;
        check='valid';
    end;
    
    if(cond3)
        
        point(1,1:3)=TimeSeries(1:3,i)';
        point(1,4) = approx(4); % Sign in this case is the same as the last time
        check='valid';
    end;

    i=i+1;
 
end



function vertex_matrix = plotplane(a,b,c,d,xmin,xmax,zmin,zmax,ymin,ymax)
% Uses simple geometry:'plane equation' manipulation to return a vertex
% matrix using plane equation ax+by+cz+d=0 coefficients to calculate
% unknown vertices - ymin ymax



if b~=0
vertex_matrix = [xmin ((-d-a*xmin-c*zmin)/b) zmin; xmin ((-d-a*xmin-c*zmax)/b) zmax; xmax ((-d-a*xmax-c*zmin)/b) zmin; xmax ((-d-a*xmax-c*zmax)/b) zmax];
end

if (b==0 & a~=0)
vertex_matrix = [((-d-b*ymin-c*zmin)/a) ymin zmin;((-d-b*ymin-c*zmax)/a) ymin zmax;((-d-b*ymax-c*zmin)/a) ymax zmin;((-d-b*ymax-c*zmax)/a) ymax zmax];
end

if a==0
vertex_matrix = [xmin ymin ((-d-b*ymin-a*xmin)/c);xmax ymin ((-d-b*ymin-a*xmax)/c);xmin ymax ((-d-b*ymax-a*xmin)/c);xmax ymax ((-d-b*ymax-a*xmax)/c)];
end