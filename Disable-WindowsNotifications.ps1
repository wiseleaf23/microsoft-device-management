#Script to disable all notifications

#Get all keys for notifications
    $MainPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\"
    $Name = "Enabled"
    $PropertyType = "DWord"
    $Value = "0"
    
    #Keys
    $Keys = @(
        'AD2F1837.HPPrinterControl_v10z8vjag6ke6!AD2F1837.HPPrinterControl'
        'DigitalPersona.Dashboard'
        'com.jabra.directonline',
        'FileZilla.Client.AppID',
        'Intel.Thunderbolt.UIApplication',
        'micr..tion_1975b8453054a2b5_a8362367f014c3d6',
        'Microsoft.Explorer.Notification.{3B857174-E254-8F32-03B5-14709557A805}',
        'Microsoft.Explorer.Notification.{94EF30AC-1D0F-B902-9128-27B0C308B31F}',
        'Microsoft.Management.Clients.IntuneManagementExtension',
        'Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge',
        'Microsoft.Office.lync.exe.15',
        'Microsoft.Office.OUTLOOK.EXE.15',
        'Microsoft.ScreenSketch_8wekyb3d8bbwe!App',
        'Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI',
        'Microsoft.Windows.InputSwitchToastHandler',
        'Microsoft.WindowsStore_8wekyb3d8bbwe!App',
        'QuietHours',
        'windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel',
        'Windows.System.AppInitiatedDownload',
        'Windows.System.Continuum',
        'Windows.SystemToast.AutoPlay',
        'Windows.SystemToast.DeviceManagement',
        'Windows.SystemToast.DisplaySettings',
        'Windows.SystemToast.HelloFace',
        'Windows.SystemToast.Print.Notification'
    )

#Check main path
    


#Set properties for each key
    foreach($Key in $Keys){
        If(!(Test-Path "$MainPath\$Key")){
            New-Item -Path $MainPath -Name $Key -Force
        }
        New-ItemProperty -Path "$MainPath\$Key" -Name $Name -PropertyType $PropertyType -Value $Value -Force
    }

#Done
    Exit