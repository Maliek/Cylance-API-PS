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

Write-Host "Migrating policies"
$DestPolicies = Get-CyPolicyList -API $Dest
Get-CyPolicyList -API $Source | ForEach-Object {
    $DestPolicyName = "$(ToSafeString $_.name)"
    if (! ($DestPolicies.name -contains $DestPolicyName)) {
        Write-Host "Migrating policy $($_.name)"
        Write-Host " - reading original policy settings"
        $SourcePolicy = Get-CyPolicy -API $Source -Policy $_
        Write-Host " - creating new policy"
        $DestPolicy = New-CyPolicy -API $Dest -Policy $SourcePolicy -Name $DestPolicyName -User $User
    }
}