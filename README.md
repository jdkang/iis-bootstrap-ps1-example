# iis-bootstrap-ps1-example
Example configuration of IIS for "boostrapping" Powershell scripts via a `curl | iex` style. Because, port 80/443 all the things?

## Note of Caution
This is intended for HTTPS **INTRANET** sites as running code. 

Yes, `iex` can be [considered harmful](https://blogs.msdn.microsoft.com/powershell/2011/06/03/invoke-expression-considered-harmful/), and [CSS tomfoolery](https://thejh.net/misc/website-terminal-copy-paste) exists to exploit the behavior. Nonetheless, this is how [Chocolatey](https://chocolatey.org/), [PsGet](http://psget.net/), and even [Homebrew](http://brew.sh/) bootstrap themselves. In any case, one should always approach code with caution (i.e. curl first without the `iex`).

## Examples
**Normal**
```powershell
(new-object net.webclient).DownloadString('https://site.contoso.local/bootstrap-thing.ps1')|iex
```
**NTLM**
```powershell
$wc=new-object net.webclient;$wc.UseDefaultCredentials=$true;$wc.DownloadString('https://site.contoso.local/windowsAuth/bootstrap-thang.ps1')|iex
```

## Setup
### Initial Site Setup
1. Use `.\setup-urlAuthorization-WindowsAuth.ps1` to
    1. Install [URL Authorization](http://www.iis.net/learn/manage/configuring-security/understanding-iis-url-authorization) feature (`Web-Url-Auth`)
    2. Configure [`authenticatedUserOverride`](https://www.iis.net/configreference/system.webserver/serverruntime) in your `appHostConfig` -- otherwise you have to grant authenticating users NTFS permissions (see [link](http://weblogs.asp.net/owscott/iis-using-windows-authentication-with-minimal-permissions-granted-to-disk))
2. In your site's top `web.config`, ensure you add [MIME maps](https://www.iis.net/configreference/system.webserver/staticcontent/mimemap) for at least `.ps1` -- if not for `.7z`, etc.

### Adding Windows Auth
You can use `.\enable-windowsAuthOnSitePath.ps1` to setup your `appHostConfig` for your site path as such:

1. Disable Anonymous authentication
2. Enable Windows authentication
    1. Clear existing Windows Auth Providers
    2. Add `NTLM` provider
    
However, how you setup that portion (even via the GUI) is up to you.

An example of setting up restrictions via [URL authorization rules](https://www.iis.net/configreference/system.webserver/security/authorization) against AD is in `site\windowsAuth\web.config`