#requires -version 2
<#
.SYNOPSIS
  This script will convert Office ADMX files to allow them to be used with the Business version of the Office client apps.

.DESCRIPTION
  This script replaces text from the Office administrative templates to
  allow them to be used with the Business version of the Office client apps.

.PARAMETER AdmxFolder
  Path to the folder containing the ADMX files

.INPUTS
  Folder containing the ADMX files

.OUTPUTS
  None, the administrative template files will be overwritten.

.NOTES
  Version:          1.0
  Template version: 1.3
  Author:           Axel Timmermans
  Creation Date:    2019-07-28
  Purpose/Change:   Initial script development 
  
.EXAMPLE
  Create Office 365 Business ADMX.ps1 -AdmxFolder "C:\O365-ADMX"

  This will convert all ADMX files in C:\O365-ADMX to be used with Office 365 Business.

#>

#region Parameters-----------------------------------------------------------------------------------------

Param (
    [Parameter(Mandatory=$false)][string]$AdmxFolder
)

#endregion-------------------------------------------------------------------------------------------------

#region Initializations------------------------------------------------------------------------------------



#endregion-------------------------------------------------------------------------------------------------

#region Declarations---------------------------------------------------------------------------------------
    If(!$AdmxFolder){
        Read-Host -Prompt "Please enter the path to the folder containing the ADMX files"
    }

    $AdmxFiles = Get-ChildItem -Path $AdmxFolder -Recurse -Filter *.admx -Force

#endregion-------------------------------------------------------------------------------------------------

#region Functions------------------------------------------------------------------------------------------



#endregion-------------------------------------------------------------------------------------------------


#region Execution------------------------------------------------------------------------------------------

    #Replace the shit out of it
    ForEach($AdmxFile in $AdmxFiles){
        Write-Host "Now processing" $AdmxFile.Name -ForegroundColor Green
        $Content = Get-Content $AdmxFile.PSPath | Out-String
        $Content = $Content.Replace('.Office.Microsoft.Policies.Windows" />','.Office.Microsoft.Windows" />')
        $Content = $Content.Replace('software\policies\microsoft\office\16.0','software\microsoft\office\16.0')
        $Content += '<!-- PLEASE NOTE THAT THIS AMDX FILE HAS BEEN MODIFIED TO WORK WITH OFFICE 365 BUSINESS-->'
        $Content | Out-File -FilePath $AdmxFile.PSPath -Force
        Write-Host "Finished processing" $AdmxFile.Name -ForegroundColor Green
    }

    #Done
    Write-Host "All .admx files have been converted to work with Office 365 Business" -ForegroundColor Cyan
 
    #Additional warning   
    Write-Warning "At this moment (2019-07-16) the office16.admx file contains a policy named L_DisableVSTOLegacy1Or2
The associated key is not allowed to be written to by Intune, so this will throw an error. Remove this policy from the ADMX file
More information: https://docs.microsoft.com/en-us/windows/client-management/mdm/win32-and-centennial-app-policy-configuration"

#endregion-------------------------------------------------------------------------------------------------

    
