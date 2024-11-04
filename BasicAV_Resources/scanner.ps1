function Set-Scan {
    param (
        [string]$Path
    )

    # Tworzenie obiektu DirectoryInfo
    $directoryInfo = New-Object System.IO.DirectoryInfo($Path)

    # Rekursywne pobieranie wszystkich plików
    $allFiles = $directoryInfo.GetFiles("*.*", [System.IO.SearchOption]::AllDirectories)
    $allFilesCount = $allFiles.Count
    $total = 0
    $startTime = Get-Date
    $allResults = @()

    foreach ($file in $allFiles) {
        $total ++
        $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
        $result = [PSCustomObject]@{
            Name = $file.Name
            Path = $file.FullName
            Hash = $hash.Hash
        }
        $allResults += $result

        # Progress
        $percentComplete = ($total / $allFilesCount) * 100

        # time estimation
        $elapsedTime = (Get-Date) - $startTime
        $estimatedTotalTime = ($elapsedTime.TotalSeconds / $total) * $allFilesCount
        $remainingTime = $estimatedTotalTime - $elapsedTime.TotalSeconds

        # time format
        $remainingTimeFormatted = [TimeSpan]::FromSeconds($remainingTime)

        # show progress
        Write-Progress -Activity "File Scan" -Status " $total/$allFilesCount (Time to End: $($remainingTimeFormatted.Hours):$($remainingTimeFormatted.Minutes):$($remainingTimeFormatted.Seconds))" -PercentComplete $percentComplete
    }

    # results
    $allResults
}







# Function to compare two JSON files containing scan results, identifying differences.
function Compare-Results {
    param (
        [string]$FirstPath,
        [string]$SecondPath,
        [string]$mainScanResultsPath
    )
    
    # Read the contents of the first JSON file
    $firstJsonContent = Get-Content -Path $FirstPath | ConvertFrom-Json
    # Read the contents of the second JSON file
    $secondJsonContent = Get-Content -Path $SecondPath | ConvertFrom-Json
    # Initialize an array to store results
    $allResults = @()

    # Find items that are in the first JSON but not in the second
    foreach ($item in $firstJsonContent) {
        $match = $secondJsonContent | Where-Object { 
            ($_.Path -eq $item.Path) -or (($_.Name -eq $item.Name) -and ($_.Hash -eq $item.Hash)) 
        }
        if (-not $match) {
            $allResults += $item
        }
    }

    # Find items that are in the second JSON but not in the first
    foreach ($item in $secondJsonContent) {
        $match = $firstJsonContent | Where-Object { 
            ($_.Path -eq $item.Path) -or (($_.Name -eq $item.Name) -and ($_.Hash -eq $item.Hash)) 
        }
        if (-not $match) {
            $allResults += $item
        }
    }

    # Return the results as output
    return $allResults
}


function Get-Hash {
[CmdletBinding()]
param (
[string]$SourcePath,
[string]$DestPath = "$env:ProgramFiles\BasicAV\Definitions\Scan_Results\Results"
)

$firstFile = Get-Content -Path $SourcePath | ConvertFrom-Json 
$allHash = @()
foreach ($file in $firstFile)
{

    $hash = [PSCustomObject]@{
        Hash = $file.Hash
    }
    $allHash += $hash

}
$date = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
$DestPath = Join-Path -Path $DestPath -ChildPath "Results_$date.json"
$allHash | ConvertTo-Json | Out-File -FilePath $DestPath

return $DestPath

}




# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUE36pfedJ1oeV6xtjJMXBGk3d
# LWmgggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBR0/2nVtvvXckGikOBmJNJm1+zaKjAN
# BgkqhkiG9w0BAQEFAASCAQASNunvihywzUYQivYros5iiQeS54Dj+xKfAEZ1UH3a
# tRXe3fkHzHEC1ABSouWj/CimISIWskRtRzMHuByxBlctgX8yr0pjKg7LlUfCOypB
# 3A5XMhF0209GmVOg+ogbzrUeUkebJEa383VWMBhmKTBPumvUqSgWR9oGc1UxME53
# r7T+fouRwxgMrmGXMFM722MZNaa7j7czsbgqEOCzlT7xfbVO6/fEz/qf6sfxXksq
# VYHcjkyvaSsC1sgRazHqxEbn5UIv3Oku2oHTrCvkWZnFBihLaaQMl0jkKFL23vNf
# T83ezk49VZVmZUcm5oOzaScdeZDdf3cSFedhivIfFai1
# SIG # End signature block
