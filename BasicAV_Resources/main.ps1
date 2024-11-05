function Run {
    param (
$mainJson = "$env:ProgramFiles\BasicAV\Definitions\Scan_Results\Main\",
$secondJson = "$env:ProgramFiles\BasicAV\Definitions\Scan_Results\"
    )
    
}
. .\scanner.ps1
. .\Malware_Bazar_Api.ps1
. .\GetHash.ps1
. .\CompareResults.ps1
. .\OfflineHashChecker.ps1

$mainJson = "$env:ProgramFiles\BasicAV\Definitions\Scan_Results\Main\"
$secondJson = "$env:ProgramFiles\BasicAV\Definitions\Scan_Results\"
$date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$allDisk = Get-Volume | Select-Object -ExpandProperty DriveLetter
$allResults = @()
foreach($disk in $allDisk)
{
    $result = Set-Scan -Path $disk":\"
    $allResults += $result
}
#Write-Output $allResults

if (Test-Path "$mainJson\main_result.json")
{
    $outputDirectory = "$secondJson\addition_result_$date.json"
    $result | ConvertTo-Json | Out-File -FilePath $outputDirectory -Encoding utf8

}else{
    $outputDirectory = "$mainJson\main_result.json"
    $result | ConvertTo-Json | Out-File -FilePath $outputDirectory -Encoding utf8 
    Copy-Item -Path $outputDirectory -Destination "$secondJson\addition_result_$date.json"

}

if ($outputDirectory -notcontains $mainJson)
{
   $compare = Compare-Results -FirstPath "$mainJson\main_result.json" -SecondPath $outputDirectory 
   $compare | ConvertTo-Json | Out-File -FilePath "$secondJson\Main\Result_$date.json"

 $path = Get-Hash -SourcePath $outputDirectory

$checker = Check-Hash -Path "$secondJson\Results"
$checker | ConvertTo-Json | Out-File -FilePath "$env:ProgramFiles\BasicAV\Logs\Check-Result-$date.json" 
}
Run
 
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXpYBkgoSRmMTNUqZrLwfPNlp
# /j+gggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
# AQUFADAbMRkwFwYDVQQDDBBMYXp5U2NyaXB0VHVydGxlMB4XDTI0MTAzMTA5MjQx
# M1oXDTM0MTAzMTA5MzQxM1owGzEZMBcGA1UEAwwQTGF6eVNjcmlwdFR1cnRsZTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJz6d43WDjnR+UHWBVK990vf
# Up1YotDErRDEsL07VFlLf/P/iljrZDOesqRFadcK87fmrFBsHQge1bqQPYie/BRn
# CtmuqgUBRK5eIlhLYQBmjncuCHL/qcASzgrT9WmivEyJD5Yt3PeISJOOWWYOU8bj
# xCWbHeeTwvGXFTFYfD9+T1p3dPsJ+d1xkVxnQe7JECjE3IPbycLZhxnJxNH2DpVH
# GAeN8KGG+KcxuJtnzpwA2O3kQIbFZsl4fGZ9uOBPqFhu4g29jtLEk3b1byBkDOcA
# dkB4i5fHrVnSs6trsnG5H/5NrVYvj7tMdCeJnwzLB4w7yxCaR4UYRdq6MVKQ4v0C
# AwEAAaNjMGEwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBsG
# A1UdEQQUMBKCEExhenlTY3JpcHRUdXJ0bGUwHQYDVR0OBBYEFABN6yQfpg4TB5Mw
# 5+vLgebC9tGvMA0GCSqGSIb3DQEBBQUAA4IBAQAePqOzciA9Bi5vBjEXxdmJkWHs
# A/PZuaD7esJh5c7MVW15QUKGIy7OsdD2pXpkhSsHNUO/n7If8VRyChSfzs/owwZY
# WvJyxWHtGUDi+zY6Tk4QvePO2vlA7UTprygQAozcsN/PWZ1oQWnoMWSmHB5iQkvF
# bj1abLLD++x8RJWjFbIw6s9vNEQcO/IlgPGWBct4gtPdPEYYfNM0igBDl6ZGz2yz
# OCmehnF/Hk28DlaW7OK4TRJTgXt40wEfWrZUWO6Z839HcdQ/C+P5dJ2Ts6PZ09B3
# Gl0qm2icfLP2vZtGJkg1Uh3k1RZ+X7ETSN+XFq8VCQtOOodKxPBLp7tNYQe0MYIB
# 0DCCAcwCAQEwLzAbMRkwFwYDVQQDDBBMYXp5U2NyaXB0VHVydGxlAhB6NxYOT+UY
# rkx1ylzJnGAGMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQdNL/H0u0FRCioKM73mS5uA6Bs6DAN
# BgkqhkiG9w0BAQEFAASCAQBZs3J5l+9Z23njz6+iNbr5L++A7x8jx+tCJ7ULJUuw
# Jl+0vmVwQAhuK9rvuYuSp8Dzmj8kmSg8mPLcpeXNv2wmh9tFJxSMpefIxrSUOKvo
# aMqwW8Rko+7mRjaX4nsIrM39gfFEfGonk1pcMpq/yigyyav691G0c8K++5VhIu4y
# py4P2otlwN7a8moQKZUoE0nz1PmMPBQYiPIlP9IsNcruCPW2JJNmi1rNIV3mi8I3
# HW9VdIHXY0IOt7iG1Uj1aeSUZp8yh8i208XnDNMzSQiDMOP9Rz5VjP0/66uaLJG/
# jq+AhW5d3aHkPayVSG0cVzOO2nS0/EUqbYKhDtH8kSxv
# SIG # End signature block
