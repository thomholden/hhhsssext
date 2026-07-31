%% Set up database parameters for local SQLite database
%
% Copyright 2013 The MathWorks, Inc.
javaaddpath '.\sqlite-jdbc-3.7.2.jar';
dbname='C:\MatlabProjects\CommodityTrading\ohlcdata.db';
connString=['jdbc:sqlite:' dbname];
dbDriver='org.sqlite.JDBC';
