% Call the api
% input is the method and the parameters
% output is the response of the api call in json format
%
% parameters format should look like:
% parameters = '&parameter1=value1&parameter2=value2'
%
% Example:
%
% method = 'getInfo';
% parameters = '';
% response = btce_call(method, parameters);
%
% !Important!
% Change the appKey and appSecret to your key and secret (found online
% on your btc-e account.

function response = btce_call(method, params)

    % Change appKey and appSecret
    %%%%%%%%%%%%%%%%
    appKey = 'KI6WUSUR-UV39EEW9-Z1II71KC-YK7Q7HW8-I9OVKEDL';
    appSecret = 'a971b9afa868d3c83334b499812927dbddc63c338ec6e6aafa4395fa74eec4a4';

    % Create a nonce, calls can be made successively every millisecond
    % This nonce works until 18-jan-2026
    nonce = strrep(num2str(now*1000000-7.34E11), '.', '');
    nonce = nonce(1:10);

    % Addres to call
    addr = 'https://btc-e.com/tapi';

    % Parameters to use
    parameters = ['method=' method ...
        '&nonce=' nonce params];

    % SHA512 encoding
    requestString = doHMAC_SHA512(parameters, appSecret);

    % Create the headers
    header1 = http_createHeader('Content-Type','application/x-www-form-urlencoded');
    header2 = http_createHeader('Key', appKey);
    header3 = http_createHeader('Sign', requestString);
    headers = [header1 header2 header3];

    % Do the request
    response = urlread2(addr,'POST',parameters,headers);

end