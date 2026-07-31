% This function does the inter-year value selection
% Consult the help and the paper for details
% INPUT
% doy: in the format of yyyyddd, for instance, 2001179 is in year 2001, the
% 179th day of the year
% vegidx: the input time-series data
% maxiter: the maximum iteratio allowed
% OUTPUT
% Only one value for each year is remained.
% year: the array indicating the period, for instance [2001 2002 2003 ...
% 2011];
% out: output data arrays
% iter: the number of iterations

function [year, out, iter] = annuallify(doy, vegidx, maxiter)
    year = [min(fix(doy/1000)):max(fix(doy/1000))];
    n = length(year);
    data = -10001*ones(n, 23);
    ct = zeros(n);
    iter = 0;
    doy = doy(vegidx ~= -10001);
    vegidx = vegidx(vegidx ~= -10001);
    for i = 1:length(vegidx)
        idx = fix(doy(i)/1000)-year(1)+1;
        ct(idx) = ct(idx) + 1;
        data(idx, ct(idx))=vegidx(i);
    end
    out = data(:, 1);
    id = zeros(n,1);
    idold = ones(n,1);
    while (sum(idold - id)~=0 && iter <= maxiter)
        y = out;
        y(1:find(out~=-10001,1)-1) = y(find(out~=-10001,1));
        y(find(out~=-10001,1,'last')+1:n) = y(find(out~=-10001,1,'last'));
        df = find(y~=-10001);
        do = y(y~=-10001);
        y = interp1(df, do, 1:n);
        iter = iter + 1;
        idold = id;
        if find(data(1,:)==-10001,1)>2
            x = data(1,1:find(data(1,:)==-10001,1)-1);
            [~, id(1)] = min(abs(x-y(2)),[],2);
        end
        for i = 2:n-1
            if find(data(i,:)==-10001,1)>2
                x = data(i,1:find(data(i,:)==-10001,1)-1);
                [~, id(i)] = min(abs(x-(y(i-1)+y(i+1))/2),[],2);
            end
        end
        if find(data(n,:)==-10001,1)>2
            x = data(n,1:find(data(n,:)==-10001,1)-1);
            [~, id(n)] = min(abs(x-y(n-1)),[],2);
        end
        for i = 1:n
            if id(i)~= 0
                out(i) = data(i, id(i));
            end
        end
    end
    out = y;
end