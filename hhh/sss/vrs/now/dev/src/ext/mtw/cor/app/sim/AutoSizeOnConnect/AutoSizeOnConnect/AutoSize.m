function AutoSize(hand)
% AutoSize.m
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
% This function sets the ConnectionCallbacks to InputAutoSize and
% OutputAutoSize appropriately. Put this in any blocks CopyFcn, MoveFcn, or
% InitFcn callback to have the blocks automatically resize tehmselves upon
% connection to get straight lines.
%

btype = get_param(gcb,'BlockType');
if strcmp(btype,'Sum')
    icon_shape = get_param(gcb,'IconShape');
    if strcmp(icon_shape,'round')
        return
    end
end
p = get_param(gcb,'PortHandles');
if ~isempty(p.Inport)
    set_param(p.Inport(1),'ConnectionCallback','InputAutoSize');
end

if ~isempty(p.Outport)
    set_param(p.Outport(1),'ConnectionCallback','OutputAutoSize');
end



   


            
    


