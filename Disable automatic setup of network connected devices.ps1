﻿#requires -version 2
<#
.SYNOPSIS
  Disable automatic setup of network connected devices.

.DESCRIPTION
  This script will create a task in Task Scheduler that checks on every login if the automtic setup of network connected devices is disabled.
  This settings is known to re-enable after certain updates, so it checks on every login.
  
  There are no policies available for this at the moment, and the part of the registry that sets this is forbidden to be written to by Intune.

.PARAMETER
  None

.INPUTS
  None

.OUTPUTS
  - The scheduled task XML that will be imported, in $Temp
  - The PowerShell script that will be run by the scheduled task, in System32

.NOTES
  Version:          1.1
  Template version: 1.3
  Author:           Axel Timmermans
  Creation Date:    2019-08-18
  Purpose/Change:   Added help text
  
.EXAMPLE
  Deploy script using Intune in system context and 64-bit PowerShell host.

#>

#region Parameters-----------------------------------------------------------------------------------------

#endregion-------------------------------------------------------------------------------------------------

#region Initializations------------------------------------------------------------------------------------

#Write XML
    $XmlPath = "$env:TEMP\Set automatic setup of network connected devices.xml"
    $Base64Xml = '//48AD8AeABtAGwAIAB2AGUAcgBzAGkAbwBuAD0AIgAxAC4AMAAiACAAZQBuAGMAbwBkAGkAbgBnAD0AIgBVAFQARgAtADEANgAiAD8APgANAAoAPABUAGEAcwBrACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADQAIgAgAHgAbQBsAG4AcwA9ACIAaAB0AHQAcAA6AC8ALwBzAGMAaABlAG0AYQBzAC4AbQBpAGMAcgBvAHMAbwBmAHQALgBjAG8AbQAvAHcAaQBuAGQAbwB3AHMALwAyADAAMAA0AC8AMAAyAC8AbQBpAHQALwB0AGEAcwBrACIAPgANAAoAIAAgADwAUgBlAGcAaQBzAHQAcgBhAHQAaQBvAG4ASQBuAGYAbwA+AA0ACgAgACAAIAAgADwARABhAHQAZQA+ADIAMAAxADkALQAwADcALQAxADYAVAAxADcAOgA1ADQAOgAzADEALgA2ADIANwA4ADUAMQAxADwALwBEAGEAdABlAD4ADQAKACAAIAAgACAAPABBAHUAdABoAG8AcgA+AE8ARgBGAEkAQwBFAEcAUgBJAFAAXABhAHQAaQBtAG0AZQByAG0AYQBuAHMAXwBvAGcAPAAvAEEAdQB0AGgAbwByAD4ADQAKACAAIAAgACAAPABVAFIASQA+AFwAUwBlAHQAIABhAHUAdABvAG0AYQB0AGkAYwAgAHMAZQB0AHUAcAAgAG8AZgAgAG4AZQB0AHcAbwByAGsAIABjAG8AbgBuAGUAYwB0AGUAZAAgAGQAZQB2AGkAYwBlAHMAPAAvAFUAUgBJAD4ADQAKACAAIAA8AC8AUgBlAGcAaQBzAHQAcgBhAHQAaQBvAG4ASQBuAGYAbwA+AA0ACgAgACAAPABUAHIAaQBnAGcAZQByAHMAPgANAAoAIAAgACAAIAA8AEwAbwBnAG8AbgBUAHIAaQBnAGcAZQByAD4ADQAKACAAIAAgACAAIAAgADwARQBuAGEAYgBsAGUAZAA+AHQAcgB1AGUAPAAvAEUAbgBhAGIAbABlAGQAPgANAAoAIAAgACAAIAA8AC8ATABvAGcAbwBuAFQAcgBpAGcAZwBlAHIAPgANAAoAIAAgADwALwBUAHIAaQBnAGcAZQByAHMAPgANAAoAIAAgADwAUAByAGkAbgBjAGkAcABhAGwAcwA+AA0ACgAgACAAIAAgADwAUAByAGkAbgBjAGkAcABhAGwAIABpAGQAPQAiAEEAdQB0AGgAbwByACIAPgANAAoAIAAgACAAIAAgACAAPABVAHMAZQByAEkAZAA+AFMALQAxAC0ANQAtADEAOAA8AC8AVQBzAGUAcgBJAGQAPgANAAoAIAAgACAAIAAgACAAPABSAHUAbgBMAGUAdgBlAGwAPgBIAGkAZwBoAGUAcwB0AEEAdgBhAGkAbABhAGIAbABlADwALwBSAHUAbgBMAGUAdgBlAGwAPgANAAoAIAAgACAAIAA8AC8AUAByAGkAbgBjAGkAcABhAGwAPgANAAoAIAAgADwALwBQAHIAaQBuAGMAaQBwAGEAbABzAD4ADQAKACAAIAA8AFMAZQB0AHQAaQBuAGcAcwA+AA0ACgAgACAAIAAgADwATQB1AGwAdABpAHAAbABlAEkAbgBzAHQAYQBuAGMAZQBzAFAAbwBsAGkAYwB5AD4AUABhAHIAYQBsAGwAZQBsADwALwBNAHUAbAB0AGkAcABsAGUASQBuAHMAdABhAG4AYwBlAHMAUABvAGwAaQBjAHkAPgANAAoAIAAgACAAIAA8AEQAaQBzAGEAbABsAG8AdwBTAHQAYQByAHQASQBmAE8AbgBCAGEAdAB0AGUAcgBpAGUAcwA+AGYAYQBsAHMAZQA8AC8ARABpAHMAYQBsAGwAbwB3AFMAdABhAHIAdABJAGYATwBuAEIAYQB0AHQAZQByAGkAZQBzAD4ADQAKACAAIAAgACAAPABTAHQAbwBwAEkAZgBHAG8AaQBuAGcATwBuAEIAYQB0AHQAZQByAGkAZQBzAD4AdAByAHUAZQA8AC8AUwB0AG8AcABJAGYARwBvAGkAbgBnAE8AbgBCAGEAdAB0AGUAcgBpAGUAcwA+AA0ACgAgACAAIAAgADwAQQBsAGwAbwB3AEgAYQByAGQAVABlAHIAbQBpAG4AYQB0AGUAPgB0AHIAdQBlADwALwBBAGwAbABvAHcASABhAHIAZABUAGUAcgBtAGkAbgBhAHQAZQA+AA0ACgAgACAAIAAgADwAUwB0AGEAcgB0AFcAaABlAG4AQQB2AGEAaQBsAGEAYgBsAGUAPgB0AHIAdQBlADwALwBTAHQAYQByAHQAVwBoAGUAbgBBAHYAYQBpAGwAYQBiAGwAZQA+AA0ACgAgACAAIAAgADwAUgB1AG4ATwBuAGwAeQBJAGYATgBlAHQAdwBvAHIAawBBAHYAYQBpAGwAYQBiAGwAZQA+AGYAYQBsAHMAZQA8AC8AUgB1AG4ATwBuAGwAeQBJAGYATgBlAHQAdwBvAHIAawBBAHYAYQBpAGwAYQBiAGwAZQA+AA0ACgAgACAAIAAgADwASQBkAGwAZQBTAGUAdAB0AGkAbgBnAHMAPgANAAoAIAAgACAAIAAgACAAPABTAHQAbwBwAE8AbgBJAGQAbABlAEUAbgBkAD4AdAByAHUAZQA8AC8AUwB0AG8AcABPAG4ASQBkAGwAZQBFAG4AZAA+AA0ACgAgACAAIAAgACAAIAA8AFIAZQBzAHQAYQByAHQATwBuAEkAZABsAGUAPgBmAGEAbABzAGUAPAAvAFIAZQBzAHQAYQByAHQATwBuAEkAZABsAGUAPgANAAoAIAAgACAAIAA8AC8ASQBkAGwAZQBTAGUAdAB0AGkAbgBnAHMAPgANAAoAIAAgACAAIAA8AEEAbABsAG8AdwBTAHQAYQByAHQATwBuAEQAZQBtAGEAbgBkAD4AdAByAHUAZQA8AC8AQQBsAGwAbwB3AFMAdABhAHIAdABPAG4ARABlAG0AYQBuAGQAPgANAAoAIAAgACAAIAA8AEUAbgBhAGIAbABlAGQAPgB0AHIAdQBlADwALwBFAG4AYQBiAGwAZQBkAD4ADQAKACAAIAAgACAAPABIAGkAZABkAGUAbgA+AHQAcgB1AGUAPAAvAEgAaQBkAGQAZQBuAD4ADQAKACAAIAAgACAAPABSAHUAbgBPAG4AbAB5AEkAZgBJAGQAbABlAD4AZgBhAGwAcwBlADwALwBSAHUAbgBPAG4AbAB5AEkAZgBJAGQAbABlAD4ADQAKACAAIAAgACAAPABEAGkAcwBhAGwAbABvAHcAUwB0AGEAcgB0AE8AbgBSAGUAbQBvAHQAZQBBAHAAcABTAGUAcwBzAGkAbwBuAD4AZgBhAGwAcwBlADwALwBEAGkAcwBhAGwAbABvAHcAUwB0AGEAcgB0AE8AbgBSAGUAbQBvAHQAZQBBAHAAcABTAGUAcwBzAGkAbwBuAD4ADQAKACAAIAAgACAAPABVAHMAZQBVAG4AaQBmAGkAZQBkAFMAYwBoAGUAZAB1AGwAaQBuAGcARQBuAGcAaQBuAGUAPgB0AHIAdQBlADwALwBVAHMAZQBVAG4AaQBmAGkAZQBkAFMAYwBoAGUAZAB1AGwAaQBuAGcARQBuAGcAaQBuAGUAPgANAAoAIAAgACAAIAA8AFcAYQBrAGUAVABvAFIAdQBuAD4AZgBhAGwAcwBlADwALwBXAGEAawBlAFQAbwBSAHUAbgA+AA0ACgAgACAAIAAgADwARQB4AGUAYwB1AHQAaQBvAG4AVABpAG0AZQBMAGkAbQBpAHQAPgBQAFQAMQBIADwALwBFAHgAZQBjAHUAdABpAG8AbgBUAGkAbQBlAEwAaQBtAGkAdAA+AA0ACgAgACAAIAAgADwAUAByAGkAbwByAGkAdAB5AD4ANwA8AC8AUAByAGkAbwByAGkAdAB5AD4ADQAKACAAIAAgACAAPABSAGUAcwB0AGEAcgB0AE8AbgBGAGEAaQBsAHUAcgBlAD4ADQAKACAAIAAgACAAIAAgADwASQBuAHQAZQByAHYAYQBsAD4AUABUADEATQA8AC8ASQBuAHQAZQByAHYAYQBsAD4ADQAKACAAIAAgACAAIAAgADwAQwBvAHUAbgB0AD4AMwA8AC8AQwBvAHUAbgB0AD4ADQAKACAAIAAgACAAPAAvAFIAZQBzAHQAYQByAHQATwBuAEYAYQBpAGwAdQByAGUAPgANAAoAIAAgADwALwBTAGUAdAB0AGkAbgBnAHMAPgANAAoAIAAgADwAQQBjAHQAaQBvAG4AcwAgAEMAbwBuAHQAZQB4AHQAPQAiAEEAdQB0AGgAbwByACIAPgANAAoAIAAgACAAIAA8AEUAeABlAGMAPgANAAoAIAAgACAAIAAgACAAPABDAG8AbQBtAGEAbgBkAD4AUABvAHcAZQByAFMAaABlAGwAbAAuAGUAeABlADwALwBDAG8AbQBtAGEAbgBkAD4ADQAKACAAIAAgACAAIAAgADwAQQByAGcAdQBtAGUAbgB0AHMAPgAtAEUAeABlAGMAdQB0AGkAbwBuAFAAbwBsAGkAYwB5ACAAQgB5AFAAYQBzAHMAIAAtAFcAaQBuAGQAbwB3AFMAdAB5AGwAZQAgAEgAaQBkAGQAZQBuACAALQBGAGkAbABlACAAIgAlAHcAaQBuAGQAaQByACUAXABTAHkAcwB0AGUAbQAzADIAXABTAGUAdAAgAGEAdQB0AG8AbQBhAHQAaQBjACAAcwBlAHQAdQBwACAAbwBmACAAbgBlAHQAdwBvAHIAawAgAGMAbwBuAG4AZQBjAHQAZQBkACAAZABlAHYAaQBjAGUAcwAuAHAAcwAxACIAPAAvAEEAcgBnAHUAbQBlAG4AdABzAD4ADQAKACAAIAAgACAAPAAvAEUAeABlAGMAPgANAAoAIAAgADwALwBBAGMAdABpAG8AbgBzAD4ADQAKADwALwBUAGEAcwBrAD4A'
    $bytes = [Convert]::FromBase64String($Base64Xml)
    [IO.File]::WriteAllBytes($XmlPath, $bytes)
    $XmlContent = Get-Content -Path $XmlPath | Out-String

