% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



clear; clc;


modelname = 'vgcir';
optmethod = 'sa'; % 'de', 'nelder', 'fmincon', 'sqp'
fftmethod = 'cm'; % 'bs', 'cos', 'lewis'
N = 10;
eta = 0.1;
alpha = 0.75;
L = 8;
sigma = 0.4;

P_struct.type = 0;
% Model Stuff
P_struct.S0 = 7657.796;             % Spot prices asset         
P_struct.df = [.9794, .9599, .9410, .9223, .9041, .8861, .8686, .8514, .8345, .8179];   
P_struct.d = 0;
P_struct.dataT = [0.52,	1.02,	1.52,	2.02,	2.52,	3.02,	3.52,	4.02,	4.52,	5.02];
P_struct.r = -log(P_struct.df)./P_struct.dataT;


P_struct.dataK = [.5 .6 .7 .8 .9 1 1.1 1.2 1.3 1.4 1.5]';
P_struct.weights = [100.00	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05;
0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05;
0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05;
10.00	10.00	10.00	10.00	10.00	10.00	10.00	10.00	10.00	10.00;
50.00	50.00	50.00	50.00	50.00	50.00	50.00	50.00	50.00	50.00;
200.00	200.00	200.00	200.00	200.00	200.00	200.00	200.00	200.00	200.00;
50.00	50.00	50.00	50.00	50.00	50.00	50.00	50.00	50.00	50.00;
10.00	10.00	10.00	10.00	10.00	10.00	10.00	10.00	10.00	10.00;
0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05;
0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05;
0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05] / 100;

if(P_struct.type == 1) % call
    % call cases
    P_struct.dataOpt = [3910.65	3998.97	4089.17	4179.71	4265.62	4351.84	4436.23	4519.81	4600.36	4679.90;
        3172.19	3294.54	3414.70	3533.09	3643.19	3753.06	3859.58	3964.42	4064.46	4162.89;
        2452.71	2617.21	2770.59	2919.10	3054.61	3188.60	3317.20	3443.02	3561.99	3678.66;
        1764.69	1977.77	2165.52	2344.73	2505.44	2662.52	2811.93	2957.42	3093.93	3227.51;
        1128.21	1391.15	1610.46	1817.98	2001.48	2178.75	2346.32	2509.13	2660.99	2809.50;
        583.36	879.37	1119.58	1348.04	1548.85	1741.21	1922.82	2099.51	2263.74	2424.60;
        202.30	471.92	709.45	944.58	1153.52	1353.58	1543.64	1729.70	1902.63	2072.72;
        44.71	205.06	399.25	617.02	820.51	1018.75	1210.40	1400.47	1577.88	1753.66;
        8.87	76.05	200.34	374.42	555.29	739.89	924.62	1112.28	1289.40	1467.00;
        1.52	27.58	93.60	213.30	358.47	518.82	687.96	866.11	1037.56	1212.55;
        0.22	10.07	43.40	116.86	222.71	352.60	499.44	661.73	822.42	990.38];


    P_struct.dataOptType = [1 1 1 1 1 1 1 1 1 1 1];
   

elseif(P_struct.type == -1) % put
    % put cases
    P_struct.dataOpt = [2.85 16.71 34.34 53.34 69.51 86.99 104.38 121.92 137.75	153.85;
        14.39 47.39 80.45 113.00 139.41	166.81 192.92 218.52 240.89	263.19;
        44.91 105.17 156.93	205.29 243.17 280.94 315.74	349.10 377.45 405.31;
        106.89 200.84 272.45 337.21 386.34 433.45 475.65 515.48 548.43 580.51;
        220.41 349.32 437.99 516.75 574.72 628.26 675.23 719.18 754.53 788.85;
        425.56 572.65 667.70 753.09 814.42 869.31 916.92 961.54 996.32 1030.30;
        794.50 900.32 978.16 1055.91 1111.43 1160.28 1202.93 1243.71 1274.24 1304.77;
        1386.91	1368.56	1388.55	1434.63	1470.76	1504.03	1534.88	1566.46	1588.53	1612.06;
        2101.07	1974.66	1910.23	1898.32	1897.87	1903.77	1914.29	1930.26	1939.09	1951.74;
        2843.72	2661.30	2524.08	2443.48	2393.39	2361.29	2342.82	2336.07	2326.28	2323.64;
        3592.42	3378.90	3194.48	3053.33	2949.97	2873.66	2819.49	2783.67	2750.19	2727.82];   % Put Prices
    
    P_struct.dataOptType = [0 0 0 0 0 0 0 0 0 0 0];

