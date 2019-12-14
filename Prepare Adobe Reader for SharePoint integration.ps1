#Variables to fill
$SharePointBaseUrl = "localnl.sharepoint.com" #For example "contoso.sharepoint.com"

Function Set-RegistryProperty {
    # Version 1.1
    Param(
        [Parameter(Mandatory=$true)][string]$RegistryPath,
        [Parameter(Mandatory=$true)][string]$PropertyName,
        [Parameter(Mandatory=$true)][string]$PropertyType,
        [Parameter(Mandatory=$true)][string]$PropertyValue
    )
    #Check for registry key path and create if necassary
    If(!(Test-Path -Path $RegistryPath)){
        New-Item -Path $RegistryPath -Force
    }
    #Remove previous itemproperty with a different property type. Error will be ignored if it does not exist.
    Remove-ItemProperty -Path $RegistryPath -Name $PropertyName -Force -ErrorAction SilentlyContinue
    #Create new itemproperty with the right settins
    New-ItemProperty -Path $RegistryPath -Name $PropertyName -PropertyType $PropertyType -Value $PropertyValue -Force
}

#Set trusted location
Set-RegistryProperty -RegistryPath "HKCU:\Software\Adobe\Acrobat Reader\DC\Privileged" -PropertyName "tHostWhiteList" -PropertyType "String" -PropertyValue $SharePointBaseUrl
#Set recent URL so this will be prefilled during SharePoint setup
Set-RegistryProperty -RegistryPath "HKCU:\Software\Adobe\Acrobat Reader\DC\AVCloud\cRecentURLs" -PropertyName "t1" -PropertyType "String" -PropertyValue "https://$SharePointBaseUrl"