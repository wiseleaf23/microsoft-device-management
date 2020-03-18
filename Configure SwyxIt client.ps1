#region Functions

Function Set-RegistryProperty {
    # Version 2.3
    Param(
        [Parameter(Mandatory=$true)][string]$RegistryKey,
        [Parameter(Mandatory=$true)][string]$PropertyName,
        [Parameter(Mandatory=$true)][string][ValidateSet("String","ExpandString","Binary","DWord","MultiString","Qword")]$PropertyType,
        [Parameter(Mandatory=$true)][string]$PropertyValue
    )
    #Check for registry key path and create if necassary
    If(!(Test-Path -Path $RegistryKey)){
        New-Item -Path $RegistryKey -Force
    }

    #Remove previous itemproperty with a different property type. Error will be ignored if it does not exist.
    Remove-ItemProperty -Path $RegistryKey -Name $PropertyName -Force -ErrorAction SilentlyContinue
    #Create new itemproperty with the right settins
    New-ItemProperty -Path $RegistryKey -Name $PropertyName -PropertyType $PropertyType -Value $PropertyValue -Force
}

Function Get-UserPrincipalName {
    #requires -version 2
    <#
    .SYNOPSIS
      This function will detected the logged on user's User Principal Name (UPN)

    .DESCRIPTION
      The function will detect the UPN by looking up the corresponding values in the registry. When these can't be found, or the UPN is Null, an error is returned.

    .PARAMETER
      None

    .INPUTS
      None

    .OUTPUTS
      User Principal Name, also known as UPN

    .NOTES
      Version:          1.2
      Template version: 1.3
      Author:           Axel Timmermans
      Creation Date:    2019-07-24
      Purpose/Change:   Added help text, added if statement to catch Null UPN, Updated variable name
  
    .EXAMPLE
      $UPN = Get-UserPrincipalName

    #>

    try{
        $objUser = New-Object System.Security.Principal.NTAccount($Env:USERNAME)
        $strSID = ($objUser.Translate([System.Security.Principal.SecurityIdentifier])).Value
        $basePath = "HKLM:\SOFTWARE\Microsoft\IdentityStore\Cache\$strSID\IdentityCache\$strSID"
        $UPN = (Get-ItemProperty -Path $basePath -Name UserName).UserName
        #Write error if UPN is Null
        If($UPN -eq $Null){
            Write-Error "Null UPN detected"
        }
        Return $UPN
    }catch{
        Write-Error "Failed to auto detect user principal name"
    }
}

#endregion

#region Execution

#Get AAD module
    $PackageProvider = Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue | Where-Object {$_.Version -ge 2.8}
    $AADModule = Get-InstalledModule -Name AzureAd -MinimumVersion 2.0 -ErrorAction SilentlyContinue
    if(!$PackageProvider){
        Install-PackageProvider -Name NuGet -Scope CurrentUser -Force -Confirm:$false
    }
    if(!$AADModule){
        Install-Module -Name AzureAd -Scope CurrentUser -Force -Confirm:$false
    }

#Connect with and get values from AAD. Disconnect after done
    $UPN = Get-UserPrincipalName
    Connect-AzureAD -AccountId $UPN
    $UserInfo = Get-AzureAdUser -ObjectId $UPN
    
    #Contact information - Physical
    $StreetAddress = $UserInfo.StreetAddress
    $City = $UserInfo.City
    $Country = $UserInfo.Country
    $State = $UserInfo.State
    $PostalCode = $UserInfo.PostalCode
        
    #Contact information - Digital
    $Email = $UserInfo.Mail
    $MobilePhone = $UserInfo.Mobile
    $OfficePhone = $UserInfo.TelephoneNumber

    #Company information
    $CompanyName = $UserInfo.CompanyName
    $Department = $UserInfo.Department
    $JobTitle = $UserInfo.JobTitle

    #Names
    $DisplayName = $UserInfo.DisplayName
    $FirstName = $UserInfo.GivenName
    $LastName = $UserInfo.Surname

    Disconnect-AzureAD

#Configure Swyx Server and Username (which is firstname + lastname)
    $RegKey = "HKCU:\Software\Swyx\SwyxIt!\CurrentVersion\Options"
    $PbxUser = $FirstName + " " + $LastName
    $PbxServer = "ap02.contoso.local"
    $AuthenticationType = "1"
    $UsePbxServerFromAutoDetection = "0"
    Set-RegistryProperty -RegistryKey $RegKey -PropertyName "PbxUser" -PropertyType String -PropertyValue $PbxUser
    Set-RegistryProperty -RegistryKey $RegKey -PropertyName "PbxServer" -PropertyType String -PropertyValue $PbxServer
    Set-RegistryProperty -RegistryKey $RegKey -PropertyName "TrustedAuthentication" -PropertyType DWord -PropertyValue $AuthenticationType
    Set-RegistryProperty -RegistryKey $RegKey -PropertyName "UsePbxServerFromAutoDetection" -PropertyType DWord -PropertyValue $UsePbxServerFromAutoDetection

#endregion
