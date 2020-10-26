Function CheckFor-DriveMaps{
    Param(
        [Parameter(Mandatory=$true)][string]$DriveLetter,
        [Parameter(Mandatory=$true)][string]$RemotePath
    )

    #Check for current drivemap at $driveLetter. If so, open Explorer window, else, remove current drive map and create new one
    
    #Load modules
    Add-Type -AssemblyName System.Windows.Forms

    #Get all network drives, including broken ones with Get-CimInstance -Class Win32_NetworkConnection. More info: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-psdrive#examples
    $CurrentDriveMap = Get-CimInstance -Class Win32_NetworkConnection | Where-Object {$_.LocalName -Match "$DrivePath"}
    If($CurrentDriveMap){
        #Drive map detected at $DrivePath, but it is not the one we want, removing this
        Try{net use $DrivePath /Delete}
        Catch{
            $OUTPUT= [System.Windows.Forms.MessageBox]::Show("Removal of current mapping failed, please reboot and try again. Error: $($Error[0])", "$driveLetter error" , 0)
            Exit
        }
    }
}