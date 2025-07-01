@echo off
rem https://github.com/Liub0myr/win11-all-icons-on-taskbar
title ^"Always show all icons and notifications on the taskbar^" fix by Liub0myr v2.01
color f
if exist "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\all-icons-on-taskbar.lnk" (goto :remove)
if exist "%userprofile%\all-icons-on-taskbar-min.ps1" (goto :remove)
:install
copy /v all-icons-on-taskbar-min.ps1 "%userprofile%" > nul
attrib +R +H "%userprofile%\all-icons-on-taskbar-min.ps1"
cscript create_shortcut.vbs "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\all-icons-on-taskbar.lnk" "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe" "-WindowStyle hidden -noprofile -NoExit -executionpolicy bypass -file %userprofile%\all-icons-on-taskbar-min.ps1" > nul
start /min %windir%\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -noprofile -NoExit -executionpolicy bypass -file %userprofile%\all-icons-on-taskbar-min.ps1
start /min %windir%\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -noprofile -executionpolicy bypass -file run-once-min.ps1
echo Installation complete.
rem echo Press any key to exit . . .
rem pause > nul
exit /b

:remove
echo Removing...
:remove-menu-powershell-ask
goto :remove-powershell-stop-skip
set choice=none
echo Stop all PowerShell shells and WMI asynchronous callbacks processes ?
echo 0. No ^(changes will take effect after logging out / restarting the computer^)
echo 1. Yes ^(not recommended! It may cause errors or UNFORESEEN CONSEQUENCES^)
set /p choice=
if %choice%==0 goto :remove-powershell-stop-skip
if %choice%==1 goto :remove-powershell-stop
cls
color e
echo Enter 0 or 1 only!
goto :remove-menu-powershell-ask
:remove-powershell-stop
taskkill /f /im powershell.exe > nul
taskkill /f /im unsecapp.exe > nul
:remove-powershell-stop-skip
color f
cls
attrib -R -H "%userprofile%\all-icons-on-taskbar-min.ps1" > nul
del /q "%userprofile%\all-icons-on-taskbar-min.ps1" > nul
del /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\all-icons-on-taskbar.lnk" > nul
cls
echo Removal complete. 
echo Press any key to exit . . .
pause > nul
exit /b
