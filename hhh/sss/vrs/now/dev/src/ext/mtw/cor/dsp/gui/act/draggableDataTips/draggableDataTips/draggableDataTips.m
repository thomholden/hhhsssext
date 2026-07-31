function draggableDataTips(newState)
% draggableDataTips set new-functionality data-tips (draggable text-box with connector line)
%
% Matlab plots can display data-tips but these cannot be interactively moved
% except to the 4 corners of the data point. This utility enables the user to
% interactively drag any newly-created data-tip, anywhere in the Matlab figure.
% A dashed line connects the dragged data-tip with the original data point.
% 
% The new draggable functionality only affects new data-tips, so it can be turned
% on/off to enable standard and new data-tips to co-exist in the same plot.
%
% Syntax:
% draggableDataTips (without any input parameters) turns the new data-tips
% functionality ON for data-tips created from now onward.
%
% draggableDataTips('on')  or draggableDataTips(true)  turns the new functionality ON
% draggableDataTips('off') or draggableDataTips(false) turns the new functionality OFF
%
% Warning:
% Relies on undocumented functionality.
% Expected to fail in the upcoming HG2.
% 
% Technical description:
% http://UndocumentedMatlab.com/blog/draggable-plot-data-tips/

% Change log:
%    2013-11-06: Fixed bug when clicking on connector line (reported by Aditya on FEX page)
%    2013-10-23: First version posted on Matlab File Exchange, renamed draggableDataTips
%    2007-12-08: Initial version (newdatatips.m)

% Programmed by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.2 $  $Date: 2013/11/06 23:14:39 $

   % Normalize the new state flag
   if nargin < 1
       newState = true;
   elseif ischar(newState)
       newState = strcmpi(newState,'on');
   end

   % Get the handle for the cursor object's DataCursor property
   hFig = figure('visible','off');  % only used to get the datacursormode handle
   cursorObj = datacursormode(hFig);
   try
       % HG1
       % This works but is indirect and a bit more complicated
       %ch = classhandle(cursorObj);
       %hPropIdx = strcmpi(get(ch.Properties,'Name'), 'CurrentDataCursor');
       %hProp = ch.Properties(hPropIdx);
       
       % This is the direct alternative
       hProp = findprop(cursorObj, 'CurrentDataCursor');
       setPropName = 'SetFunction';
   catch
       % HG2
       hProp = findprop(cursorObj, 'CurrentCursor');
       setPropName = 'SetMethod';
   end
   delete(hFig);
   if isempty(hProp)
       error('YMA:DraggableDataTips:PropNotFound', 'could not install new datatips - bailing out');
   end

   % Install or remove the new move function whenever a datatip is created or selected
   try
       % Note: setting hProp fails on HG2 - I haven't yet found a solution...
       if newState
           hProp.(setPropName) = @installNewMoveFcn;
           %disp('installed new move function: @installNewMoveFcn');
       else
           hProp.(setPropName) = @dummy;  % [] or '' may cause matlab to crash!
           %disp('removed new move function');
       end
   catch
       error('YMA:DraggableDataTips:PropNotSet', 'could not install new datatips - bailing out:\n%s', lasterr); %#ok<LERR>
   end

% Dummy function to serve as empty function so that new datatips will resume their natural behavior
function hDataTip = dummy(cursorObj, hDataTip) %#ok<INUSL>
   return;

% Install a replacement callback function for datatip textbox mouse movement
function hDataTip = installNewMoveFcn(cursorObj, hDataTip) %#ok<INUSL>
   try
   srcObjs = get(hDataTip.SelfListenerHandles,'SourceObject');
   for srcIdx = 1 : length(srcObjs)
       try
       if strcmpi(srcObjs{srcIdx}.Name,'Orientation')
           hDataTip.SelfListenerHandles(srcIdx).Callback = @textBoxUpdateFcn;
           hDataTip.MarkerHandle.Marker = 'none';
           %disp('replaced Orientation listener with @textBoxUpdateFcn');
           break;
       end
           catch
               % ignore - maybe not a property object
           end
       end
   catch
       % ignore
   end
   return;

