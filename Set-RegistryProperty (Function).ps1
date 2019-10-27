Function Set-RegistryProperty {
    # Version 2.3
    Param(
        [Parameter(Mandatory=$true)][string]$RegistryKey,
        [Parameter(Mandatory=$true)][string]$PropertyName,
        [Parameter(Mandatory=$true)][string][ValidateSet("String","ExpandString","Binary","DWord","MultiString","Qword")]$PropertyType,
        [Parameter(Mandatory=$true)][string]$PropertyValue
    )
    #Check for registry key path and create if necassary
    If(!(Test-Path -Path $RegistryKey)){
        New-Item -Path $RegistryKey -Force
    }

    #Remove previous itemproperty with a different property type. Error will be ignored if it does not exist.
    Remove-ItemProperty -Path $RegistryKey -Name $PropertyName -Force -ErrorAction SilentlyContinue
    #Create new itemproperty with the right settins
    New-ItemProperty -Path $RegistryKey -Name $PropertyName -PropertyType $PropertyType -Value $PropertyValue -Force
}