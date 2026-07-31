classdef mat2xls < handle
   % MAT2XLS Stores and customizes numeric array or cell array in Excel workbook.
   %
   %    The function allows to create MS Excel documents and assigns the
   %    specified properties and values to customize the output in excel.
   %
   % Usage / Workflow:
   %    e = mat2xls                     Initialize ActiveX Interface
   %    e.visible(ON/OFF)               set visibility for Excel document
   %    e.open(FILE)                    Open existing document (if necessary)
   %
   %    e.data(ARRAY,SHEET,RANGE, ...   
   %       'PropertyName1',value1,...
   %       'PropertyName2',value2,..)   Transfer Data to Excel
   %
   %        ARRAY, SHEET and RANGE are required!
   %
   %           - ARRAY Array of Data (CellArray or Numeric)
   %           - SHEET Name of the active sheet. if the sheet does not exist, 
   %             so it would be created.
   %           - RANGE Range in worksheet speciefied by top left corner only!
   %                                    
   %        Propertys are optional:
   %
   %           BackgroundColor          [R G B]
   %           ForegroundColor          [R G B]
   %           BorderStyle              {'-' '.' '='}
   %           BorderColor              [R G B]
   %           FontName
   %           FontSize
   %           FontAngle                {'normal' 'Italic'}
   %           FontWeight               {'normal' 'bold'}
   %           Orientation              {-90 ... +90}
   %           MultipleLine             {'on' 'off'}
   %           HorizontalAlignment      {'right' 'left' 'center'}
   %           VerticalAlignment        {'top' 'middle' 'bottom'}
   %           Height
   %           Width
   %
   %    e.data(ARRAY,SHEET,RANGE, 'PropertyName1',value1,... )
   %    e.data(ARRAY,SHEET,RANGE, 'PropertyName1',value1,... )
   %
   %    e.save(FILE)                    Save document
   %    e.close                         Close ActiveX Interface
   %
   % NOTE: The above functionality depends upon Excel as a COM server. That
   % means Excel should be installed on your machine.
   %
   % Example:
   %    e = mat2xls;
   %    e.visible('on');
   %
   %    % create title in sheet "Magic Square"
   %    % at location "A1" (top left corner)
   %    e.data({'MAGIC SQUARE'}, ...
   %       'Magic Square','A1', ...
   %       'BackgroundColor',[0 0 0], ...
   %       'ForegroundColor',[1 1 1], ...
   %       'MultipleLine','on', ...
   %       'BorderStyle','-', ...
   %       'Height',100,...
   %       'HorizontalAlignment','center', ...
   %       'VerticalAlignment','middle')
   %
   %    % add column names "Magic Square" at location "B1"
   %    e.data({'Column 1' 'Column 2' 'Column 3' 'Column 4'}, ...
   %       'Magic Square','B1', ...
   %       'BackgroundColor',[.3 .3 .3], ...
   %       'ForegroundColor',[0 1 0], ...
   %       'BorderStyle','-', ...
   %       'Orientation',90, ...
   %       'FontWeight','bold', ...
   %       'Height',100,...
   %       'HorizontalAlignment','center', ...
   %       'VerticalAlignment','middle')
   %
   %    % add row names in same sheet at location "A2"
   %    e.data({'Row 1';'Row 2';'Row 3';'Row 4'}, ...
   %       'Magic Square','A2', ...
   %       'BackgroundColor',[.3 .3 .3], ...
   %       'ForegroundColor',[1 0 0], ...
   %       'BorderStyle','-', ...
   %       'FontWeight','bold', ...
   %       'HorizontalAlignment','center', ...
   %       'VerticalAlignment','middle')
   %
   %    % place data in excel at location "B2"
   %    e.data(magic(4), ...
   %       'Magic Square','B2', ...
   %       'ForegroundColor',[0 0 1], ...
   %       'BackgroundColor',[0.9922    0.9176    0.7961], ...
   %       'BorderStyle','=', ...
   %       'Width',10,...
   %       'BorderColor',[0 0 0])
   %
   %    e.save('.\example');
   %    e.close
   %
   %  See also XLSWRITE, XLSREAD.
   %
   %   Author: Elmar Tarajan [MCommander@gmx.de] (c) 2010
   %  Version: v2.0
   %     Date: 2010/06/02 15:33:00
   %
   %  <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/4137">File Exchange</a>  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=Z8NDTASMAYB8W">PayPal Donate</a>
      
   properties (SetAccess = private,GetAccess = private)
      excel
      workbook
      range
   end
   
   methods
      function obj = mat2xls
         % Open Excel COM Server
         try
            obj.excel = actxserver('excel.Application');
         catch
            error('Could not start Excel server for export.');
         end% catch
         % set default Path         
         obj.excel.DefaultFilePath = cd;
         % count of sheets in new document
         obj.excel.SheetsInNewWorkbook = 1;
      end
      %
      function obj = visible(obj,flag)
         % set visibility
         ind = strcmp({'off' 'on'},flag);
         obj.excel.Visible = find(ind)-1;         
      end
      
      function obj = open(obj,filename)
         % open         
         obj.workbook = obj.excel.Workbooks.Open(filename);
      end
      
      function obj = save(obj,filename)
         % save as
         obj.workbook.SaveAs(filename);
      end
      
      function obj = close(obj)
         % close ActiveX interface
         obj.excel.Quit;
      end
      
      function obj = data(obj,data,sheetname,loc,varargin)
         %
         % select sheet
         %%%%%%%%%%%%%%%
         if isempty(obj.excel.ActiveWorkbook)
            obj.workbook = obj.excel.Workbooks.Add;
            obj.excel.ActiveWorkBook.Sheets.Item(1).Name = sheetname;
         else
            % get all names
            allnames = arrayfun(@(x) {obj.excel.ActiveWorkBook.Sheets.Item(x).Name}, ...
               1:obj.excel.ActiveWorkBook.Sheets.Count);
            % check if the sheet already exists
            if any(strcmp(allnames,sheetname))
               % then activate them
               n = find(strcmp(allnames,sheetname));
               obj.excel.ActiveWorkBook.Sheets.Item(n).Activate;
            else
               % or create new one
               obj.excel.ActiveWorkBook.Sheets.Add;
               obj.excel.ActiveWorkBook.Sheets.Item(1).Name = sheetname;
            end
         end% if
         %
         % calculate the range due to location and size of the data
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         tmp = get(obj.excel,'Range',loc);
         loc1 = [tmp.row tmp.column] + size(data)-1;
         tmp = get(obj.excel,'Cells',loc1(1),loc1(2));
         area = sprintf('%s:%s',loc,tmp.Address);
         %
         % selected area
         obj.range = obj.excel.Activesheet.Range(area);
         %
         % prepare and transfer data to excel
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if isnumeric(data)
            obj.range.value = arrayfun(@(x) {x},data);
         else
            obj.range.value = data;
         end
         %
         
         %
         % parse input parameters
         while ~isempty(varargin)
            switch lower(varargin{1})
               case 'backgroundcolor'
                  obj.range.Interior.Color = rgb2true(varargin{2});
                  %
               case 'foregroundcolor'
                  obj.range.Font.Color = rgb2true(varargin{2});
                  %
               case 'borderstyle'
                  ind = strcmp({'none' '-' '.' '' '' '' '' '' '' '='},varargin{2});
                  obj.range.Borders.value = find(ind)-1;
                  %
               case 'bordercolor'
                  obj.range.Borders.Color = rgb2true(varargin{2});
                  %
               case 'fontname'
                  obj.range.Font.Name = varargin{2};
                  %
               case 'fontsize'
                  obj.range.Font.Size = varargin{2};
                  %
               case 'fontangle'
                  switch lower(varargin{2})
                     case 'italic'
                        obj.range.Font.Italic = 1;
                     otherwise
                        obj.range.Font.Italic = 0;
                  end% switch
                  %
               case 'fontweight'
                  switch lower(varargin{2})
                     case 'bold'
                        obj.range.Font.Bold   = 1;
                     otherwise
                        obj.range.Font.Bold   = 0;
                  end% switch
                  %
               case 'orientation'
                  obj.range.Cells.Orientation = varargin{2};
                  %
               case 'multipleline'
                  ind = strcmp({'off' 'on'},varargin{2});
                  obj.range.Cells.wrapText = find(ind)-1;

                  %
               case 'horizontalalignment'
                  ind = strcmp({'right' 'left' 'center'},varargin{2});
                  obj.range.HorizontalAlignment = find(ind);
                  %
               case 'verticalalignment'
                  ind = strcmp({'top' 'middle' 'bottom'},varargin{2});
                  obj.range.VerticalAlignment = find(ind);  
                  %
               case 'height'
                  obj.range.RowHeight = varargin{2};
                  %
               case 'width'
                  obj.range.ColumnWidth = varargin{2};
                  %
                  % ADD YOUR OWN PARAMETERS
                  % case 'myparameter'
                  %    ...
                  %    ...
                  %
               otherwise
                  warning(sprintf('There is no "%s" property.',varargin{1}))
                  %
            end% switch
            varargin(1:2)=[];
         end% while
      end
      
      function obj = display(obj)
      end

   end
   %
end%

function clr = rgb2true(rgb)
   clr = hex2dec(sprintf(dec2hex(uint8(255*flipdim(rgb,2)))'));
end