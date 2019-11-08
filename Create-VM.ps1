#Create a new VM and perform basic config
Function Create-VM {
    Param(
        [Parameter(Mandatory=$true)] [string] $VmName,
        [Parameter(Mandatory=$false)] [string] $ISO
    )

    $MemoryStartupBytes = "1073741824"
    $SwitchName = "Default Switch"
    $VmPath = "D:"
    $VmPath = $VmPath.Replace('\','')
    $VmGeneration = "2"
    $NewVhdPath = "$VmPath\$VmName\Virtual Hard Disks\$VmName.vhdx"
    $NewVhdSizeBytes = "136365211648"
    $VmProcessorCount = "8"

    #Create VM
    $Args = @{
        Name = $VmName
        MemoryStartupBytes = $MemoryStartupBytes
        #BootDevice = 
        SwitchName = $SwitchName
        NewVHDPath = $NewVhdPath
        NewVHDSizeBytes = $NewVhdSizeBytes
        Path = $VmPath
        #Version
        #Prerelease
        #Experimental
        Generation = $VmGeneration
        #Force
        #AsJob
        #CimSession CimSession
        #ComputerName String
        #Credential PSCredential
        #WhatIf
        #Confirm
        #CommonParameters
    }
        
    New-VM @Args

    #Additional config
        #Enable Secure Boot & TPM
        Set-VMFirmware $VmName -EnableSecureBoot On
        Set-VMKeyProtector -VMName $VmName -NewLocalKeyProtector
        Enable-VMTPM -VMName $VmName

        #CPU's
        Set-VM -Name $VmName -ProcessorCount $VmProcessorCount

        #Add DVD drive & Set boot device
        If($ISO){
            $Args = @{
                #CimSession CimSession
                #ComputerName String
                #Credential PSCredential
                VMName = $VmName
                #ControllerNumber Int32
                #ControllerLocation Int32
                Path = $ISO
                #ResourcePoolName String
                #AllowUnverifiedPaths
                #Passthru
                #WhatIf
                #Confirm
                #CommonParameters
            }
            Add-VMDvdDrive @Args
            $VmDvdDrive = Get-VMDvdDrive -VMName $VmName
            Set-VMFirmware -VMName $VmName -FirstBootDevice  $VmDvdDrive
        }

}