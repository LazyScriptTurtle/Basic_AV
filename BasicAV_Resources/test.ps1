function scanner_module {
    param (
        [string]$Path,
        [int]$batch = 100
    )
    $excludePaths = @("C:\Windows\")
    $allFiles = Get-ChildItem -Path $Path -File -Recurse -Force -ErrorAction SilentlyContinue
    $allFilesCount = $allFiles.Count
    $total = 0
    $results = @()

    # Funkcja do sprawdzenia obciążenia dysku
    function Get-DiskUsage {
        return (Get-Counter '\PhysicalDisk(_Total)\% Disk Time').CounterSamples.CookedValue
    }

    # Skanowanie plików w seriach
    foreach ($file in $allFiles) {
        # Sprawdzenie, czy ścieżka jest wykluczona
        if (-not ($excludePaths | ForEach-Object { $file.FullName -like "*$_*" })) {
            try {
                # Monitorowanie wykorzystania dysku
                while ((Get-DiskUsage) -gt 40) {
                    Write-Output "Dysk obciążony powyżej 40%, wstrzymywanie na 500 ms"
                    Start-Sleep -Milliseconds 500  # Wstrzymywanie do czasu spadku obciążenia dysku
                }

                $total += 1
                $date = Get-Date -Format "dd/MM/yyyy_HH:mm:ss"
                $result = Get-FileHash -Path $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue
                $results += [PSCustomObject]@{
                    Name = $file.Name
                    Path = $file.FullName
                    Hash = if ($result) { $result.Hash } else { "Error" }
                    Date = $date
                }

                Write-Progress -Activity "Scanning files" -Status "$total/$allFilesCount files processed" -PercentComplete (($total / $allFilesCount) * 100)

                # Zapis wyników po każdej serii
                if (($total % $batch) -eq 0) {
                    $results | ConvertTo-Json | Out-File -FilePath "scan_results_batch_$($total/$batch).json" -Encoding UTF8
                    $results = @()  # Czyszczenie wyników po zapisaniu serii
                }
            }
            catch {
                Write-Output "Error: $($_.Exception.Message)"
            }
        }
    }

    # Zapis pozostałych wyników po zakończeniu wszystkich serii
    if ($results.Count -gt 0) {
        $results | ConvertTo-Json | Out-File -FilePath "scan_results_final.json" -Encoding UTF8
    }

    return $results
}

$date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$mainScanResultsPath = 'C:\Program Files\BasicAV\Definitions\Scan_Results\Main_Scan.json'
$anotherScanResultPath = "C:\Program Files\BasicAV\Definitions\Scan_Results\Another_Scan_$date.json"
$mainDisk = Get-Volume | Select-Object -ExpandProperty DriveLetter
try {
    if (Test-Path -Path $mainScanResultsPath) {
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\" -Batch 100
        }
        $results | ConvertTo-Json | Out-File -FilePath $anotherScanResultPath -Encoding utf8
        # Write-Host "2"
    }
    else {
    
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\" -Batch 100
            #    Write-Host "3"
        }
        $results | ConvertTo-Json | Out-File -FilePath $mainScanResultsPath -Encoding utf8
        # Write-Host "4"
    }
}
catch {
    Write-Output "Error $($_.Exception.Message)"
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnOjd9bPIIl3G9k9kOdibkmoA
# OGmgggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRV0xVEt+HcgSJtd6hv8PaUku3XPjAN
# BgkqhkiG9w0BAQEFAASCAQCET7vrR0w3Gu8uq6XRLvcw61GZtt2pCzjmwHisBGnW
# kUOyMlDDs/namgSZujZWo6SgoU44ECPYCPKxqCupexDCk3Hv7mGSGJjZsTal31wn
# Fc0T5TRrrYzHXvpgOgKEc/gEMk7MqgK5qn0uhuMvPYGus4+Ple4bzjYp0s6+NZwC
# aDMjfjD2zWAzXhYIXZlC07Sb00Y2ylJeSz1nT/f+9NKhcKzL1AN6Zk+HukS45eOt
# tTmM4xMrS0477VdoDk+vNDQ7kRTCNnWBnMhhVyouHOveZH7M3tghYAltGpl29DFK
# qpFmg7cG+t1SpSRYb1/dMDFy0ZH6mU9T+Go+Oo/rxmm6
# SIG # End signature block
