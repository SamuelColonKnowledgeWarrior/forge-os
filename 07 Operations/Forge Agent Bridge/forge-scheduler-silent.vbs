Set shell = CreateObject("WScript.Shell")
shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File ""C:\Users\Family\OneDrive\Forge\Forge\07 Operations\Forge Agent Bridge\forge-scheduler.ps1"" -RunOnce", 0, True
