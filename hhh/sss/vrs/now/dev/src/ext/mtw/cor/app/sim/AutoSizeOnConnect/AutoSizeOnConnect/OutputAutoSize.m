function OutputAutoSize(hand)
% OutpuAutoConnect.m
% Mike Anthony
% MathWorks
% Copyright (c) 2010, The MathWorks, Inc.
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%
% Called by AutoSize, so the below instructions are for education only.
% AutoSize will set the ConnectionCallback appropriately.
%
% Automatically resizes MIMO blocks upon connection to ensure lines coming
% into the top and bottom ports are straight.
%
% To enable this, this function must be called from the ConnectionCallback
% of a port. Note this is a port callback, not a block callback. As such,
% it must be set programatically. To set this, in the block library,
% select the block. Then, on the command line, type the following:
%
% >> p = get_param(gcb,'PortHandles');
% >> set_param(p.Outport(1),'ConnectionCallback','OutputAutoSize');
%
% Save the library. Henceforth, as long as this function is on your MATLAB
% path, the autosize feature will be enabled for all blocks originating from
% that library block.
%

blk = get_param(hand,'Parent');
pos = get_param(blk,'Position');
porth = get_param(blk,'PortHandles');

if length(porth.Outport) > 1
    % In case num of inports has changed, make sure this is on the last port
    set_param(porth.Outport(end),'ConnectionCallback','OutputAutoSize');
    
    % Make sure all the ports are connected, otherwise exit
    ports = [];
    for i = 1:length(porth.Outport)
        isline = get_param(porth.Outport(i),'Line');
        if isline ~= -1
            isconnect = get_param(isline,'DstPortHandle');
            if isconnect ~= -1
                ports(i,:) = get_param(isconnect,'Position');
            else
                return;
            end
        else
            return;
        end
        % Make sure only the last port has the Callback to OutputAutoSize 
        if i ~= length(porth.Outport)
            set_param(porth.Outport(i),'ConnectionCallback','');
        end
    end
    
    % grab the top and bottom port locations
    top_port = get_param(porth.Outport(1),'Position');
    % bot_port = get_param(porth.Outport(end),'Position');
    bot_port = get_param(porth.Outport(2),'Position');
    
    % Sort, just in case the ports are out of order
    srcs = sortrows(ports,1);
    
    % Create size variables
    dx = pos(1)-srcs(1,1);
    w = pos(3)-pos(1);
    h = pos(4)-pos(2);
    
    
    delta = 2;
    dy = 0;
    % set_param(blk,'Position',[srcs(1,1)+dx srcs(1,2)-dy srcs(1,1)+dx+w srcs(1,2)-dy+h]);
    
    % Outer loop moves the block to keep the top line straight
    % while top_port(2) > srcs(1,2) || bot_port(2) < srcs(end,2)
    tic;
    while top_port(2) > srcs(1,2) || bot_port(2) < srcs(2,2)
        dy = dy+delta;
        set_param(blk,'Position',[srcs(1,1)+dx srcs(1,2)-dy srcs(1,1)+dx+w srcs(1,2)-dy+h]);
        
        % Inner loop makes the block bigger to keep the 2nd line straight
        while bot_port(2) < srcs(2,2)
            h = h+delta;
            set_param(blk,'Position',[srcs(1,1)+dx srcs(1,2)-dy srcs(1,1)+dx+w srcs(1,2)-dy+h]);
            bot_port = get_param(porth.Outport(2),'Position');
        end
        top_port = get_param(porth.Outport(1),'Position');
        bot_port = get_param(porth.Outport(2),'Position');
        
        % Just in case you get into an infitine loop, break after 10 sec
        check = toc;
        if check > 5
            break
        end
    end
end








