# Scanner run
function Run {
    param (
        [string]$mainScanResultsPath,
        [string]$anotherScanResultPath
    )

    . .\scanner.ps1

    # Pobieranie wszystkich dostępnych dysków
    $mainDisk = @("C", "D")#Get-Volume | Select-Object -ExpandProperty DriveLetter
    $allResults = @()

    try {
        # Wykonywanie skanowania na wszystkich dyskach
        foreach ($disk in $mainDisk) {
            Write-Host $disk
            $results = Set-Scan -Path $disk":\"
            $allResults += $results
        }

        # Zapis wyników skanowania do odpowiedniego pliku JSON
        $outputPath = if (Test-Path -Path "D:\GitHub\Basic_AV\BasicAV_Resources\result_1.json" <#$mainScanResultsPath#>) { "D:\GitHub\Basic_AV\BasicAV_Resources\result_2.json"<#$anotherScanResultPath#> } else { "D:\GitHub\Basic_AV\BasicAV_Resources\result_1.json"<#$mainScanResultsPath#> }
        $allResults | ConvertTo-Json | Out-File -FilePath $outputPath -Encoding utf8
    }
    catch {
        Write-Output "Error: $($_.Exception.Message)"
    }


$alljsonCompare =@()
$jsonCompare = Compare-Results -FirstPath $mainScanResultsPath -SecoundPath $anotherScanResultPath
Write-host "1"
$alljsonCompare += $jsonCompare
$alljsonCompare | ConvertTo-Json | Out-File -FilePath D:\GitHub\Basic_AV\BasicAV_Resources\Wyniki.json
#Write-Output $jsonCompare
}

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUuqpH/xy4gRL99ofvoSx8wdlX
# QkmgggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBREZoKUy1wL9/2VYbiSDTLCu/ljFjAN
# BgkqhkiG9w0BAQEFAASCAQB87FUhTlAE98/6J5CZeLUCSAN5mfbsdi1DPF7Dtnro
# 8vloZvYr+bCeulZV0dSKx97LMvCqRKCKXjkAu6FMbwZgzEv+MINhK+ln0esCo54F
# qOgLIuWSO0eg1g8DjkXhljXIgeUA4ZM0XrahXeoIDbXXGc96L8WDwSC86L8I63hZ
# 90fyywS8zztdzUJkIHp4TJp6D/b30UjFEGmnSL/UYXm3qbeanPkSu71QCYTjufkJ
# abtboEbcz8ji23C1EO/K7CmUdm3Uae5OmTzDmuGRNiqrauCqiN6oiA7Rtn3MTHqT
# fS6AUgQHaMwUlWGi7hR0ox3/goyPzLzXA7l2l5U8fxoH
# SIG # End signature block
