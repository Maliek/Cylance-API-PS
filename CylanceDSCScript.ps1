Configuration CylanceDeployment
{
    
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    
    Script DeploymentScript
    {
        SetScript =
        {
            $script = New-Object System.IO.StreamWriter("C:\Old\Cylance\Cylance-API-PS\TestPS.ps1")

            $script.WriteLine("Invoke-WebRequest https://raw.githubusercontent.com/Maliek/CylanceProtect-Windows-Deployment-Azure-ARM/master/CylanceProtect_x64.msi -OutFile 'C:\Old\Cylance\Cylance-API-PS\CylanceProtect_x64.msi'")
            $script.WriteLine("Invoke-WebRequest https://raw.githubusercontent.com/Maliek/CylanceProtect-Windows-Deployment-Azure-ARM/master/CylanceOPTICSSetup.exe -OutFile 'C:\Old\Cylance\Cylance-API-PS\CylanceOPTICSSetup.exe'")

            $script.WriteLine("Start-Process msiexec.exe -Wait -ArgumentList '/i C:\WindowsAzure\CylanceProtect_x64.msi /qn PIDKEY=XXXXXXXXXXXXXXXXXXXXXXXXX LAUNCHAPP=1'")
            $script.WriteLine("Start-Process -FilePath 'C:\WindowsAzure\CylanceOPTICSSetup.exe' -ArgumentList -q -Wait")

            $script.Close()
        }

        TestScript = 
        {
            Powershell.exe C:\Old\Cylance\Cylance-API-PS\TestPS.ps1
            If (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Cylance\Desktop' -Name LastStateRestorePoint -ErrorAction SilentlyContinue) {

                Write-Output 'Value exists'
                return $true

            } Else {

                Write-Output 'Value DOES NOT exist'
                return $false

            }


        }

        GetScript = 
        {
            @{ 
                Result = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Cylance\Desktop' -Name LastStateRestorePoint) 
            }
        }
    }
}