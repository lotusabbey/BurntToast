. $PSScriptRoot\Public\New-BurntToastNotification.ps1
. $PSScriptRoot\Private\Test-PSDifferentUser.ps1
. $PSScriptRoot\Private\ValidationScripts.ps1

if ([Environment]::OSVersion.Version.Major -ge 10)
{
    . $PSScriptRoot\Private\AdaptiveToast_Classes.ps1
}
