#requires -version 2
<#
.SYNOPSIS
    This script will get all ttf & otf files from the given SharePoint folder and its subdirectories (recursive) using the SharePointPnPmodule.
    After downloading the font files, they will be installed

.DESCRIPTION
    This script will get all ttf & otf files from the given SharePoint folder and its subdirectories (recursive) using the SharePointPnPmodule.
    After downloading the font files, they will be installed in the user folder for fonts, so this needs to run for every user. The PnP module is automatically installed in user context by the script. Deployment via Microsoft Endpoint Manager has been tested.

    Devices must be AAD joined, and SSO must not be disabled (it is enabled by default). The user must also have read access to the font files on SharePoint.

.PARAMETER URL
    The URL of the SharePoint site on which the fonts are located, for example: https://contoso.sharepoint.com/sites/sales. DO NOT end with /

.PARAMETER RelativeFolderPath
    The relative path on the SharePoint site URL in which the fonts are located, for example: Documents/Fonts/New

.INPUTS
    None

.OUTPUTS
    Fonts installed on the client machine

.NOTES
    Version:          1.2
    Template version: 1.4
    Author:           Axel Timmermans
    Creation Date:    2020-01-09
    Last change:      Added help text and support for OTF files, changed copy method for Font Files
  
.EXAMPLE
    When deploying via Microsoft Endpoint Manager:
    * Fill required variables
    * Test on AAD joined client machine
    * Deploy with 64-bit PowerShell host and in user context

#>

#region Parameters-----------------------------------------------------------------------------------------
Param (
    [string]$URL,
    [string]$RelativeFolderPath
)
#endregion-------------------------------------------------------------------------------------------------

#region Declarations---------------------------------------------------------------------------------------
#Required variables
$URL = "" 
$RelativeFolderPath = ""

#Other variables
$WorkingDir = "$env:TEMP\Install-Fonts"
$sa =  New-Object -ComObject shell.application
$Fonts =  $sa.NameSpace(20)
$FontsFolderUser = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
#endregion-------------------------------------------------------------------------------------------------

#region Functions------------------------------------------------------------------------------------------
function Install-PSGalleryModule {
    param (
        [Parameter(Mandatory=$true)][string]$ModuleName
    )
    #Version 1.1
    Install-PackageProvider -Name NuGet -Scope CurrentUser -Force -Confirm:$false
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module $ModuleName -Scope CurrentUser -Force -Confirm:$false
}
#endregion-------------------------------------------------------------------------------------------------

#region Execution------------------------------------------------------------------------------------------
#Check $WorkingDir existence and delete old folder if necessary
try{
    if(Test-Path $WorkingDir -ErrorAction SilentlyContinue){
        Remove-Item $WorkingDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $WorkingDir
}catch{
    Write-Error "Could not create temporary folder to download fonts"
}

#Install SharePointPnPPowerShellOnline module
Install-PSGalleryModule -ModuleName SharePointPnPPowerShellOnline

#Connect to PnPOnline
try {
    Connect-PnPOnline -Url $URL -UseWebLogin
}
catch {
    Write-Error "Could not connect to PnPOnline"
}

#Get fonts, download
$FontFiles = Find-PnPFile -Folder $RelativeFolderPath -Match *.ttf
$FontFiles += Find-PnPFile -Folder $RelativeFolderPath -Match *.otf
foreach($File in $FontFiles){
    Get-PnPFile -ServerRelativeUrl $File.ServerRelativeUrl -Path $WorkingDir -Filename $File.Name -AsFile -Force
}

#Disconnect
Disconnect-PnPOnline

#Install fonts
Get-ChildItem $WorkingDir -Recurse | ForEach-Object {
    If(Test-Path "$FontsFolderUser\$($_.Name)"){
        Write-Output "Font $($_.Name) already installed, skipping"
    }else {
        $Fonts.MoveHere($_.FullName)
    }
}

#Done
Remove-Item -Path $WorkingDir -Recurse -Force
Exit

#endregion-------------------------------------------------------------------------------------------------
