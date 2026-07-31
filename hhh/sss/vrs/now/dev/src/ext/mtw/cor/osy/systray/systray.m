function handles = systray(varargin)
%SYSTRAY set/get system-tray icons on your computer's desktop
%
%   SYSTRAY sets icons in the system-tray of your computer's desktop, if
%   available. SYSTRAY enables setting several sys-tray icon properties
%   and returns the system tray handle(s), if available.
%
%   Syntax:
%      handles = systray(varargin);
%
%   handles = SYSTRAY retrieves the array of handles for the system-tray
%   icons that were set in Matlab. If no icon is currently displayed in
%   the sys-tray, then the returned array will be empty. If system-tray
%   functionality is unsupported on your platform, then SYSTRAY throws a
%   deliberate error.
%
%   handle = SYSTRAY(ICONIMAGE) sets an icon based on the requested icon
%   image and returns its handle. The icon is automatically resized to the
%   sys-tray's default icon size (e.g., 16x16). If ICONIMAGE was already
%   created then it will not be recreated, only its handle will be returned.
%   Note that ICONIMAGE may be an image filename, or any image format
%   accepted by Matlab's im2java function. ICONIMAGE may also be a two-arg
%   pair [X,Map] (indexed image & color map).
%
%   handle = SYSTRAY(ICON, param1,value1, param2,value2, ...) sets ICON
%   with initial properties in the familiar format of property name/value
%   pairs. ICON may be either an existing systray icon handle, an array of
%   existing icon handles, or an iconImage as explained above. Property
%   order does not matter and the property names are case-insensitive.
%
%   Icon properties can also be read/modified after creation, using get() &
%   set() on the icon handle, or via the dot-notation (hIcon.Tag='iconTag').
%
%   The supported properties (gettable and settable) are:
%   
%      'IconImage'     - updates the icon image [filename or Matlab image]
%      'ImageAutoSize' - auto-resizes icon to tray size (default='on'/true)
%      'Tooltip'       - sets the icon hover tooltip
%      'UIContextMenu' - sets the right-click context-menu (like uicontrols)
%                        provide a uicontextmenu handle or java.awt.PopupMenu object
%      'MarkForDeletion' - set to any value to remove the icon from the systray
%      'Tag'           - same as uicontrol
%      'UserData'      - same as uicontrol
%      'Message'       - text of an informational popup msg next to the icon
%                        should be a cell array of {titleText,msgText,severity}
%                        Where severity = 'none','error','info' or: 'warn' (default: 'info')
%                        Title may be empty, but then no severity icon will show
%
%   ...and also some gettable-only (i.e., read-only) properties:
%      'Size'          - icon size [width,height] - a java.awt.Dimension object
%      'IconWidth'     - icon width  in [pixels] - numeric value
%      'IconHeight'    - icon height in [pixels] - numeric value
%      'Type'          - icon type [class name = 'java.awt.TrayIcon']
%      'JavaObject'    - reference to the TrayIcon Java object
%      'Class'         - class of the Java object
%   
%   ...and also a bunch of callback properties that can be set in any of
%   Matlab's callback formats: 'callback string', @callbackFunc or:
%   {@callbackFunc,params,...}:
%   
%      'MouseClickedCallback'    - called when icon is mouse-clicked (pressed & released)
%      'MousePressedCallback'    - called when icon is mouse-clicked (before release)
%      'MouseReleasedCallback'   - called when icon is mouse-clicked (after release)
%      'MouseEnteredCallback'    - called when mouse is moved to within icon bounds
%      'MouseExitedCallback'     - called when mouse is moved outside the icon bounds
%      'MouseMovedCallback'      - called when mouse is moved over the icon
%      'MouseDraggedCallback'    - called when mouse drags the icon
%      'ActionPerformedCallback' - called when icon is double-clicked
%   
%   Examples:
%      hIcons = systray;  % returns list of existing icon handles
%      hIcon = systray('icon.png');  % display a simple icon
%      hIcon = systray('icon.png','Tooltip','right-click me!','UIContextmenu',cm);
%      systray(hIcon,'Message',{'title','informational message','warn'});
%      userdata = get(hIcon,'UserData');
%      set(hIcon,'userdata',magic(5));  % case insensitive property names
%      set(hIcon,'markForDeletion',1);  % remove icon from the system tray
%
%   Warning:
%     This code requires Java 1.6, available since Matlab 7.5 (R2007b).
%     This code also uses some undocumented Matlab features.
%
%   Technical details:
%     The details are explained in <a href="http://undocumentedmatlab.com/blog/setting-system-tray-icons/">http://undocumentedmatlab.com/blog/setting-system-tray-icons/</a>
%     and <a href="http://undocumentedmatlab.com/blog/setting-system-tray-popup-messages/">http://undocumentedmatlab.com/blog/setting-system-tray-popup-messages/</a>
%
%   Limitations:
%     Due to the undocumented nature of some features, I have still not been able
%     to achieve the following (also see the TODO list at the end of this file):
%
%       1. to use setappdata/getappdata on the icon handle - it works on the Java
%          object but not on the main handle. Use the ApplicationData property instead.
%       2. To hide or disable several properties in the handle, which really 
%          only belong in the Java object but not in the main handle.
%       3. To enable Matlab's findall() to find the icons based on handle or Tag
%       4. To add a deletion listener so that the icon will be removed when the
%          main handle is deleted. Instead, use the MarkForDeletion property.
%
%   Bugs and suggestions:
%     Please send to Yair Altman (altmany at gmail dot com)
%
%   Change log:
%     2010-Jan-26: Fixed uicontextmenu edge case reported by T. Farajian
%     2009-Mar-16: First version posted on MathWorks file exchange: <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">http://www.mathworks.com/matlabcentral/fileexchange/authors/27420</a>
%
%   See also:
%     im2java, uicontrol

