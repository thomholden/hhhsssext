function plotSystem ()

global fName st hFname hStat bGoOnOptimizing 

if (strcmp(fName,'') == 1)
    errordlg ('Please specify a valid fileName');
    return
end

menuIn = menu('Choose a Trading System','Dimbeta','Dimbeta - Stochastic','Cross (Dimbeta - Stochastic)','Cross (Stochastic - Dimbeta)','Cancel');

if (menuIn==1)
   title   = 'Input System Parameters for (Dimbeta) ';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):', 'Initial capital:', 'Accepted % loss:', 'Risk free intrest rate:', 'Number of contracts:'};
   lines= 1;
   def     = {'close', '50','20','1000', '0.50', '0.02', '1'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'capital', 'Xra', 'XRF', 'NR'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   capital = str2num(a(1).capital);
   Xra = str2num(a(1).Xra);
   XRF = str2num(a(1).XRF);
   NR  = str2num(a(1).NR);

   [tsSysOut, tsSysOutPlot] = sysDimbeta(st, tsIn, days1, days2);
   
   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
 
   [XLB,p] = pruin(numTrades, capital, trades, Xra, XRF, NR);

   figure;
   [plRuin]=plotpruin(numTrades,(round(numTrades/2)),capital,trades,XRF, NR);
end

if (menuIn==2)
   title   = 'Input System Parameters for (Dimbeta - Stochastic)';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):','Enter days3 for (Stochastic):','Enter days4 for (MovAvg of Stochastic):', 'Initial capital:', 'Accepted % loss:', 'Risk free intrest rate:', 'Number of contracts:'};
   lines= 1;
   def     = {'close','50','20','10','3', '1000', '0.50', '0.02', '1'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'day3', 'day4', 'capital', 'Xra', 'XRF', 'NR'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   days3 = str2num(a(1).day3);
   days4 = str2num(a(1).day4);
   capital = str2num(a(1).capital);
   Xra = str2num(a(1).Xra);
   XRF = str2num(a(1).XRF);
   NR  = str2num(a(1).NR);
   
   [tsSysOut, tsSysOutPlot] = sysDimbetaStoh(st, tsIn, days1, days2, days3, days4);
   
   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
 
   [XLB,p] = pruin(numTrades, capital, trades, Xra, XRF, NR);

   figure;
   [plRuin]=plotpruin(numTrades,(round(numTrades/2)),capital,trades,XRF, NR);
end 

if (menuIn==3)
   title   = 'Input System Parameters for Cross (Dimbeta - Stochastic)';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):','Enter days3 for (Stochastic):','Enter days4 for (MovAvg of Stochastic):', 'Initial capital:', 'Accepted % loss:', 'Risk free intrest rate:', 'Number of contracts:'};
   lines= 1;
   def     = {'close','50','20','10','3', '1000', '0.50', '0.02', '1'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'day3', 'day4', 'capital', 'Xra', 'XRF', 'NR'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   days3 = str2num(a(1).day3);
   days4 = str2num(a(1).day4);
   capital = str2num(a(1).capital);
   Xra = str2num(a(1).Xra);
   XRF = str2num(a(1).XRF);
   NR  = str2num(a(1).NR);
   
   [tsSysOut, tsSysOutPlot] = sysDimbetaStCr(st, tsIn, days1, days2, days3, days4);

   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
 
   [XLB,p] = pruin(numTrades, capital, trades, Xra, XRF, NR);

   figure;
   [plRuin]=plotpruin(numTrades,(round(numTrades/2)),capital,trades,XRF, NR);
end

if (menuIn==4)
   title   = 'Input System Parameters for Cross (Stochastic - Dimbeta)';
   prompt  = {'Enter open or close:','Enter days1 for (Dimbeta):','Enter days2 for (MovAvg of Dimbeta):','Enter days3 for (Stochastic):','Enter days4 for (MovAvg of Stochastic):', 'Initial capital:', 'Accepted % loss:', 'Risk free intrest rate:', 'Number of contracts:'};
   lines= 1;
   def     = {'close','50','20','10','3', '1000', '0.50', '0.02', '1'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1', 'day2', 'day3', 'day4', 'capital', 'Xra', 'XRF', 'NR'};
   a = cell2struct(answer, fields, 1);

   days1 = str2num(a(1).day1);
   days2 = str2num(a(1).day2);
   days3 = str2num(a(1).day3);
   days4 = str2num(a(1).day4);
   capital = str2num(a(1).capital);
   Xra = str2num(a(1).Xra);
   XRF = str2num(a(1).XRF);
   NR  = str2num(a(1).NR);
    
    
   [tsSysOut, tsSysOutPlot]  = sysStDimbetaCr(st, tsIn, days1, days2, days3, days4);

   [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, capital);
 
   [XLB,p] = pruin(numTrades, capital, trades, Xra, XRF, NR);

   figure;
   [plRuin]=plotpruin(numTrades,(round(numTrades/2)),capital,trades,XRF, NR);
end 

if (menuIn==5 | menuIn==0)
    return;
end

%user_entry = input('prompt','s');
%disp (user_entry);

%handle = uicontrol(...,'PropertyName',PropertyValue,...)
%get(edit_handle,'String')



%dialog, errordlg, helpdlg, questdlg, warndlg


% hFigure = figure;