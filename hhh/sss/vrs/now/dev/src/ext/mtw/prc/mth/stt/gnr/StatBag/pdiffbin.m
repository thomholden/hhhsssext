function [p] = pdiffbin (obs,expect)

% function [p] = pdiffbin (obs,expect)
% Return the probability that two binned distributions are 
% distributed the same. See page 620 Press et. al.
% USES: pchisq.m

Nobs=length(obs);
Nexpect=length(obs);
if ~(Nobs == Nexpect)
	disp('Error in pdiffbin: vectors must be same length');
	return
end

e=expect(find(expect>0));
o=obs(find(expect>0));
c=sum((o-e).^2./e);
df=length(e)-1;
p=pchisq(c,df);

