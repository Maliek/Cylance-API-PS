# Created by Maliek Meersschaert

param(
    [parameter(Mandatory=$true, ParameterSetName="Direct")]
    [int] $daysAgo
)

Import-Module CyCLI

$longtime = [DateTime]::Now.AddDays("-" + $daysAgo)
$output = Get-CyDeviceList | Get-CyDeviceDetail | where state -eq Offline | where date_offline -lt $longtime

Write-Output $output

# Remove-CyDevice -DeviceId $output.id