%% Exchanging data
spmd
    % Generate different data on each worker
    dataToSend = labindex * ones(labindex);
    
    % Left neighbor
    % for labindex ~= 1, left neighbor is labindex-1
    % for labindex = 1, left neighbor is numlabs (wrapping around)
    left = mod(labindex - 2, numlabs) + 1;
    
    % Right neighbor
    % for labindex ~= numlabs, right neighbor is labindex+1
    % for labindex = numlabs, right neighbor is 1
    right = mod(labindex, numlabs) + 1;

    dataReceived = labSendReceive(right, left, dataToSend);
    
    disp(dataReceived)
end

%% Getting data back to client
dataOnClient = dataReceived(:);

% Copyright 2014 The MathWorks, Inc.