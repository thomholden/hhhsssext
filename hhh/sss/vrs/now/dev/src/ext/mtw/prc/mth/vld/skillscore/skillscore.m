% Skill Score is a form of model Accuracy (Error Analysis).
%
% The skill score is a statistic similar to the Nash-Sutcliffe in that the
% closer to one the better the model prediction. 
% This function interprets model predictability using residual error
% and observed variability in your data. A skill score of 1 means a perfect
% fit (don't we all wish). Skill score equal to or less than zero means
% your model error is larger than the variability in your data. 
%
% SkillScore is defined as:  1 - RMSE/SDobs
% Narrative:  One minus the Root-Mean-Square-Error divided by Standard
%               Deviation of the observed data.
%
% Dimensions of Observed data array does not have to equal simulated data.
% An intersection is used to pair up observed data to simulated. This
% function is setup to pair up the first column in the observed data matrix
% and the first column in the simulated data matrix. Data values are
% located in column 2 of both matricies. 
%
% One critical assumption to this measurement is the data are normal.
% Without "recreating the wheel" the Statistical Toolbox would be needed to
% quickly evaluate your observed AND simulated data to test for normalcy.
% For example: qqplot
%
% Another possible application for this function is using this equation for
% Genetic algorithms and optimatizations.
%
% Syntax:
%     [SKout metric_id] = skillscore(obsDATA, simDATA)
%
% where:
%     obsData = N x 2
%     simData = N x 2
%
%     obsData(:,1) = time observed
%     obsData(:,2) = Observed Data
%     simData(:,1) = time simulated
%     simData(:,2) = Simulated data
%
%  SKout = double scalar
%  metric_id = 1000
%
% Requirements: none
%
% Written by Jeff Burkey
% King County, Department of Natural Resources and Parks
% 3/7/2007
% email: jeff.burkey@metrokc.gov
%
function [SKout metric_id] = skillscore(obsData, simData)
    % Set metric id for optional use.  This is arbitrarily set to 1000
    % for this metric and used in other applications not associated to this 
    % function. The user can either ignore or remove from the function. 
    metric_id = 1000;

    % find matching time values
    [c loc_obs loc_sim] = intersect(obsData(:,1), simData(:,1));

    % and create subset of data with elements= Time, Observed, Simulated
    MatchedData = [c obsData(loc_obs,2) simData(loc_sim,2)];
    [r c] = size(MatchedData); %#ok<NASGU>

    if r >= 2
        % for clarity, RMSE is caclucated in segments. Is this faster than
        % using more basic algebra? I haven't tested it yet.
        % RMSE = sqrt(sum((MatchedData(:,3) - MatchedData(:,2)).^2) /
        %       length(MatchedData))
        E = MatchedData(:,3) - MatchedData(:,2);
        SE = E.^2;
        MSE = mean(SE);
        RMSE = sqrt(MSE);

        SKout = 1 - RMSE/std(MatchedData(:,2));
    
        if r < 10
            warning('MATLAB:TooFewData','there are less than 10 data points used \n to compute skill score.');
        end
        if SKout < 0
            % model predictions are poor
            warning('MATLAB:ScoreLTZero','model predictions are poor. Model error is greater \n than observed data variability.')
        end
    else % cannot compute statistics
        error('MATLAB:divideByZero','Intesecting data resulted in too few elements to compute. \n Function has been terminated. If this is unexpected, \n check your index vectors of the two arrays.');
    end
end
