Function Create-Junction {
    #Version 1.1
    Param(
        [Parameter(Mandatory=$false)] [switch] $Hidden, #Mark the junction as hidden
        [Parameter(Mandatory=$true)] $Source,
        [Parameter(Mandatory=$true)] $Destination
    )

    #Move
    If(Test-Path $Source){
        Move-Item -Path "$Source" -Destination "$Destination"
    }else {
        New-Item -ItemType Directory -Path $Destination
    }

    #Create Junction
    New-Item -ItemType Junction -Path $Source -Value $Destination

    #Hide Junction if Hidden is used
    If($Hidden){
        (Get-Item -Path $Source).Attributes += 'Hidden' #The method you use to set a hidden attribute is important, you dont want to overwrite existing attributes
    }
}