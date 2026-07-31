function P_n_L = Buy_only_trade_execution_algo(x,D,Buy_Signal,Sell_Signal)

%          BUY ONLY - this algorithm is used as a comparison method
%          against buy and hold strategies to assess strategy
%          performance.
%
%          P_n_L       = a generated structure that holds all trade data
%                        attributed to each executed trade
%          x           = vector of closing prices of the security being 
%                        traded
%          D           = vector of dates corresponding to the prices of 
%                        vector x
%          Buy_Signal  = Trading signal, set of instructions to enter a
%                        long position in the underlying asset
%          Sell_Signal = Trading signal, set of instructions to exit a long
%                        position in the underlying asset

                %% Create Profit and Loss structure

%          This structure is used to hold all executed trading signals and
%          related trade prices and times

                        P_n_L = struct ('enter_long_price', [],...
                                        'enter_long_time',[],...
                                        'exit_long_price',[],...
                                        'exit_long_time', [],...
                                        'enter_long_i',[],...
                                        'exit_long_i',[]);
                                    
%          P_n_L.enter_long_price = Price the asset is bought for when a
%                                   long position is initiated
%          P_n_L.enter_long_time  = Time the asset is bought when a
%                                   long position is initiated 
%          P_n_L.enter_long_price = Price the asset is sold for when a
%                                   long position is exited
%          P_n_L.enter_long_time  = Time the asset is sold when a
%                                   long position is exited 
      
                    %% GENERATING TRADING SIGNALS
                    
P_n_L.long_count = 0;   % Count used to track trades

for i = 1:(length(x)-3)
    
    if (Buy_Signal(i))  % Buy signal generated
           
        if (P_n_L.long_count == 1 )  
            
                        % Long position currently in play 
                        
            P_n_L.long_count = 1;    
            
        elseif (P_n_L.long_count == 0) 
            
                        % No position, long position initiated and logged. 
                        % Long count = 1
                                       
            P_n_L.enter_long_price = [P_n_L.enter_long_price x(i)];                                           
            P_n_L.enter_long_time = [P_n_L.enter_long_time D(i)];
            P_n_L.enter_long_i = [P_n_L.enter_long_i i];
            P_n_L.long_count = 1;    
            
        end       
        
    end
    
    if (Sell_Signal(i)) % Sell signal generated
        
        if (P_n_L.long_count == 1)
            
                        % Long position currently in play, position is sold
                        % and logged
                        % Long count = 0
                        
            P_n_L.exit_long_price = [P_n_L.exit_long_price x(i)];                        
            P_n_L.exit_long_time = [P_n_L.exit_long_time D(i)];
            P_n_L.exit_long_i = [P_n_L.exit_long_i i];
            P_n_L.long_count = 0;

        elseif (P_n_L.long_count == 0) 
            
                        % No position 
                        
            P_n_L.long_count = 0;
            
        end          
    end      
    
end
 
                        % Fixes the length of the vecotrs if a buy signal
                        % is executed and the vector ends before a sell
                        % signal can be executed.

if (length(P_n_L.exit_long_price) ~= length(P_n_L.enter_long_price))    
    d = length(P_n_L.exit_long_price);    
    P_n_L.enter_long_price = P_n_L.enter_long_price(1:d);    
    P_n_L.enter_long_time = P_n_L.enter_long_time(1:d); 
    P_n_L.enter_long_i = P_n_L.enter_long_i(1:d);
    P_n_L.exit_long_i = P_n_L.exit_long_i(1:d);
end    

    d = length(P_n_L.exit_long_price);
    P_n_L.enter_long_i = P_n_L.enter_long_i(1:d);
    P_n_L.exit_long_i = P_n_L.exit_long_i(1:d);
    
end
                    
