param(
    [parameter(Mandatory=$true, ParameterSetName="Direct")]
    [int] $daysAgo
)

Import-Module CyCLI

$longtime = [DateTime]::Now.AddDays("-" + $daysAgo)
Write-Output "All infected devices since:"  $longtime

$output = New-Object System.Collections.ArrayList
$threats = Get-CyDeviceList | Get-CyDeviceThreatList

Foreach ($sha in $threats.sha256)
{    
    $output = Get-CyThreatDeviceList -SHA256 $sha | where date_found -gt $longtime
    Write-Output $output
    
    if([string]::IsNullOrEmpty($output)){
        break
    }    
}

Write-Output "Done!"