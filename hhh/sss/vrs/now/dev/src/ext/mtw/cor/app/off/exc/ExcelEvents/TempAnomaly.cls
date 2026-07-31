VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TempAnomaly"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private WithEvents tempGUI As GlobalTemp.GlobalTempClass
Attribute tempGUI.VB_VarHelpID = -1

Private Sub Class_Initialize()
    If tempGUI Is Nothing Then
        Set tempGUI = New GlobalTemp.GlobalTempClass
    End If
End Sub

Public Sub LaunchGUI()
    tempGUI.GlobalTemp
End Sub

Private Sub tempGUI_DisplayLocation(ByVal city As Variant, ByVal lat As Variant, ByVal lng As Variant)
    Dim str As String
    Dim latVal As Double
    Dim lngVal As Double
    latVal = lat
    lngVal = lng
    ActiveSheet.Cells(2, 1) = "Latitude"
    ActiveSheet.Cells(2, 2) = latVal
    ActiveSheet.Cells(3, 1) = "Longitude"
    ActiveSheet.Cells(3, 2) = lngVal
    ActiveSheet.Cells(4, 1) = "Selector"
    ActiveSheet.Cells(4, 2) = city
End Sub
' Label the X axis (a value axis) by using a dummy data series and data labels
' Thanks to Jon Peltier for this trick (www.peltier.com)
Private Sub SetXAxisLabels(chartObj As ChartObject, dateRange As Range, ByVal xLabels As Variant, ByVal startRow As Long, ByVal endRow As Long)
    Dim minY As Long
    Dim maxY As Long
    Dim xlabelStr As Variant
    
    ReDim xLabelData(UBound(xLabels(1, 1), 2) - 1) As Double
    For k = LBound(xLabels(1, 1), 2) To UBound(xLabels(1, 1), 2)
        xLabelData(k - 1) = xLabels(1, 1)(1, k)
    Next k
    
    xlabelStr = xLabels(1, 2)
    
    minY = chartObj.chart.Axes(xlValue, xlPrimary).MinimumScale
    maxY = chartObj.chart.Axes(xlValue, xlPrimary).MaximumScale
    ReDim minValueArray(UBound(xLabelData)) As Long
   
    For k = 0 To UBound(minValueArray)
        minValueArray(k) = minY
    Next k
    
    With chartObj.chart.SeriesCollection.NewSeries
        .Name = "X Axis Labels"
        .Values = minValueArray
        .xValues = xLabelData
        .MarkerBackgroundColorIndex = xlNone
        .MarkerForegroundColor = RGB(0, 0, 0)
        .MarkerStyle = xlPlus
        .MarkerSize = 8
    End With
    
    With chartObj.chart.SeriesCollection(3)
        For k = 1 To .Points.Count
            .Points(k).HasDataLabel = True
            With .Points(k).DataLabel
                .Text = " " + xlabelStr(k, 1) + " "
                .NumberFormat = "Text"
                .Type = xlDataLabelsShowLabel
                .Position = xlLabelPositionBelow
            End With
        Next k
    End With
   
    With chartObj.chart.Axes(xlValue, xlPrimary)
        .MinimumScale = minY
        .MaximumScale = maxY
    End With
    
    ' Turn off the automatically generated (and incredibly wrong) X axis
    ' labels, and make the X axis start and end at the first and last data
    ' points.
    With chartObj.chart.Axes(xlCategory, xlPrimary)
        .MajorTickMark = xlNone
        .MinorTickMark = xlNone
        .TickLabelPosition = xlTickLabelPositionNone
        .MinimumScale = xLabelData(0)
        .MaximumScale = xLabelData(UBound(xLabelData))
    End With
   
End Sub