#Write PowerShell script
    $PsScriptPath = "$env:windir\System32\Set automatic setup of network connected devices.ps1"
    $Base64PsScript = '77u/RnVuY3Rpb24gU2V0LVJlZ2lzdHJ5UHJvcGVydHkgew0KICAgICMgVmVyc2lvbiAyLjENCiAgICBQYXJhbSgNCiAgICAgICAgW1BhcmFtZXRlcihNYW5kYXRvcnk9JHRydWUpXVtzdHJpbmddJFJlZ2lzdHJ5S2V5LA0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeT0kdHJ1ZSldW3N0cmluZ10kUHJvcGVydHlOYW1lLA0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeT0kdHJ1ZSldW3N0cmluZ10kUHJvcGVydHlUeXBlLA0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeT0kdHJ1ZSldW3N0cmluZ10kUHJvcGVydHlWYWx1ZSwNCiAgICAgICAgW1BhcmFtZXRlcihNYW5kYXRvcnk9JHRydWUpXVtWYWxpZGF0ZVNldCgiVXNlciIsIkFkbWluaXN0cmF0b3IiLCJTWVNURU0iKV1bc3RyaW5nXSRDb250ZXh0ICNUaGUgY29udGV4dCB0aGUgc2NyaXB0IHdpbGwgYmUgcmFuIGFzLiBVc2VyLCBTWVNURU0gb3IgQWRtaW5pc3RyYXRvcj8NCiAgICApDQogICAgI0NoZWNrIGZvciByZWdpc3RyeSBrZXkgcGF0aCBhbmQgY3JlYXRlIGlmIG5lY2Fzc2FyeQ0KICAgIElmKCEoVGVzdC1QYXRoIC1QYXRoICRSZWdpc3RyeUtleSkpew0KICAgICAgICBOZXctSXRlbSAtUGF0aCAkUmVnaXN0cnlLZXkgLUZvcmNlDQogICAgfQ0KDQogICAgI1NldCBwZXJtaXNzaW9ucyBmb3Iga2V5IGlmIGl0IGlzIG5vdCBydW4gYXMgdXNlcg0KICAgIElmKCRDb250ZXh0IC1uZSAiVXNlciIpew0KICAgICAgICAjTW9kaWZ5IEFDTCB1c2luZyAuTmV0IG1ldGhvZHMsIGFuZCBnaXZlICJTWVNURU0iIG9yICJBZG1pbmlzdHJhdG9ycyIgZnVsbCBhY2Nlc3MgdG8gcmVnaXN0cnkga2V5DQogICAgICAgICRSZWdLZXlEb3RORVRJdGVtID0gW01pY3Jvc29mdC5XaW4zMi5SZWdpc3RyeV06OkxvY2FsTWFjaGluZS5PcGVuU3ViS2V5KCRSZWdpc3RyeUtleS5UcmltKCdIS0xNOlwnKSxbTWljcm9zb2Z0LldpbjMyLlJlZ2lzdHJ5S2V5UGVybWlzc2lvbkNoZWNrXTo6UmVhZFdyaXRlU3ViVHJlZSxbU3lzdGVtLlNlY3VyaXR5LkFjY2Vzc0NvbnRyb2wuUmVnaXN0cnlSaWdodHNdOjpDaGFuZ2VQZXJtaXNzaW9ucykNCiAgICAgICAgJERvdE5FVF9BQ0wgPSAkUmVnS2V5RG90TkVUSXRlbS5HZXRBY2Nlc3NDb250cm9sKCkNCiAgICAgICAgU3dpdGNoKCRDb250ZXh0KXsNCiAgICAgICAgICAgICJTWVNURU0ieyREb3RORVRfQWNjZXNzUnVsZSA9IE5ldy1PYmplY3QgU3lzdGVtLlNlY3VyaXR5LkFjY2Vzc0NvbnRyb2wuUmVnaXN0cnlBY2Nlc3NSdWxlICgiU3lzdGVtIiwiRnVsbENvbnRyb2wiLCJBbGxvdyIpfQ0KICAgICAgICAgICAgIkFkbWluaXN0cmF0b3IieyREb3RORVRfQWNjZXNzUnVsZSA9IE5ldy1PYmplY3QgU3lzdGVtLlNlY3VyaXR5LkFjY2Vzc0NvbnRyb2wuUmVnaXN0cnlBY2Nlc3NSdWxlICgiQWRtaW5pc3RyYXRvcnMiLCJGdWxsQ29udHJvbCIsIkFsbG93Iil9DQogICAgICAgIH0NCiAgICAgICAgJERvdE5FVF9BQ0wuU2V0QWNjZXNzUnVsZSgkRG90TkVUX0FjY2Vzc1J1bGUpDQogICAgICAgICRSZWdLZXlEb3RORVRJdGVtLlNldEFjY2Vzc0NvbnRyb2woJERvdE5FVF9BQ0wpDQogICAgfQ0KDQogICAgI1JlbW92ZSBwcmV2aW91cyBpdGVtcHJvcGVydHkgd2l0aCBhIGRpZmZlcmVudCBwcm9wZXJ0eSB0eXBlLiBFcnJvciB3aWxsIGJlIGlnbm9yZWQgaWYgaXQgZG9lcyBub3QgZXhpc3QuDQogICAgUmVtb3ZlLUl0ZW1Qcm9wZXJ0eSAtUGF0aCAkUmVnaXN0cnlLZXkgLU5hbWUgJFByb3BlcnR5TmFtZSAtRm9yY2UgLUVycm9yQWN0aW9uIFNpbGVudGx5Q29udGludWUNCiAgICAjQ3JlYXRlIG5ldyBpdGVtcHJvcGVydHkgd2l0aCB0aGUgcmlnaHQgc2V0dGlucw0KICAgIE5ldy1JdGVtUHJvcGVydHkgLVBhdGggJFJlZ2lzdHJ5S2V5IC1OYW1lICRQcm9wZXJ0eU5hbWUgLVByb3BlcnR5VHlwZSAkUHJvcGVydHlUeXBlIC1WYWx1ZSAkUHJvcGVydHlWYWx1ZSAtRm9yY2UNCn0NCg0KI1NldCB0aGUga2V5DQogICAgJFJlZ2lzdHJ5S2V5ID0gIkhLTE06XFNPRlRXQVJFXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRWZXJzaW9uXE5jZEF1dG9TZXR1cFxQcml2YXRlIg0KICAgICRQcm9wZXJ0eU5hbWUgPSAiQXV0b1NldHVwIg0KICAgICRQcm9wZXJ0eVR5cGUgPSAiRFdPUkQiDQogICAgJFByb3BlcnR5VmFsdWUgPSAiMCINCiAgICBTZXQtUmVnaXN0cnlQcm9wZXJ0eSAtUmVnaXN0cnlLZXkgJFJlZ2lzdHJ5S2V5IC1Qcm9wZXJ0eU5hbWUgJFByb3BlcnR5TmFtZSAtUHJvcGVydHlUeXBlICRQcm9wZXJ0eVR5cGUgLVByb3BlcnR5VmFsdWUgJFByb3BlcnR5VmFsdWUgLUNvbnRleHQgU1lTVEVN'
    $bytes = [Convert]::FromBase64String($Base64PsScript)
    [IO.File]::WriteAllBytes($PsScriptPath, $bytes)


#endregion-------------------------------------------------------------------------------------------------

#region Declarations---------------------------------------------------------------------------------------

#endregion-------------------------------------------------------------------------------------------------

#region Functions------------------------------------------------------------------------------------------

#endregion-------------------------------------------------------------------------------------------------


#region Execution------------------------------------------------------------------------------------------

#Import and first run
    $TaskName = "Set automatic setup of network connected devices"
    Register-ScheduledTask -Xml $XmlContent -TaskName $TaskName –Force
    Start-ScheduledTask -TaskName $TaskName

#Done
    Exit

#endregion-------------------------------------------------------------------------------------------------
