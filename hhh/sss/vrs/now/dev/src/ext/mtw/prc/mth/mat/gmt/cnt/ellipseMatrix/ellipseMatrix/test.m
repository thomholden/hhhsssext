m = 800;
n = 600;
im = zeros(800, 600);

for i = 1:40
    y0 = randi(m);
    x0 = randi(n);
    a = randi(round(m/3));
    b = randi(round(n/3));
    
    c = max(a, b);
    
    while (x0 - c <= 5) || (x0 + c >= n-5) || (y0 - c < 5) || (y0 + c > m-5)
        a = randi(round(m/3));
        b = randi(round(n/3));
        c = max(a,b);
        y0 = randi(m);
        x0 = randi(n);
    end
    
    theta = 2*pi*rand(1);
    color = randi(256);
    color2 = round(color/3);
    
    disp(i)
    
    im = ellipseMatrix(y0, x0, a, b, theta, im, color, color2, randi(2));
    
end

colormap(gray(256));
image(im)