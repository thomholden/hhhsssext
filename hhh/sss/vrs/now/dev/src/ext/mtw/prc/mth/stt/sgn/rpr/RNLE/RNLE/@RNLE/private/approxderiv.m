function diff=approxderiv(fun,point,type,order,step)

% Allocate space for return argument.
diff=zeros(size(point));

% Create signed binomial coefficients.
coeff=diag((-1).^(0:order));
coeff(:,1)=1;
for j=2:order
    for i=j+1:order+1
        coeff(i,j)=coeff(i-1,j)-coeff(i-1,j-1);
    end
end

% Store increments.
switch lower(type)
    case 'forward'
        inc=(order:-1:0)';
    case 'backward'
        inc=(0:-1:-order)';
    otherwise
        inc=(order/2:-1:-order/2)';
end

% Approximate numerical derivatives.
if any(inc==0)
    val=feval(fun,point);
end
for i=1:numel(point)
    for j=0:order
        weight=coeff(order+1,j+1)/order;
        if inc(j+1)==0
            diff(i)=diff(i)+weight*val;
        else
            point(i)=point(i)+step*inc(j+1);
            diff(i)=diff(i)+weight*feval(fun,point);
            point(i)=point(i)-step*inc(j+1);
        end
    end
    diff(i)=diff(i)/step;
end

end