





function scanner_module {
    param (
        [string]$Path,
        [int]$Batch,
        [string]$ExcludedPath
    )
    $excludePaths = @("C:\Windows\")
    $excludePaths += $ExludedPath
    $allFiles = Get-ChildItem -Path $Path -Exclude $excludePaths* -File -Recurse -Force -ErrorAction SilentlyContinue
    $allFilesCount = $allFiles.Count
    $total = 0
    $results = @()
    #$diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue


    # if ($diskUtil -gt 50) {
    #     do {
    #         Start-Sleep -Milliseconds 500
    #         $diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue            
    #     } while ($diskUtil -gt 50)
        
    # }
    # else {

        foreach ($file in $allFiles) {
           # if (<#($file.FullName -notcontains $ExcludedPath) -and #> ($file.FullName -notcontains $excludePaths)) {
                try {
            

                    $total += 1
                    $date = Get-Date -Format "dd/MM/yyyy_HH:mm:ss"
                    $result = Get-FileHash -Path $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue
                    $results += [PSCustomObject]@{
                        Name = $file.Name
                        Path = $file.FullName
                        Hash = if ($result) { $result.Hash } else { Write-Output "Error" }
                        Date = $date
                    }

                    Write-Progress -Activity "Scanning files" -Status "$total/$allFilesCount files processed" -PercentComplete (($total / $allFilesCount) * 100) 
            
            
                }
                catch {
                    Write-Output "Error $($_.Exception.Message)"
                }
            #}
            # else {
            #     continue
            # }
        }
# }


    return $results

}
$date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$mainScanResultsPath = 'C:\Program Files\BasicAV\Definitions\Scan_Results\Main_Scan.json'
$anotherScanResultPath = "C:\Program Files\BasicAV\Definitions\Scan_Results\Another_Scan_$date.json"
$mainDisk = Get-Volume | Select-Object -ExpandProperty DriveLetter
$allResults = @()
try {
    if (Test-Path -Path $mainScanResultsPath) {
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\"
            $allResults += $results
        }
        $results | ConvertTo-Json | Out-File -FilePath $anotherScanResultPath -Encoding utf8
        # Write-Host "2"
    }
    else {
    
        foreach ($disk in $mainDisk) {
            $results = scanner_module -Path $disk":\" 
            $allResults += $results
            #    Write-Host "3"
        }
        $allResults | ConvertTo-Json | Out-File -FilePath $mainScanResultsPath -Encoding utf8
        # Write-Host "4"
    }
}
catch {
    Write-Output "Error $($_.Exception.Message)"
}


# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZogQsxbx9IllezBBM5/UlSBZ
# zJegggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSqLrQnEsVAzhS6wXri3iE/HZ8FyzAN
# BgkqhkiG9w0BAQEFAASCAQB4z7lo1b2tPswzIgD0B41H0zrXITpPjoA1VVCevcVD
# 5yYXTEFGr2nM858Lw95Qq+vRpCv5L25I4zgovuB8q6VEKpS7ia2BJdaY3plPv3Nq
# zeiu0Qosaj41LYmTlcwtL3PhE5Grv+68Km85cpCOWENKWs1ymzm6Gln/+K8bymmT
# dTOMswFYTVXtjHxrp4XAU8Yov59bMZyLNEeyuIwf+G4qfQHsXHB6puYR4oAIOg2m
# YQnaa74ONUes0n7Juk89bKzb1Gbx7AOFaF1YV0WRsHCROk3/ncakJr5DUNJyX2XA
# Lvuo5oM0wyCsJDXAkefoWFE84QE/Av0S7onrsGu/xgVg
# SIG # End signature block
