. $PSScriptRoot\New-BurntToastNotification.ps1
. $PSScriptRoot\Test-PSDifferentUser.ps1
. $PSScriptRoot\ValidationScripts.ps1

if ([Environment]::OSVersion.Version.Major -ge 10)
{
    . $PSScriptRoot\AdaptiveToast_Classes.ps1
}
