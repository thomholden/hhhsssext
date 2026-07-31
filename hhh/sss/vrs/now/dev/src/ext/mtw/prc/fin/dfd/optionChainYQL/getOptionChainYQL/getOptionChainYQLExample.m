%visualize option chains of Coke, Pepsi and VIX
close all;
tickers = {'KO' 'PEP' '^VIX'};
optionChain = getOptionChainYQL(tickers);

%%

for h = 1:numel(optionChain)
    figure;
    for i = 1:numel(optionChain(h).expirations)
        
        %call option
        calls = optionChain(h).calls([optionChain(h).calls(:).expiration] == optionChain(h).expirations(i));    
        %strike price
        cK = [calls(:).strikePrice];
        %C last price
        cLp = [calls(:).lastPrice];
        %expiration
        cE = ([calls(:).expiration]-datenum(date))./365;
        
        %put option
        puts = optionChain(h).puts([optionChain(h).puts(:).expiration] == optionChain(h).expirations(i));    
        %strike price
        pK = [puts(:).strikePrice];
        %last price
        pLp = [puts(:).lastPrice];
        %expiration
        pE = ([puts(:).expiration]-datenum(date))./365;
        
        plot3(cE,cK,cLp,'ro','linewidth',1.5); hold on;
        plot3(cE,cK,cLp,'r-','linewidth',1.5);
        plot3(pE,pK,pLp,'bo','linewidth',1.5);
        plot3(pE,pK,pLp,'b-','linewidth',1.5);

    end

    xlabel('expiration (year)');ylabel('strike'); zlabel('last price');
    grid on; view(90,0)
    title(sprintf('%s, call (red), put (blue)',tickers{h}));
end