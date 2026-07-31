function AutoSizeOnConnect()
% AutoSizeOnConnect.m
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
% Automatically creates the correct number of ports and aligns blocks
% during connection. Particularly useful with Bus Creator, Mux, and Demux
% Blocks.
%

ublks = find_system(gcs,'SearchDepth',1,'Selected','on');

if isempty(ublks)
    return
end

for i = 1:length(ublks)
    pos = get_param(ublks{i,1},'Position');
    ublks{i,2} = pos(2);
end
ublks = sortrows(ublks,2);
blks = ublks(:,1);

oldgcb = gcb;
while strcmp(oldgcb,gcb)
    pause(0.05)
end

cblk = gcb;
cname = get_param(cblk,'Name');

inerr = false;
try
    % check if any of the blocks have multiple outports
    numIns = 0;
    for i = 1:length(blks)
        porth = get_param(blks{i},'PortHandles');
        numIns = numIns + length(porth.Outport);
    end
    set_param(cblk,'Inputs',num2str(numIns));
catch
    inerr = true;
end

% Fix to handle Multiple Input blocks with NumInputs property
% (Like VectorConcatenate)
if inerr
    try 
        set_param(cblk,'NumInputs',num2str(numIns));
        inerr = false;
    catch
    end
end

% Fix to handle Multiple Input blocks with NumInputPorts property
% (Like Scope)
if inerr
    try 
        set_param(cblk,'NumInputPorts',num2str(numIns));
        inerr = false;
    catch
    end
end

outerr = false;
try
    numOuts = 0;
    for i = 1:length(blks)
        porth = get_param(blks{i},'PortHandles');
        numOuts = numOuts + length(porth.Inport);
    end
    set_param(cblk,'Outputs',num2str(numOuts));
catch
    outerr = true;
end  
      

if inerr && outerr
    disp('Cannot automatically size and connect these blocks');
    return
end

% Connect outports
if inerr
    cblk_port = 0;
    for i = 1:length(blks)
        dname = get_param(blks{i},'Name');
        lines = get_param(blks{i},'LineHandles');
        
        % Check if the block is already connected to the destination block
        ac = false;
        for j = 1:length(lines.Inport)
            if lines.Inport(j) ~= -1
                sblk = get_param(lines.Inport(j),'SrcBlockHandle');
                if strcmp(getfullname(sblk),cblk)
                    ac = true;
                    break
                end
            end
        end
        
        % If the block isn't already connected, try to connect it
        if ~ac
            port_found = false;
            for j = 1:length(lines.Inport)
                if lines.Inport(j) == -1
                    port_found = true;
                    cblk_port = cblk_port + 1;
                    cports = get_param(cblk,'PortHandles');
                    set_param(cports.Outport(cblk_port),'ConnectionCallback','OutputAutoSize');
                    add_line(gcs,[cname '/' num2str(cblk_port)],[dname '/' num2str(j)],'autorouting','on');
                end
            end
            if ~port_found
                error('Cannot automatically connect blocks');
            end
        end
    end
    %     error('Cannot automatically size number of destination block inputs.')
end

% Connect inports
if outerr
    cblk_port = 0;
    for i = 1:length(blks)
        % Increment destination block port counter
%         cblk_port = cblk_port + 1;
        
        sname = get_param(blks{i},'Name');
        lines = get_param(blks{i},'LineHandles');
        
        % Check if the block is already connected to the destination block
        ac = false;
        for j = 1:length(lines.Outport)
            if lines.Outport(j) ~= -1
                dblk = get_param(lines.Outport(j),'DstBlockHandle');
                if strcmp(getfullname(dblk),cblk)
                    ac = true;
                    break
                end
            end
        end
        
        % If the block isn't already connected, try to connect it
        if ~ac
            port_found = false;
            for j = 1:length(lines.Outport)
                if lines.Outport(j) == -1
                    port_found = true;
                    cblk_port = cblk_port + 1;
                    cports = get_param(cblk,'PortHandles');
                    set_param(cports.Inport(cblk_port),'ConnectionCallback','InputAutoSize');
                    add_line(gcs,[sname '/' num2str(j)],[cname '/' num2str(cblk_port)],'autorouting','on');
                end
            end
            if ~port_found
                error('Cannot automatically connect blocks');
            end
        end
    end
%     error('Cannot automatically size number of source block outputs.')
end


   


            
    


