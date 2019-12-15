#requires -version 2
<#
.SYNOPSIS
  This script enables you to export all WiFi profiles to a folder and import these later on a new machine.

.DESCRIPTION
  This script enables you to export all WiFi profiles to a folder and import these later on a new machine.
  This way, you wont't lose any Wi-Fi profiles when reinstallaing your machine, or when moving to a new machine.

.INPUTS
  When importing: the folder that contains the Wi-Fi profiles

.OUTPUTS
  When exporting: all WiFi profiles stored in the folder you enter

.NOTES
  Version:          1.0
  Template version: 1.3
  Author:           Axel Timmermans
  Creation Date:    2019-12-15
  Purpose/Change:   Converted script from two seperate batch files
  
.EXAMPLE
  <Example explanation goes here>
  
  <Example goes here. Repeat this attribute for more than one example>

#>


#region Functinons

Function Check-FolderExistence {
	#Version 1.2
    Param(
		[Parameter(Mandatory=$true)][string]$Folder
    )
    If(!(Test-Path -Path $Folder -ErrorAction SilentlyContinue)) {
        New-Item -ItemType "Directory" -Path $Folder
    }
}

#endregion

#region Variables

$Choice = Read-Host -Prompt "What do you want to do, List, Import or Export? Please enter your choice"
$Folder = Read-Host -Prompt "Which folder would you like to use to import or export? Please enter the full path, for example C:\Users\JohnDoe\Documents\WiFi profiles"

#endregion

Check-FolderExistence -Folder $Folder
Swith($Choice){
    "List"
        {netsh wlan show profiles}    
    "Export"
        {netsh wlan export profile key=clear folder=$Folder}
    "Import"
        {
            $Files = Get-ChildItem $Folder -Recurse -Include *.xml
            foreach($File in $Files){
                Write-Host "Now importing" $File.Name -ForegroundColor Green
                netsh wlan add profile filename="$($File.Name)" user=current
            }
        }

}
