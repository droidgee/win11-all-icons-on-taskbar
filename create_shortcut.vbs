Set oWS = WScript.CreateObject("WScript.Shell")

If WScript.Arguments.Count < 2 Then
    WScript.Echo "Usage: create_shortcut.vbs <shortcut_path> <target_path> <arguments>"
    WScript.Quit
End If

sLinkFile = WScript.Arguments(0)
sTargetPath = WScript.Arguments(1)

If WScript.Arguments.Count = 3 Then
    sArguments = WScript.Arguments(2)
Else
    sArguments = ""
End If

Set oLink = oWS.CreateShortcut(sLinkFile)
oLink.TargetPath = sTargetPath
oLink.Arguments = sArguments
oLink.WindowStyle = 7
oLink.Save
