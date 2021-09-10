Function Remove-RegistryProperty {
    # Version 1.0
    Param(
        [Parameter(Mandatory=$true)][string]$RegistryKey,    
        [Parameter(Mandatory=$true)][string]$PropertyName
    )
    Write-Host "Removing property $PropertyName in $RegistryKey" -ForegroundColor Magenta
    if(Get-ItemProperty -Path $RegistryKey -Name $PropertyName -ErrorAction SilentlyContinue){
        Remove-ItemProperty -Path $RegistryKey -Name $PropertyName -Force
    }else{
        Write-Host "Registry property does not exist, so do nothing" -ForegroundColor Magenta
    }
}