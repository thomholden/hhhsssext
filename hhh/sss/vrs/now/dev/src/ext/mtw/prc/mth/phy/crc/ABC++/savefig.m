%Code to save main figure

figure(8)

 sys_variables = [str2double(get(A_ABC_pp(9),'String')),str2double(get(A_ABC_pp(8),'String')),str2double(get(A_ABC_pp(11),'String')),str2double(get(A_ABC_pp(10),'String')),str2double(get(A_ABC_pp(19),'String')),str2double(get(A_ABC_pp(20),'String')),str2double(get(A_ABC_pp(18),'String')),str2double(get(A_ABC_pp(12),'String'))]; % L,R0,C2,G,Ga,Gb,E,C1
        integ_variables = [str2double(get(A_ABC_pp(21),'String')),str2double(get(A_ABC_pp(22),'String')),str2double(get(A_ABC_pp(23),'String')),str2double(get(A_ABC_pp(28),'String')),str2double(get(A_ABC_pp(27),'String'))]; % x0,y0,z0,dataset_size,step_size
        
        clear global data;
        % Calculate Timeseries
        global Timeseries;
        Timeseries = chua(sys_variables,integ_variables);
        % Calculate Equilibrium Points
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
        
        
        % Calculate Eigen Points & Planes, then place them on GUI
        Eigen_Planes = eigen(sys_variables,Points);
   
     
        
        % Plot Attractor
        %---------------
        figure(9)
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
        
        %Plot Inner EigenPlane
        %%%%%%%%%%%%%%%%%%%%%% here sys_variables(7) = E
        inner_x1 = pointplane(Eigen_Planes(1,1),Eigen_Planes(1,2),Eigen_Planes(1,3),Eigen_Planes(1,4),0,ylimit,sys_variables(7),'x');
        inner_x2 = pointplane(Eigen_Planes(1,1),Eigen_Planes(1,2),Eigen_Planes(1,3),Eigen_Planes(1,4),0,-ylimit,sys_variables(7),'x');
        inner_y1 = pointplane(Eigen_Planes(1,1),Eigen_Planes(1,2),Eigen_Planes(1,3),Eigen_Planes(1,4),xlimit,0,sys_variables(7),'y');
        inner_y2 = pointplane(Eigen_Planes(1,1),Eigen_Planes(1,2),Eigen_Planes(1,3),Eigen_Planes(1,4),-xlimit,0,sys_variables(7),'y');
        inner_z = sys_variables(7);
        
        point_number = 1;
        plot_number = 1;
        if (inner_x1 >= -xlimit)&&(inner_x1 <= xlimit)
            point(point_number,:) = [inner_x1 ylimit inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            P_ABC_PP(plot_number) = plot3(-point(point_number,1),-point(point_number,2),-point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_x2 >= -xlimit)&&(inner_x2 <= xlimit)
            point(point_number,:) = [inner_x2 -ylimit inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            P_ABC_PP(plot_number) = plot3(-point(point_number,1),-point(point_number,2),-point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_y1 >= -ylimit)&&(inner_y1 <= ylimit)
            point(point_number,:) = [xlimit inner_y1 inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            P_ABC_PP(plot_number) = plot3(-point(point_number,1),-point(point_number,2),-point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_y2 >= -ylimit)&&(inner_y2 <= ylimit)
            point(point_number,:) = [-xlimit inner_y2 inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            P_ABC_PP(plot_number) = plot3(-point(point_number,1),-point(point_number,2),-point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        
        % Plot U-1 Region Devision Planes
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        vertex_matrix = [-xlimit -ylimit -sys_variables(7);-xlimit ylimit -sys_variables(7);xlimit -ylimit -sys_variables(7);xlimit ylimit -sys_variables(7)];
        G_ABC_pp(9) = patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','b','FaceColor','none','FaceAlpha',0.2,'EdgeAlpha',0.2);
        text(xlimit,ylimit,-sys_variables(7),'  U_{-1}','Color',[0 0 1],'FontWeight','bold');
        
        % Plot inner Plane
        if point_number ~= 1
            vertex_matrix = [point(1,:); point(2,:); -point(1,:); -point(2,:)];
            G_ABC_pp(8) = patch('Vertices',vertex_matrix,'Faces',[1 2 3 4],'EdgeColor','m','FaceColor','none','FaceAlpha',0.2,'EdgeAlpha',0.2);
            text((xlimit/5),(ylimit/5),pointplane(Eigen_Planes(1,1),Eigen_Planes(1,2),Eigen_Planes(1,3),Eigen_Planes(1,4),(xlimit/5),(ylimit/5),0,'z'),'  E^{c}(0)','Color','m','FontWeight','bold');
        end
        
        % Plot U Region Devision Planes
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        vertex_matrix = [-xlimit -ylimit sys_variables(7);-xlimit ylimit sys_variables(7);xlimit -ylimit sys_variables(7);xlimit ylimit sys_variables(7)];
        G_ABC_pp(5) = patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','b','FaceColor','none','FaceAlpha',0.2,'EdgeAlpha',0.2);
        text(xlimit,ylimit,sys_variables(7),'  U_{1}','Color',[0 0 1],'FontWeight','bold');
        
        %Plot P+ Outer EigenPlane
        %%%%%%%%%%%%%%%%%%%%%% here sys_variables(7) = E
        inner_x1 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),-Eigen_Planes(2,4),0,ylimit,sys_variables(7),'x');
        inner_x2 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),-Eigen_Planes(2,4),0,-ylimit,sys_variables(7),'x');
        inner_y1 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),-Eigen_Planes(2,4),xlimit,0,sys_variables(7),'y');
        inner_y2 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),-Eigen_Planes(2,4),-xlimit,0,sys_variables(7),'y');
        inner_z = sys_variables(7);
        
        point_number = 1;
        if (inner_x1 >= -xlimit)&&(inner_x1 <= xlimit)
            point(point_number,:) = [inner_x1 ylimit inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,3)-point(point_number,1)) (2*Points(2,3)-point(point_number,2)) (2*Points(3,3)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_x2 >= -xlimit)&&(inner_x2 <= xlimit)
            point(point_number,:) = [inner_x2 -ylimit inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,3)-point(point_number,1)) (2*Points(2,3)-point(point_number,2)) (2*Points(3,3)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_y1 >= -ylimit)&&(inner_y1 <= ylimit)
            point(point_number,:) = [xlimit inner_y1 inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,3)-point(point_number,1)) (2*Points(2,3)-point(point_number,2)) (2*Points(3,3)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_y2 >= -ylimit)&&(inner_y2 <= ylimit)
            point(point_number,:) = [-xlimit inner_y2 inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,3)-point(point_number,1)) (2*Points(2,3)-point(point_number,2)) (2*Points(3,3)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        % Plot P+ outer Plane
        if point_number ~= 1
            vertex_matrix = [point(1,:); point(2,:); mirror_point(1,:); mirror_point(2,:)];
            G_ABC_pp(6) = patch('Vertices',vertex_matrix,'Faces',[1 2 3 4],'EdgeColor','c','FaceColor','none','FaceAlpha',0.2,'EdgeAlpha',0.2);
            text(vertex_matrix(4,1),vertex_matrix(4,2),vertex_matrix(4,3),'  E^{c}(P^{+})','Color','c','FontWeight','bold');
           
            %text((vertex_matrix(2,1)+vertex_matrix(4,1))/1,(vertex_matrix(2,2)+vertex_matrix(4,2))/1,(vertex_matrix(2,3)+vertex_matrix(4,3))/1,'  E^{c}P_{+}(0)','Color','c','FontWeight','bold');
            %text((xlimit/5),(ylimit/5),pointplane(Eigen_Planes(1,1),Eigen_Planes(1,2),Eigen_Planes(1,3),Eigen_Planes(1,4),(xlimit/5),(ylimit/5),0,'z'),'  E^{c}P_{+}(0)','Color','m','FontWeight','bold');
        end
        
        %Plot P- Outer EigenPlane
        %%%%%%%%%%%%%%%%%%%%%% here sys_variables(7) = E
        inner_x1 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),Eigen_Planes(2,4),0,ylimit,-sys_variables(7),'x');
        inner_x2 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),Eigen_Planes(2,4),0,-ylimit,-sys_variables(7),'x');
        inner_y1 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),Eigen_Planes(2,4),xlimit,0,-sys_variables(7),'y');
        inner_y2 = pointplane(Eigen_Planes(2,1),Eigen_Planes(2,2),Eigen_Planes(2,3),Eigen_Planes(2,4),-xlimit,0,-sys_variables(7),'y');
        inner_z = -sys_variables(7);
        
        point_number = 1;
        if (inner_x1 >= -xlimit)&&(inner_x1 <= xlimit)
            point(point_number,:) = [inner_x1 ylimit inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,1)-point(point_number,1)) (2*Points(2,1)-point(point_number,2)) (2*Points(3,1)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_x2 >= -xlimit)&&(inner_x2 <= xlimit)
            point(point_number,:) = [inner_x2 -ylimit inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,1)-point(point_number,1)) (2*Points(2,1)-point(point_number,2)) (2*Points(3,1)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_y1 >= -ylimit)&&(inner_y1 <= ylimit)
            point(point_number,:) = [xlimit inner_y1 inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,1)-point(point_number,1)) (2*Points(2,1)-point(point_number,2)) (2*Points(3,1)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end
        if (inner_y2 >= -ylimit)&&(inner_y2 <= ylimit)
            point(point_number,:) = [-xlimit inner_y2 inner_z];
            P_ABC_PP(plot_number) = plot3(point(point_number,1),point(point_number,2),point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            mirror_point(point_number,:)=[(2*Points(1,1)-point(point_number,1)) (2*Points(2,1)-point(point_number,2)) (2*Points(3,1)-point(point_number,3))];
            P_ABC_PP(plot_number) = plot3(mirror_point(point_number,1),mirror_point(point_number,2),mirror_point(point_number,3),'.', ...
                'MarkerSize',10,'Color',[0 0 0]);hold on;
            plot_number = plot_number + 1;
            point_number = point_number+1;
        end

        % Plot P- outer Plane
        if point_number ~= 1
            vertex_matrix = [point(1,:); point(2,:); mirror_point(1,:); mirror_point(2,:)];
            G_ABC_pp(7) = patch('Vertices',vertex_matrix,'Faces',[1 2 3 4],'EdgeColor','c','FaceColor','none','FaceAlpha',.2,'EdgeAlpha',0.2);
            
            text(vertex_matrix(4,1),vertex_matrix(4,2),vertex_matrix(4,3),'  E^{c}(P^{-})','Color','c','FontWeight','bold');
            %text((vertex_matrix(2,1)+vertex_matrix(4,1))/1.5,(vertex_matrix(2,2)+vertex_matrix(4,2))/1.5,(vertex_matrix(2,3)+vertex_matrix(4,3))/1.5,'  E^{c}P_{-}(0)','Color','c','FontWeight','bold');
            %text((xlimit/5),(ylimit/5),pointplane(Eigen_Planes(1,1),Eigen_Planes(1,2),Eigen_Planes(1,3),Eigen_Planes(1,4),(xlimit/5),(ylimit/5),0,'z'),'  E^{c}(0)','Color','m','FontWeight','bold');
        end
        
        axis([-xlimit xlimit -ylimit ylimit -zlimit zlimit]);
        

        
        % Color Axes - Necessary after reset it would seem
        %set(G_ABC_pp(1),'XColor',[1 0 0],'YColor',[0 1 0],'ZColor',[0 0 1]);        