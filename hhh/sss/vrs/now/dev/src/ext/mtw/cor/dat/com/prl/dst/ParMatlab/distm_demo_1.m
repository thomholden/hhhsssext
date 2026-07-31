close all; clear all;

problemsize=100; %if your tcpip comms are slow change this to 10
ps=problemsize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  1            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp('                                                                ')
disp('       PARALLEL MATLAB Toolbox. Version Beta 1.77  2001-09      ')
disp('                                                                ')
disp('                      by Lucio Andrde                           ')
disp('                                                                ')
disp('                                                                ')
disp('                                                                ')
disp('This toolbox distributes processes over matlab workers available')
disp('over the intranet/internet. These workers must be runing a      ')
disp('deamon to be accessed.                                          ')
disp('                                                                ')
disp('This tool is very useful for corsely granular parallelization   ')
disp('problems and in the presence of a distributed enviroment. It is ')
disp('easy to implement a MPMD (Multiple Program-Multiple Data) as    ')
disp('well as a SPMD (Single Program-Multiple Data) parallel model.   ')
disp('                                                                ')
disp('This demo (first of two) show the basics of this toolbox so you ')
disp('can understand it and start implementing both types of parallel ')
disp('models.                                                         ')
disp('                                                                ')
disp('                                                                ')
disp('                                                           PAUSE')
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  2            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 1. BASIC CONCEPTS                                              ')
disp('                                                                ')
disp('The master session of matlab (runs in this computer) is the one ')
disp('that controls all communications and determines the different   ')
disp('threads, as well as decides who will process them. All comunica-')
disp('tions are through tcp-ip connections between workers and the    ')
disp('master session (or majordomo). No communications are performed  ')
disp('between workers. (at least in this version)                     ')
disp('                                                                ')
disp('Two non-blocking tcpip ports are used for communications, one   ')
disp('is used to establish communications when we want to send a task ')
disp('and the other is to receive completed tasks.                    ')
disp('                                                                ')
disp('To initialize these communication ports use:                    ')
disp('                                                                ')
disp('>> [ss,rs]=initmajordomo                                        ')
disp('    ^  ^                                                        ')
disp('    |  |____  rs:  is the task receiving port handler           ')
disp('    |_______  ss:  is the task sending port handler             ')  
disp('                                                                ')
disp('                                                           PAUSE')
pause

[ss,rs]=initmajordomo;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  3            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 2. SENDING A SIMPLE TASK TO A WORKER                           ')
disp('                                                                ')
disp('Now we are ready to start distributing tasks to workers, our    ')
disp('very first example will be to compute a simple inverse of a 2x2 ')
disp('matrix:                                                         ')
a = [1 2 ; 3 4 ]
disp('Normally to compute this inverse we would write:     b = inv(a) ')
disp('to send this computation to a remote machine we will use:       ')
disp('                                                                ')
disp('>> [con,hostname]=sendtask(ss,''inv'',1,1,a)                    ')
disp('                            ^   ^   ^ ^ ^                       ')
disp('      Port handler _________|   |   | | |____ Input variable    ')
disp('      Function _________________|   | |                         ')
disp('      # of input args ______________| |______ # of output args  ')
disp('                                                                ')
disp('b is not returned inmediately, its value will be returned       ')
disp('through the -rs- port when the remote machine finishes the work,')
disp('in the meantime the control of the majordomo is returned to us  ')
disp('to send other tasks or to do other computations.                ')
disp('                                                                ')  
disp('OK lets try it !                                                ')
disp('                                                           PAUSE')
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  4            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 2. SENDING A SIMPLE TASK TO A WORKER  (cont)                   ')
disp('                                                                ')

[con,hostname]=sendtask(ss,'inv',1,1,a)                                    

