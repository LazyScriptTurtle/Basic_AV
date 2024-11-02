#function Set-Scan {
    param (
        [string]$Path,
        [string]$ExcludedPath
    )

    $excludePaths = @("C:\Windows\")
    if ($ExcludedPath) { $excludePaths += $ExcludedPath }

    # Próbujemy pobrać listę wszystkich plików w podanej ścieżce, z ignorowaniem błędów dostępu
    try {
        $allFiles = [System.IO.Directory]::EnumerateFiles($Path, "*.*", [System.IO.SearchOption]::AllDirectories)
    }
    catch {
        Write-Output "Błąd podczas enumeracji plików w ścieżce $Path : $($_.Exception.Message)"
        return
    }

    $allFilesCount = ($allFiles | Measure-Object).Count

    if ($allFilesCount -eq 0) {
        Write-Output "Brak plików do przetworzenia w podanej ścieżce: $Path"
        return
    }

    $total = 0
    $results = @()
    $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()

    foreach ($file in $allFiles) {
        if ($excludePaths | ForEach-Object { $file -like "$_*" }) { continue } # Sprawdzenie ścieżek

        try {
            $total += 1
            $date = Get-Date -Format "dd/MM/yyyy_HH:mm:ss"
            $fileStream = [System.IO.File]::OpenRead($file)
            $hashBytes = $hashAlgorithm.ComputeHash($fileStream)
            $fileStream.Close()

            $hashString = -join ($hashBytes | ForEach-Object { "{0:x2}" -f $_ })

            $results += [PSCustomObject]@{
                Name = (Get-Item $file).Name
                Path = $file
                Hash = $hashString
                Date = $date
            }

           # Write-Progress -Activity "Scanning files" -Status "$total/$allFilesCount files processed" -PercentComplete (($total / $allFilesCount) * 100)
        }
        catch {
            Write-Output "Błąd podczas przetwarzania pliku $file : $($_.Exception.Message)"
            continue  # Pomija plik, w którym wystąpił błąd i przechodzi do kolejnego
        }
    }

    $hashAlgorithm.Dispose()
    return $results



function Compare-Results {
    param (
        [string]$FirstPath,
        [string]$SecoundPath
    )
    
    try {
        # Wczytanie zawartości plików JSON
        $firstJsonContent = Get-Content -Path $FirstPath | ConvertFrom-Json
        $secoundJsonContent = Get-Content -Path $SecoundPath | ConvertFrom-Json
        $results = @()  # Lista wyników z unikalnymi `Hash`

        # Tworzymy listę wszystkich hashy z pierwszego pliku
        $firstHashes = $firstJsonContent | ForEach-Object { $_.Hash }
        $secoundHashes = $secoundJsonContent | ForEach-Object { $_.Hash }
        # Iteracja przez elementy drugiego pliku JSON
        foreach ($item in $secoundJsonContent) {
            if ($firstHashes -contains $item.Hash) {
                Continue
            }
            else {
                $results += $item
            }
        }
        
        # Zwracamy tylko te wpisy, których `Hash` nie występuje w pierwszym pliku
        return $results
    }
    catch {
        Write-Error "Wystąpił błąd: $($_.Exception.Message)"
    }
}


    

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUJQaX2FCE84z4oR8zmjHm3D7Z
# BNKgggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSSrJEjvW2ifoHiJv/oNKlG2PRjkzAN
# BgkqhkiG9w0BAQEFAASCAQBW+oYRiOCxpJfa4j9fwn5ng4wM3h+ho1Cu3QQe+JZh
# 1BoFqxopAyYbZ1K14TWtvcIRGBtVvrPZo+7M3u4VV6LD4gDNRiLBav7r2DfiynQL
# nAjpZrJLuUBmF916mU4jRvQRlLKThwzpog5f9O/ZYD77dNbD/Tih1Ao9eMPjtYHb
# q0Yb3KybJTgnPC2HrnOTKidaElKMGtY9H/jRdydhD3/SYQWgP+IKRL/UXy1wEe7Z
# IYzHWcf7xj27qeuM2j04RJ9atlsm5QTLUVz2dnXmHp3Sx8aDnGtAkZYgdMPM/5af
# JNhmVW0IIilI1+NsexrQKozKX4xbTxOtAYBn66HyQ6Gc
# SIG # End signature block
