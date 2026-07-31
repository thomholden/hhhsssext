%% Settings
M = 300;       % output number of rows
K = 500;       % matrix multiply inner dimension
N = 100;       % output number of columns
P = 200;       % number of pages

%% CPU code
tic
A = rand(M,K);   
B = rand(K,N,P);
C = zeros(M,N,P);
for I=1:P
    C(:,:,I) = A * B(:,:,I);
end
t = toc;
disp(['CPU time: ' num2str(t)])

%% equivalent GPU code
tic
A = rand(M,K,'gpuArray');   
B = rand(K,N,P,'gpuArray');
C2 = zeros(M,N,P,'gpuArray');
for I=1:P
    C2(:,:,I) = A * B(:,:,I);
end
wait(gpuDevice)
t = toc;
disp(['GPU, using gpuArrays: ' num2str(t)])

%% improved GPU code
tic
A = rand(M,K,'gpuArray');   
B = rand(K,N,P,'gpuArray');
C3 = pagefun(@mtimes,A,B);
wait(gpuDevice)
t = toc;
disp(['GPU, using pagefun: ' num2str(t)])


% Copyright 2014 The MathWorks, Inc.