disp('the negative value of -con- is because we have not launched any ')
disp('worker, the function could not detect any worker available and  ')
disp('the task was not sent.                                          ')
disp('                                                                ')
disp('Let''s launch a worker, login into other computer (in any       ')
disp('internet site and with any plataform), run matlab and run the   ')
disp('matlab function:                                                ')
disp('                                                                ')
disp(['     worker(''' getmyip ''') <-- the actual ip of this machine'])
disp('                                                                ')
disp('(assuming that you installed this toolbox in the remote computer)')
disp('continue when you are ready,                                    ')
disp('                                                                ')
disp(' I will send again the task...                                  ')
disp('                                                                ')
disp('OK lets try it !                                                ')
disp('                                                           PAUSE')
pause


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  5            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 2. SENDING A SIMPLE TASK TO A WORKER  (cont)                   ')
disp('                                                                ')
[con,hostname]=sendtask(ss,'inv',1,1,a)                                    
disp('-con- should now be positive, it has a handler to the socket    ')
disp(' that was used to communicate to the remote computer and        ')
disp('-hostname- has the identification of theremote computer. You can')
disp(' use this info to administrate the parallel instances in the    ')
disp(' majordomo                                                      ')
disp('                                                                ')
disp('If -con- was negative again, there is a problem, check that the ')
disp('toolbox is installed and compiled properly in both machines.    ')
disp('Contact me describing your problem: landrade@ece.neu.edu        ')
disp('                                                                ')
disp('                                                           PAUSE')
pause



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  6            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 3. RECEIVING A FINISHED TASK                                   ')
disp('                                                                ')
disp('When a remote computer finishes a task, it will contact the -rs-')
disp('port and hang until majordomo attends it. When majordomo is     ')
disp('ready (and available) to go and check it can retraive the value ')
disp('of the variable b, it is up to majordomo to keep track which    ')
disp('remote machine is doing what and organize the returning values, ')
disp('                                                                ')
disp('to receive the data we simple use:                              ')
disp('                                                                ')
disp('>> [con,hostname,b]=receivetask(rs,1)                           ')
disp('                                                                ')                    
disp('again, if -con- is negative that means that there is not any    ')
disp('retuning parameters ready from any of the remote tasks.         ')
disp('OK lets try it !                                                ')
disp('                                                           PAUSE')
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  7            %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 3. RECEIVING A FINISHED TASK  (cont)                           ')

[con,hostname,b]=receivetask(rs,1)                              

disp('If you are implementing a MPMD program you are responsible of   ')
disp('keeping track of the tasks, the reception of the output         ')
disp('arguments for different tasks most probably will not occur in   ')
disp('the same order that the tasks were sent.                        ')
disp('                                                                ')
disp('The remote computer will no become available in the -ss- port   ')
disp('for a new task until the majordomo reads back the returning data')
disp('and aknowlges it.                                               ')
disp('                                                                ')
disp('If an error occurs in the remote computer you will have the     ')
disp('chance to debug the remote workspace without suspending the work')
disp('of other workers neither the majordomo, I have implemented a    ')
disp('trap error block that will help you to continue long computa-   ')
disp('tions with the other workers (help receivetask for more info)   ')
disp('                                                                ')
disp('                                                           PAUSE')
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  8           %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 4. RECYCLING DATA                                              ')
disp('                                                                ')
disp('There is the possibility of re-use data which we already sent   ')
disp('to a worker, by sending an empty variable the worker will use   ')
disp('the variable which already is in its own workspace, for example ')
disp('lets compute the transpose of matrix a                          ')
disp('                                                                ')
disp('>> [con,hostname]=sendtask(ss,''transpose'',1,1,[]);            ')
disp('>> [con,hostname,c]=receivetask(rs,1);                          ')
disp('                                                                ')
[con,hostname]=sendtask(ss,'transpose',1,1,[]);
pause(2);
[con,hostname,c]=receivetask(rs,1); 
c                                   
disp('                                                                ')
disp('                                                                ')
disp('                                                           PAUSE')
pause


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%            SLIDE  9           %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
disp('                                                                ')
disp(' 5. IMPLEMENTING A SPMD PARALLEL MODEL                          ')
disp('                                                                ')
disp('PARALLELIZE is the most important function of this toolbox, it  ')
disp('is used to automatic create parallel instances and mannage them ')
disp('with any quantity of workers available when the data is         ')
disp('regularly ordered. The same function is applied to              ')
disp('sub-hyperblocks of data wich are selected with control indexes. ')
disp('                                                                ')
disp('The function keeps track of the tasks assigned to every worker, ')
disp('finds out if it can re-use data, and order the output variables ')
disp('                                                                ')
disp('The remaining of this demos show how to use this function to    ')
disp('solve typical SPMD parallel problems                            ')
disp('                                                                ')
disp('                                                           PAUSE')
pause



clc
disp('                                                                ')

disp('FIRST EXAMPLE...')
%if (exist('imread')==2) imshow(imread('para1.tif')); end

disp(' ')
disp('Ax=b is solved for 15 different b''s')
pss=num2str(5*ps);
a = rand(5*ps,5*ps); disp(['A = rand(' pss ',' pss ');  <-- A is a constant matrix'])
b = rand(5*ps,15);   disp(['B = rand(' pss ',15);   <-- for every b column in B'])
disp(' ')
disp('We want to compute: ')
disp(' ')
disp(['      mldivide( A(1:' pss ',1:' pss '), B(1:' pss ',1:1) ) '])
disp(['      mldivide( A(1:' pss ',1:' pss '), B(1:' pss ',2:2) ) '])
disp('                  ...')
disp(' ')
disp(['      mldivide( A(1:' pss ',1:' pss '), B(1:' pss ',14:14) ) '])
disp(['      mldivide( A(1:' pss ',1:' pss '), B(1:' pss ',15:15) ) '])
disp('                                                                ')
disp('                                                           PAUSE')
pause


clc
disp(' ')
disp('To control the indexes for A we use:')
disp(' ')
disp('    [Dim #elem startat inc blocksize]')

aindexes=[1 1 1 0 5*ps; 2 15 1 0 5*ps]

disp(' ')
disp('  observe that for A we need 15 parallel elements, but it happens')
disp('  that they are all the same, therefore increment in both dimesions')
disp('  is always 0, we also see that every element extracted from A starts')
disp(['  at (1,1) and has a size of (' pss ',' pss ') resulting in a constant '])
disp('  matrix fed to every parallel instance')
disp(' ')
disp('  the 15 elements could have also been generated using the first dimension')
disp('  control indexes (first row) instead of the second, but since the output of ')
disp(['  every mldivide will be a column ' pss 'x1 we use the second dimension to']) 
disp('  concatenate the result along the columns and not rows. i.e. the order of ')
disp('  every output variable is controlled by the dimensions of the first')
disp('  set of indexes, in this case the indexes of A (aindexes)')
disp('                                                                ')
disp('                                                           PAUSE')
pause


clc
disp(' ')
disp('Now, to control the indexes for B we use:')
disp(' ')
disp('    [Dim #elem startat inc blocksize]')

bindexes=[2 15 1 1 1; 1 1 1 0 5*ps]
disp(' ')
disp('  to transverse B, we travel first among the second dimension generating')
disp('  the 15 parallel elements, the outer loop is processed only once.')
disp('  Observe that in the second dimension we DO have increments of 1 and')
disp('  that we start at the first column and proces 1 column at the time,')
disp('  while in the first dimension we always extrat the entire row from')
disp(['  1 to ' pss ' (increment=0). Since the indexes of the data were constant'])
disp('  in one dimension we could switch the order of the rows in bindexes ')
disp('  without changing the result, (remember that output is controlled')
disp('  by the first set of control indexes)')
disp('                                                                ')
disp('                                                           PAUSE')
pause

clc
disp(' ')
disp('To launch the parallel instances we use:')
disp(' ')
disp('x=parallelize(ss,rs,inf,1,''mldivide'',1,a,aindexes,b,bindexes);')
disp('              \   /  |  |      |     | |     |    |     |')
disp('               \ /   |  |      |     | |     |____|_____|___ Control indexes for ')
disp('                |    |  |      |     | |          |          every input variable')
disp('                |    |  |      |     | |          |')
disp('  port   _______|    |  |      |     | |__________|__________Input variables') 
disp('  handlers           |  |      |     |')
disp('                     |  |      |     |___ Expected output variables')
disp('  how to ____________|  |      |')
disp('  handle                |      |_________ Function to parallelize')
disp('  errors          Verbose ctrl')
disp(' ')
disp('                                                                ')
disp('                                                           PAUSE')
pause


clc
disp(' ')
x=parallelize(ss,rs,inf,1,'mldivide',1,a,aindexes,b,bindexes);
disp(' ')

disp(['Results are in ''x'' which have size of   ' num2str(size(x))])
disp('                                                                ')
disp('                                                           PAUSE')
pause


clc
disp(' ')
disp('SECOND EXAMPLE...')
disp(' ')
disp('  Now a real time consuming computation to see the advantages...')
disp('  Linear least squares with nonnegativity constraints for 50 ')
disp('  different ''d'', will search for vectors that minimizes NORM(C*y - d)')
disp('  subject to y >= 0. C and d must be real. Here we will use four')
disp('  output variables, all ordered as the first index control commands')
disp(' ')
c = rand(2*ps,2*ps);disp(['C = rand(' pss ',' pss ');'])
d = rand(2*ps,50);disp(['D = rand(' pss ',50);'])
disp(' ')
disp('  Indexes are controlled as follows (very similar to the first')
disp('  example), output for every different variable (in this case 4)')
disp('  will be concatenated in the second dimension')
disp('    [Dim #elem startat inc blocksize]')

cindexes=[1 1 1 0 2*ps; 2 50 1 0 2*ps]
dindexes=[2 50 1 1 1; 1 1 1 0 2*ps]
disp('                                                                ')
disp('                                                           PAUSE')
pause

clc
disp(' ')
disp('To launch the parallel instances we use:')
disp(' ')
disp(' ')
disp('[y,RESNORM,RESIDUAL,EXITFLAG] =parallelize(ss,rs,inf,1,''LSQNONNEG'',4,c,cindexes,d,dindexes);')
disp('                                                           |       | \                   /')
disp('                                Function to parallelize ___|       |  \                 /')
disp('                                                                   |   \               /')
disp('                                Expecting 4 output variables ______|    \             /')
disp('                                                                         \           /')
disp('                 2 input variables and their control indexes _____________\_________/')
disp(' ')
disp(' ')
disp('  Observe that some workers may be faster than others,')
disp('  but the correct ordering of the results is preserved...')
disp('  Also note that output parameters has the same ideology as regular')
disp('  matlab functions, we could have had omitted the last three if we')
disp('  do not need them') 
disp(' ')
disp('  You better launch some other workers, but do not worry, you can')
disp('  launch them on the fly as you feel you will need them !!   :>)')
disp('                                                                ')
disp('                                                           PAUSE')
pause


clc
disp(' ')
[y,RESNORM,RESIDUAL,EXITFLAG]=parallelize(ss,rs,inf,1,'lsqnonneg',4,c,cindexes,d,dindexes);
disp(' ')

disp(['Results are in y,RESNORM,RESIDUAL,EXITFLAG...'])
disp('                                                                ')
disp('                                                           PAUSE')
pause



clc
disp(' ')
disp('A FINAL EASY EXAMPLE...')
disp(' ')
disp('  Lets take the average over the 50 ''y'' solutions of the last problem,')
disp('  this example demostrates that input dimensions do not need to be the same')
disp('  as output dimensions... observe now that the first dimension to be')
disp('  processed is the one that actually generates the parallel elements,')
disp('  therefore the output (1x1) elements will be concatenated rowise')

disp(' ')
disp('Indexes are controlled as follows')
disp('    [Dim #elem startat inc blocksize]')
yindexes=[1 2*ps 1 1 1; 2 1 1 0 50]

disp('parallelize(ss,rs,inf,1,''mean'',1,y,yindexes)')
disp('                                                                ')
disp('                                                           PAUSE')
pause


clc
disp(' ')
parallelize(ss,rs,inf,1,'mean',1,y,yindexes)

disp(' ')
disp(' ')
disp('Now I will release all workers and close connections')
disp('closemajordomo(ss,rs)')
disp(' ')
disp('                                                                ')
disp('                                                           PAUSE')
pause

clc
closemajordomo(ss,rs)

disp('End of demo, if you have the image toolbox please go to distm_demo_2')
disp('For further questions/comments please e-mail landrade@ece.neu.edu')

