% Get (cross)-spectra from MAR coefficients
% for example in Marple, p. 409

mar_org.p=1;
mar_org.lag(1).a=[-0.85 0.75; -0.65 -0.55];
mar_org.noise_cov=[1 0; 0 1];
ns=128;
mar_plot_spectra(mar_org,1,2,ns);

disp('Compare this with Figure 15.6 in Marple p. 412');

total_seconds=3;
T=total_seconds*ns;
Y=mar_gen (mar_org, T);

disp('Now use an overcomplex MAR model and see what happens');
mar.p=4;
mar = mar_learn (Y',mar.p);
mar_plot_spectra(mar,1,2,ns);

disp('It still works');