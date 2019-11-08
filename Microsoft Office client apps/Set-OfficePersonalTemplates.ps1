#requires -version 2
<#
.SYNOPSIS
  Set personal templates for Word, PowerPoint and Excel

.DESCRIPTION
  Set personal templates for Word, PowerPoint and Excel, using registry properties. The Intune policies for this do not work at the moment, because of the lack of support for environment variables.

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:          1.1
  Template version: 1.3
  Author:           Axel Timmermans
  Creation Date:    2019-10-27
  Purpose/Change:   Added help text
  
.EXAMPLE
  Fill required configuration @ Declarations
  Deploy via Intune in user context and 64-bit PowerShell host.

#>

#region Parameters-----------------------------------------------------------------------------------------

#endregion-------------------------------------------------------------------------------------------------

#region Initializations------------------------------------------------------------------------------------

#endregion-------------------------------------------------------------------------------------------------

#region Declarations---------------------------------------------------------------------------------------

#REQUIRED CONFIGURATION
$AADName = "Contoso"
$LibraryName = "Sales - Documents"

#ItemProperty
$PropertyName = "PersonalTemplates"
$PropertyValue = "$env:USERPROFILE\$AADName\$LibraryName"
$PropertyType = "ExpandString"
$Keys = @(
    "HKCU:\Software\Microsoft\Office\16.0\PowerPoint\Options"
    "HKCU:\Software\Microsoft\Office\16.0\Word\Options"
    "HKCU:\Software\Microsoft\Office\16.0\Excel\Options"
)

#endregion-------------------------------------------------------------------------------------------------

#region Functions------------------------------------------------------------------------------------------

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

#endregion-------------------------------------------------------------------------------------------------


#region Execution------------------------------------------------------------------------------------------

foreach($Key in $Keys){
    Set-RegistryProperty -RegistryKey $Key -PropertyName $PropertyName -PropertyType $PropertyType -PropertyValue $PropertyValue
}

#endregion-------------------------------------------------------------------------------------------------