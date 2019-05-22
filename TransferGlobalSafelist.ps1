$Source = Get-CyAPI -Console <Console1> -Scope None
$Dest = Get-CyAPI -Console <Console2> -Scope None
$User = "User that lives on <Console2>"

<#
    Legacy consoles sometimes contain strings that cannot be written with current console releases
#>
function ToSafeString() {
    Param(
        [parameter(Mandatory=$true,Position=1)]
        [string]$String
    )

    $String -replace "[&<>]","_"
}

Write-Host "Migrating global safe list"
$DestList = Get-CyGlobalList -List GlobalSafeList -API $Dest
Get-CyGlobalList -API $Source -List GlobalSafeList | ForEach-Object { 
    if (! ($DestList.sha256 -contains $_.sha256)) {
        Write-Host "Adding hash $($_.sha256) to global safe list in destination"
        $Reason = "M:$(ToSafeString $_.reason)"
        Add-CyHashToGlobalList -List GlobalSafeList -SHA256 $_.sha256 -Reason $Reason -Category None -API $Dest 
    }
}