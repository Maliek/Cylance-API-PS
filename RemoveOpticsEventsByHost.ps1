# Created by Maliek Meersschaert
# Use with caution!

param(
    [parameter(Mandatory=$true, ParameterSetName="Direct")]
    [string] $hostname
)


Import-Module CyCLI

$detections = Get-CyDetectionList | where Device -like "*$hostname*"

Write-Output "Removing all detections for hostname: $hostname"

Foreach ($detectionId in $detections.Id)
{
    Write-Output "Removing $detectionId for $hostname"
    Remove-CyDetection -Detection $detectionId
}