elseif(P_struct.type == 0) % call / put cases
    P_struct.dataOpt = [2.85	16.71	34.34	53.34	69.51	86.99	104.38	121.92	137.75	153.85;
        14.39	47.39	80.45	113.00	139.41	166.81	192.92	218.52	240.89	263.19;
        44.91	105.17	156.93	205.29	243.17	280.94	315.74	349.10	377.45	405.31;
        106.89	200.84	272.45	337.21	386.34	433.45	475.65	515.48	548.43	580.51;
        220.41	349.32	437.99	516.75	574.72	628.26	675.23	719.18	754.53	788.85;
        583.36	879.36	1119.58	1348.04	1548.85	1741.21	1922.82	2099.51	2263.74	2424.60;
        202.30	471.92	709.45	944.58	1153.52	1353.58	1543.64	1729.70	1902.63	2072.72;
        44.71	205.06	399.25	617.02	820.51	1018.75	1210.40	1400.47	1577.88	1753.66;
        8.87	76.05	200.34	374.42	555.29	739.89	924.62	1112.28	1289.40	1467.00;
        1.52	27.58	93.60	213.29	358.47	518.82	687.96	866.11	1037.56	1212.55;
        0.22	10.07	43.40	116.86	222.71	352.60	499.44	661.73	822.43	990.38];

    P_struct.dataOptType = [0 0 0 0 0 1 1 1 1 1 1];
else
    fprintf('Nothing to do!');
end    


P_struct.t_star = 0;                                            % Forward Start 

% The objective function
ofunc = 'rmse';

if(strcmp(ofunc,'aae'))
        P_struct.ofunc = aae(P_struct.dataOpt,P_struct.weights);    % aae
    elseif(strcmp(ofunc,'ape'))
        P_struct.ofunc = ape(P_struct.dataOpt,P_struct.weights);    % ape
    elseif(strcmp(ofunc,'arpe'))
        P_struct.ofunc = arpe(P_struct.dataOpt,P_struct.weights);   % arpe
    elseif(strcmp(ofunc,'rmse'))
        P_struct.ofunc = rmse(P_struct.dataOpt,P_struct.weights);   % rmse
end

% modelbuilder
mbd = modelbuilderdirector();

if(strcmp(modelname,'vg'))
    % params = [0.5373	2.6224	7.6753];
    params = [0.4373	1.6224	6.6753];
    mpar.c = params(1); mpar.g = params(2); mpar.m = params(3);
    mpar.usec = true; mpar.useg = true; mpar.usem = true;
    mpar.cgm = true;
    mbd.setmodelbuilder(vgmodelbuilder());
    
    usevec = [1 1 1];

elseif(strcmp(modelname,'vgcir'))
    params = [0.4373 1.6224	6.6753 1.2329 0.6498 1.4334];
    mpar.c = params(1); mpar.g = params(2); mpar.m = params(2);
    mpar.kappa = params(4); mpar.eta = params(5); mpar.lambda = params(6);
    mbd.setmodelbuilder(vgcirmodelbuilder());
    usevec = [1 1 1 1 1 1];
    
elseif(strcmp(modelname,'vggou'))
    params = [6.4704	11.1021	33.4128	0.9397	0.6291	1.4659];
    mpar.c = params(1); mpar.g = params(2); mpar.m = params(3);
    mpar.a = params(4); mpar.b = params(5); mpar.lambda = params(6);
    mbd.setmodelbuilder(vggoumodelbuilder());
    usevec = [1 1 1 1 1 1];
    
elseif(strcmp(modelname,'nig'))
    params= [5.9532 -3.6732	1.4121];
    mpar.alpha = params(1); mpar.beta = params(2); mpar.delta = params(3);
    mpar.usealpha = true; mpar.usebeta = true; mpar.usedelta = true;
    mbd.setmodelbuilder(nigmodelbuilder());
    usevec = [1 1 1];
    
elseif(strcmp(modelname,'nigcir'))
    params = [4	3 1	1.3276	0.6567	1.5042];
    mpar.alpha = params(1); mpar.beta = params(2); mpar.delta = params(3);
    mpar.kappa = params(4); mpar.eta = params(5); mpar.lambda = params(6);
    mbd.setmodelbuilder(nigcirmodelbuilder());
    usevec = [1 1 1 1 1 1];

