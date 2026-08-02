function [sigma, pri] = sdh_gmm_em(x, mu, sigma_old, pri_old)

N = length(x);
C = length(mu);

sigma = zeros(C,1);
pri = zeros(C,1);

for i=1:C,
    post(:,i) = normpdf(x,mu(i),sigma_old(i))*pri_old(i);
end
post = post./repmat(sum(post,2),1,C);
for i=1:C,
    sigma(i) = sqrt(sum(post(:,i).*(x-mu(i)).^2)/sum(post(:,i)));
    pri(i) = sum(post(:,i))/N;
end
