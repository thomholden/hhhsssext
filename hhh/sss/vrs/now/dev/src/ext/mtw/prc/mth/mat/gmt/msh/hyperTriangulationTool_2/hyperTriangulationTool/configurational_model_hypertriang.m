% generates an hypertriangulation with degrees of each vertex as similar 
% as possible to z0
function [zF,edg,N,g,M,en,en1] = configurational_model_hypertriang(z0,rns,g,bta)
tic;
N0 = length(z0);
if nargin == 1 || isempty(rns),runs = 10*N0^2;else runs = rns*N0^2; end
%%%% compute genus (if not provided in input)
if nargin < 3 || isempty(g)
    g = max(floor(1+(mean(z0)-6)/12*N0+0.5),0);
end
if nargin < 4 || isempty(bta)
    bta = inf;
end
%%%%% build random triangulation with genus g %%%%
[edg,N] = generate_triang(g);
%%%%% make it of N vertices %%%%%
if N<N0
    while N<N0
        [edg,N]=t2move(edg,N,floor(rand*N+1),floor(rand+3.5));
    end
elseif N>N0
    it = 0;
    while N>N0 || it < 100*N
        [edg,ou]   = t1move(edg,floor(rand*(3*N-6)+1));
        [edg,ou,N] = at2move(edg,N,floor(rand*N+1)); 
        it = it+(1-ou);
    end 
    while N<N0
        [edg,N]=t2move(edg,N,floor(rand*N+1),floor(rand+3.5));
    end
end
if N~=N0
    fprintf('N (%d) is not equal to N0 (%d) \n',N,N0)
    return
end
%% randomize %%
M=0;
while M<10*N
    [edg,ou] = t1move(edg,floor(rand*(3*N-6)+1));
    M=M+ou;
end
t=toc;
fprintf('Hyper triangulation generated\n')
fprintf('N=%d, g=%d, <z>=%0.2f, randomized with M=%d T1 executed moves\n',N,g,mean(full(sum(compute_adjacency_matrix(edg,N),2))),M)
fprintf('elapsed time %3.2f sec\n',t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% energy %%%%%%%%%%%%%%%%%%%%%%%
z = full(sum(compute_adjacency_matrix(edg,N),2));
E = sum((z0-z).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout > 6, en1 = zeros(runs,1); end
if nargout > 5, en  = zeros(runs,1); end
tic
M = 0;
E = sum((z-z0).^2);
for t=1:runs
    ij = floor(rand*(3*N-6)+1);
    e = edg(ij,:); %choose an edge at random
    a=e(3);
    b=e(1);
    c=e(4);
    d=e(2);
    dE = 2*(z(a)-z0(a)+z(c)-z0(c)-z(b)+z0(b)-z(d)+z0(d))+4;
    E1 = E+dE;
    if (bta==0) || (bta~=0 && 1/(1+exp(bta*dE))>=rand) || (dE==0)
        [edg1,ou] = t1move(edg,ij);
        if ou ~= 0
            edg = edg1;
            z = full(sum(compute_adjacency_matrix(edg,N),2));
            E = E+dE;
            M=M+1;
        end
    end
    if nargout > 6, en1(t)=E1; end
    if nargout > 5, en(t)=E;   end
end
t=toc;
fprintf('Configurational model hyper-triangulation generated\n')
fprintf('M=%d executed T1 moves (%0.2f per-cent of attempted)\n',M,M/runs*100)
fprintf('elapsed time %3.2f sec\n',t)
%%%%% final degree distribution %%%%%%%%%%%%%%%%%%
zF = full(sum(compute_adjacency_matrix(edg,N),2));
