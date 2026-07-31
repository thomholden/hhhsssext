%Dumb example: square some stuff
%For obvious reasons you probably want to load the code from a file
%instead; you can use the readfile convenience function for this
cstring = ...
['for(mwSize i = 0; i < x_numel; i++) { ' char(10) ...
 '    y[i] = x[i]*x[i]; ' char(10) ...
 '}'];

%This function uses x as an input and y as the output
%x_numel is automatically generated, as well as x_m, x_n, x_ndims,
%x_dim and x_ptr which is the raw mxArray

%Assuming x is two dimensional, then:
inputarg = InputNum('x');
%Note that we are setting the size of y with C variable names; 
%raw numbers are of course valid as well
outputarg = OutputNum('y','x_m, x_n');
cfile = mexme(cstring,inputarg,outputarg);

%%
%This actually compiles!
%Write to a file
writefile('mydouble.cpp',cfile);
%Compile
mex mydouble.cpp
%Call
a = mydouble(1:20)

%wam bam thank you mam

%%
%Working with complex vars
%Compute norm of complex vars
cstring = ...
['for(mwSize i = 0; i < x_numel; i++) { ' char(10) ...
 '    y[i] = sqrt(pow(x_r[i],2) + pow(x_i[i],2)); ' char(10) ...
 '}'];

%The real and imaginary parts of the data are automagically assigned to _r and _i

%Assuming x is two dimensional, then:
inputarg = InputNum('x',false,false); %last false is for not real = complex
outputarg = OutputNum('y','x_m,x_n');
cfile = mexme(cstring,inputarg,outputarg);

writefile('mycplxnorm.cpp',cfile);
mex mycplxnorm.cpp

inputs = randn(10,1)+1i*randn(10,1);
[mycplxnorm(inputs),abs(inputs)]

%Works

%%
%Showcases scalars, non-double types
%Take x (int16) and duplicate f (uint32) times
cstring = ...
['for(mwSize i = 0; i < f; i++) { ' char(10) ...
 '    y[i] = x;' char(10) ...
 '}'];

inputargs = [InputNum('f',true,true,'uint32'),...
             InputNum('x',true,true,'int16')]; %scalar, real, int16
outputarg = OutputNum('y','f,1',true,'int16');

cfile = mexme(cstring,inputargs,outputarg);

%This actually compiles!
%Write to a file
writefile('myduplicator.cpp',cfile);

%Compile
mex myduplicator.cpp

%Call
a = myduplicator(uint32(30),int16(-10))
isa(a,'int16')

%%
%Showcases input checking
%Too many arguments
myduplicator(uint32(30),int16(-10),'toaster')
%%
%No output arguments
myduplicator(uint32(30),int16(-10))
%%
%Double instead of int uint32 for first argument
a = myduplicator(30,int16(-10))
%%
%uint8 instead of uint32 for first argument works (upcasting)
a = myduplicator(uint8(30),int16(-10))

%%
%casting from signed to unsigned and vice versa is prohibited, though
a = myduplicator(int32(30),int16(-10))

%%
%Scalar-ness is also checked
a = myduplicator(uint32([30,30]),int16(-10))

%%
%It is also possible to link to a c file instead of including the string
%This gives more meaningful error messages on compilation

%Example: Compute the Mandelbrot set
%I found this code at http://warp.povusers.org/Mandelbrot/
%And made very minor changes
%Originally written by Juha Nieminen

inputargs = [InputNum('ImageWidth',true,true,'uint32'),...
             InputNum('ImageHeight',true,true,'uint32')];
outputarg = OutputNum('mset','ImageHeight,ImageWidth',true,'uint16');

cfile = mexme('mandelbrotex.cpp',inputargs,outputarg);

%Write to a file
writefile('mandelbrotwrap.cpp',cfile);

%Compile
mex mandelbrotwrap.cpp

%Call
tic;A = mandelbrotwrap(uint16(640),uint16(480));toc;
imagesc(A);

%You've just been served, fools!

%%
%Now for something actually useful
%Recursive filter implementation
%Equivalent to y = filter(alpha,[1,-1+alpha],x)
cstring = ...
['y[0] = x[0]*alpha;' char(10) ... 
 'for(mwSize i = 1; i < x_length; i++) { ' char(10) ...
 '    y[i] = x[i]*alpha + y[i-1]*(1-alpha);' char(10) ...
 '}'];

%alpha must be in 0..1, add a condition to this effect
inputargs = [InputNum('x'),...
             InputNum('alpha',true,true,'double','alpha > 0 && alpha < 1')];
outputarg = OutputNum('y','x_length,1');

cfile = mexme(cstring,inputargs,outputarg);

%This actually compiles!
%Write to a file
writefile('myfilter.cpp',cfile);

%Compile
mex myfilter.cpp

A = randn(1e7,1);
alpha = .1;
%Matlab
tic;a1 = myrecursivefilter(A,alpha);toc;
%mex
tic;a2 = myfilter(A,alpha);toc;
%Mathworks' mex
tic;a3 = filter(alpha,[1,-1+alpha],A);toc;

std(a3-a2)
std(a3-a1)

%Not bad given the lack of optimizations!
%%
