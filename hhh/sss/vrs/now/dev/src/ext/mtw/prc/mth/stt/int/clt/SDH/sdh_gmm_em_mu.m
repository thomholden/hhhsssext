function [mu, sigma, pri] = sdh_gmm_em_mu(x, mu_old, sigma_old, pri_old, min_sigma)
% also estimate mu

N = length(x);
C = length(mu_old);

sigma = zeros(C,1);
pri = zeros(C,1);
mu = zeros(C,1);

for i=1:C,
    post(:,i) = normpdf(x,mu_old(i),sigma_old(i))*pri_old(i);
end
post = post./repmat(sum(post,2),1,C);
for i=1:C,
    sigma(i) = sqrt(sum(post(:,i).*(x-mu_old(i)).^2)/sum(post(:,i)));
    pri(i) = sum(post(:,i))/N;
    mu(i) = sum(post(:,i).*x)/sum(post(:,i));
end

% remove centers where std ~ zero
idx = find(sigma>min_sigma);
if ~isempty(idx),
    sigma = sigma(idx);
    pri = pri(idx);
    mu = mu(idx);
end
