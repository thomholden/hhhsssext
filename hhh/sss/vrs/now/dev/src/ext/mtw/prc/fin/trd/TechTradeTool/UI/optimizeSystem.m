function optimizeSystem ()

global fName st hFname hStat bGoOnOptimizing 

bGoOnOptimizing = 1;

if (strcmp(fName,'') == 1)
    errordlg ('Please specify a valid fileName');
    return
end


menuIn = menu('Choose a Trading System','Dimbeta','Dimbeta - Stochastic','Cross (Dimbeta - Stochastic)','Cross (Stochastic - Dimbeta)','Cancel');

if (menuIn==1)
   title   = 'Input System Parameters for (Dimbeta) ';
   prompt  = {'Enter open or close:','Enter days1 lowerbound for (Dimbeta):','Enter days1 upperbound for (Dimbeta):','Enter days2 lowerbound for (MovAvg of Dimbeta):', 'Enter days2 upperbound for (MovAvg of Dimbeta):'};
   lines= 1;
   def     = {'close', '30','50', '10','20'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1Lo', 'day1Up', 'day2Lo', 'day2Up'};
   a = cell2struct(answer, fields, 1);

   days1Lo = str2num(a(1).day1Lo);
   days1Up = str2num(a(1).day1Up);
   days2Lo = str2num(a(1).day2Lo);
   days2Up = str2num(a(1).day2Up);

   [bestPerf, opt1, opt2, opt3, opt4]=optimizeSys2(menuIn, st, tsIn, days1Lo, days1Up, days2Lo, days2Up, 0, 0, 0, 0);
end

if (menuIn==2)
   title   = 'Input System Parameters for (Dimbeta - Stochastic)';
   prompt  = {'Enter open or close:','Enter days1 lowerbound for (Dimbeta):','Enter days1 upperbound for (Dimbeta):','Enter days2 lowerbound for (MovAvg of Dimbeta):', 'Enter days2 upperbound for (MovAvg of Dimbeta):',  'Enter days3 lowerbound for (Stochastic):','Enter days3 upperbound for (Stochastic):','Enter days4 lowerbound for (MovAvg of Stochastic):', 'Enter days4 upperbound for (MovAvg of Stochastic):'};
   lines= 1;
   def     = {'close', '30','50', '10','20', '30','50', '10','20'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1Lo', 'day1Up', 'day2Lo', 'day2Up', 'day3Lo', 'day3Up', 'day4Lo', 'day4Up'};
   a = cell2struct(answer, fields, 1);

   days1Lo = str2num(a(1).day1Lo);
   days1Up = str2num(a(1).day1Up);
   days2Lo = str2num(a(1).day2Lo);
   days2Up = str2num(a(1).day2Up);
   days3Lo = str2num(a(1).day3Lo);
   days3Up = str2num(a(1).day3Up);
   days4Lo = str2num(a(1).day4Lo);
   days4Up = str2num(a(1).day4Up);

   [bestPerf, opt1, opt2, opt3, opt4]=optimizeSys2(menuIn, st, tsIn, days1Lo, days1Up, days2Lo, days2Up, days3Lo, days3Up, days4Lo, days4Up);
end 

if (menuIn==3)
   title   = 'Input System Parameters for Cross (Dimbeta - Stochastic)';
   prompt  = {'Enter open or close:','Enter days1 lowerbound for (Dimbeta):','Enter days1 upperbound for (Dimbeta):','Enter days2 lowerbound for (MovAvg of Dimbeta):', 'Enter days2 upperbound for (MovAvg of Dimbeta):',  'Enter days3 lowerbound for (Stochastic):','Enter days3 upperbound for (Stochastic):','Enter days4 lowerbound for (MovAvg of Stochastic):', 'Enter days4 upperbound for (MovAvg of Stochastic):'};
   lines= 1;
   def     = {'close', '30','50', '10','20', '30','50', '10','20'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1Lo', 'day1Up', 'day2Lo', 'day2Up', 'day3Lo', 'day3Up', 'day4Lo', 'day4Up'};
   a = cell2struct(answer, fields, 1);

   days1Lo = str2num(a(1).day1Lo);
   days1Up = str2num(a(1).day1Up);
   days2Lo = str2num(a(1).day2Lo);
   days2Up = str2num(a(1).day2Up);
   days3Lo = str2num(a(1).day3Lo);
   days3Up = str2num(a(1).day3Up);
   days4Lo = str2num(a(1).day4Lo);
   days4Up = str2num(a(1).day4Up);

   [bestPerf, opt1, opt2, opt3, opt4]=optimizeSys2(menuIn, st, tsIn, days1Lo, days1Up, days2Lo, days2Up, days3Lo, days3Up, days4Lo, days4Up);
end

if (menuIn==4)
   title   = 'Input System Parameters for Cross (Stochastic - Dimbeta)';
   prompt  = {'Enter open or close:','Enter days1 lowerbound for (Dimbeta):','Enter days1 upperbound for (Dimbeta):','Enter days2 lowerbound for (MovAvg of Dimbeta):', 'Enter days2 upperbound for (MovAvg of Dimbeta):',  'Enter days3 lowerbound for (Stochastic):','Enter days3 upperbound for (Stochastic):','Enter days4 lowerbound for (MovAvg of Stochastic):', 'Enter days4 upperbound for (MovAvg of Stochastic):'};
   lines= 1;
   def     = {'close', '30','50', '10','20', '30','50', '10','20'};
   answer  = inputdlg (prompt,title,lines,def);
   if (size(answer) == 0)
       return;
   end
   
   tsIn = st.close;
   if (strcmp(answer(1),'open'))
       tsIn = st.open;
   end
   
   fields = {'openClose', 'day1Lo', 'day1Up', 'day2Lo', 'day2Up', 'day3Lo', 'day3Up', 'day4Lo', 'day4Up'};
   a = cell2struct(answer, fields, 1);

   days1Lo = str2num(a(1).day1Lo);
   days1Up = str2num(a(1).day1Up);
   days2Lo = str2num(a(1).day2Lo);
   days2Up = str2num(a(1).day2Up);
   days3Lo = str2num(a(1).day3Lo);
   days3Up = str2num(a(1).day3Up);
   days4Lo = str2num(a(1).day4Lo);
   days4Up = str2num(a(1).day4Up);

   [bestPerf, opt1, opt2, opt3, opt4]=optimizeSys2(menuIn, st, tsIn, days1Lo, days1Up, days2Lo, days2Up, days3Lo, days3Up, days4Lo, days4Up);
end 

if (menuIn==5 | menuIn==0)
    return;
end

if (bGoOnOptimizing == 1)
  assignin('base','bestPerf', bestPerf);
  parameters=[opt1, opt2, opt3, opt4];
  assignin('base','parameters', parameters);
  
  openvar ('bestPerf');
  openvar ('parameters');
end
   
