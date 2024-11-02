# Function to initialize a scan of a directory and compute SHA256 hash for each file.
function Set-Scan {
    param (
        [string]$Path
    )

    # Check if the provided path exists
    if (-not [System.IO.Directory]::Exists($Path)) {
        Write-Error "The specified path '$Path' does not exist."
        return
    }

    # Initialize SHA256 object
    $sha256 = [System.Security.Cryptography.SHA256]::Create()

    # Initialize collection to store results
    $results = @()

    # Function to compute SHA256 hash for a single file
    function Get-FileHash ([string]$filePath) {
        try {
            # Open file in read-only mode
            $fileStream = [System.IO.File]::OpenRead($filePath)
            $hashBytes = $sha256.ComputeHash($fileStream)
            $fileStream.Close()

            # Convert hash to hexadecimal format
            $hashString = [BitConverter]::ToString($hashBytes) -replace '-', ''
            
            # Create the resulting object and add it to the results collection
            $results += [PSCustomObject]@{
                FileName = [System.IO.Path]::GetFileName($filePath)
                FilePath = $filePath
                SHA256Hash = $hashString
            }
        }
        catch {
            Write-Warning "Failed to read file '$filePath': $($_.Exception.Message)"
        }
    }

    # Recursive function to safely process files within directories
    function ProcessDirectory ([string]$directoryPath) {
        try {
            # Get list of files
            $files = [System.IO.Directory]::GetFiles($directoryPath)
            foreach ($file in $files) {
                # Calculate and store result for each file
                Get-FileHash -filePath $file
            }

            # Get list of subdirectories and process them recursively
            $directories = [System.IO.Directory]::GetDirectories($directoryPath)
            foreach ($subDir in $directories) {
                ProcessDirectory -directoryPath $subDir
            }
        }
        catch {
            # Ignore access errors for directories
            Write-Warning "Failed to access directory '$directoryPath': $($_.Exception.Message)"
        }
    }

    # Start processing from the main directory
    ProcessDirectory -directoryPath $Path

    # Dispose of the SHA256 object
    $sha256.Dispose()

    # Return the results collection
    return $results
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

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXn1B/Chqaa2nIUnZljyNggxd
# CYigggMnMIIDIzCCAgugAwIBAgIQejcWDk/lGK5MdcpcyZxgBjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBS0Pu4jLhU2vs+VW0S2aA/Dv+7ARTAN
# BgkqhkiG9w0BAQEFAASCAQB95Ky5brOWLcjCrz8iBOnFgw7ejgEI5zhk/+ug8v/F
# XFWDHxN2BOfOIDuARV+/kKKfCjbBEqKDhBcVwHSGpQMRoRKWIJbnLiBe9V9D16vW
# vuoGIb4qoKKBwwt+9zom6dOkRnkDx/0U/JgATs2Z3B7ZBkFzQZzCDNp/0EZLh2u9
# qsjl544hecqNyHYnAgDfJ2d9NDfYWw9OWIDEYahEPn/ILLyxK0VzgdMkPm3sjy5d
# XglGdzeZRwgOZ2aj305Gi1RYcWiTEI4ImaSfGjeUiOWq+ouAxSCEqEJnZeevzL3J
# 5/0trKjRi5hDapPXRxOpDDOmFc0qn2T7sEfANwZIJ4Ot
# SIG # End signature block
