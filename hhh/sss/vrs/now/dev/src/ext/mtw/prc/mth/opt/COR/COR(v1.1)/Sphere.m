function y=Sphere(x)

    global NFE;
    if isempty(NFE)
        NFE=0;
    end
    
    NFE=NFE+1;

    y = sum((1*x) .^2);

end