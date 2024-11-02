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
$allDisk = @("D:\Github\") #Get-Volume | Select-Object -ExpandProperty DriveLetter
$allResults = @()
foreach($disk in $allDisk)
{
    $result = Set-Scan -Path $disk
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
   $compare | ConvertTo-Json | Out-File -FilePath "$secondJson\Wynik_$date.json"
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUr/IAjGkr9IHFx6MsthG9l0zH
# 6RWgggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSRjmf+4hpS6FfFvDq5xpPi6XoPUDAN
# BgkqhkiG9w0BAQEFAASCAQBIXSROZmeoTaN9an/O+5Hkl1NRD2JjLcQDQqsP1g55
# REiBNbRlZgrK1nife11sUeXDolzjreZ7kvuc8cNOEZOmnWOxojEfiuGcLSU3jbZN
# LTAdiHc8lqaLUtsaGcuazyt35o3JG1W/2BY6KCb47QQF67xSp/KgBxC4vZzKk8LB
# Ib8+6pdGigPM7jNDF7P5J83bGQvqs50aXsO9jJsuj6v/vqlUliHlSk+r6uPU4s5s
# iQPiOnk61U6wcpPQhzq7thEvwOygDNC23iFyl8yOd9y1TWGGfEJ46IZuRBAqp4jO
# 7LI1KkeTKm1MRdo9bx8I59IqU4lkZ2BCQU5n9wPX2njy
# SIG # End signature block
