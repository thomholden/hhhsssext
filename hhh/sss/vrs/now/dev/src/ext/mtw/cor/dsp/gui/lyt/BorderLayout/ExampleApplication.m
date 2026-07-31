function ExampleApplication
f = figure('Name', 'Simple Border App');
panels = BorderLayout(f, 0, 25, 100, 0);
panelsArray = [panels.South panels.East panels.Center];
set(panelsArray, 'BorderType', 'none', ...
                 'BackgroundColor', get(f, 'Color'));
ax = axes('Parent', panels.Center);
statusui = uicontrol('Parent', panels.South, ...
                     'Position', [0 0 125 25], 'Style', 'text', ...
                     'BackgroundColor', get(f, 'Color'), ...
                     'String', 'No data displayed');
peaksui = uicontrol('Parent', panels.East, 'Position', [0 0 100 100], ...
                    'String', 'peaks', 'callback', {@ButtonCallback, statusui});
membraneui = uicontrol('Parent', panels.East, 'Position', [0 110 100 100], ...
                       'String', 'membrane', 'callback', {@ButtonCallback, statusui});
plotui = uicontrol('Parent', panels.East, 'Position', [0 220 100 100], ...
                   'String', 'plot(1:10)', 'callback', {@ButtonCallback, statusui});

function ButtonCallback(hObject, eventdata, statusui)
    command = get(hObject, 'String');
    eval(command);
    message = strcat(command, ' displayed.');
    set(statusui, 'String', message);
    