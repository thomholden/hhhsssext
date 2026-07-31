function sl_customization(cm)

  %% Register custom menu function.
  cm.addCustomMenuFcn('Simulink:ContextMenu', @getMyMenuItems);
end

%% Define the custom menu function.
function schemaFcns = getMyMenuItems(callbackInfo) 
  schemaFcns = {@AutoSizeSchema}; 
end

%% Define the schema function for first menu item.
function schema = AutoSizeSchema(callbackInfo)
  schema = sl_action_schema;
  schema.label = 'AutoSizeOnConnect';
  schema.userdata = 'AutoSizeOnConnect';	
  schema.callback = @AutoSizeCallback; 
end

function AutoSizeCallback(callbackInfo)
%   disp(['Callback for item ' callbackInfo.userdata ' was called']);
  AutoSizeOnConnect;
end