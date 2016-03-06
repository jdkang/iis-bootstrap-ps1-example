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