% License to use and modify this code is granted freely without warranty to all, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.1 $  $Date: 2010/01/26 10:03:54 $

    % Check for available Java/AWT (not sure if Swing is really needed so let's just check AWT)
    if ~usejava('awt')
        error('YMA:systray:noJava','systray only works on Matlab envs that run on java');
    elseif num2str(regexprep(version('-java'),'Java (...).*','$1')) < 1.59  % should be 1.6 but lets not get FP accuracy errors here...
        error('YMA:systray:oldJava','systray only works on Matlab envs that run on java 1.6 and up (shipped with R2007b)');
    end

    % Check whether system-tray icons are supported on this platform
    sysTray = java.awt.SystemTray.getSystemTray;
    if ~(sysTray.isSupported)
        error('YMA:systray:noSysTray','systray is not supported on this platform due to system limitations');
    end

    % Initialize
    hndls = handle([]);

    % If no args, return the list of all systray icons (if any)
    if nargin < 1
        % The following fails for an unknown reason:
        %hndls = cellfun(@(c)handle(c,'callbackproperties'),cell(sysTray.getTrayIcons));
        
        icons = sysTray.getTrayIcons;
        for iconIdx = 1 : length(icons)
            try
                hndls(iconIdx) = handle(icons(iconIdx),'callbackproperties');
            catch
                hndls(iconIdx) = handle(icons(iconIdx));
            end
        end  % loop over all systray icons

    % Process input args
    else

        % first arg check: iconImage filename
        lastIconIdx = 1;
        if ischar(varargin{1})
            hndls = createTrayIcon(varargin{1},varargin{1});

            % image iconImage
        elseif ~iscell(varargin{1}) && ~ishandle(varargin{1}(1))
            if nargin > 1 && ~ischar(varargin{2}),  lastIconIdx = 2;  end
            hndls = createTrayIcon('input',varargin{1:lastIconIdx});

            % icon handle(s)
        else
            % Ensure that all supplied handles are valid HG GUI handles (Note: 0 is a valid HG handle)
            hndls = varargin{1};
            if ~all(ishandle(hndls))
                error('YMA:systray:invalidHandle','invalid icon handle passed to systray');
            end
        end
        varargin(1:lastIconIdx) = [];

        % Set the requested properties for all requested icon handles
        hndls = unique(hndls);
        set(hndls, varargin{:});
    end

    % If icon handles output arg requested
    if nargout
        % Return the list of all valid (non-empty) icon handles
        handles = hndls;
    end

end  % systray

%% Create a Java image from an image filename or image data
function javaImage = getJavaImage(varargin)
    if ischar(varargin{1})
        try
            javaImage = java.awt.Toolkit.getDefaultToolkit.createImage(varargin{:});
        catch
            javaImage = im2java(imread(varargin{:}));
        end
    elseif isa(varargin{1},'java.awt.Image')
        javaImage = varargin{1};
    else
        javaImage = im2java(varargin{:});
    end
end  % getJavaImage

%% Update icon image
function iconImage = setIconImage(trayIcon,iconImage)
    javaImage = getJavaImage(iconImage);
    trayIcon.setImage(javaImage);
    setappdata(trayIcon.JavaObject,'iconImage__',iconImage);
end  % setIconImage

%% Update icon popup menu
function popupMenu = setIconPopup(trayIcon,uicontextmenu)
    popupMenu = uicontextmenu;
    try
        if isa(handle(popupMenu),'uicontextmenu')
            popupMenu = java.awt.PopupMenu;
            menuItems = get(uicontextmenu,'children');
            itemsPos = get(menuItems,'position');
            if iscell(itemsPos)  % i.e., multiple menu items
                [sortedPos,sortedIdx] = sort(cell2mat(itemsPos)'); %#ok sortedPos is unused
                menuItems = menuItems(sortedIdx);
            end
            for itemIdx = 1 : length(menuItems)
                thisItem = menuItems(itemIdx);
                if strcmp(get(thisItem,'Separator'),'on')
                    popupMenu.addSeparator;
                end
                menuItem = java.awt.MenuItem(get(thisItem,'Label'));
                set(menuItem,'ActionPerformedCallback',get(thisItem,'Callback'));
                set(menuItem,'Enabled',get(thisItem,'Enable'));
                popupMenu.add(menuItem);
            end
        end
        trayIcon.setPopupMenu(popupMenu);
    catch
        % never mind...
        lasterr     %#ok
        debug = 1;  %#ok breakpoint
    end
end  % setIconPopup

%% Update icon informational popup message
function message = setIconMessage(trayIcon,message)
    if ischar(message)
        message = {'',message,'Info'};
    end
    if ~iscell(message) || length(message)>3 || ~all(cellfun(@ischar,message))
        error('YMA:systray:invalidMessage',['invalid icon message passed to systray: ' char(10) 'needs to be a cell array like {''title'',''message body'',''info''}']);
    end
    if length(message) == 1
        message = {'', message{1}, 'Info'};
    elseif length(message) == 2
        message = [message, 'Info'];
    end
    if isempty(message{3})
        message{3} = 'Info';
    end

    % The java.awt.TrayIcon.MessageType enumeration object cannot be directly
    % accessed, so we need some Java reflection hackery:
    msgType = find(upper(message{3}(1)) == 'EWIN', 1);
    if isempty(msgType)
        error('YMA:systray:invalidMessageType',['invalid icon message type passed to systray: ' char(10) 'needs to be one of: ''Info'', ''Warn'', ''Error'' or ''None''.']);
    end
    trayIconClasses = trayIcon.getClass.getClasses;
    MessageTypes = trayIconClasses(1).getEnumConstants;
    trayIcon.displayMessage(message{1},message{2},MessageTypes(msgType));
end  % setIconMessage

%% Get the relevant property value from jcomp
function propValue = localGetData(object,propValue,jcomp,propName)  %#ok
    propValue = get(jcomp,propName);
end

%% Set the relevant property value in jcomp
function propValue = localSetData(object,propValue,jcomp,propName)  %#ok
    set(jcomp,propName,propValue);
end

%% Utility function: add a new property to a handle and update its value
function prop = addOrUpdateProp(handle,propName,propValue)
    try
        if ~isprop(handle,propName)
            prop = schema.prop(handle,propName,'mxArray');
        else
            prop = findprop(handle,propName);
        end
        set(handle,propName,propValue);
    catch
        % never mind...
        lasterr  %#ok
    end
end

%% Link a specific property
function linkIconProp(trayIcon,iconHandle,propName)
    try
        % Create/update the handle property with the Java value
        prop = addOrUpdateProp(iconHandle,propName,get(trayIcon,propName));

        % Link the property data between the 2 handles
        prop.GetFunction = {@localGetData,trayIcon,propName};
        prop.SetFunction = {@localSetData,trayIcon,propName};
    catch
        % never mind... skip
    end
end  % linkIconProp

%% Link the Java and Matlab handle object properties
function linkIconProps(trayIcon,iconHandle)
    try
        prop = addOrUpdateProp(iconHandle,'JavaObject',trayIcon);
        prop.AccessFlags.PublicSet = 'off';  % read-only
        
        %addOrUpdateProp(iconHandle,'DeleteFcn',@deleteCallbackFcn);
        %addlistener(iconHandle, 'ObjectBeingDestroyed',@deleteCallbackFcn);
        prop = addOrUpdateProp(iconHandle,'MarkForDeletion',[]);
        prop.SetFunction = {@deleteCallbackFcn,trayIcon};

        % The following fails - cannot be modified!
        %prop = findprop(iconHandle,'Image');
        %prop.SetFunction = @getJavaImage;  % disallowed
        %prop.AccessFlags.PublicSet = 'off';
        prop = addOrUpdateProp(iconHandle,'IconImage',trayIcon.getImage);
        prop.SetFunction = @setIconImage;

        %linkIconProp(trayIcon,iconHandle,'UIContextMenu');
        prop = addOrUpdateProp(iconHandle,'UIContextMenu',[]);
        prop.SetFunction = @setIconPopup;

        prop = addOrUpdateProp(iconHandle,'IconWidth',trayIcon.getSize.getWidth);
        prop.AccessFlags.PublicSet = 'off';  % read-only
        prop = addOrUpdateProp(iconHandle,'IconHeight',trayIcon.getSize.getHeight);
        prop.AccessFlags.PublicSet = 'off';  % read-only

        prop = addOrUpdateProp(iconHandle,'Message',{});
        prop.SetFunction = @setIconMessage;

        %linkIconProp(trayIcon,iconHandle,'BusyAction');
        %linkIconProp(trayIcon,iconHandle,'HandleVisibility');
        %linkIconProp(trayIcon,iconHandle,'HelpTopicKey');
        %linkIconProp(trayIcon,iconHandle,'Interruptible');
        linkIconProp(trayIcon,iconHandle,'Tag');
        linkIconProp(trayIcon,iconHandle,'Type');
        linkIconProp(trayIcon,iconHandle,'UserData');
        linkIconProp(trayIcon,iconHandle,'ApplicationData');
    catch
        % never mind - try to work without the linked properties...
        %lasterr
        %a=1;  % debug point
    end
end  % linkIconProps

%% Callback function for object deletion
function propValue = deleteCallbackFcn(object,propValue,jcomp)
  java.awt.SystemTray.getSystemTray.remove(jcomp);
  delete(object);
end  % deleteCallback

%% Get an existing systm-tray icon based on the supplied image data
function iconHandle = getExistingIcon(imageData)
    try
        iconHandle = [];
        sysTray = java.awt.SystemTray.getSystemTray;
        icons = sysTray.getTrayIcons;
        for iconIdx = 1 : length(icons)
            if isequal(imageData,getappdata(icons(iconIdx),'iconImage__'))
                iconHandle = handle(icons(iconIdx));
                break;
            end
        end  % loop over all existing tray icons
    catch
        % never mind... - recreate the tray icon
    end
end  % getExistingIcon

%% Create a try icon from an image
function iconHandle = createTrayIcon(description,varargin)
   % Ensure that this image is not reused
   iconHandle = getExistingIcon(varargin{1});
   description = strrep(description,'\','/');
   if isempty(iconHandle)
       try
            % Get the Java image data
            iconImage = getJavaImage(varargin{:});

            % Try to create a new system tray icon object
            trayIcon = java.awt.TrayIcon(iconImage);
        
            % Dummy call, to ensure that callback properties are exposed
            dummy = get(trayIcon);  %#ok unused

            % Store the iconImage for possible later use
            setappdata(trayIcon,'iconImage__',varargin{1});

            % Create a Matlab handle and link the Java object's properties to it
            iconHandle = handle(trayIcon,'callbackproperties');
            linkIconProps(trayIcon,iconHandle);

            % Add the icon to the system tray
            sysTray = java.awt.SystemTray.getSystemTray;
            sysTray.add(trayIcon);
       catch
           error('YMA:systray:badImage',['could not convert ' description ' into an icon image: ' char(10) lasterr]);  %#ok
       end
       if iconImage.getWidth < 0  % indicates an invalid image
           error('YMA:systray:badImage',['could not convert ' description ' into an icon image: ' char(10) lasterr]);  %#ok
       end
   end
end  % createTrayIcon



%%%%%%%%%%%%%%%%%%%%%%%%%% TODO %%%%%%%%%%%%%%%%%%%%%%%%%
% - Enh: Add deletion listener: handle(trayIcon) apparently does not call the destroy object
% - Enh: Disable access to direct Java props like Image/PopupMenu (schema.prop cannot be modified since an instance already exists)
% - Enh: Merge the other-properties into the inspector table (inspect.m)
% - Enh: Enable getappdata/setappdata: works on Java object but not its handle()
% - Enh: Enable Matlab's findall() to find the icons based on handle or Tag