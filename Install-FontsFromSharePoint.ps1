<#
This script will get all ttf files from the give SharePoint folder and its subdirectories (recursive) using the SharePointPnPmodule.
The PnP module is automatically installed in user context by the script. Deployment via Intune has been tested.

Devices must be AAD joined, and SSO must not be disabled (it is enabled by default).

Before deploying:
- Fill required variables
- Test

When deploying
- 64 bit PowerShell host
- User context

#>


#Required variables
    $URL = "" #for example "https://contoso.sharepoint.com/sites/sales". DO NOT end with /
    $RelativeFolderPath = "" #For example: Documents/Fonts/New

#Other variables
    $WorkingDir = "$env:TEMP\Install-Fonts"
    $sa =  New-Object -ComObject shell.application
    $Fonts =  $sa.NameSpace(20)

#Check $WorkingDir existence and delete old folder if necessary
    if(Test-Path $WorkingDir -ErrorAction SilentlyContinue){
        Remove-Item $WorkingDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $WorkingDir | Out-Null

#Install SharePointPnPPowerShellOnline module
    Install-PackageProvider -Name NuGet -Force -Confirm:$false
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module SharePointPnPPowerShellOnline -Scope CurrentUser -Force -Confirm:$false

#Connect, download
    #Connect and get fontfiles
    Connect-PnPOnline -Url $URL -UseWebLogin
    $FontFiles = Find-PnPFile -Folder $RelativeFolderPath -Match *.ttf
    #Loop throug each fontfile to download
    foreach($File in $FontFiles){
        Get-PnPFile -ServerRelativeUrl $File.ServerRelativeUrl -Path $WorkingDir -Filename $File.Name -AsFile -Force
    }

#Install fonts
    Get-ChildItem $WorkingDir -Recurse -Include *.ttf | % {$Fonts.MoveHere($_.FullName)}

#Done
    Exit