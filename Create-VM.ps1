#See https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help for more info on help
#requires -version 2
<#
.SYNOPSIS
  Create a new VM and perform some basi configuration tasks.

.DESCRIPTION
  This script will enable you to create a VM and perform some basic configuration tasks. I use this script when I need to setup a modern
  Windows 10 VM for testing purposes. Most variables are preconfigured so this script can be run quickly, but feel free to change these

.PARAMETER VmName
    Name of the VM to be created

.PARAMETER ISO
    ISO file to place in DVD drive

.INPUTS
  Setup media in ISO format

.OUTPUTS
  Newly created VM in Hyper-V

.NOTES
  Version:          1.0
  Template version: 1.3
  Author:           Axel Timmermans
  Creation Date:    2019-11-08
  Purpose/Change:   Initial script development, added help text
  
.EXAMPLE
  Create a VM with the name "Autopilot test 1" with the ISO file located at "D:\W10 x64 en-US.iso" mounted in the DVD drive
  
  Create-VM.ps1 -VmName "Autopilot test 1" -ISO "D:\W10 x64 en-US.iso"

#>


Param(
    [Parameter(Mandatory=$true)] [string] $VmName,
    [Parameter(Mandatory=$false)] [string] $ISO
)

#Variables, feel free to change these
$MemoryStartupBytes = "1073741824" #1024MB, because 512MB can cause a license agreement error when installing Windows 10
$SwitchName = "Default Switch"
$VmPath = "D:"
$VmPath = $VmPath.Replace('\','') #Don't edit
$VmGeneration = "2"
$NewVhdPath = "$VmPath\$VmName\Virtual Hard Disks\$VmName.vhdx" #Best not to edit
$NewVhdSizeBytes = "136365211648" #127GB, MS default
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
