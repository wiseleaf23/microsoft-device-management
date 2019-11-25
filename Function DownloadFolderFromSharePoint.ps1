Function DownloadFolderFromSharePoint{
    #Version 1.0
    #IMPORTANT: please prevent Internet Explorer first run using "Prevent running First Run wizard" policy - This registry key cannot be changed as a user. The script will set the key if the user is a local admin
    #The script will open IE and Windows Explorer in the foreground, to set the required cookies. If you knwo a way to fix this, please let me know.

    Param(
        [Parameter(Mandatory=$true)][string]$SharePointUrl, #For example: contoso.sharepoint.com - DO NOT end with /
        [Parameter(Mandatory=$true)][string]$SpRelativeUrl, #For example: sites/branding/Shared Documents/Fonts - DO NOT begin or end with '/'
        [Parameter(Mandatory=$true)][string]$TargetDir #Target Directory
    )

    #Functions
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

    #Variables
    $SpRelativeUrl = $SpRelativeUrl.Replace('/','\')
    $WebDavUrl = "\\$SharePointUrl@SSL\DavWWWRoot\$SpRelativeUrl"
    $TenantName = $SharePointUrl.Split('.')[0]

    #Disable IE first run
    $RegistryKey = "HKCU:\Software\Policies\Microsoft\Internet Explorer\Main"
    $PropertyName = "DisableFirstRunCustomize"
    $PropertyType = "DWord"
    $PropertyValue = "2"
    Set-RegistryProperty -RegistryKey $RegistryKey -PropertyName $PropertyName -PropertyType $PropertyType -PropertyValue $PropertyValue -ErrorAction SilentlyContinue #EA SilentlyContinue to prevent error is user is not a local admin
    
    #Add the site as trusted using the "Site to Zone Assignment List" policy
    $RegistryKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\sharepoint.com\$TenantName"
    $PropertyName = "https"
    $PropertyType = "DWord"
    $PropertyValue = "2"
    Set-RegistryProperty -RegistryKey $RegistryKey -PropertyName $PropertyName -PropertyType $PropertyType -PropertyValue $PropertyValue

    #Launch Internet Explorer and Explorer to login to SharePoint
    $IE = New-Object -ComObject internetexplorer.application
    $IE.Visible = $false
    $IE.Navigate("https://$SharePointUrl") #Edge does not work
    Sleep -s 30 #Long sleep for slow computers
    Start explorer $WebDavUrl
    Sleep -s 10 #Long sleep for slow computers

    #Check $TargetDir existence and create if necessary
    If(!(Test-Path $TargetDir -ErrorAction SilentlyContinue)){
        Try{
            New-Item -ItemType Directory -Path $TargetDir -Force
        }Catch{
            Write-Error "Error during TargetDir creation"
        }
    }

    #Get items & loop
    $Items = Get-ChildItem -Path $WebDavUrl -Recurse
    ForEach($Item in $Items){
        $Destination = Join-Path -Path $TargetDir -ChildPath (Split-Path $Item.FullName -NoQualifier).Replace($WebDavUrl,'')
        Copy-Item $Item.FullName -Destination $Destination -Force
    }
}
