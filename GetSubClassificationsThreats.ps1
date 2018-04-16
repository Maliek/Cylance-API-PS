Import-Module CyCLI

$threats = Get-CyDeviceList | Get-CyDeviceThreatList
$output = New-Object System.Collections.ArrayList

Foreach ($sub in $threats.sub_classification)
{
    [void]$output.Add($sub)
}

Write-Output $output | Sort | Get-Unique