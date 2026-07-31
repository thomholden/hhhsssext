% executeSQL  execute the text in the "SQL Statement"
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   executeSQL
%
% Description:
%   This Matlab script uses the string in the "SQLStr" variable
%   to execute a query on the Access97 database file.
%   
%
% Input:
%   hDB - handle of the database opened by the DAO Database Engine
%   SQLStr - query string returned from getSQLStr function
%
% Output:
%   n/a
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   31-May-1999
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% History
% Version 1.0 31-May-1999
 

if (~isempty(SQLStr))
   % create a QueryDef based on the "SQL Statement" editbox
   invoke(hDB,'CreateQueryDef','TempSQL',SQLStr);
   
   % Open a recordset in the DBEngine object containing the query
   hRSet = invoke(hDB,'OpenRecordset','TempSQL');
   RSetCnt = get(hDB.Recordsets,'Count');
   RSetCnt = double(RSetCnt);
   
   % Name of recordset
   RSetName = get(hRSet,'Name');
   
   % determine the number of fields in the query
   FLDCnt = get(hRSet.Fields,'Count');
   FLDCnt = double(FLDCnt);
   
   % requery to make sure we are at the first record
   invoke(hRSet,'ReQuery');
   
   % move pointer to last record in query
   invoke(hRSet,'MoveLast');
   
   % count the number of records in the query
   RCount = get(hRSet,'RecordCount');
   
   % if there are no records in the query table then stop processing
   if (RCount > 0)
      
      No_Records = 0; % false
      
      % requery to make sure we are at the first record
      invoke(hRSet,'ReQuery');
      
      % Transfer all rows to the Matlab workspace. This is transferred as
      % a VARIANT data type and hence is stored in a cell array in the 
      % Matlab worksapce.
      data = invoke(hRSet,'GetRows',RCount);
      
      % Convert cell array to variables for each column
      for i = 1:FLDCnt
         hFLD = get(hRSet,'Fields',(i-1));
         FLDName = get(hFLD,'Name');
         if (ischar(data{i,1}))
            eval([FLDName,' = data(',num2str(i),',:);']);
         else
            % Cell arrays are containers for double arrays, character arrays, and
            % other Matlab types. Hence by putting the [ ] brackets around the
            % cell array data, I can easily strip out double arrays. This improves
            % the speed of this function by orders of magnitude over the earlier
            % version of msquery. Blair Greenan 28-May-1999
            eval([FLDName,' = [data{',num2str(i),',:}];']);
         end
      end
      
   else
      No_Records = 1; % true
   end
   % close the recordset and release the ActiveX object handle
   invoke(hRSet,'Close');
   release(hRSet);
   
   % Remove temporary Query (tempSQL) from the Query Defintions 
   invoke(hDB.QueryDefs,'Delete','TempSQL');
   
end

% Give the user a message
% msgbox('Data transfer complete!')

% clear variables from workspace 
clear RSetCnt RSetName FLDCnt RCount 
clear data FLDName hFLD hRSet i j 
