function response = GetInfo()
    % Get info
    % No parameters
    
    method = 'getInfo';
    params = '';

    response = btce_call(method,params);
end