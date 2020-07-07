function Install-PSGalleryModule {
    param (
        [Parameter(Mandatory=$true)][string]$ModuleName,
        [Parameter(Mandatory=$false)][string][ValidateSet("CurrentUser","AllUsers")][PSDefaultValue(Help = 'CurrentUser')]$Scope = 'CurrentUser'
    )
    #Version 1.4
    Install-PackageProvider -Name NuGet -Scope $Scope -Force -Confirm:$false #Install or update NuGet package provider
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module PowerShellGet -Scope $Scope -Force -AllowClobber -Confirm:$false #Install or update PowerShellGet
    Start-Process -FilePath powershell.exe -ArgumentList "-WindowStyle Hidden -Command & {Install-Module $ModuleName -Scope $Scope -Force -AcceptLicense -Confirm:`$false}" -Wait #Start PowerShell in a new session, to prevent any issues with loaded modules etc
}