% Main mouse drag callback function
function textBoxUpdateFcn(hDataTip,eventSrc,varargin) %#ok<INUSD>
% This gets called when the user drags the datatip
% textbox (not to be confused with the datatip marker)
  persistent hText newPos
  try
      if ~ishandle(hDataTip)
          return;
      end

      % Get needed handles
      hAxes = get(hDataTip,'HostAxes');
      %hFig = ancestor(hAxes,'figure');
      %hHost = hDataTip.Host;
      
      % Get mouse position in points
      mouse_pos = localGetAxesMousePointsPosition(hAxes);
      xm = mouse_pos(1);
      ym = mouse_pos(2);
      
      % Get datatip position in points
      %datatip_pos = localGetDatatipPointsPosition(hDataTip);
      %xd = datatip_pos(1);
      %yd = datatip_pos(2);
      
      % Update the text box so that its center is at the mouse position
      hText = hDataTip.TextBoxHandle;
      orig_units = hText.Units;
      newPos = hText.Position;
      newPos(1) = xm;  newPos(2) = ym;
      hText.Units = 'points';
      hText.Position = newPos;
      %drawnow;
      %disp(newPos);
      hText.Units = orig_units;
      hText.HorizontalAlignment = 'center';
      hText.VerticalAlignment   = 'middle';

      % Store the information for possible later use
      if ~isprop(hText,'LoosePosition')
          schema.prop(hText,'LoosePosition','mxArray');
      end
      set(hText,'LoosePosition',hText.Position);

      % This callback function is only called when the Orientation prop value changes
      % => force an incorrect orientation here so that when the mouse moves slightly the Orientation value
      %    will be "corrected" and then this function will be re-called
      %oldOr = hDataTip.Orientation;
      newOrientation = regexprep(hDataTip.Orientation,{'top','bottom','x'},{'x','top','bottom'}); %'loose';
      hDataTip.Orientation = regexprep(newOrientation,{'left','right','x'},{'x','left','right'}); %'loose';
      %disp({oldOr newOrientation hDataTip.Orientation})

      % Draw the connector line
      if ~isprop(hText,'ConnectorLineHandle')
          schema.prop(hText,'ConnectorLineHandle','mxArray');
      end
      hConnectorLine = get(hText,'ConnectorLineHandle');
      updateConnectorLine(hConnectorLine,hDataTip,hText);
  catch
      % ignore
      err = lasterr  %#ok
      a = 1;  %#ok debug point
  end

% Restore loose position after he system automatically updates using the standard function
function restoreLoosePosition(hText)
  % Check if we simply need to undo a standard call to localApplyCurrentOrientation
  stk = dbstack;
  try
      if any(strcmpi({stk.name},'localApplyCurrentOrientation'))
          %hText = eventData.AffectedObject;
          newPosition = get(hText,'LoosePosition');
          if ~isequal(hText.Position, newPosition)
              hText.Position = newPosition;
              if hText.Position(3) == 0
              % unsuccessful attempt to prevent z-order problem when textbox is defocussed
              %hText.Position = hText.Position + [0,0,1];

              % ...and another unsuccessful attempt
              %uistack(hText,'top');
              end
              hText.HorizontalAlignment = 'center';
              hText.VerticalAlignment   = 'middle';
          end
          return;
      end
  catch
      % never mind - ignore
      err = lasterr  %#ok
      a = 1;  %#ok debug point
  end

