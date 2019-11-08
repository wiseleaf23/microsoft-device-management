#Variables
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\General'
$Name = 'ShownFileFmtPrompt'
$Value = '1'
$PropertyType = 'DWORD'

#Remove and set the property again
If(!(Test-Path $RegistryPath)){
    New-Item -Path $RegistryPath -Force
}
Remove-ItemProperty -Path $RegistryPath -Name $Name -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType $PropertyType
