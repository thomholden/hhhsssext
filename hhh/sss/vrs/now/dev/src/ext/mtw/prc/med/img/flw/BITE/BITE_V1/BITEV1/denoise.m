% This function removes spike noises iteratively.
% For details, consult the help and the paper.
% 
% INPUT
% 
% data: input time-series data.
% 
% thres: multiplier for the standard deviation, use 1.
% 
% OUTPUT
% 
% out: denoised time-series data.

function out = denoise(data, thres)
    noise = true;
    n = length(data);
    if size(data,1) ~= 1
        data = data';
    end
    data = [(data(2) + data(3))/2 data (data(n-2)+data(n-1))/2];
    while noise 
        sd = std(data);
        noise = false;
        spike = 0;
        id = 0;
        for i = 2:n+1
                if abs(data(i) - data(i-1) + data(i) - data(i+1))  > thres * sd...
                        && (data(i) - data(i-1))*(data(i) - data(i+1))>0
                    noise = true;
                    if abs(data(i) - data(i-1)) + abs(data(i) - data(i-1)) ...
                            > spike
                        spike = abs(data(i) - data(i-1))+ abs(data(i) - data(i-1));
                        id = i;
                    end
                end
        end
        if noise
            if abs(data(id-1)-data(id))<abs(data(id+1)-data(id))
                data(id) = data(id-1);
            else
                data(id) = data(id+1);
            end
        end
    end
    out = data(2:n+1);
end
                    