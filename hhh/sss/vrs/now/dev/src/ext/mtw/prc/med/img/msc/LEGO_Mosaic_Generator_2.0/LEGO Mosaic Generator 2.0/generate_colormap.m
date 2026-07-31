function [map, names] = generate_colormap()
% This function will open a GUI that will allow you to select a color to add
% to a color map (via uisetcolor), it returns both the color map and a cell
% array of color names
%
% It should be pretty intuitive to use, but you start by pressing the "Add
% new" button, which opens the uisetcolor gui, you select your color and
% then it should show up in the axes, next thing to do is to name your
% color, it is required to name every color you pick the current way it is
% set up, but that is probably pretty easily changeable. 
%
% You can use the << and >> buttons to see what images you have already
% selected, and remove images you no longer what
%
% This code is likely breakable, while I have tried to protect against
% common mistakes and whatnot that could happen, things like canceling out
% of the uisetcolor menu could throw an error and I did not overly test the
% next and prev and remove buttons, just enough to ensure basic
% functionality and attempt to protect against common issues
%
% This code was originally written by Shaun VanWeelden on 2/2/2013
% My email is shaun314@iastate.edu, feel free to contact me with anything
% weird that comes up or clarifying questions

%% Main Function + Initialization
count=1;
spot=0;
map=[];
flag=0;

%Create figure window
f=figure('MenuBar','none','Name','Generate Colormap','NumberTitle','off','Position',[200,600,270,120]);

%Create the "accept" push button
uicontrol('Style','PushButton','String','Accept','Position',[200,53,50,20],...
'CallBack',@AcceptPressed);

%Color Name title
uicontrol('Style','Text','String','Color Name:','Position',[130,105,120,15],...
'HorizontalAlignment','left','FontSize',10,'BackgroundColor',[204 204 204]/255); 

%Color name edit box
color_text = uicontrol('Style','Edit','Position',[130,75,120,25],...
'HorizontalAlignment','left','FontSize',10,'CallBack',@AcceptPressed);

%Go back button
uicontrol('Style','PushButton','String','<<','Position',[20,5,30,20],...
'CallBack',@prev,'FontSize',10);

%Go forward button
uicontrol('Style','PushButton','String','>>','Position',[63,5,30,20],...
'CallBack',@next,'FontSize',10);

%Add a new color button
uicontrol('Style','PushButton','String','Add New','Position',[120,42,60,30],...
'CallBack',@add,'FontSize',10);

%Remove an item button
uicontrol('Style','PushButton','String','Remove','Position',[120,5,60,30],...
'CallBack',@remove,'FontSize',10);

%Exit GUI 
uicontrol('Style','PushButton','String','Done!','Position',[220,5,40,20],...
'CallBack',@Close);

%Set axes for color
ah = axes('Parent',f,'Position',[.05 .25 .3 .5]);

%Initialize color box
axes(ah);
C=ones(1,1,3);
C(:,:,1)=color(1);
C(:,:,2)=color(2);
C(:,:,3)=color(3);
imshow(C)
uiwait

%% Accept Callback
    function AcceptPressed(~,~)
        if  flag       
            names{count+1}=get(color_text,'string');
            spot=count+1;
            count=count+1; 
            flag=0;
        else
            %errordlg('Add a color first!','Add a color')     
            %
            % For some reason, this seems to be called twice, and then
            % that gets annoyoing really quick, so now its just doing
            % nothing
        end      
    end

%% Close Callback
    function Close(~,~)
        if flag==0 %i.e not in the middle of picking a color           
           close(f)          
        else
           errordlg('Finish picking a color first!','Finish Picking') 
        end
    end

%% Next Color Callback
    function next(~,~) 
        if flag==0 %i.e not in the middle of picking a color
           %see if its already the newest one
           if spot<count;
               spot=spot+1;
               set(color_text,'string',names{spot})
               color = map(spot,:);
               C(:,:,1)=color(1);
               C(:,:,2)=color(2);
               C(:,:,3)=color(3);
               imshow(C)             
           end
               
           
        else
           errordlg('Finish picking a color first!','Finish Picking') 
        end
    end

%% Go Back a Color Callback
    function prev(~,~)
        if flag==0 %i.e not in the middle of picking a color
           %see if its already the newest one
           if spot>1
               spot=spot-1;
               set(color_text,'string',names{spot})
               color = map(spot,:);
               C(:,:,1)=color(1);
               C(:,:,2)=color(2);
               C(:,:,3)=color(3);
               imshow(C)             
           end
           
        else
           errordlg('Finish picking a color first!','Finish Picking') 
        end
    end

%% Add a Color Callback
    function add(~,~)
        if  flag==0;          
            color=uisetcolor;
            set(color_text,'string','')
            axes(ah);
            C=ones(1,1,3);
            C(:,:,1)=color(1);
            C(:,:,2)=color(2);
            C(:,:,3)=color(3);
            count=size(map,1);
            map(count+1,:)=color;
            imshow(C)
            flag=1;   
        else
            errordlg('You must name the color first!','Name Color First')
        end
    end

%% Remove a Color Callback
    function remove(~,~)
       names(spot)=[];
       map(spot,:)=[];
       set(color_text,'string',names{spot})
       color = map(spot,:);
       C(:,:,1)=color(1);
       C(:,:,2)=color(2);
       C(:,:,3)=color(3);
       imshow(C)  
       count=count-1;
       spot=spot-1;
    end


end





