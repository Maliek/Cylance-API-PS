#Calculate hashes of all files in current directory

dir .\ -Recurse | Get-FileHash -Algorithm SHA256 | select -ExpandProperty hash | Set-Content .\hashes.txt


$hashes = Get-Content -Path ".\hashes.txt"


foreach ($hash in $hashes){

    Add-CyHashToGlobalList -List GlobalQuarantineList -Category None -Reason AEGIS -SHA256 $hash

}