function [y] = myrecursivefilter(x,alpha)
    y = zeros(size(x));
    y(1) = x(1)*alpha;
    for ii = 2:length(x)
        y(ii) = y(ii-1)*(1-alpha) + x(ii)*alpha;
    end
end