% Update connector line positions upon datacursor movement etc.
function updateConnectorLine(hConnectorLine,hDataTip,hText)
  persistent inCallback
  if ~isempty(inCallback)
      return;
  end

  try
      % ignore events due to moveToFront
      stk = dbstack;
      if strcmpi(stk(5).name, 'movetofront')
          return;
      end
  catch
      % never mind - ignore
  end

  try
      inCallback = 1; %#ok<NASGU>
      if ~strcmpi(hDataTip.ViewStyle, 'datatip')
          deleteConnectorLine(hConnectorLine);
      else
          if nargin < 3
              hText = hDataTip.TextBoxHandle;
              %restoreLoosePosition(hText);
          end
          cursorObj = hDataTip.DataCursorHandle;
          datatip_pos = cursorObj.Position;
          mouse_pos   = getObjectDataPos(hText);  % hText.Position
          lineX = [datatip_pos(1), mouse_pos(1)];
          lineY = [datatip_pos(2), mouse_pos(2)];
          setappdata(hDataTip.HostAxes,'datatip_fireDataTipUpdate',false);
          %rmappdata(hDataTip.HostAxes,'datatip_fireDataTipUpdate');
          if nargin < 3,  restoreLoosePosition(hText);  end
          if isempty(hConnectorLine) || ~ishandle(hConnectorLine)
              % Create a new connector line
              hConnectorLine = line(lineX, lineY, 'LineStyle',':', 'Color','k', 'Tag','ConnectorLine', 'HitTest','off');  % black dotted line, unclickable
              try
                  % Ensure that we don't accumulate dangling connectors
                  oldConnectorLine = get(hText,'ConnectorLineHandle');
                  delete(oldConnectorLine);
              catch
                  % ignore - maybe none or invalid
              end
              set(hText,'ConnectorLineHandle',hConnectorLine);
              
              % Store a reference to the text box and the cursor marker
              schema.prop(hConnectorLine, 'TextBoxHandle','mxArray');
              set(hConnectorLine, 'TextBoxHandle', hText);
              schema.prop(hConnectorLine, 'DataCursor','mxArray');
              set(hConnectorLine, 'DataCursor', cursorObj);
              schema.prop(hConnectorLine, 'MarkerHandle','mxArray');
              set(hConnectorLine, 'MarkerHandle', hDataTip.MarkerHandle);
              
              % Destroy the connector line upon textbox deletion
              try set(hText,'Listeners__',[]); catch, end
              addlistener(hText, 'ObjectBeingDestroyed', @(o,e)deleteConnectorLine(hConnectorLine));

              % Update the connector line upon textbox or datacursor movement/appearance/disappearance
              listeners = handle([]);
              listeners(end+1) = handle.listener(hText,     findprop(hText,'Position'),     'PropertyPostSet',@(h,e)updateConnectorLine(hConnectorLine,hDataTip));
              listeners(end+1) = handle.listener(hText,     findprop(hText,'Visible'),      'PropertyPostSet',@(h,e)updateConnectorLine(hConnectorLine,hDataTip));
              setappdata(hText, 'listeners',listeners);

             %listeners(end+1) = handle.listener(hDataTip,  findprop(hDataTip,'Visible'),   'PropertyPostSet',@(h,e)deleteConnectorLine(hConnectorLine));
             %listeners(end+1) = handle.listener(hDataTip,  findprop(hDataTip,'ViewStyle'), 'PropertyPostSet',@(h,e)deleteConnectorLine(hConnectorLine));

              listeners = handle([]);
              listeners(end+1) = handle.listener(cursorObj, findprop(cursorObj,'Position'), 'PropertyPostSet',@(h,e)updateConnectorLine(hConnectorLine,hDataTip));
             %listeners(end+1) = handle.listener(cursorObj, findprop(cursorObj,'DisplayStyle'), 'PropertyPostSet',@(h,e)updateConnectorLine(hConnectorLine,hDataTip));
              setappdata(cursorObj, 'listeners',listeners);
          else
              set(hConnectorLine, 'XData',lineX, 'YData',lineY);
          end
      end
  catch
      err = lasterr  %#ok
      a = 1;  %#ok debug point
  end
  inCallback = [];

% Delete the connector line upon datatip deletion etc.
function deleteConnectorLine(hConnectorLine)
  try delete(hConnectorLine); catch, end

% Get the object's position in data units
function pos = getObjectDataPos(hObject)
  old_units = get(hObject, 'Units');
  if strcmpi(old_units,'data')
      pos = get(hObject, 'Position');
  else
      set(hObject, 'Units', 'data');
      pos = get(hObject, 'Position');
      set(hObject, 'Units', old_units);
  end

% --- THE FOLLOWING IS TAKEN FROM MATLAB'S datatip.m ---
function [mouse_pos] = localGetAxesMousePointsPosition(hAxes)
% Get mouse points position relative to axes

% Get mouse points position relative to figure
hFig = ancestor(hAxes,'figure');
mouse_pos = hgconvertunits(hFig,[0 0 get(hFig,'CurrentPoint')],...
    get(hFig,'Units'),'points',0);
mouse_pos = mouse_pos(3:4);

% Get axes points position
axes_pos = hgconvertunits(hFig,get(hAxes,'Position'),...
    get(hAxes,'Units'),'points',get(hAxes,'Parent'));

% Get mouse position relative to axes position
mouse_pos = mouse_pos(1:2) - axes_pos(1:2);

function [points_pos] = localGetDatatipPointsPosition(hDataTip) %#ok<DEFNU>

%hMarker = hDataTip.MarkerHandle;
hText = hDataTip.TextBoxHandle;
%Prevent update function from firing too much:
setappdata(hDataTip.HostAxes,'datatip_fireDataTipUpdate',false);
orig_text_pos = get(hText,'Position');
orig_text_units = get(hText,'Units');
rmappdata(hDataTip.HostAxes,'datatip_fireDataTipUpdate');

% Ideally we can transform from data to points via HG
% but currently there is no hook. We can get this
% transform indirectly via a text object.
hText.Units = 'data';
% Do not use hDataTip.Position here, that property may be temporarily stale
% and is intended for client code only
pos = hDataTip.DataCursorHandle.Position;
if isempty(pos)
    error('MATLAB:graphics:datatip:emptyPosition','Data cursor position is empty');
end
hText.Position = pos;
hText.Units = 'points';
points_pos = hText.Position;

% Restore text object state
hText.Units = orig_text_units;
hText.Position = orig_text_pos;
