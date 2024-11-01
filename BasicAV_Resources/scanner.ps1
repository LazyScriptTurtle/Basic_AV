
function Set-Scan {
    param (
        [string]$Path,
        [int]$Batch,
        [string]$ExcludedPath
    )

    # Initialize an array of paths to exclude from scanning. 
    # This includes the Windows directory by default and any additional excluded paths provided.
    $excludePaths = @("C:\Windows\")
    $excludePaths += $ExludedPath

    # Retrieve all files within the specified path, excluding the defined paths, recursively.
    # Errors are suppressed for smoother execution.
    $allFiles = Get-ChildItem -Path $Path -Exclude $excludePaths* -File -Recurse -Force -ErrorAction SilentlyContinue
    $allFilesCount = $allFiles.Count
    $total = 0
    $results = @()

    # Optionally, the disk utilization check can be enabled here.
    # This section is currently commented out but can be used to pause the scan if disk usage exceeds 50%.
    <# 
    $diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue
    #
    # if ($diskUtil -gt 50) {
    #     do {
    #         Start-Sleep -Milliseconds 500
    #         $diskUtil = Get-Counter | Select-Object -ExpandProperty CounterSamples | Where-Object { $_.Path -like '*\% disk time*' } | Select-Object -ExpandProperty cookedValue            
    #     } while ($diskUtil -gt 50)
    # }

    # Process each file found in the specified path.
    # For each file, calculate its MD5 hash and capture the date and time of the scan.
    #>
    foreach ($file in $allFiles) {
        # Uncomment the conditional check if you want to exclude specific paths dynamically.
        # if (<#($file.FullName -notcontains $ExcludedPath) -and #> ($file.FullName -notcontains $excludePaths)) {

        try {
            $total += 1
            $date = Get-Date -Format "dd/MM/yyyy_HH:mm:ss"

            # Calculate the file's hash and add file information to the results array.
            $result = Get-FileHash -Path $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue
            $results += [PSCustomObject]@{
                Name = $file.Name
                Path = $file.FullName
                Hash = if ($result) { $result.Hash } else { Write-Output "Error" }
                Date = $date
            }

            # Display the progress of the scanning operation.
            Write-Progress -Activity "Scanning files" -Status "$total/$allFilesCount files processed" -PercentComplete (($total / $allFilesCount) * 100) 
        }
        catch {
            # Output error message if there’s an issue processing the file.
            Write-Output "Error $($_.Exception.Message)"
        }
        # }
        # else {
        #     continue # Skip excluded paths (if uncommented in the condition above)
        # }
    }
    
    # Return the scan results to the caller.
    return $results
}
function Compare-Results {
    param (
    [string]$FirstPath,
    [string]$SecoundPath
    #[string]$DestPath
    
    )
    $firstJsonContent = Get-Content -Path $FirstPath | ConvertFrom-Json
    $secoundJsonContent = Get-Content -Path $SecoundPath | ConvertFrom-Json
    $results = @()
    $allResults = @()
    foreach($item in $firstJsonContent)
    {
        $match = $secoundJsonContent | Where-Object {($_.Path -eq $item.Path) -or ($_.Name -eq $item.Name) -and ($_.Hash -eq $item.Hash) }

        if ($match -eq $false)
        {
            $results += $item
            $allResults += $results
        }
    }
    Move-Item -Path $SecoundPath
    return = $allResults

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
