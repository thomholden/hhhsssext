
%% Build worker thread mex file
mex GaussianBlurThread.cpp "CXXFLAGS=$CXXFLAGS -std=c++0x -fpermissive -fPIC -DNDEBUG" 


%% Demo
% That's how you would acquire data, process it in a seperate thread and
% display the results once they're ready
clear all; close all;


% Assign the compiled mex file to MexThread class
thread = MexThread( @GaussianBlurThread );


% Initial acquisition
img = rand(240,320,3);
thread.start( img, 2.0 );
while thread.running(), pause(0.1); end
imgResult = thread.result();


% Main while(true) loop
fprintf( 'Starting threaded while(true) loop.\n' );
while true
      
    % Acquire data (as fast as possible)
    img = rand(240,320,3);
      
    % If thread has finished, get results.
    if ~thread.running()  
        if thread.finished()  
            % This is where you could do something with the results
            imgResult = thread.result();             
        end
        % Start thread with current input
        thread.start( img, 2.0 );
    end
       
    % Display current and last processed frame
    figure(1) 
    subplot(1,2,1), imshow(img,[]); 
    subplot(1,2,2), imshow( imgResult, [] );

end