% This function finds the segmentation solution with the lowest r2
% 
% INPUT
% 
% xx is the array indicating years.
% 
% yy is the array of spectral index value.
% 
% numseg is the number of segments.
% 
% OUTPUT
% 
% output is segmentation result, first row stores years, second row stores
% spectral index values. Column is the endpoints and breakpoints.
% For instance, the output [2001 2005 2011; 0.5 0.2 0.3] defines two
% segments, with x = 2005, y = 0.2 as the breakpoint.
% 
% r2 is the coefficient of determination.

function [output, r2] = Segmentation(xx, yy, numseg)

    r2 = 0;

    output = zeros(numseg + 1, 2);
    output(1, 1) = min(xx);
    output(end, 1) = max(xx);

    if numseg == 1

        tmp = zeros(length(xx),1);
        output(1,2) = yy(1);
        output(2,2) = yy(end);
        slope = (output(2, 2) - output(1, 2)) / (output(2, 1) - output(1, 1));
        tmp(:) = yy(:) - slope * (xx(:) - output(1, 1)) - output(1, 2); 

        rr = tmp' * tmp;
        r2 = 1 - rr/var(yy)/(length(yy)-1);

    else        

        outlist = nchoosek(xx(2:end-1),numseg-1);

        rr0 = 1e+32;
        for i = 1:size(outlist,1)

            output(2:numseg, 1) = outlist(i,:);

            tmp = zeros(length(xx),1);
            output(1,2) = yy(1);
            for ii = 1:numseg
                output(ii+1,2) = yy(xx == output(ii+1,1));
                kk = find((xx > output(ii, 1)) & (xx <= output(ii + 1, 1)));
                slope = (output(ii + 1, 2) - output(ii, 2)) / (output(ii + 1, 1) - output(ii, 1));
                tmp(kk) = yy(kk) - slope * (xx(kk) - output(ii, 1)) - output(ii, 2); 
            end

            rr = tmp' * tmp;
            if rr < rr0
                rr0 = rr;
                r2 = 1 - rr/var(yy)/(length(yy)-1);
                abc = output;
            end
        end
        output = abc;
    end
