function z=spatial_mean(template)

w=template.states.*template.high_mean;

z=atomic_rep(w,1);

