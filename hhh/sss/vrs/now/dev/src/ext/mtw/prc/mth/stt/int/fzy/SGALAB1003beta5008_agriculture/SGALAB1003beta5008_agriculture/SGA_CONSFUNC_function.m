function [ constraint_value ,error_status ] = SGA_CONSFUNC_function( X, Y, Z )

% /*M-FILE FUNCTION SGA_CONSFUNC_function MMM SGALAB */
% /*==================================================================================================
%  Simple Genetic Algorithm Laboratory Toolbox for Matlab 7.x
%
%  Copyright 2007 The SxLAB Family - Yi Chen - chenyi2005@gmail.com
% ====================================================================================================
%File description:
%
%      SGA_CONSFUNC_function contains the constraint (fitness) functions 
%      this function is an example of a constraint fitness function
%      
%
%Input:
%            x1,x2,x3,... -- are input varialbes
% 
%Output:
%            constraint_value   -- is the constraint (fitness) functions' result
%                                  if 'constraint_value' = NaN , that is to say, the 
%                                  the xi is not fit the constraint functions
%            error_status =    0 -- ok
%                             !0 -- fail
% 
%Appendix comments:
%                     
% 
%Usage:
%[ subjected_decimal_value ] = SGA_CONSFUNC_function(x1,x2,x3)
%
% 
%  See Also:         SGA_ENCODING ,
%                    SGA_DECODING ,
%                    SGA_SELECTION ,
%                    SGA_CROSSOVER,
%                    SGA_MUTATION,
%                    SGA_FITNESS_FUNCTION, 
%                    SGA_FITNESS_EVALUATING, 
%                    SGA_BENCHMARK_FUNCS,
%                    		
%
%===================================================================================================
% 
%===================================================================================================
%Revision -
%Date          Name     Description of Change  email                 where
%27-Jun-2003   Chen Yi  Initial version        chen_yi2000@sina.com  Chongqing
%14-May-2007   Chen Yi  update 1003            chenyi2005@gmail.com  Glasgow
%HISTORY$
%==================================================================================================*/

% SGA_CONSFUNC_function Begin
                      
% initialise the status        
error_status = 0 ;
eq_flag      = 0;
ineq_flag    = 0;

% %check Equation constraint, user define
% if ( ( eq_consfunc1( x1,x2,x3 ) == 0 )&&...
%      ( eq_consfunc2( x1,x2,x3 ) == 0 )&&...
%      ( eq_consfunc3( x1,x2,x3 ) == 0 )...
%    )
% 
%    eq_flag = 1 ;
%    
% end


%check in-Equation constraint , user define
%if  ( ineq_consfunc1( x1,x2,x3 ) <= 0 ) 
if  ( ineq_consfunc1( X, Y, Z ) >= 0 ) 
    
   ineq_flag = 1 ;
   
end

% check x fit constraint or not, user defines the conditions
%if( eq_flag == 1 && ineq_flag == 1 ) % check both eq and in-eq conditions
 if( ineq_flag == 1 )                 % check only in-eq conditions
    
   constraint_value = [  X, Y, Z  ];
   
   error_status = 0 ;
   
else
    
    constraint_value = [ 0,0,0 ];
 
end

% SGA_CONSFUNC_function End



%%Here to define constrait functions : Subject to target functions
% to take constrait function this this way :

% Part I
%=================================================================
%%%  Equation :
%                EQ_CONSFUNC_NUM = 1 ;  f1(x1,x2,x3,...)= 0
%                EQ_CONSFUNC_NUM = 2 ;  f2(x1,x2,x3,...)= 0
%                EQ_CONSFUNC_NUM = 3 ;  f3(x1,x2,x3,...)= 0
%                ...
%==================================================================
% equation 1
function  [ eq_consfunc_value1 ] = eq_consfunc1(x1,x2,x3)
           
           eq_consfunc_value1 = 10.5*x1^2 + 100.334*x2^7+sin(exp( x3 ) );
% equation 2          
function  [ eq_consfunc_value2 ] = eq_consfunc2(x1,x2,x3)
            
           eq_consfunc_value1 = x1/x2+exp( x3 ) ;
% equation 3         
function  [ eq_consfunc_value3 ] = eq_consfunc3(x1,x2,x3)
            
           eq_consfunc_value3 = x1 + x2*sin(exp( x3 ) );

           
% Part II
%=================================================================
%%%  InEquation: :
%                INEQ_CONSFUNC_NUM = 1 ;  g1(x1,x2,x3,...)<= 0
%                INEQ_CONSFUNC_NUM = 2 ;  g2(x1,x2,x3,...)<= 0
%                INEQ_CONSFUNC_NUM = 3 ;  g3(x1,x2,x3,...)<= 0
%                ...
%==================================================================
function [ineq_consfunc_value1]=ineq_consfunc1( X, Y, Z )

          ineq_consfunc_value1= X + Y + Z ;
      