elseif(strcmp(modelname,'nigou'))
    params = [5.9532 3.6732	1.4121	0.8553	0.6810	1.5300];
    mpar.alpha = params(1); mpar.beta = params(2); mpar.delta = params(3);
    mpar.lambda = params(4); mpar.a = params(5); mpar.b = params(6);
    mbd.setmodelbuilder(niggoumodelbuilder());
    usevec = [1 1 1 1 1 1];
        
elseif(strcmp(modelname,'mj'))
    params = [0.2500 0.0500	0.1500 0.1000];
    mpar.sigma = params(1); 
    mpar.alpha_j = params(2); mpar.sigma_j = params(3); mpar.lambda = params(4);
    mbd.setmodelbuilder(mjmodelbuilder());
    usevec = [1 1 1 1];
    
elseif(strcmp(modelname,'bs'))
    params = 0.25;
    mpar.sigma = params(1);
    mbd.setmodelbuilder(bsmodelbuilder());
    usevec = 1;

elseif(strcmp(modelname,'heston'))
    params = [0.0200	0.0200	0.0500	0.2000	-0.6000];
    mpar.v0 = params(1); mpar.theta = params(2); 
    mpar.kappa = params(3); mpar.omega = params(4); mpar.rho = params(5);
    mbd.setmodelbuilder(hestonmodelbuilder());
    usevec = [1 1 1 1 1];

elseif(strcmp(modelname,'bates'))
    params = [0.0200 0.0200	0.0500	0.2000	-0.6000	0.0500	0.1500	0.1000];
    mpar.v0 = params(1); mpar.theta = params(2); 
    mpar.kappa = params(3); mpar.omega = params(4); mpar.rho = params(5);
    mpar.lambda = params(6); mpar.muj = params(7); mpar.sigmaj = params(8);
    mbd.setmodelbuilder(batesmodelbuilder());
    usevec = [1 1 1 1 1 1 1 1];
end

model = mbd.buildmodel(mpar, 'eq');

% characteristic function
%pf=params(usevec==false);
%P_struct.func = CharFuncCreator(model,pf,usevec);

if(strcmp(fftmethod,'cm'))
    fftpricer = fftcm(N, eta, alpha,model);
elseif(strcmp(fftmethod,'cos'))
    fftpricer = fftcos(N,L,model);
elseif(strcmp(fftmethod,'bs'))
    fftpricer = fftbs(N,eta,alpha, sigma,model);
elseif(strcmp(fftmethod,'lewis'))
    fftpricer = fftlewis(N,eta,model);
end

%%%% Optimization Stuff %%%%

%boundary constraints
if (strcmp(modelname,'vg'))
    lb = [0	0 0]; ub = [10 10 10];
elseif(strcmp(modelname,'vgcir'))
    lb = [1	1 10 0 0 0]; ub = [2 5 20 1 1 1];
elseif(strcmp(modelname,'vggou'))
    lb = [0	0 0 0 0 0]; ub = [30 30 30 2 2 2];
elseif(strcmp(modelname,'nig'))
    lb = [0 -20 0]; ub = [40 40 40];
elseif(strcmp(modelname,'nigcir'))
    lb = [5	-15	0 0 0 0]; ub = [15 0 1 1 1 1];
elseif(strcmp(modelname,'nigou'))
    lb = [15 -20 0 0 0 0]; ub = [20 -10 2 2 2 2];
elseif(strcmp(modelname,'mj'))
    lb = [0 -1 0 0]; ub = [1 1 1 1];
elseif(strcmp(modelname,'bs'))
    lb = 0; ub = 1;
elseif(strcmp(modelname,'heston'))
    lb = [0	0 0	0 -1]; ub = [1 1 2 1 1];
elseif(strcmp(modelname,'bates'))
    lb = [0	0 0	0 -1 0 0 0]; ub = [1 1 2	1 1	1 1 1];
end

S_struct.lb = lb(usevec == true);
S_struct.ub = ub(usevec == true);
S_struct.start = params(usevec==true);
S_struct.I_plotting = 1;

if strcmp(optmethod,'de')
    S_struct.I_D = length(find(usevec==true));
    S_struct.I_NP = 20;
    S_struct.F_weight = .9;
    S_struct.F_CR = .9;
    S_struct.FVr_minbound = S_struct.lb;
    S_struct.FVr_maxbound = S_struct.ub;
    S_struct.I_bnd_constr = 1;
    S_struct.I_itermax = 300;
    S_struct.F_VTR = .001;
    S_struct.I_strategy = 1;
    S_struct.I_refresh = 20;
    
    S_struct = rmfield(S_struct,{'lb';'ub';'start'}); %remove fields lb,ub,start from S_struct
end

