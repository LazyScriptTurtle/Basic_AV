function Run {
    param (
$mainJson = "$env:ProgramFiles\BasicAV\Definitions\Scan_Results\Main\",
$secondJson = "$env:ProgramFiles\BasicAV\Definitions\Scan_Results\"
    )
    
}
. .\scanner.ps1


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
    $outputDirectory = $mainJson
    $result | ConvertTo-Json | Out-File -FilePath "$outputDirectory\main_result.json" -Encoding utf8 

}

if ($outputDirectory -notcontains $mainJson)
{
   $compare = Compare-Results -FirstPath "$mainJson\main_result.json" -SecondPath $outputDirectory 
   $compare | ConvertTo-Json | Out-File -FilePath "$secondJson\Main\Result_$date.json"
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUr8kqKe1WIb5YgTwns1PSgaZO
# 0lSgggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSHXVQ9ARlN/RZKw1bzx52xZCeDjTAN
# BgkqhkiG9w0BAQEFAASCAQBOApNqt8TWJlF+rbOHYTLa2bDsUztL6zkfM/LrTx8r
# bJkRsB+niqP4IcLHhPCYsvNcndefVVFsX1hynmA+7cM5M27YSGEx7d/HH7nxHkBy
# F8xuTIn2qplYm0kyrPh14dqMtWN/tVzfK7Q0DSI9k6r9D34Z+mpGmNZIxivIqaK/
# iy2N8eYiG2V2LAvcdqsDBTCAWSORH74AYq7k1/gaiI1A44CmBHVygTH1RN0OU66i
# o2gU8rmKpisteM8LucqK/aM10Ky88QMgeaNzQvPdO3S4e3lnzIvxrGOai5jfD6oS
# CKzIcVzTTt6QzJ3PA4lrWDURut7hsVkhOW13MT8rS0dO
# SIG # End signature block
