# Thunderbolt

## test
When using a Thunderbolt dock in an business or even enterprise environment, a main problem is that by default, only local admin users are able to approve attached Thunderbolt devices. Initially, a fix for this was settings the registry property "HKLM\SYSTEM\CurrentControlSet\Services\ThunderboltService\TbtServiceSettings\ApprovalLevel" to 1 via a PowerShell script. Howeverm this sometimes presented some problems because of the default permissions (only Thunderbolt service had full control and system is the owner). So when deploying the script via Intune, I had a hard time finding the correct setting that would work on any PC, even thos who did not have Thunderbolt software installed yet.

So, what I did is create an ADMX template for this, which can be ingested by Intune, or deployed as you are used to via GPO. You can check it out on your local machine by importing the ADMX to %WinDir%\PolicyDefinitions and the ADML to %WinDir%\PolicyDefinitions\en-us The files are basic for now, but feel free to suggest improvements.
