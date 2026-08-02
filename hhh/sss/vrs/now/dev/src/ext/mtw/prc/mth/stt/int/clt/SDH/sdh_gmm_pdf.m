function px = sdh_gmm_pdf(x, mu, sigma, pri)
% calculates the PDF at the locations x described by the gaussian mixture model

N = length(x);
C = length(mu);

px = zeros(N,1);
for i=1:C,
    px = px + pri(i)*normpdf(x,mu(i),sigma(i));
end
