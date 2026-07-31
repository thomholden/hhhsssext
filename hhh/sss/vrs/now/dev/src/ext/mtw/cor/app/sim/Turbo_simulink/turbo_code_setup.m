function turbo_code_setup

% Get parameter names and values from mask
mask_ws_vars = get_param([gcs '/Global Parameters'],'maskwsvariables');

if ~isempty(mask_ws_vars)
    for i = 1:length(mask_ws_vars),
        curr_var = mask_ws_vars(i).Name;
        evalin('base',[curr_var ' = ' num2str(mask_ws_vars(i).Value) ';']);
    end
    
    % Set up other parameters in the MATLAB workspace as needed
    evalin('base','trellis = poly2trellis(3, [7 5],7);');  % rate 1/2
    
    evalin('base','code_rate = 1/3;');            % Overall code rate = 1/3
    
    evalin('base','Es = 1;');                     % Signal energy is 1         
    evalin('base','Eb = Es/code_rate;');          % bit energy is 3         
    evalin('base','EbNo = 10.0.^(0.1*EbNodB);');  % Convert from dB to linear
    evalin('base','Variance = Eb/EbNo/2;');       % Calculate channel noise variance
    evalin('base','clear EbNo Es Eb;');
    
else
    evalin('base','Len = 1024;');
    evalin('base','Iter = 11;');
end