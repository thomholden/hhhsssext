Attribute VB_Name = "TempAnomTool"
Dim tempGUI As TempAnomaly
Sub LaunchTempAnomGUI()
Attribute LaunchTempAnomGUI.VB_Description = "Macro recorded 4/20/2006 by Peter Webb 2"
Attribute LaunchTempAnomGUI.VB_ProcData.VB_Invoke_Func = " \n14"
    If tempGUI Is Nothing Then
        Set tempGUI = New TempAnomaly
    End If
    tempGUI.LaunchGUI
End Sub
