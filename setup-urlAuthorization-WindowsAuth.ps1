param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $site
)
function Ensure-Feature {
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    $feature
)
    if ((Get-WindowsFeature $feature).installstate -ne 'installed') {
        write-verbose "Installing $feature"
        Add-WindowsFeature $feature
    } else {
        write-verbose "$feature already installed" -f cyan
    }
}
function Ensure-WebadminAssembly {
    if (!('Microsoft.Web.Administration.ServerManager' -is [type])) {
        [System.Reflection.Assembly]::LoadFrom( ${env:windir} + "\system32\inetsrv\Microsoft.Web.Administration.dll" ) > $null
        if (!$?) { throw "Unable to laod Microsoft.Web.Administration.dll" }
    }
}
ipmo servermanager

# ---- url authorization ----
Ensure-Feature -feature 'Web-Url-Auth'

# ---- authenticatedUserOverride (use appPool permissions for windows users) ----
# appcmd.exe set config $site -section:system.webServer/serverRuntime /authenticatedUserOverride:"UseWorkerProcessUser" /commit:apphost
Ensure-WebadminAssembly
$serverManager = New-Object Microsoft.Web.Administration.ServerManager
$appHostConfig = $serverManager.GetApplicationHostConfiguration()

# Run NTFS requests as appPool user rather than authenticating user
$serverRuntimeSection = $apphostConfig.GetSection("system.webServer/serverRuntime", $site)
$serverRuntimeSection['authenticatedUserOverride'] = 'UseWorkerProcessUser'

# save
$serverManager.CommitChanges()
