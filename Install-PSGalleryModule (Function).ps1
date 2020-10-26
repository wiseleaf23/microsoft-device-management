function Install-PSGalleryModule {
    param (
        [Parameter(Mandatory=$true)][string]$ModuleName,
        [Parameter(Mandatory=$false)][string][ValidateSet("CurrentUser","AllUsers")][PSDefaultValue(Help = 'CurrentUser')]$Scope = 'CurrentUser'
    )
    #Version 1.6
    Install-PackageProvider -Name NuGet -Scope $Scope -Force -Confirm:$false #Install most recent NuGet package provider
    Install-Module PackageManagement -Scope $Scope -Force -AllowClobber -Confirm:$false #Install most recent PackageManagement, must be done before PSGet
    Install-Module PowerShellGet -Scope $Scope -Force -AllowClobber -Confirm:$false #Install most recent PowerShellGet
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Start-Process -FilePath powershell.exe -ArgumentList "-WindowStyle Hidden -Command & {Install-Module $ModuleName -Scope $Scope -Force -AcceptLicense -Confirm:`$false}" -Wait #Start PowerShell in a new session, to prevent any issues with loaded modules etc
}