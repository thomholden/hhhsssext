function calcSystemPerf ()

global hFig fName st hFname hStat bGoOnOptimizing 

if (strcmp(fName,'') == 1)
    errordlg ('Please specify a valid fileName');
    return
end

menuIn = menu('Choose a Trading System','Dimbeta','Dimbeta - Stochastic','Cross (Dimbeta - Stochastic)','Cross (Stochastic - Dimbeta)','Cancel');

if (menuIn==1)
   title   = 'Input System Parameters for (Dimbeta) ';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):', 'Initial capital:'};
   lines= 1;
   def     = {'close', '50','20','1000'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'capital'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   capital = str2num(a(1).capital);

   [tsSysOut, tsSysOutPlot] = sysDimbeta(st, tsIn, days1, days2);
   
   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
end

if (menuIn==2)
   title   = 'Input System Parameters for (Dimbeta - Stochastic)';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):','Enter days3 for (Stochastic):','Enter days4 for (MovAvg of Stochastic):', 'Initial capital:'};
   lines= 1;
   def     = {'close','50','20','10','3', '1000'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'day3', 'day4', 'capital'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   days3 = str2num(a(1).day3);
   days4 = str2num(a(1).day4);
   capital = str2num(a(1).capital);
   
   [tsSysOut, tsSysOutPlot] = sysDimbetaStoh(st, tsIn, days1, days2, days3, days4);
   
   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
end 

if (menuIn==3)
   title   = 'Input System Parameters for Cross (Dimbeta - Stochastic)';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):','Enter days3 for (Stochastic):','Enter days4 for (MovAvg of Stochastic):', 'Initial capital:'};
   lines= 1;
   def     = {'close','50','20','10','3', '1000'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'day3', 'day4', 'capital'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   days3 = str2num(a(1).day3);
   days4 = str2num(a(1).day4);
   capital = str2num(a(1).capital);
   
   [tsSysOut, tsSysOutPlot] = sysDimbetaStCr(st, tsIn, days1, days2, days3, days4);

   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
end

if (menuIn==4)
   title   = 'Input System Parameters for Cross (Stochastic - Dimbeta)';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):','Enter days3 for (Stochastic):','Enter days4 for (MovAvg of Stochastic):', 'Initial capital:'};
   lines= 1;
   def     = {'close','50','20','10','3', '1000'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'day3', 'day4', 'capital'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   days3 = str2num(a(1).day3);
   days4 = str2num(a(1).day4);
   capital = str2num(a(1).capital);
    
    
   [tsSysOut, tsSysOutPlot]  = sysStDimbetaCr(st, tsIn, days1, days2, days3, days4);

   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
end 

if (menuIn==5 | menuIn==0)
    return;
end

assignin('base','performance', performance);
assignin('base','plCalcTable',plCalcTable);
assignin('base','numTrades', numTrades);
assignin('base','trades',trades);
  

openvar ('performance');
openvar ('plCalcTable');
openvar ('numTrades');
openvar ('trades');
   
