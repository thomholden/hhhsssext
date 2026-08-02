
synth_data=cell(1,Ts);
synth_transforms=zeros(3,Ts);

states=template.states;
[N1,N2]=size(states);
antistates=ones(N1,N2)-states;
w_mean=states.*(template.high_mean);
w_var=states.*(max(template.high_var,.001))+antistates.*(template.low_var);
w_std=sqrt(w_var);

% stuff for generating random shifts
for i=1:length(scope.hshifts)
  hweight(i)=length(scope.vshifts{i}); 
		% num of vert trans at each hor trans
end
num_trans = sum(hweight); 	% total num of shifts
cmf = cumsum(hweight);		% cmf of h given uniform dist over all trans

%figure

for t=1:Ts
    q=unidrnd(num_trans); hind = min(find(q <= cmf));
    h= scope.hshifts(hind);
    v = univec(scope.vshifts{hind});
    r = univec(scope.angles);
    synth_transforms(:,t)=[h v r]';

    w = w_mean + randn(N1, N2).*w_std;
    latent_im = atomic_rep(w,1);
%    noise = randn(N1, N2)*sqrt(obs_var);

%    synth_data{t} = latent_im + noise;
    synth_data{t} = transform(latent_im, h, v, r);%  + noise;

%    subplot(4,5,t)
%    displayimagesc(  synth_data{t})
end

