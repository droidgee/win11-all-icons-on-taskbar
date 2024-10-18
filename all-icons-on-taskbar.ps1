# https://github.com/Liub0myr/win11-all-icons-on-taskbar

# "-WindowStyle hidden" in powershell arguments works faster
#PowerShell -WindowStyle hidden -Command "Out-Null"

# Change the priority to Low to reduce the impact on performance
(Get-Process -Id $PID).PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle

while ($true) {
    # Get a list of all possible icons
    try {
        $allIcons = Get-ChildItem -Path "HKCU:\Control Panel\NotifyIconSettings" -ErrorAction Stop
    }
    catch {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("[""Always show all icons and notifications on the taskbar"" fix by Liub0myr]: An error occurred while scanning the registry for new programs.")
        return 1
    }
    foreach ($key in $allIcons) { 
        #  Checking the status of the icon
        $isPromoted = Get-ItemProperty -Path $key.PSPath -Name "IsPromoted" -ErrorAction SilentlyContinue

        # >>>>> If you do NOT want the script to automatically enable the icons you have disabled, remove "-or $isPromoted.IsPromoted -ne 1" in the next line <<<<<
        if ($isPromoted -or $isPromoted.IsPromoted -ne 1) {
            # Enable icon display for a new app
            Set-ItemProperty -Path $key.PSPath -Name "IsPromoted" -Value 1
        }
    }

    # Check every 60 seconds
    Start-Sleep -Seconds 60
}