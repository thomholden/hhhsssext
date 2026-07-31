% This function implements the time-series segmentation to extract
% trajectories.
% 
% INPUT
% 
% x is x array (Years).
% 
% y is y array (Spectral Index Value).
% 
% mp is the max segments allowed.
% 
% OUTPUT
% 
% out is the output for the optimal result.
% 
% bestp is the number of segments. Determined by if r2 reaches r2thres or
% changes is smaller than r2cthres but it must reach r2low at least.
% 
% r2 is the coefficient of determination for the final result.

function [out, bestp, r2] = PLRtsfast(x, y, mp, r2thres, r2low, r2cthres)
    r2 = zeros(1,mp);
    bestp = mp;
    r2o = 0;
    % fit models starting from 1 segment to max piece of segments.
    for j = 1:mp
        tmp = [];
        while isempty(tmp)
            try
                [tmp, r22] = Segmentation(x, y, j);
                r2(j) = r22;
            catch err
                tmp = [];
            end
        end
        
        % terminate when r2 meets the general threhold
        if r2(j) > r2thres
            bestp = j;
            out = tmp;
            return;
        end
        if j > 1
            % or terminate if the increment is smaller than the incremental
            % threshold. But the r2 should be at least bigger than r2low. 
            if r2(j-1)> r2low && r2(j) - r2o < r2cthres
                bestp = j;
                out = tmp;
                return;
            end
        end

        if r2(j)>r2o
            out = tmp;
            r2o = r2(j);
            maxr = j;
        end
    end
    bestp = maxr;
end