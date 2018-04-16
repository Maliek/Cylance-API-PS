Import-Module CyCLI

$threats = Get-CyDeviceList | Get-CyDeviceThreatList | where sub_classification -eq Backdoor

Foreach ($sha in $threats.sha256)
{
    $output = Get-CyThreatDeviceList -SHA256 $sha
    Write-Output $output
}
