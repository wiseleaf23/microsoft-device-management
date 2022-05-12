Function Remove-RegistryProperty {
    #Version 1.1
    Param(
        [Parameter(Mandatory=$true)][string]$RegistryKey,
        [Parameter(Mandatory=$true)][string]$PropertyName
    )
    
    #If property is not specified, we need to delete an entire key, else, only remove property
    if(!$PropertyName){
        #Property is not specified, checking for and removing the entire key
        if(Get-Item -Path $RegistryKey -ErrorAction SilentlyContinue){
            Remove-Item -Path $RegistryKey -Recurse -Force -Confirm:$false -Verbose
        }else{
            Write-Output "Registry key $RegistryKey does not exist, doing nothing"
        }        
    }else {
        #Property is specified, checking for and removing the property
        if(Get-ItemProperty -Path $RegistryKey -Name $PropertyName -ErrorAction SilentlyContinue){
            Remove-ItemProperty -Path $RegistryKey -Name $PropertyName -Force -Confirm:$false -Verbose
        }else{
            Write-Output "Registry property $PropertyName in $RegistryKey does not exist, doing nothing"
        }
    }
}