clear; close all; clc

% Fast access to video frames from a (web)cam using the peekdata() function.
% This implementation includes a loop-frequency counter.
% To stop, simply close the figure window.
%
% Author: D.J. van Gerwen
% Created: 2010 Dec 6
% Last update: 2014 Jul 2

% Reset image acquisition (removes hidden videoinput objects)
imaqreset

% Turn off the warning message for peekdata
warning('off','imaq:peekdata:tooManyFramesRequested');

% Construct a videoinput object using the first device associated with the winvideo adapter
vid_obj = videoinput('winvideo',4);

% Set trigger type to manual, to prevent automatic triggering (and automatic stopping, unless 'triggerrepeat' is set to 'inf') of the video object
triggerconfig(vid_obj, 'manual'); % Default is 'immediate', which triggers directly after start()...

% Start video input object
start(vid_obj);

% Wait for peekdata to return a frame
while isempty(peekdata(vid_obj,1))
end

% Initialize image
figure('numbertitle','off','name','Timed Webcam','toolbar','none','menubar','none')
himg = imshow(peekdata(vid_obj,1),'initialmagnification',100);
htitle = title('','interpreter','none','fontsize',14);

% Initialize frequency counters
fwindow  = 100; % Number of frames to use for calculating average frequency [-]
fcount   = 0; % Counter for loop frequency calculations [-]
ftic     = tic; % Initial time reference [s]

% Run video capture
while 1
    
    % Try to update figure (this implementation allows proper deletion when figure is closed)
    try
        
        % Update image
        set(himg,'cdata',peekdata(vid_obj,1)); % Show most recent video frame (could be the same as in previous iteration)
        drawnow % flush video buffer
        
        % Update frequency every fwindow frames
        fcount = fcount + 1; % Increment frame counter [-]
        if ~mod(fcount,fwindow)
            set(htitle,'string',sprintf('Average loop frequency @ %s: %3.0fHz',vid_obj.VideoFormat,fwindow/toc(ftic))); % Update frequency
            ftic = tic; % Reset reference time
        end
        
    catch mexc
        
        disp(mexc.message)
        break
        
    end
    
end

% Stop video input object 
stop(vid_obj);

% Remove video input object from memory
delete(vid_obj)
if ~isvalid(vid_obj)
    clear vid_obj % The video object handle needs to be cleared after deletion, because it has become invalid
end

% Turn on the warning message for peekdata
warning('on','imaq:peekdata:tooManyFramesRequested');
