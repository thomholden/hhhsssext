% msqueryhelp -generates string for the Matlab Help Window to provide help for tsgui
% ============================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage: 
%   msqueryhelp
%
% Description:
%   Generates the string which appears in the Matlab Help Window when
%   the user if msqueryGUI clicks Help->MSQuery Help.
%
% Input:
%   n/a
%
% Output:
%   n/a
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   September 8, 1998
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

helpstr={'msquery.m';
   ' ';
   'MSQuery is a Matlab 5.2.1 function which provides the user with a';
   'Graphical User Interface (GUI) to enable interaction with a Microsoft';
   'Access97 database.  This makes it possible to execute queries on the';
   'Access database and have the results returned to the Matlab Workspace';
   'where an alaysis of the data can be performed.';
   ' ';
   'The GUI controls provided in the MSQuery window include:';
   ' ';
   'Open Database pushbutton and uimenu: Prompts the user with a standard';
   'File->Open dialog box to choose the MS Access97 database to open. Access';
   'is initiated as an ActiveX automation server at this point.';
   ' ';
   'Close Database pushbutton and uimenu: Close the current Access database';
   'and shuts down Access as an ActiveX automation server. Note: if the user';
   'has manipulated the Access window while it has been open it must be closed';
   'manually after the "Close Database" button has been clicked.';
   ' ';
   'Tables listbox: Lists the names of the Tables defined in the MS Access';
   'database. By clicking on a Table name in the listbox, the fields in the';
   'Fields listbox are updated to correspond to chosen table.  Clicking on the';
   '"Add to SQL" pushbutton below the listbox adds the Table name to the string';
   'displayed in the "SQL Statement" editbox.';
   ' ';
   'Fields listbox: Lists the fields defined in the table selected in the "Tables"';
   'listbox.  The user may selected more than one field and press the "Add to SQL"';
   'button below the listbox to add these fields to the "SQL Statement".';
   ' ';
   'Existing Queries listbox: Lists queries defined in the MS Access database.';
   'Clicking on on of the queries will update the "SQL Statement" editbox to';
   'correspond to the SQL statement in the defined query. The "Delete Query"';
   'pushbutton below this listbox enables the user to remove an existing query';
   'definition from the database.';
   ' ';
   'SQL Statement editbox: Enables the user to define an SQL statement which';
   'could be executed on the open database. If the user selects a name in the';
   '"Existing Queries" listbox the corresponding SQL statement is displayed in';
   'this editbox.';
   ' ';
   'Save Query checkbox: If this is NOT checked (default) then any query executed';
   'on the open database is temporary in nature and does not affect the "Existing';
   'Queries" listbox. If the Save Query checkbox is checked then the edit box beside';
   'it is enabled so that the user can enter a name for the query definition to be';
   'saved as in the database. If the Save Query checkbox is checked AND the user does';
   'not enter a name in the editbox then an Error dialog box will be displayed when';
   'the user attempts to execute the query and hence no execution will occur.';
   ' ';
   'Clear SQL pushbutton: Enables the user to clear the "SQL Statement" editbox.';
   ' ';
   'Execute pushbutton: Executes the query displayed in the "SQL Statement" editbox';
   'on the open database. If the user chose to save the query, a query defintion';
   '(QueryDef) is created in the Access database and the "Existing Queries" listbox';
   'is updated. The results of the query are transferred to the Matlab workspace';
   'and assigned the appropriate names as defined in the Access database.';
   ' ';
   'Blair Greenan';
   'Bedford Institute of Oceanography';
   'September, 1998';
   'Matlab 5.2.1';
   'email: greenanb@mar.dfo-mpo.gc.ca';
};
helpwin(helpstr,'MSQuery');
