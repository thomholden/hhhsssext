classdef uiHistory < hgsetget
  % UIHISTORY - Navigation pane object for MATLAB graphics
  %-----------------------------------------------------------------------------
  % File name  : uiHistory.m
  % Created on : 25-03-2009
  % Description: Navigation pane object for MATLAB graphics
  %
  % Copyright 2008-2009 T. Montagnon
  %-----------------------------------------------------------------------------
  %
  
  properties (SetAccess = private, GetAccess = public)
    type     = 'uigroup' % uiHistory type is UIGROUP
    style    = 'navPane' % uiHistory style is NAVPANE
    units    = 'pixels'  % uiHistory units are forced to PIXELS
  end
  
  properties (Dependent = true)
    Parent             % Parent HG object
    data               % Data displayed. Cell array with 2 elements (xdata & ydata)
    Position           % Position in pixels od the UI control
    Cmin               % Lower cursor position
    Cmax               % Upper cursor position
    AxisColor          % Color of the X- and Y-axis
    XAxisLocation      % X axis location ( {top} | bottom )
    AreaFaceColor      % Face color of the history area
    AreaEdgeColor      % Edge color of the history area
    SelAreaFaceColor   % Face color of the selected area
    SelAreaEdgeColor   % Edge color of the selected area
    CursorColor        % Lower and upper cursors color
    BackgroundColor    % Axe background color
    XisDate            % Boolean indicating if the X-axis contains dates ( true | {false} )
    FontAngle          % Font angle property for the axis labels
    FontName           % Font name used for the axis labels
    FontSize           % Font size used for the axis labels
    FontUnits          % Font unit used for the axis labels
    FontWeight         % Font weight used for the axis labels
  end
  
  properties (Constant, Access = private)
    DefaultLocXAxis       = 'top';                           % Default XAxisLocation is TOP
    DefaultClrAxis        = [0.30  0.30  0.30];              % Default axis color
    DefaultClrAreaFace    = [0.50  0.50  0.50];              % Default history area face color
    DefaultClrAreaEdge    = [0.50  0.50  0.50];              % Default history area edge color
    DefaultClrSelAreaFace = [1.00  0.80  0.80];              % Default selected area face color
    DefaultClrSelAreaEdge = [1.00  0.40  0.40];              % Default selected area edge color
    DefaultClrCursor      = [1.00  0.40  0.40];              % Default cursors' color
    DefaultClrBackground  = [0.96  0.98  0.99];              % Default axe background color
    DefaultFtAngle        = get(0,'defaultAxesfontangle');   % Default font angle
    DefaultFtName         = get(0,'defaultAxesfontname');    % Default font name
    DefaultFtSize         = get(0,'defaultAxesfontsize');    % Default font size
    DefaultFtUnits        = get(0,'defaultAxesfontunits');   % Default font units
    DefaultFtWeight       = get(0,'defaultAxesfontweight');  % Default font weight
  end
  
  properties (Access = private)
    HdlFig
    HdlParent
    HdlMainAxes
    HdlMainArea
    HdlSelectedArea
    historyCursor
    XData
    YData
    CminValue
    CmaxValue
    PosMainAxes
    XisDateFlag    = false;
    LocXAxis       = 'top';
    FtAngle        = get(0,'defaultAxesfontangle');
    FtName         = get(0,'defaultAxesfontname');
    FtSize         = get(0,'defaultAxesfontsize');
    FtUnits        = get(0,'defaultAxesfontunits');
    FtWeight       = get(0,'defaultAxesfontweight');
    ClrAxis        = [0.30  0.30  0.30];
    ClrAreaFace    = [0.50  0.50  0.50];
    ClrAreaEdge    = [0.50  0.50  0.50];
    ClrSelAreaFace = [1.00  0.80  0.80];
    ClrSelAreaEdge = [1.00  0.40  0.40];
    ClrCursor      = [1.00  0.40  0.40];
    ClrBackground  = [0.96  0.98  0.99];
    CursRelPos
    CursDistance
    FcnWindowButtonMotion
    FcnWindowButtonUp
  end
  
  events
    onStartDrag
    onDrag
    onReleased
  end
  
  methods
    
    function this = uiHistory(parent,data,varargin)
      
      this.Parent = parent;
      this.HdlFig = ancestor(this.Parent,'figure');
      
      if ~isempty(varargin)
        this.XisDateFlag = varargin{1};
      end
      
      this.HdlMainAxes = axes(...
        'Parent'    , parent, ...
        'Tag'       , 'AxPlotHistory', ...
        'Units'     , this.units, ...
        'Position'  , this.Position,...
        'FontAngle' , this.FtAngle,...
        'FontName'  , this.FtName,...
        'FontUnits' , this.FtUnits,...
        'FontSize'  , this.FtSize,...
        'FontWeight', this.FtWeight,...
        'YColor'    , this.ClrAxis,...
        'XColor'    , this.ClrAxis,...
        'YTick'     , [], ...
        'Color'     , this.ClrBackground, ...
        'Box'       , 'on');
      
      this.historyCursor = cursors(this.HdlMainAxes,this.ClrCursor);
      addlistener(this.historyCursor,'onStartDrag',@this.cursor_onStartDrag);
      addlistener(this.historyCursor,'onDrag'     ,@this.cursor_onDrag);
      addlistener(this.historyCursor,'onReleased' ,@this.cursor_onReleased);
      
      this.data = data;
      
    end
    
    function cursor_onDrag(this,eventSrc,eventData) %#ok<INUSL>
      % Executed while cursor is beeing dragged
      
      % Sort the cursorPos vector and transpose it
      cursorPos = sort(eventData.Positions)';
      
      % Remove the highlighted section on the history graph
      try %#ok<TRYNC>
        delete(this.HdlSelectedArea);
      end
      
      % Get the corresponding indices in the original data
      iStart = find(cursorPos(1) >= this.XData,1,'last');
      iEnd   = find(cursorPos(2) <= this.XData,1,'first');
      
      hold(this.HdlMainAxes,'on');
      
      this.HdlSelectedArea  = area( ...
        this.HdlMainAxes, ...
        this.XData(iStart:iEnd), this.YData(iStart:iEnd), ...
        'FaceColor', this.ClrSelAreaFace, ...
        'EdgeColor', this.ClrSelAreaEdge, ...
        'LineWidth', 2);
      
      notify(this,'onDrag',cursorsData([this.XData(iStart) this.XData(iEnd)]));
      
    end
    
    function cursor_onReleased(this,eventSrc,eventData) %#ok<INUSL>
      % Executed when cursor is released 
      
      % Sort the cursorPos vector and transpose it
      cursorPos = sort(eventData.Positions)';
      
      % Get the corresponding indices in the original data
      iStart = find(cursorPos(1) >= this.XData,1,'last');
      iEnd   = find(cursorPos(2) <= this.XData,1,'first');
      
      % Update CminValue and CmaxValue property values
      this.CminValue = this.XData(iStart);
      this.CmaxValue = this.XData(iEnd);
      
      % Refresh cursor positions
      this.historyCursor.Positions = [this.CminValue this.CmaxValue NaN];
      
      notify(this,'onReleased',cursorsData([this.CminValue this.CmaxValue]));
      
    end
    
    function cursor_onStartDrag(this,eventSrc,eventData) %#ok<INUSL>
      % Executed when a cursor is selected (onStartDrag event on cursor object)
      
      % Sort the cursorPos vector and transpose it
      cursorPos = sort(eventData.Positions)';
      
      % Get the corresponding indices in the original data
      iStart = find(cursorPos(1) >= this.XData,1,'last');
      iEnd   = find(cursorPos(2) <= this.XData,1,'first');
      
      notify(this,'onStartDrag',cursorsData([this.XData(iStart) this.XData(iEnd)]));
      
    end
    
    function set.data(this,historyData)
      
      this.XData = historyData{1};
      this.YData = historyData{2};
      
      % Initialize cursors' positions
      this.CminValue = this.XData(ceil(end/4));
      this.CmaxValue = this.XData(ceil(3*end/4));
      
      hold(this.HdlMainAxes,'on');
      
      try %#ok<TRYNC>
        delete(this.HdlMainArea);
        delete(this.HdlSelArea);
      end
      
      this.HdlMainArea = area( ...
        this.HdlMainAxes, ...
        this.XData, this.YData, ...
        'FaceColor',this.ClrAreaFace, ...
        'EdgeColor',this.ClrAreaEdge);
      
      set(this.HdlMainAxes, ...
        'Xcolor'       , this.ClrAxis, ...
        'Ycolor'       , this.ClrAxis, ...
        'YTick'        , [], ...
        'YTickLabel'   , {}, ...
        'XGrid'        , 'on', ...
        'Box'          , 'on', ...
        'XAxisLocation', this.LocXAxis, ...
        'GridLineStyle', '-', ...
        'Color'        , this.BackgroundColor);
      
      axis(this.HdlMainAxes,'tight');
      
      xlim(this.HdlMainAxes,[this.XData(1) this.XData(end)]);
      yLim = ylim(this.HdlMainAxes);
      ylim(this.HdlMainAxes,[yLim(1) max(this.YData)+0.2*(max(this.YData)-yLim(1))]);
      
      if this.XisDateFlag
        datetick(this.HdlMainAxes,'keeplimits');
      end
      
      set(this.HdlMainAxes,'Layer','top')
      
      % Remove all cursors if exist
      if ~isempty(this.historyCursor.Positions)
        this.historyCursor.remove([]);
      end
      
      % Add cursors
      this.historyCursor.add(this.CminValue);
      this.historyCursor.add(this.CmaxValue);
      
    end
    function value = get.data(this)
      value = {this.XData,this.YData};
    end
    
    function set.AreaFaceColor(this,value)
      if isempty(value)
        this.ClrAreaFace = this.DefaultClrAreaFace;
      else
        this.ClrAreaFace = value;
      end
      set(this.HdlMainArea,'FaceColor',this.ClrAreaFace)
    end
    function value = get.AreaFaceColor(this)
      value = this.ClrAreaFace;
    end
      
    function set.AreaEdgeColor(this,value)
      if isempty(value)
        this.ClrAreaEdge = this.DefaultClrAreaEdge;
      else
        this.ClrAreaEdge = value;
      end
      set(this.HdlMainArea,'EdgeColor',this.ClrAreaEdge)
    end
    function value = get.AreaEdgeColor(this)
      value = this.ClrAreaEdge;
    end
    
    function set.SelAreaFaceColor(this,value)
      if isempty(value)
        this.ClrSelAreaFace = this.DefaultClrSelAreaFace;
      else
        this.ClrSelAreaFace = value;
      end
      set(this.HdlSelectedArea,'FaceColor',this.ClrSelAreaFace)
    end
    function value = get.SelAreaFaceColor(this)
      value = this.ClrSelAreaFace;
    end
    
    function set.SelAreaEdgeColor(this,value)
      if isempty(value)
        this.ClrSelAreaEdge = this.DefaultClrSelAreaEdge;
      else
        this.ClrSelAreaEdge = value;
      end
      set(this.HdlSelectedArea,'EdgeColor',this.ClrSelAreaEdge)
    end
    function value = get.SelAreaEdgeColor(this)
      value = this.ClrSelAreaEdgeColor;
    end
    
    function set.AxisColor(this,value)
      if isempty(value)
        this.ClrAxis = this.DefaultClrAxis;
      else
        this.ClrAxis = value;
      end
      set(this.HdlMainAxes,'XColor',this.ClrAxis)
      set(this.HdlMainAxes,'YColor',this.ClrAxis)
    end
    function value = get.AxisColor(this)
      value = this.ClrAxes;
    end
    
    function set.XAxisLocation(this,value)
      if isempty(value)
        this.LocXAxis = this.DefaultLocXAxis;
      else
        this.LocXAxis = value;
      end
      set(this.HdlMainAxes,'XAxisLocation',this.LocXAxis)
    end
    function value = get.XAxisLocation(this)
      value = this.LocXAxis;
    end
    
    function set.Cmin(this,value)
      if (value < min(this.XData)) || (value >= this.Cmax)
        error('uiHistory:Cmin:WrongValue','Wrong Cmin property value');
      end
      this.CminValue = value;
      this.historyCursor.Positions = [this.CminValue this.CmaxValue];
    end
    function value = get.Cmin(this)
      value = this.CminValue;
    end
    
    function set.Cmax(this,value)
      if (value > max(this.XData)) || (value <= this.Cmin)
        error('uiHistory:Cmax:WrongValue','Wrong Cmax property value');
      end
      this.CmaxValue = value;
      this.historyCursor.Positions = [this.CminValue this.CmaxValue];
    end
    function value = get.Cmax(this)
      value = this.CmaxValue;
    end
    
    function set.Position(this,value)
      this.PosMainAxes = value;
      set(this.HdlMainAxes,'Position',this.PosMainAxes)
    end
    function value = get.Position(this)
      if isempty(this.PosMainAxes)
        pos = getpixelposition(this.Parent);
        this.PosMainAxes = [round(pos(3)/8) round(pos(4)/8) round(pos(3)*3/4) round(pos(4)/6)];
      end
      value = this.PosMainAxes;
    end
    
    function set.Parent(this,value)
      if ~ishandle(value)
        error('uiHistory:Parent:mustBeHandle','Parent property must be a handle graphic');
      end
      if ~any(strcmp(get(value,'type'),{'figure','uipanel','uibuttongroup'}))
        error('uiHistory:Parent:mustBeProperHandle','Parent property must be a figure, uipanel or uibuttongroup handle graphic');
      end
      this.HdlParent = value;
      set(this.HdlMainAxes,'Parent',value)
    end
    function value = get.Parent(this)
      value = this.HdlParent;
    end
    
    function set.XisDate(this,value)
      if ~islogical(value)
        error('uiHistory:XisDate:WrongType','XisDate must be a logical value');
      end
      this.XisDateFlag = value;
      if this.XisDateFlag
        datetick(this.HdlMainAxes,'keeplimits');
      else
        set(this.HdlMainAxes,'XTickLabelMode','auto','XTickMode','auto');
      end
    end
    function value = get.XisDate(this)
      value = this.XisDateFlag;
    end
    
    function set.BackgroundColor(this,value)
      if isempty(value)
        this.ClrBackground = this.DefaultClrBackground;
      else
        this.ClrBackground = value;
      end
      set(this.HdlMainAxes,'Color',this.ClrBackground)
    end
    function value = get.BackgroundColor(this)
      value = this.ClrBackground;
    end
    
    function set.CursorColor(this,value)
      if isempty(value)
        this.ClrCursor = this.DefaultClrCursor;
      else
        this.ClrCursor = value;
      end
      this.historyCursor.Color = this.ClrCursor;
    end
    function value = get.CursorColor(this)
      value = this.ClrCursor;
    end
    
    function set.FontAngle(this,value)
      if isempty(value)
        this.FtAngle = this.DefaultFtAngle;
      else
        this.FtAngle = value;
      end
      set(this.HdlMainAxes,'FontAngle',this.FtAngle)
    end
    function value = get.FontAngle(this)
      value = this.FtAngle;
    end
    
    function set.FontName(this,value)
      if isempty(value)
        this.FtName = this.DefaultFtName;
      else
        this.FtName = value;
      end
      set(this.HdlMainAxes,'FontName',this.FtName)
    end
    function value = get.FontName(this)
      value = this.FtName;
    end
    
    function set.FontSize(this,value)
      if isempty(value)
        this.FtSize = this.DefaultFtSize;
      else
        this.FtSize = value;
      end
      set(this.HdlMainAxes,'FontSize',this.FtSize)
    end
    function value = get.FontSize(this)
      value = this.FtSize;
    end
    
    function set.FontUnits(this,value)
      if isempty(value)
        this.FtUnits = this.DefaultFtUnits;
      else
        this.FtUnits = value;
      end
      set(this.HdlMainAxes,'FontUnits',this.FtUnits)
      this.FtSize = get(this.HdlMainAxes,'FontSize');
    end
    function value = get.FontUnits(this)
      value = this.FtUnits;
    end
    
    function set.FontWeight(this,value)
      if isempty(value)
        this.FtWeight = this.DefaultFtWeight;
      else
        this.FtWeight = value;
      end
      set(this.HdlMainAxes,'FontWeight',this.FtWeight)
    end
    function value = get.FontWeight(this)
      value = this.FtWeight;
    end
    
  end
  
end

