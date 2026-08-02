function [sigma, pri] = sdh_gmm_init(x,mu) % estimate initial values

N = length(x);
C = length(mu);

[foo w] = min(abs(repmat(x,1,C)-repmat(mu,N,1)),[],2); % which x lies in which bin?

sigma = zeros(1,C);
pri = zeros(1,C);
for i=1:C;
    sigma(i) = sqrt(1/sum(w==i) * sum((x(w==i)-mu(i)).^2)); % std
    pri(i) = sum(w==i)/N; % priors
end
