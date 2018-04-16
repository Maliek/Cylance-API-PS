Import-Module CyCLI

$threats = Get-CyDeviceList | Get-CyDeviceThreatList | where sub_classification -eq Ransom
$threatDetails = $threats.sha256 | Get-CyThreatDetail

Write-Output $threatDetails
