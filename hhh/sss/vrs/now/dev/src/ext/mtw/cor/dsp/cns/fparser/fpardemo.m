%% command line decoding
        com='f=pi;dddd=''d'';a.bb=ccc.(dddd).e=inf';
	par=fparser(com,'-c','-d');
%%
%% M-file decoding
% show contents of m-file <fpartest.m>

        type fpartest
%%
% decode m-file <fpartest.m>

	par=fparser('fpartest.m','-d');
        par
%%