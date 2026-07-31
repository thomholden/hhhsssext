% This script shows the usage of c# (.Net) Form GUI in Matlab
%
% See info_MatlabGUI.txt on how to Create and Register the MatlabGUI ActiveX control
%
% Author: D.Kroon, University of Twente

net = actxserver('MatlabGUI.FormControlClass');

methods(net) % The functions of ComMatlab Class

net.showGUI % Show the user interface

% User Interface loop
while(~net.ReturnFinished) % Watch finished button
    pause(0.3) % Wait 0.3 sec
end

userinput=net.ReturnInput; % Get user input in form

disp(userinput); % Display User Input

net.closeGUI % Close the user interface


