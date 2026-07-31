function [h sxy] = DrawFootball(x0,y0,r1,r2,p,N,theta,holes,idx,ShowShape,opts)

M = RotationMatrix(theta);

if ShowShape
    n = round(N / 2);

    x = linspace(-1,1,n);
    y = r2 * (abs(x).^p);

    x = [(r1 * x) (r1 * x(end:-1:1))];
    y = [(r2-y) (y(end:-1:1)-r2)];

    xy = M * [x;y] + repmat([x0;y0],1,N);

    h = plot(xy(1,:),xy(2,:),opts{:});
else
    h = [];
end

hold on;
axis equal;

Nh = size(holes,2);
if (Nh > 0)
    holes(1,:) = r1 * holes(1,:);
    holes(2,:) = r2 * holes(2,:);
    hxy = M * holes + repmat([x0;y0],1,Nh);
    
    if ShowShape
        regInds = setdiff(1:size(holes,2),idx);
        if ~isempty(regInds)
            h = [h plot(hxy(1,regInds),hxy(2,regInds),'ko','Linewidth',1)];
        end
        h = [h plot(hxy(1,idx),hxy(2,idx),'ko','Linewidth',2)];
    end
    
    sxy = hxy(:,idx);
else
    sxy = zeros(2,0);
end
