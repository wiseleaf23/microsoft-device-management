#Clean the start menu
#Run in logged on user context, 64-bit PowerShell host

#Variables
    $Name = "Data"
    $MainRegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount'
    $RegistryPath = (Get-ChildItem -Path $MainRegistryPath | Where-Object {$_.PSChildName -match 'start.tilegrid'}).PSPath + "\Current"

#Remove binary data, and restart explorer to rebuild this.
    Remove-ItemProperty -Path $RegistryPath -Name $Name -Force
    Stop-Process -Name "explorer" -Force
    Start-Process "explorer.exe"

#Start menu should now be set to the default profile
