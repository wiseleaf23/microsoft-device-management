#requires -version 2
<#
.SYNOPSIS
  This script prevents the default file type prompt when starting Word, Excel or PowerPoint for the first time.

.DESCRIPTION
  This script prevents the default file type prompt when starting Word, Excel or PowerPoint for the first time by setting a registry property.

.INPUTS
  None

.OUTPUTS
  'HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\General\ShownFileFmtPrompt' set to 1 instead of 0

.NOTES
  Version:          1.2
  Template version: 1.3
  Author:           Axel Timmermans
  Creation Date:    2019-12-18
  Purpose/Change:   Added help text, implemented Set-RegistryProperty function
  
.EXAMPLE
  Deploy using Microsoft Endpoint Manager with the following settings
  - 64-bit PowerShell host
  - Execute in user context!

#>

#Functions
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

#Variables
$RegistryKey = 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\General'
$PropertyName = 'ShownFileFmtPrompt'
$PropertyValue = '1'
$PropertyType = 'DWORD'

#Execution
Set-RegistryProperty -RegistryKey $RegistryKey -PropertyName $PropertyName -PropertyType $PropertyType -PropertyValue $PropertyValue