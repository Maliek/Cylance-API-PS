param(
    [parameter(Mandatory=$true, ParameterSetName="Direct")]
    [int] $daysAgo
)

Import-Module CyCLI

$longtime = [DateTime]::Now.AddDays("-" + $daysAgo)
$test = Get-Date $longtime -Format G

Write-Output "All infected devices since:"  $test

$output = New-Object System.Collections.ArrayList
$threats = Get-CyDeviceList | Get-CyDeviceThreatList

Foreach ($sha in $threats.sha256)
{
    $output = Get-CyThreatDeviceList -SHA256 $sha | where date_found -gt $test
    Write-Output $output
}