%This function uses the smoothing algorithm that the user decides to smooth
%the displacement data

function [dispx_smooth,dispy_smooth,smooth_setup] = smooth_disp(...
    smooth_setup,grid_param,corr_setup,...
    dispx,dispy,dispx_smooth_prev,dispy_smooth_prev,loop_type,N_threads)

%Get the smoothing algorithm from the smooth setup structure
smoothing_algorithm = smooth_setup.smoothing_algorithm;

if strcmp(smoothing_algorithm,'no smoothing'); %No smoothing is requested
    if isempty(dispx_smooth_prev) %No previous smoothing
        %Set the raw data as the smoothed data
        dispx_smooth = dispx;
        dispy_smooth = dispy;
    else %dispx_smooth_prev is NOT empty-->Previous smoothing
        %Set the previously smoothed data as the current smoothed data
        dispx_smooth = dispx_smooth_prev;
        dispy_smooth = dispy_smooth_prev;
    end
       
elseif strcmp(smoothing_algorithm,'moving average') %Use my code for moving average
    [dispx_smooth,dispy_smooth] = smooth_moving_average(smooth_setup,...
        grid_param,corr_setup,dispx,dispy,loop_type,N_threads);

end