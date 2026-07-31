% Donate bitcoin: 16FezyuqQonxc4sp9ft8nYLa9ST2HVM542
%
% BTC-e api main function
% This is just an example and should be edited by you.
%
% !Important!
% You should edit your key and secret in the btce_call function 

function btce_api_main()

    % All possible requests
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % response = GetInfo()
    % response = TransHistory()
    % response = TradeHistory('count',2)
    % response = ActiveOrders()
    % response = Trade('pair','btc_usd','type','buy','rate',200,'amount',1)
    % response = CancelOrder('order_id',651389)
    % ticker_output = realtime_ticker('btc_usd');
    
    % Example:
    response = GetInfo();
    ticker_output = realtime_ticker('btc_usd');
    
    % Parse the json return
    parsed_json = parse_json(response);
    
    % Display the returned parsed json string
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    success = parsed_json.success;  
    disp('Success:');   
    disp(success);
    
    if success
        returned = parsed_json.return;
        disp('Response structure:')
        disp(returned)
    else
        error = parsed_json.error;
        disp('Error:')
        disp(error)
    end
    
    disp(ticker_output)

end