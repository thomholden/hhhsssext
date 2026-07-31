function Trade_Plots(C,D,n,P_n_L)

    plot(D,C)

        if n == 10
            datetick('x',10)
        else
            datetick('x',3)
        end

    hold on
    plot(P_n_L.enter_long_time,P_n_L.enter_long_price,...
    'g^','Linewidth',1.0)
    hold on
    plot(P_n_L.exit_long_time,P_n_L.exit_long_price,...
    'r^','Linewidth',1.0)
    grid on
    
end

  