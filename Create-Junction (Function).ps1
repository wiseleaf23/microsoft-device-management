Function Create-Junction {
    #Version 1.0
    Param(
        [Parameter(Mandatory=$true)] [switch] $Hidden, #Mark the junction as hidden
        [Parameter(Mandatory=$true)] $Source,
        [Parameter(Mandatory=$true)] $Destination
    )

    #Move
    Move-Item -Path "$Source" -Destination "$Destination"

    #Create Junction
    New-Item -ItemType Junction -Path $Source -Value $Destination

    #Hide Junction if Hidden is used
    If($Hidden){
        (Get-Item -Path $Source).Attributes += 'Hidden' #The method you use to set a hidden attribute is important, you dont want to overwrite existing attributes
    }
}