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

Write-Host "Migrating zones"
$SourcePolicies = Get-CyPolicyList -API $Source
$DestZones = Get-CyZoneList -API $Dest
$DestPolicies = Get-CyPolicyList -API $Dest
Get-CyZoneList -API $Source | ForEach-Object {
    $DestZoneName = "$(ToSafeString $_.name)"
    if (! ($DestZones.name -contains $DestZoneName)) {
        Write-Host "Migrating zone '$($_.name)'"
        Write-Host " - reading original zone settings"
        $SourceZone = $_ | Get-CyZone -API $Source
        Write-Host " -- getting source policy name"
        $SourcePolicy = $SourcePolicies | Where-Object id -eq $SourceZone.policy_id
        Write-Host "    source policy name: $($SourcePolicy.name)"
        Write-Host " - creating new zone $($DestZoneName)"
        $DestPolicyName = "$($SourcePolicy.name)"
        Write-Host "SEARCHING FOR $DestPolicyName in $($DestPolicies.name)"
        $DestPolicy = $DestPolicies | Where-Object name -eq $DestPolicyName
        Write-Host " -- assigning policy $($DestPolicy.name) with id $($DestPolicy.id)"
        $NewDestZone = New-CyZone -Name $DestZoneName -Policy $DestPolicy -API $Dest
    }
}