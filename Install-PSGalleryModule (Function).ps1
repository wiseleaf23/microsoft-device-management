function Install-PSGalleryModule {
    param (
        [Parameter(Mandatory=$true)][string]$ModuleName
    )
    #Version 1.0
    Install-PackageProvider -Name NuGet -Force -Confirm:$false
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module $ModuleName -Scope CurrentUser -Force -Confirm:$false
}