#Variables
    param (
        [parameter(Mandatory=$true)][string]$rebootDataFolder, #folder to store reboot counter text file
        [parameter(Mandatory=$false)][int]$reboots #amount of reboots to perform, do not declare when using from scheduled task, otherwise mandatory
    )

    $scriptPath = $PSCommandPath
    $rebootsFile = "$rebootDataFolder\Reboots.xml"
    $counterFile = "$rebootDataFolder\RebootCounter.xml"
    $logFile = "$rebootDataFolder\RebootLogfile.log"

#Test reboot data folder
    If (!(Test-Path $rebootDataFolder)) {Write-Error "$rebootDataFolder not accessible, exiting"; Exit}
    
#Functions
    function Write-Log {
        param ([parameter(Mandatory=$true)][string]$text) #text to write to log
        $timeStamp = date -UFormat "%d-%m-%Y %H:%M | "
        Add-Content $logFile "$timeStamp $text"
    }

    function Export-StoredVariable {
        param (
            [parameter(Mandatory=$true)][string]$file, #file to export variable to
            [parameter(Mandatory=$true)]$variable #variable to export to file
        )
        $variable | export-clixml -path $file
        Write-Log "Variable with value of $variable exported to $file"
    }

    function Import-StoredVariable {
        param ([parameter(Mandatory=$true)][string]$file) #file to import variable from
        $variable = import-clixml -path $file
        Return $variable
        Write-Log "Variable with value of $variable imported from $file"
    }

    function Create-RebootTask {
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy ByPass -File `"$scriptPath`" -rebootDataFolder `"$rebootDataFolder`""
        $trigger =  New-ScheduledTaskTrigger -AtLogOn
        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Reboot" -Description "Reboot" -User "System"
        Write-Log "Reboot task created"
    }

Write-Log "Reboot.ps1 started, Variables set, Functions defined"

#Check variables and perform action
    #Folder exist but no counter file? Create stored variables
    If ((Test-Path $rebootDataFolder) -and (!(Test-Path $counterFile))){
        Write-Log "If statement: Folder exist but no counter file? Create stored variables"
        $Global:counter = 0
        Export-StoredVariable -file $rebootsFile -variable $reboots
        Export-StoredVariable -file $counterFile -variable $counter
    }
    
    #Folder exists and file exists? Get variables from files and perform reboot if necesarry
    If (Test-Path $counterFile) {
        Write-Log "If statement: Folder exists and file exists? Get variables from files and perform reboot if necesarry"
        $Global:counter = Import-StoredVariable -file $counterFile
        $Global:reboots = Import-StoredVariable -file $rebootsFile
        
        #First reboot?
        If($counter -eq 0) {
            Write-Log "If statement: First reboot"

            #Add module for MessageBox
            Add-Type -AssemblyName PresentationFramework
            Write-Log "PresentationFramework module loaded"

            #Notify user on required reboot, wait for approval
            [System.Windows.MessageBox]::Show("OfficeGrip requested a reboot for maintenance. Feel free to finish your work. When finished, press OK to reboot")
            Write-Log "User approved reboot"

            Create-RebootTask
            $counter++; Write-Log "Counter increased"
            Export-StoredVariable -file $counterFile -variable $counter
            shutdown.exe -r -f -t 5; Write-Log "Rebooting..."
            sleep 30
        }

        #Not the first reboot, do we still need to perform a reboot?
        If ($counter -lt $reboots) {
            Write-Log "If statement: Not the first reboot, do we still need to perform a reboot?"
            $counter++; Write-Log "Counter increased"
            Export-StoredVariable -file $counterFile -variable $counter
            shutdown -r -f -t 5; Write-Log "Rebooting..."
            sleep 30
        }
        #No more reboots needed or invalid data
        else {
            Write-Log "If statement: No more reboots needed or invalid data"
            Unregister-ScheduledTask -TaskName "Reboot" -Confirm:$false; Write-Log "Scheduled task deleted"
            #Custom commands after reboots:

        }
    }
    Write-Log "End of script"
