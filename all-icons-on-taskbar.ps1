# https://github.com/Liub0myr/win11-all-icons-on-taskbar

# "-WindowStyle hidden" in powershell arguments works faster
#PowerShell -WindowStyle hidden -Command "Out-Null"

# Change the priority to Low to reduce the impact on performance
(Get-Process -Id $PID).PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle

# Get the current user ID in the format S-1-5-21-3798938855-718814092-101549522-1001
$userID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value

# WMI doesn't support the HKEY_CURRENT_USER hive, so I use HKEY_USERS and user id
# "$null = ..." is used to avoid printing object information to the hidden console and reduce RAM usage by the conhost process
# It also reduces PowerShell's RAM consumption for some reason
$null = Register-WMIEvent -query "SELECT * FROM RegistryKeyChangeEvent WHERE Hive='HKEY_USERS' AND KeyPath='$userID\\Control Panel\\NotifyIconSettings'" -action {
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

        # >>>>> If you do NOT want the script to automatically enable manually disabled icons, remove "-or $isPromoted.IsPromoted -ne 1" in after the next line <<<<<
        # ! but in this case, if MS starts adding isPromoted = 0 for new programs in the future, the script will no longer work !
        if ($isPromoted -or $isPromoted.IsPromoted -ne 1) {
            # Enable icon display for a new app
            Set-ItemProperty -Path $key.PSPath -Name "IsPromoted" -Value 1
        }
    }
}