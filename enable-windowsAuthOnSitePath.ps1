param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $sitePath
)
function Ensure-WebadminAssembly {
    if (!('Microsoft.Web.Administration.ServerManager' -is [type])) {
        [System.Reflection.Assembly]::LoadFrom( ${env:windir} + "\system32\inetsrv\Microsoft.Web.Administration.dll" ) > $null
        if (!$?) { throw "Unable to laod Microsoft.Web.Administration.dll" }
    }
}
Ensure-WebadminAssembly
$serverManager = New-Object Microsoft.Web.Administration.ServerManager
$appHostConfig = $serverManager.GetApplicationHostConfiguration()

# ---- Authentication ----
$anonAuthenticationSection = $apphostConfig.GetSection('system.webServer/security/authentication/anonymousAuthentication', $sitePath)
$windowsAuthenticationSection = $apphostConfig.GetSection('system.webServer/security/authentication/windowsAuthentication', $sitePath)
# Enable Windows Auth, Disable Anonymous
$anonAuthenticationSection['enabled'] = $false
$windowsAuthenticationSection['enabled'] = $true
# Windows Auth Providers (NTLM)
$windowsAuthproviders = $windowsAuthenticationSection.GetCollection('providers')
$ntlmProvider = $windowsAuthproviders.CreateElement('add')
$ntlmProvider['value'] = 'NTLM'
$windowsAuthproviders.Clear()
$windowsAuthproviders.Add($ntlmProvider)
# Save
$serverManager.CommitChanges()