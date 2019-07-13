#Run in user context

#Fill these variables
    $URL = "https://localnl.sharepoint.com/MarketingCommunicatie" #for example "https://contoso.sharepoint.com/sites/sales". DO NOT end with /
    $RelativeFolderPath = "Huisstijl/Marketing Branding Huisstijl 2019/local/Fonts" #For example: Documents/Fonts/New

#Variables
    $WorkingDir = "$env:TEMP\Install-Fonts"
        if(Test-Path $WorkingDir -ErrorAction SilentlyContinue){
            Remove-Item $WorkingDir -Recurse -Force
        }else{
            New-Item -ItemType Directory -Path $WorkingDir | Out-Null
        }
    $sa =  New-Object -ComObject shell.application
    $Fonts =  $sa.NameSpace(20)

#Install SharePointPnPPowerShellOnline module
    Install-PackageProvider -Name NuGet -Force -Confirm:$false
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module SharePointPnPPowerShellOnline -Scope CurrentUser -Force -Confirm:$false

#Connect, download
    #Connect and get fontfiles
    Connect-PnPOnline -Url $URL -UseWebLogin
    $FontFiles = Find-PnPFile -Folder $RelativeFolderPath -Match *.ttf
    #Loop throug each fontfile to download
    foreach($File in $FontFiles){
        Get-PnPFile -ServerRelativeUrl $File.ServerRelativeUrl -Path $WorkingDir -Filename $File.Name -AsFile -Force
    }

#Install fonts
    Get-ChildItem $WorkingDir -Recurse -Include *.ttf | % {$Fonts.MoveHere($_.FullName)}