Private Sub CreateChart(ByVal startRow As Long, ByVal rowCount As Long, ByVal tempCol As Long, ByVal fitCol As Long, ByVal datenumCol As Long, ByVal xLabels As Variant, ByVal latStr As String, ByVal lngStr As String)
    Dim tempRange As Range
    Dim fitRange As Range
    Dim dateRange As Range
    Dim dateStrRange As Range
    Dim topCell As Range
    Dim chartObj As ChartObject
    Dim endRow As Long
    
    Set chartObj = ActiveSheet.ChartObjects.Add _
        (Left:=150, Width:=500, Top:=75, Height:=500)
    chartObj.chart.ChartType = xlXYScatter
    
    endRow = startRow + rowCount - 1
    prevDataSize = rowCount
 
    Set dateRange = Range(ActiveSheet.Cells(startRow, datenumCol), ActiveSheet.Cells(endRow, datenumCol))
    
    Set topCell = ActiveSheet.Cells(startRow, tempCol)
    Set bottomCell = ActiveSheet.Cells(endRow, tempCol)
    Set tempRange = Range(topCell, bottomCell)
    chartObj.chart.SeriesCollection.Add Source:=tempRange
    With chartObj.chart.SeriesCollection(1)
        .Name = "Temperature Anomaly"
        .xValues = dateRange
    End With
    Set topCell = ActiveSheet.Cells(startRow, fitCol)
    Set bottomCell = ActiveSheet.Cells(endRow, fitCol)
    Set fitRange = Range(topCell, bottomCell)
    chartObj.chart.SeriesCollection.Add Source:=fitRange
    With chartObj.chart.SeriesCollection(2)
        .Name = "Regression (4th order)"
        .xValues = dateRange
    End With
   
    ' Custom label the X-axis: use date strings as labels
    Call SetXAxisLabels(chartObj, dateRange, xLabels, startRow, endRow)
    
    chartObj.chart.Legend.LegendEntries(3).Delete
    chartObj.chart.Legend.Position = xlLegendPositionTop
   
    ' Make sure the X-axis labels run across the bottom
    ' of the chart area.
    With chartObj.chart.Axes(xlValue)
        .Crosses = xlCustom
        .CrossesAt = .MinimumScale
    End With
          
    With chartObj.chart
        .HasTitle = True
        .ChartTitle.Characters.Text = "Temperature Anomaly Over Time (" + latStr + " " + lngStr + ")"
        .Axes(xlCategory, xlPrimary).HasTitle = True
        .Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "Date"
        .Axes(xlCategory, xlPrimary).AxisTitle.Top = .Axes(xlCategory, xlPrimary).AxisTitle.Top + 20
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = _
        "Variance, Degrees Centigrade"
    End With
    
End Sub

Private Sub tempGUI_PlotTempData(ByVal city As Variant, ByVal xData As Variant, ByVal localAnomData As Variant, ByVal fitval As Variant, ByVal latStr As Variant, ByVal lngStr As Variant)
    Dim index As Integer
    Dim tempCol As Integer
    Dim fitCol As Integer
    Dim dateCol As Integer
    Dim startRow As Integer
    Dim labelRange As Range
    Dim seriesSize As Integer
    Dim xLabels As Variant
    Dim xValues As Variant
    
    xValues = xData(1, 1)
    xLabels = xData(1, 2)
    
    If UBound(localAnomData, 1) > UBound(localAnomData, 2) Then
        seriesSize = UBound(localAnomData, 1)
    Else
        seriesSize = UBound(localAnomData, 2)
    End If
   
    ActiveSheet.Cells(1, 1) = "Global Temperature Anomaly History"
    ActiveSheet.Cells(1, 1).Font.Bold = True

    startRow = 8
    tempCol = 1
    fitCol = tempCol + 1
    dateCol = fitCol + 1
    
    If Not (ActiveSheet.ChartObjects Is Nothing) Then
        Dim oldDataRange As Range
        Dim oldDataSize As Long
        Dim endOldData As Range
        Set endOldData = ActiveSheet.Cells(startRow - 3, dateCol + 1).End(xlDown)
        Set oldDataRange = Range(ActiveSheet.Cells(startRow - 3, tempCol), endOldData)
        oldDataRange.Clear
        ActiveSheet.ChartObjects.Delete
    End If
    
    ActiveSheet.Cells(startRow - 2, tempCol) = "Temp."
    ActiveSheet.Cells(startRow - 1, tempCol) = "Anomaly"
    ActiveSheet.Cells(startRow - 2, fitCol) = "Trend"
    ActiveSheet.Cells(startRow - 1, fitCol) = "Line"
    ActiveSheet.Cells(startRow - 2, dateCol) = "Date"
    ActiveSheet.Cells(startRow - 1, dateCol) = "Number"
    Set labelRange = Range(ActiveSheet.Cells(startRow - 2, tempCol), _
                           ActiveSheet.Cells(startRow - 1, dateCol))
    labelRange.Font.Bold = True
    labelRange.HorizontalAlignment = xlCenter
    
    index = startRow
    ReDim dateArray(seriesSize - 1) As Long

    For rowCount = 1 To UBound(localAnomData, 1)
        For ColCount = 1 To UBound(localAnomData, 2)
            ActiveSheet.Cells(index, tempCol) = localAnomData(rowCount, ColCount)
            ActiveSheet.Cells(index, fitCol) = fitval(rowCount, ColCount)
            ActiveSheet.Cells(index, dateCol) = xValues(1, index - startRow + 1)
            index = index + 1
        Next ColCount
    Next rowCount
    
    ' Now the data is on the sheet, we can draw it.
    Call CreateChart(startRow, index - startRow, tempCol, fitCol, dateCol, xLabels, latStr, lngStr)
    
    ActiveSheet.Name = city
    
End Sub
