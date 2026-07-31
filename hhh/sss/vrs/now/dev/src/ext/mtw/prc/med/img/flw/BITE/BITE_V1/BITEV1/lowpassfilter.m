function data = lowpassfilter(image, mask)
% 3 by 3 mean filter
% mask value is the value that is ignored during the filter process
p = size(image);
data = zeros(p(1),p(2),p(3));
for i = 2:p(1)-1
    for j = 2:p(2)-1
        for k = 1:p(3)
            ct = 0;
            for m = -1:1
                for n = -1:1
                    if image(i+m,j+n,k)~=mask
                        data(i,j,k) = data(i,j,k)+image(i+m,j+n,k);
                        ct = ct + 1;
                    end
                end
            end
            % only with 6,7 and 8 available neighbors the filtering is
            % implemented, otherwise the pixel is discarded as a mask pixel.
            if ct > 5
                data(i,j,k) = data(i,j,k)/ct;
            else
                data(i,j,k) = mask;
            end
        end
    end
end