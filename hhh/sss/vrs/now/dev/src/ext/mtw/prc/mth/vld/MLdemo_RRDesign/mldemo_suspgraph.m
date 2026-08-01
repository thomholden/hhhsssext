%   SLDEMO_SUSPGRAPH script which runs the suspension model.
%   SLDEMO_SUSPGRAPH when typed at the command line runs the simulation and
%   plots the results of the Simulink model SLDEMO_SUSPN.
%
%   See also SLDEMO_SUSPDAT, SLDEMO_SUSPN.

%   Author(s): D. Maclay, S. Quinn, 12/1/97
%   Modified by R. Shenoy 11/12/04
%   Modified by G. Chistol 08/24/06
%   Modified by T. Schultz 06/27/2007
%   Copyright 1990-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $


status = 'stopped';

if ~exist('sldemo_suspn_output','var')
    display('Did not find sldemo_suspn_output to plot results.');
    display('Please run simulation on the sldemo_suspn.mdl model.');
else

    % data saved to sldemo_suspn_output
    % this is a Simulink.Timeseries 
    % sldemo_suspn_output.FrontForce
    % sldemo_suspn_output.RearForce
    % sldemo_suspn_output.My
    % sldemo_suspn_output.h
    % sldemo_suspn_output.Z
    % sldemo_suspn_output.Zdot
    % sldemo_suspn_output.Theta
    % sldemo_suspn_output.Thetadot
    % sldemo_suspn_output.Thetadotdot
    % sldemo_suspn_output.Zdotdot
    
    % make the time vector
    Time = t;
    % Plot graphs
    figure
    %set(gcf,'position',[222 245 572 650])
    set(gcf,'Tag','SimulationResultsPlot'); % tag used later to close the figure
    
    subplot(3,1,1), 
    plot(Time,h);
    ylabel('h (m)', 'Interpreter','LaTex');
    title('Suspension Model Simulation Results')
    set(gca,'Ylim',[-0.005 0.015]);
    text(0.5,0.005 ,'road height')
    
    
    subplot(3,1,2), 
    plot(Time,Zdotdot);
    ylabel('$$\ddot{Z}$$ $$(m/s^{2})$$','Interpreter','LaTex');
    set(gca, 'xticklabel', '')
    
    subplot(3,1,3), 
    plot(Time,thetadotdot);
    ylabel('$$\ddot{\theta}$$ $$(rad/s^{2})$$','Interpreter','LaTex');
    set(gca, 'xticklabel', '')
    %set(gca, 'xticklabel', '')
    xlabel('Time (s)','Interpreter','LaTex')   
    
    
    echo off
end
clear status stat Time;
