param(
    [parameter(Mandatory=$true, ParameterSetName="Direct")]
    [int] $minutesago
)

Import-Module CyCLI

$longtime = [DateTime]::Now.AddMinutes("-" + $minutesago)
Write-Output "All infected devices since:"  $longtime

$output = New-Object System.Collections.ArrayList
$threats = Get-CyDeviceList | Get-CyDeviceThreatList

Foreach ($sha in $threats.sha256)
{    
    $output = Get-CyThreatDeviceList -SHA256 $sha | where date_found -gt $longtime
    Write-Output $output
    Send-MailMessage -To "User01 <user01@example.com>" -From "User02 <user02@example.com>" -Subject "Test mail" -Body $output

    if([string]::IsNullOrEmpty($output)){
        break
    }    
}

Write-Output "Done!"

