function java_time
% This function reads the US Naval Observatory web page with java methods and
% displays the time in a java dialog box as a demonstration of java
% integration with m-code.

% Written by Scott Burnside, May 2005. Revised September 2006

% No user workspace variables were harmed in development or use.

% make the swing class names available as Matlab functions
import javax.swing.*;

% make the java.awt class names available as Matlab functions
import java.awt.*;

% create a java swing window with title
frame = JFrame('US Naval Observatory Time');
frame.setSize(350,78)

% put the swing window in the center of  the screen
xsize = 350;
ysize = 78;
screen_size = get(0,'ScreenSize');
x_position = screen_size(3)/2 - xsize/2;
y_position = screen_size(4)/2 - ysize/2;

% create label and text fields
lfld = JLabel('Current Time');
tfld = JTextField(9);

% create layout
time_panel = JPanel(BoxLayout.Y_AXIS);

% add layout to java swing window
time_panel.add(lfld);
time_panel.add(tfld);

% finalize the frame contents and position
frame.getContentPane.add(time_panel);
frame.setLocation(Point(x_position, y_position));

% define a Java button
Stop_Button = JButton('Stop');

% add the button to the panel
time_panel.add(Stop_Button);

% prepare a handle structure of the window components
handles.frame = frame;
handles.Stop_Button = Stop_Button;

% listen for action on the button
set(Stop_Button, 'ActionPerformedCallback',{@StopCallback, handles});

% show the frame
frame.show

% initialize break flag
set(frame,'UserData',0);

% Continuous time loop
i=1;
while i==1;

    % trigger on break flag to end program
    j = get(frame,'UserData');
    if j == 1
        break
    end

    % define the URL for US Naval Observatory Time page
    url =java.net.URL('http://tycho.usno.navy.mil/cgi-bin/timer.pl');

    % initiate a try/catch structure to trap errors when java.io times out
    try

        % read the URL
        link = openStream(url);
        parse = java.io.InputStreamReader(link);
        snip = java.io.BufferedReader(parse);

        % Read lines of html and parse the time string
        for k = 1:100
            snort(k) = readLine(snip);
            pflag = findstr(snort(k),'UTC');
            pfish = isempty(pflag);
            if pfish  == 0;
                tdatl = char(snort(k));
                tdat = tdatl(pflag-9:pflag+2);
            end
        end

        % clear the text field
        set(tfld,'Text','');

        % put the time string into the text field
        set(tfld,'Text', tdat);

        % let the user know if the page is unavailable (java io timed out)
    catch
        set(tfld,'Text','Unavailable');
    end

    % update about every 1 second
    pause(0.9)

    % end of main function
end


% callback funtion for button
function  StopCallback(hObject, eventdata, handles)

% disable the button
handles.Stop_Button.setEnabled(false);

% show the frame with the disabled button for a second
handles.frame.show;
pause(1);

% close the frame
handles.frame.dispose;

% set the break flag and return to the main function
set(handles.frame,'UserData',1);
return

% end of code
